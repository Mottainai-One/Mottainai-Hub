# Instalação e Atualização

## Pré-requisitos

- PostgreSQL 15 ou superior;
- `psql` disponível;
- permissão para extensões, schemas e roles na instalação;
- bancos físicos `mottainai_operational` e `mottainai_analytics`;
- backup validado antes de atualizar uma base existente.

## Instalação nova

Clone o repositório `Mottainai-Banco-Operacional` e execute:

```bash
psql -v ON_ERROR_STOP=1 \
  -d mottainai_operational \
  -f database/operational/install.sql
```

Depois instale o banco analítico:

```bash
psql -v ON_ERROR_STOP=1 \
  -d mottainai_analytics \
  -f database/analytics/install.sql
```

Os instaladores usam `\ir`; por isso devem ser executados pelo `psql` ou por
uma ferramenta de migration configurada na mesma ordem.

## Atualização de base existente

Ordem recomendada para esta versão:

1. aplicar a migration de `product.company_id`;
2. resolver qualquer produto com propriedade ambígua;
3. executar os testes de produto;
4. aplicar o hardening de segurança;
5. executar os testes de segurança;
6. associar o login real da API à role `mottainai_api`;
7. publicar a API compatível com o novo contrato transacional.

```bash
psql -v ON_ERROR_STOP=1 -d mottainai_operational \
  -f database/operational/10_product_company.sql

psql -v ON_ERROR_STOP=1 -d mottainai_operational \
  -f database/operational/11_product_company_tests.sql

psql -v ON_ERROR_STOP=1 -d mottainai_operational \
  -f database/operational/20_security_hardening.sql

psql -v ON_ERROR_STOP=1 -d mottainai_operational \
  -f database/operational/21_security_hardening_tests.sql
```

Se um produto antigo estiver ligado a mais de uma empresa, a migration para
sem escolher um tenant arbitrariamente. Duplique o cadastro por empresa,
redirecione as referências operacionais e reaplique o script.

## Partições mensais

O operacional mantém 12 meses anteriores, o mês atual e 6 futuros para:

- `purchase_order` por `order_date`;
- `inventory_movement` por `movement_date`;
- `sales_transaction` por `sale_date`;
- `audit_log` por `operation_date`.

O analítico usa a mesma janela inicial nas quatro maiores tabelas de fatos.
Execute a manutenção antes da virada do mês e monitore partições default no
analítico.

## Validação pós-instalação

- confirmar versões em `mottainai.schema_version`;
- confirmar que `mottainai_api` não tem `BYPASSRLS`;
- testar dois tenants distintos com a role da API;
- testar login, refresh, logout e revogação por troca de senha;
- verificar que auditoria não contém CPF ou hashes;
- medir poda de partição com `EXPLAIN (ANALYZE, BUFFERS)`;
- confirmar ingestão idempotente no banco analítico.
