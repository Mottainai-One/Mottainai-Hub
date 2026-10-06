# Estrutura e Dependências dos Scripts

## Fluxo de criação

```text
infraestrutura
  -> tipos
  -> funções sem dependência de tabela
  -> tabelas principais
  -> tabelas adicionais
  -> segurança básica
  -> índices
  -> triggers
  -> views
  -> procedures e partições
  -> seed mínimo
  -> produto por empresa
  -> testes gerais e de produto
  -> hardening profissional
  -> testes de segurança
```

## Migrations recentes

### Produto por empresa

`10_product_company.sql` adiciona `product.company_id`, descobre a empresa por
preço, estoque, compra, venda, promoção e reposição, troca unicidades globais
por `(company_id, sku)` e `(company_id, barcode)`, atualiza geração de SKU e
ativa RLS. A migration não inventa propriedade em caso de conflito.

### Hardening de segurança

`20_security_hardening.sql` adiciona:

- role de grupo `mottainai_api` sem login e sem privilégios administrativos;
- `app_user.password_set` e finalidade dos tokens;
- `staff_session` com refresh token hash, expiração e revogação;
- bootstraps validados por login, token e sessão;
- proteção dos parâmetros de contexto contra `SET` e `set_config`;
- RLS em cabeçalhos, itens e entidades críticas;
- `security_invoker=true` nas views da API;
- auditoria por tenant, imutável e sanitizada;
- limites de timeout e grants mínimos.

## Reaplicação

As migrations recentes podem ser reaplicadas. `CREATE ... IF NOT EXISTS`,
`DROP POLICY IF EXISTS`, verificações no catálogo e `ON CONFLICT` evitam
duplicação. Reaplicar não substitui backup nem revisão do plano de migration.

## Testes

| Arquivo | Verifica |
|---|---|
| `10_tests.sql` | Tabelas obrigatórias, separação física e partições |
| `11_product_company_tests.sql` | FK, índice, unicidades por empresa, RLS e SKU |
| `21_security_hardening_tests.sql` | Atributos da role, parâmetros protegidos, RLS, views e auditoria imutável |

Além da suíte estrutural, a validação de release deve testar dois tenants,
sessão, revogação, auditoria sanitizada e tentativa de falsificação de contexto.
