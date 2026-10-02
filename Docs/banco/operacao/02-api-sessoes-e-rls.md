# Contrato da API: Sessões e RLS

## Login

1. iniciar transação;
2. assumir localmente a role `mottainai_api`;
3. localizar a conta e validar o hash Argon2id na aplicação;
4. chamar `fn_bootstrap_staff_context`;
5. criar `staff_session` com hash do refresh token;
6. confirmar a transação;
7. devolver access e refresh tokens sem persistir seus valores originais.

## Requisição autenticada

Toda requisição deve possuir uma transação própria. O contexto é local à
transação e desaparece no `COMMIT` ou `ROLLBACK`, evitando vazamento entre
requisições que compartilham o mesmo pool.

```sql
BEGIN;
SET LOCAL ROLE mottainai_api;
SELECT mottainai.fn_bootstrap_staff_context(:email, 'EMAIL');
SELECT * FROM mottainai.inventory WHERE store_id = :store_id;
COMMIT;
```

O retorno falso ou nulo das funções de bootstrap deve gerar `401`/`403` e
`ROLLBACK`. A API nunca deve aceitar `company_id` do cliente como fonte de
autorização; o banco obtém essa informação do usuário autenticado.

## Refresh

1. calcular o hash do refresh token recebido;
2. iniciar contexto por `fn_bootstrap_staff_context_by_session`;
3. validar expiração e `revoked_at`;
4. substituir o hash e atualizar `last_used_at` na mesma transação;
5. se houver reutilização, revogar a sessão e exigir novo login.

## Logout e troca de senha

- logout: preencher `revoked_at` e `revoked_reason='LOGOUT'`;
- troca de senha: atualizar o hash Argon2id e revogar todas as sessões ativas;
- bloqueio administrativo: desativar `app_user` e revogar sessões;
- não apagar fisicamente sessões, tokens usados ou auditoria.

## Convite e recuperação

`password_reset_token.token_type` aceita:

- `PASSWORD_RESET` para conta ativa;
- `EMPLOYEE_INVITATION` para conta inativa com `password_set=false`.

O token é de uso único (`used_at`), tem expiração e nunca é armazenado em texto
puro. Após o primeiro cadastro de senha, a API define `password_set=true` e
ativa usuário e funcionário na mesma transação.

## Respostas e logs

Nunca retornar ou registrar:

- `password_hash`;
- qualquer hash ou valor de token;
- CPF integral sem necessidade autorizada;
- payload bruto de integração com dados pessoais;
- detalhes internos de política RLS ou estrutura de privilégios.
