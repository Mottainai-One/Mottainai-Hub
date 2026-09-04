# Script SQL — Banco Operacional Mottainai

> **Banco Operacional** · PostgreSQL 15+ · v6.0 Enterprise Final Edition
> Documentação dos scripts SQL que criam o banco operacional: schema, objetos, carga de dados de teste e suíte de validação.

## Origem do script

Os scripts usados como referência desta documentação são os que implementam o banco operacional do Mottainai e vivem no repositório **[`Mottainai-Banco-Operacional`](https://github.com/Mottainai-One/Mottainai-Banco-Operacional)** (versão da branch `feat/atender-scope-statement`, que incorpora as features de escopo — custo médio, sazonalidade e ranking de perdas — e o motor de diagnóstico).

Esta pasta **documenta** o script; os arquivos `.sql` propriamente ditos não ficam aqui.

## Conteúdo desta pasta

| Documento | Conteúdo |
|---|---|
| [`README.md`](README.md) | Visão geral, requisitos e instalação (este arquivo) |
| [`01-estrutura-do-script.md`](01-estrutura-do-script.md) | Detalhamento arquivo a arquivo (objetos criados, dependências e ordem) |

## Requisitos

- **PostgreSQL 15+** (utiliza `CREATE PROCEDURE`, particionamento por `RANGE`, `GENERATED ALWAYS AS` e `pg_partitions`).
- **Collation** do cluster: `pt_BR` ou `C` (o `00_DataBase.sql` referencia a criação do banco com suporte a acentuação; em bancos já criados, apenas *schema*/objetos são recriados).
- **Extensões** habilitadas automaticamente: `uuid-ossp`, `pgcrypto`, `btree_gin`.
- **Superusuário/permissão** para criar schema, extensões e executar o `install` (o `dataLoad.sql` é exclusivo de ambiente de teste/seed).

## Como instalar

O arquivo **`install.sql`** é o orquestrador: ele executa os scripts na ordem correta e emit mensagens de progresso.

```bash
# Passo 1 — criar/entrar no banco e rodar o instalador
psql -U postgres -d mottainai -f script/install.sql

# Passo 2 — carga de dados de teste (ambiente de seed/desenvolvimento apenas)
psql -U postgres -d mottainai -f script/dataLoad.sql

# Passo 3 — rodar a suíte de testes (requer a carga do Passo 2)
psql -U postgres -d mottainai -c "SELECT * FROM run_all_tests();"
```

> ⚠️ **`dataLoad.sql` é somente para ambiente de teste/seed.** Ele é idempotente (pode ser executado 2x), mas apaga e reinsere dados de várias tabelas e não deve ser executado em ambiente de produção.

## Ordem executada pelo `install.sql`

| Passo | Script | Responsabilidade |
|---|---|---|
| 1 | `00_DataBase.sql` | Extensões, schemas `mottainai` e `mottainai_analytics`, `search_path` |
| 2 | `01_Enums.sql` | 24 tipos enum de estado de negócio |
| 3 | `02_functions.sql` | Funções de validação, sessão, FEFO, estoque atômico e KPIs |
| 4 | `03_tables.sql` | Tabelas (cadastro, catálogo, estoque, vendas/PDV, IA, logs) |
| 5 | `04_constraints.sql` | Row Level Security (RLS) e políticas multitenancy |
| 6 | `05_index.sql` | Índices únicos parciais, parciais e de apoio a FK |
| 7 | `06_triggers.sql` | Triggers e funções de trigger (SKU, lote, auditoria, FEFO) |
| 8 | `07_views.sql` | Views operacionais + camada analítica (`mottainai_analytics`) |
| 9 | `08_seed.sql` | Dados iniciais (planos, cargos, categorias, perfis fiscais, IA) |
| 10 | `09_procedures.sql` | Partições, regras de negócio, aprovação de promoção/cancelamento de caixa |
| 11 | `10_tests.sql` | Funções de teste e runner `run_all_tests()` |

## Resumo dos objetos criados

| Grupo | Quantidade | Observação |
|---|---|---|
| Schemas | 2 | `mottainai` (OLTP) e `mottainai_analytics` (OLAP/views) |
| Enums | 24 | Estados de pedido, estoque, venda, IA, auditoria, logs |
| Tabelas | 68 + 3 arquivos | 3 arquivos `*_archive` criados via `LIKE` |
| Funções | 19 + 8 de trigger + 3 de regras | Inclui validação CPF/CNPJ/e-mail, FEFO, custo médio |
| Procedures | 3 | Partições antigas, decisão de promoção, decisão de cancelamento de venda |
| Triggers | 10 | SKU, soft delete, lote automático, FEFO, auditoria, histórico |
| Views | 35 | 5 operacionais + 1 materializada + 29 analíticas |
| RLS | 6 tabelas | Políticas por `company_id` da sessão |
| Particionamento | 4 tabelas | `purchase_order`, `inventory_movement`, `sales_transaction`, `audit_log` (mensal) |

## Relação com os modelos

O script é a implementação física dos modelos documentados neste repositório:

- **[Modelo Conceitual](../modelo-conceitual/README.md)** — entidades, domínios e regras de negócio.
- **[Modelo Lógico](../model-logico/README.md)** — detalhamento de tabelas, colunas e restrições no PostgreSQL.

Para cada tabela/documento do modelo lógico, o correspondente `CREATE TABLE` está no `03_tables.sql`; enums no `01_Enums.sql`; views analíticas no `07_views.sql`.

---

*Última atualização: 2026-09-04 · Repositório: `Mottainai-Hub-` → `Docs/banco/script` · Script de referência: `Mottainai-Banco-Operacional` (v6.0 Enterprise Final)*