# Scripts SQL do Banco Operacional

> Fonte executável: repositório `Mottainai-Banco-Operacional`

Os scripts atuais ficam em `database/operational`. A pasta legada `script/`
permanece apenas para compatibilidade de testes antigos e não é a referência de
uma instalação nova.

## Instalação

```bash
psql -v ON_ERROR_STOP=1 \
  -d mottainai_operational \
  -f database/operational/install.sql
```

O instalador usa `\ir` e abre uma transação única com interrupção no primeiro
erro. Ele não apaga schema, banco ou dados existentes.

## Módulos

| Ordem | Arquivo | Responsabilidade |
|---|---|---|
| 1 | `00_database.sql` | Extensões, schema e `search_path` |
| 2 | `01_enums.sql` | Estados do domínio |
| 3 | `02_functions.sql` | Validação, estoque, FEFO, custo e eventos |
| 4 | `03_tables.sql` | Estrutura operacional principal |
| 5 | `04_additional_tables.sql` | CPF da conta, preços por loja, inventário físico, tokens e outbox |
| 6 | `04_security.sql` | Políticas RLS básicas |
| 7 | `05_indexes.sql` | Índices de busca e apoio a FKs |
| 8 | `06_triggers.sql` | SKU, lote, FEFO, histórico e auditoria |
| 9 | `07_views.sql` | Views operacionais |
| 10 | `08_procedures.sql` | Partições e regras transacionais |
| 11 | `08_partition_maintenance_fix.sql` | Correção segura de manutenção mensal |
| 12 | `09_seed.sql` | Catálogos mínimos e versão inicial |
| 13 | `10_product_company.sql` | Propriedade de produto por empresa |
| 14 | `10_tests.sql` | Validações estruturais gerais |
| 15 | `11_product_company_tests.sql` | Testes da migration de produto |
| 16 | `20_security_hardening.sql` | Roles, sessões, RLS, auditoria e privilégios |
| 17 | `21_security_hardening_tests.sql` | Testes automatizados de segurança |

## Garantias relevantes

- migrations novas são idempotentes;
- dados antigos são preenchidos antes de `NOT NULL`;
- propriedade ambígua de produto interrompe a migration;
- role da API não é criada com login ou senha;
- testes verificam privilégios, RLS, views e auditoria;
- CI instala o schema em PostgreSQL 15 limpo e reaplica migrations críticas.

Veja [01-estrutura-do-script.md](01-estrutura-do-script.md) e o
[guia de instalação](../operacao/01-instalar-e-atualizar.md).
