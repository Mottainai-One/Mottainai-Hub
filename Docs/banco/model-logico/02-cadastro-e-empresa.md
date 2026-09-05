# 02 — Cadastro e Empresa

Domínio **multitenant (SaaS)** do Mottainai. Define o locatário (empresa), suas unidades (lojas), a hierarquia de funcionários, os usuários de acesso e os endereços reutilizados em todo o sistema.

```
subscription_plan ──< company ──< retail_store ──< employee ── 1:1 ── app_user
                      │                │
                      │                └──< address
                      └──< address
(employee também referencia retail_store e employee_role)
```

## `subscription_plan`

Tipo de assinatura SaaS oferecida a uma empresa.

| Coluna | Tipo | Restrições |
|---|---|---|
| `plan_id` 🔑 | `INTEGER` identity | `PK` |
| `name` 🔎 | `VARCHAR(100)` | `NN` `UQ` |
| `description` | `TEXT` | |
| `price` ✅ | `DECIMAL(10,2)` | `NN` `CHECK ≥ 0` |
| `store_limit` ✅ | `INTEGER` | `NN` `CHECK > 0` |
| `user_limit` ✅ | `INTEGER` | `NN` `CHECK > 0` |
| `active` | `BOOLEAN` | `def TRUE` |
| `created_at` / `updated_at` / `deleted_at` | `TIMESTAMP` | |

## `company`

A empresa é o **locatário** do sistema SaaS e dono de uma ou mais lojas.

| Coluna | Tipo | Restrições |
|---|---|---|
| `company_id` 🔑 | `INTEGER` identity | `PK` |
| `plan_id` 🔗 | `INTEGER` | `NN` `FK → subscription_plan(plan_id) ON DELETE RESTRICT` |
| `official_name` | `VARCHAR(150)` | `NN` |
| `trade_name` | `VARCHAR(150)` | |
| `cnpj` | `CHAR(14)` | `NN` `UQ` `CHECK fn_validate_cnpj` |
| `email` | `VARCHAR(150)` | `NN` `CHECK fn_validate_email` |
| `phone` | `VARCHAR(20)` | |
| `latitude` / `longitude` | `DECIMAL(9,6)` | `CHECK` faixas globais |
| `active` | `BOOLEAN` | `def TRUE` |
| timestamps | `TIMESTAMP` | `created_at`, `updated_at`, `deleted_at` |

**Observações:** sujeita a **RLS** (isolamento por locatário).

## `retail_store`

Unidade/filial da empresa; cada loja gerencia seu próprio estoque, também usada como **fonte/destino** de transferências e **destino** de geocercas do cliente.

| Coluna | Tipo | Restrições |
|---|---|---|
| `store_id` 🔑 | `INTEGER` identity | `PK` |
| `company_id` 🔗 | `INTEGER` | `NN` `FK → company(company_id) ON DELETE RESTRICT` |
| `address_id` 🔗 | `INTEGER` | `NN` `FK → address(address_id) ON DELETE RESTRICT` |
| `name` | `VARCHAR(120)` | `NN` |
| `cnpj` | `CHAR(14)` | `NN` `UQ` `CHECK fn_validate_cnpj` |
| `email` / `phone` | `VARCHAR` | `email` valida `fn_validate_email` |
| `latitude` / `longitude` | `DECIMAL(9,6)` | `CHECK` faixas globais |
| `active` | `BOOLEAN` | `def TRUE` |
| timestamps | `TIMESTAMP` | `created_at`, `updated_at`, `deleted_at` |

**Observações:** sujeita a **RLS**.

## `employee_role`

Cargo/papel do funcionário; define o **nível de permissão** (Operador de caixa, Estoquista, Gerente, Dono).

| Coluna | Tipo | Restrições |
|---|---|---|
| `role_id` 🔑 | `INTEGER` identity | `PK` |
| `name` 🔎 | `VARCHAR(80)` | `NN` `UQ` |
| `description` | `TEXT` | |
| `permission_level` ✅ | `INTEGER` | `NN` `CHECK ≥ 0` |
| `active` | `BOOLEAN` | `def TRUE` |
| timestamps | `TIMESTAMP` | |

## `employee`

Funcionário vinculado a uma loja e a um papel.

| Coluna | Tipo | Restrições |
|---|---|---|
| `employee_id` 🔑 | `INTEGER` identity | `PK` |
| `store_id` 🔗 | `INTEGER` | `NN` `FK → retail_store(store_id) ON DELETE RESTRICT` |
| `role_id` 🔗 | `INTEGER` | `NN` `FK → employee_role(role_id) ON DELETE RESTRICT` |
| `name` | `VARCHAR(150)` | `NN` |
| `cpf` | `CHAR(11)` | `NN` `UQ` `CHECK fn_validate_cpf` |
| `email` / `phone` | `VARCHAR` | `email` valida `fn_validate_email` |
| `hire_date` | `DATE` | `NN` `def CURRENT_DATE` |
| `active` | `BOOLEAN` | `def TRUE` |
| timestamps | `TIMESTAMP` | |

**Observações:** sujeita a **RLS**. Índice único parcial sobre CPF ativo.

## `app_user`

Credencial de acesso de um funcionário (login e senha). Cada funcionário tem **no máximo um** usuário.

| Coluna | Tipo | Restrições |
|---|---|---|
| `user_id` 🔑 | `INTEGER` identity | `PK` |
| `employee_id` 🔗 | `INTEGER` | `NN` `UQ` `FK → employee(employee_id) ON DELETE RESTRICT` |
| `email` 🔎 | `VARCHAR(150)` | `NN` `UQ` `CHECK fn_validate_email` |
| `password_hash` | `VARCHAR(255)` | `NN` |
| `last_login` | `TIMESTAMP` | |
| `active` | `BOOLEAN` | `def TRUE` |
| timestamps | `TIMESTAMP` | |

## `address`

Endereço reutilizado por empresa/loja (via relação), fornecedor e cliente.

| Coluna | Tipo | Restrições |
|---|---|---|
| `address_id` 🔑 | `INTEGER` identity | `PK` |
| `zip_code` ✅ | `CHAR(8)` | `NN` `CHECK ~ ^\d{8}$` |
| `street` | `VARCHAR(150)` | `NN` |
| `number` | `VARCHAR(10)` | `NN` |
| `complement` | `VARCHAR(100)` | |
| `neighborhood` | `VARCHAR(100)` | `NN` |
| `city` | `VARCHAR(100)` | `NN` |
| `state` ✅ | `CHAR(2)` | `NN` `CHECK ^[A-Z]{2}$` |
| timestamps | `TIMESTAMP` | |

---

*Próximo: [03 — Produto e Compras](03-produto-e-compras.md)*
