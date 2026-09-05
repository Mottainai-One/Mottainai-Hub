# 01 — Schemas e Convenções

## Os dois schemas

O banco é dividido em **dois schemas** com responsabilidades claramente separadas:

| Schema | Tipo | Responsabilidade |
|---|---|---|
| `mottainai` | Operacional (OLTP) | Todas as **tabelas transacionais e de cadastro** do sistema |
| `mottainai_analytics` | Analítico (OLAP) | **Views** de BI/indicadores (nenhuma tabela física de cubo; apenas views e uma view materializada) |

O `search_path` padrão é `mottainai, public` (definido na criação do banco) e, no arquivo de views, é ajustado para `mottainai_analytics, mottainai, public` para permitir que as views referenciem o schema operacional.

## Extensões habilitadas

| Extensão | Uso |
|---|---|
| `uuid-ossp` | Geração de UUIDs |
| `pgcrypto` | Funções criptográficas (hash de senha, tokens) |
| `btree_gin` | Índices GIN sobre tipos btree (busca composta/textual) |

## Convenções de projeto

### 1. Nomenclatura
- **Tabelas:** `snake_case`, semântica em inglês (ex.: `retail_store`, `sale_item`).
- **Colunas:** `snake_case`; chaves primárias seguem o padrão `<entidade>_id`.
- **Chaves estrangeiras:** colunas nomeadas conforme a tabela alvo (`store_id → retail_store`, `product_id → product`).
- **Enums (tipos):** `snake_case` (ex.: `sale_status`, `priority_level`).
- **Funções/views:** prefixo por tipo — `fn_*` (funções), `sp_*` (procedures), `trg_*` (triggers), `vw_*` (views).
- **Índices:** prefixo `idx_` (e `idx_unique_` para índices únicos).

### 2. Soft delete (exclusão lógica)
A maioria das tabelas de cadastro e transações mantém a linha mesmo após "exclusão", usando as colunas:
- `active BOOLEAN` — controla se o registro está ativo.
- `deleted_at TIMESTAMP` — marca lógica de exclusão (torna `active = FALSE` via trigger).
- `updated_at TIMESTAMP` — última atualização.

> **Benefício:** preserva rastreabilidade e FKs históricas sem quebrar referências.

### 3. Controle de concorrência otimista
Tabelas com atualização concorrente carregam a coluna `version INTEGER` (ex.: `product`, `purchase_order`, `inventory`, `sales_transaction`, `transfer`, `donation`, `disposal`). A função `fn_atomic_update_inventory` usa o `version` para detectar conflitos de escrita no estoque.

### 4. Particionamento por data
Quatro tabelas de alto volume são **particionadas por faixa de data** (PK composta inclui a coluna de data):

| Tabela | Coluna de partição |
|---|---|
| `purchase_order` | `order_date` |
| `inventory_movement` | `movement_date` |
| `sales_transaction` | `sale_date` |
| `audit_log` | `operation_date` |

As procedures `sp_create_future_partitions()` e `sp_drop_old_partitions(months)` gerenciam a criação (mês atual em diante) e a retenção de partições antigas.

### 5. Enums como domínios de estado
Todos os principais fluxos (compra, venda, estoque, promoção, IA, eventos, logs) usam **tipos enum** (ver `11-enums.md`) para garantir valores válidos. Alguns estados restritos usam `CHECK` inline com `VARCHAR` (documentados nas respectivas tabelas).

### 6. Segurança — Row Level Security (RLS)
`company`, `retail_store`, `employee`, `inventory`, `sales_transaction` e `purchase_order` possuem **políticas de linha** que escopam o acesso ao **locatário (empresa)** da sessão corrente, via `fn_get_current_company_id()`. Isso reforça o isolamento multitenant no nível do banco.

### 7. Auditoria e rastreabilidade
- Triggers de auditoria em `disposal`, `transfer` e `donation` gravam em `audit_log` (`INSERT`/`UPDATE`/`DELETE`).
- Triggers de histórico em `product` gravam mudanças em `product_history`.
- Cálculos de custo médio/preço sugerido são registrados em `product_price_history`.
- Toda sessão carrega o contexto do usuário (`fn_set_session_context`) para preencher `user_id` nos logs.

### 8. Regras de integridade e validação
- **CPF/CNPJ:** validação por dígitos verificadores (`fn_validate_cpf`/`fn_validate_cnpj`) em `employee`, `company`, `retail_store`, `supplier` e `customer`.
- **E-mail:** validação por função `fn_validate_email`.
- **Estoque:** impedimento de estoque negativo no nível de aplicação (`fn_atomic_update_inventory`) e por `CHECK` em colunas de quantidade.
- **Seleção de FEFO:** `fn_select_batch_fefo` escolhe o lote com menor validade, disparado pelo trigger `trg_select_batch_fefo` na criação de item de venda.

## Mapa de instalção dos scripts

Ordem de criação do banco (`install.sql`):

```
00 DataBase (extensões + schemas) → 01 Enums → 02 Functions → 03 Tables →
04 Constraints/RLS → 05 Indexes → 06 Triggers → 07 Views → 08 Seed → 09 Procedures → 10 Tests
```

> O arquivo `install.sql` define o schema versionado de produção. O `dataLoad.sql` é um artefato **exclusivo de teste/seed idempotente** (executado 2× no CI) e **nunca** roda em produção.

---

*Próximo: [02 — Cadastro e Empresa](02-cadastro-e-empresa.md)*
