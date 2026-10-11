# Instalação e Atualização

## Pré-requisitos

- PostgreSQL 15 ou superior;
- `psql` disponível;
- permissão para extensões, schemas e roles na instalação;
- bancos físicos `mottainai_operational` e `mottainai_analytics`;
- backup validado antes de atualizar uma base existente.

Em um PostgreSQL gerenciado, o usuário de migration pode ter `CREATEROLE` sem
ser `SUPERUSER`. O instalador não tenta alterar atributos reservados; ele
verifica que as roles de API não possuem `SUPERUSER`, `REPLICATION` ou
`BYPASSRLS` e interrompe com uma mensagem segura se encontrar configuração
privilegiada.

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

O atualizador consolidado executa os módulos de produto, segurança, dados
sensíveis, compatibilidade JPA e contrato API/RPA na ordem segura e em uma
única transação:

```bash
psql -v ON_ERROR_STOP=1 -d mottainai_operational \
  -f database/operational/update_existing_api_rpa.sql
```

Se um produto antigo estiver ligado a mais de uma empresa, a migration para
sem escolher um tenant arbitrariamente. Duplique o cadastro por empresa,
redirecione as referências operacionais e reaplique o script.

Depois da atualização, execute `11_product_company_tests.sql` e
`26_api_rpa_compatibility_tests.sql`. Associe os logins reais às roles de grupo
fora do repositório:

```sql
GRANT mottainai_api TO login_real_da_api;
GRANT mottainai_customer_api TO login_real_do_app_cliente;
GRANT mottainai_migrator TO login_real_da_rpa;
```

A RPA deve iniciar uma transação, usar `SET LOCAL ROLE mottainai_migrator`,
chamar `fn_set_legacy_migration_context(company_id)`, executar os upserts e
encerrar o contexto antes do `COMMIT`.

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
- confirmar que `mottainai_customer_api` não acessa auditoria ou integração legada;
- testar dois tenants distintos com a role da API;
- testar dois clientes distintos com a role exclusiva do aplicativo;
- testar login, refresh, logout e revogação por troca de senha;
- verificar que valores abertos são recusados e auditoria aninhada é sanitizada;
- medir poda de partição com `EXPLAIN (ANALYZE, BUFFERS)`;
- confirmar ingestão idempotente no banco analítico;
- confirmar as dez views `vw_api_*` e as funções transacionais da API;
- testar uma importação RPA com auditoria e `user_id` nulo.
