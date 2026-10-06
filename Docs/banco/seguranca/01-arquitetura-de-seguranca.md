# Arquitetura de Segurança do Banco Operacional

> PostgreSQL 15+ · defesa em profundidade · multitenancy por empresa e loja

## Objetivo

Evitar acesso entre empresas, limitar o impacto de uma credencial comprometida,
proteger tokens e dados pessoais e manter evidência confiável das operações.
Segurança de banco complementa autenticação, autorização e validação realizadas
pela API; não substitui essas camadas.

## Papéis e responsabilidades

| Papel | Finalidade | Restrições principais |
|---|---|---|
| Proprietário/migrator | Instalar migrations e manter objetos | Nunca usado pela API |
| `mottainai_api` | Role de grupo usada durante requisições | `NOLOGIN`, `NOSUPERUSER`, `NOCREATEDB`, `NOCREATEROLE`, `NOBYPASSRLS`, sem DDL |
| Login real da API | Autentica no PostgreSQL/Render | Deve ser membro de `mottainai_api` e usar `SET LOCAL ROLE` |
| Pipeline analítico | Consumir eventos confirmados | Credencial própria, sem acesso administrativo ao OLTP |

Nenhuma senha é criada pelos scripts. A associação do login real é feita pelo
administrador do ambiente:

```sql
GRANT mottainai_api TO nome_real_do_login_da_api;
```

## Contexto seguro por transação

O contexto contém `user_id`, `company_id` e `store_id`. Ele é obtido dos
relacionamentos reais entre `app_user`, `employee`, `retail_store` e `company`.
A API não informa livremente a empresa ou loja.

```sql
BEGIN;
SET LOCAL ROLE mottainai_api;
SELECT mottainai.fn_bootstrap_staff_context(:identity, :lookup);
-- comandos da requisição
COMMIT;
```

Valores válidos de `lookup`:

- `CPF`: login ativo por CPF;
- `EMAIL`: login ativo por e-mail;
- `INVITED_CPF`: primeira definição de senha de usuário convidado.

Para fluxos sem senha:

- `fn_bootstrap_staff_context_by_token`: recuperação de senha ou convite;
- `fn_bootstrap_staff_context_by_session`: renovação por sessão e hash do refresh token.

O setter antigo não é executável pela API. `SET`, `set_config` e permissões de
parâmetro também são revogados para `app.current_user_id`,
`app.current_company_id` e `app.current_store_id`. Isso impede falsificação do
tenant mesmo que uma consulta arbitrária alcance a conexão da API.

## Row Level Security

As políticas são atribuídas explicitamente à role `mottainai_api`.

| Perfil | Escopo de loja |
|---|---|
| `Administrator` | Todas as lojas ativas da empresa do usuário |
| Demais perfis | Somente `app.current_store_id` |

RLS protege cabeçalhos e tabelas filhas dos fluxos de estoque, compra,
recebimento, PDV, venda, promoção, transferência, doação, descarte e reposição.
`product` usa `company_id`: uma empresa pode possuir muitos produtos e cada
produto pertence a exatamente uma empresa.

Views da API usam `security_invoker=true`; portanto, não herdam o poder do dono
da view e continuam submetidas ao RLS do chamador.

## Credenciais, tokens e sessões

- senha é calculada pela API com Argon2id; o banco recebe somente o hash;
- token de recuperação/convite é persistido somente como hash;
- refresh token é persistido somente como hash em `staff_session`;
- refresh deve rotacionar o hash a cada uso;
- logout preenche `revoked_at`, sem exclusão física;
- troca de senha revoga todas as sessões ativas do usuário;
- tentativa de reutilização de refresh token deve revogar a cadeia da sessão;
- tokens e hashes nunca aparecem em resposta, log ou evento.

## Auditoria

`audit_log` registra tabela, operação, registro, usuário, empresa, loja, IP,
aplicação cliente, transação e estados anterior/novo. Antes da gravação são
removidos `password_hash`, hashes de token, `recovery_token_hash` e CPF.

A role da API possui somente leitura filtrada por empresa. Escrita, alteração,
exclusão e truncamento são proibidos; os triggers gravam por função
`SECURITY DEFINER` com `search_path` fixo. Uma escrita auditada da API sem
contexto validado falha em vez de continuar sem evidência.

## Controles fora do SQL

O ambiente deve complementar o banco com:

- TLS com certificado validado (`sslmode=verify-full` quando suportado);
- secret manager e rotação periódica de credenciais;
- pool configurado para iniciar e encerrar transação por requisição;
- backups criptografados, PITR e testes de restauração;
- alertas para falhas de login, violações de RLS e alterações de privilégios;
- atualização de PostgreSQL e extensões dentro da janela de suporte;
- retenção e anonimização alinhadas à LGPD e às obrigações fiscais.

## Checklist para produção

- [ ] PR de propriedade de produto por empresa aplicada.
- [ ] Migration de hardening aplicada e testes aprovados.
- [ ] Login real recebeu membership em `mottainai_api`.
- [ ] API usa transação e `SET LOCAL ROLE` por requisição.
- [ ] Senhas usam Argon2id e tokens usam gerador criptográfico.
- [ ] TLS obrigatório e credenciais fora do código.
- [ ] Backup restaurado com sucesso em ambiente isolado.
- [ ] Alertas e retenção de auditoria configurados.
