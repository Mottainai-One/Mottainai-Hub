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
| `mottainai_customer_api` | Role de grupo exclusiva do aplicativo do cliente | `NOLOGIN`, `NOBYPASSRLS`, sem acesso a auditoria ou integração legada |
| Login real da API | Autentica no PostgreSQL/Render | Deve ser membro de `mottainai_api` e usar `SET LOCAL ROLE` |
| Pipeline analítico | Consumir eventos confirmados | Credencial própria, sem acesso administrativo ao OLTP |

Nenhuma senha é criada pelos scripts. A associação do login real é feita pelo
administrador do ambiente:

```sql
GRANT mottainai_api TO nome_real_do_login_da_api;
```

O instalador aceita ambientes PostgreSQL gerenciados nos quais o migrator tem
`CREATEROLE`, mas não `SUPERUSER`. Atributos reservados (`SUPERUSER`,
`REPLICATION` e `BYPASSRLS`) são consultados em `pg_roles`: se estiverem
desativados, a instalação continua; se algum estiver ativo, o processo falha
fechado e exige correção por um administrador autorizado.

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

- senha e token de recuperação de baixa entropia são calculados pela API com BCrypt (`$2a$`, `$2b$` ou `$2y$`); o banco recebe somente o hash;
- refresh token e convite, gerados com alta entropia, são persistidos como SHA-256 prefixado;
- identificadores pessoais usados para busca são tokens SHA-256 prefixados, nunca o valor aberto;
- refresh deve rotacionar o hash a cada uso;
- logout preenche `revoked_at`, sem exclusão física;
- troca de senha revoga todas as sessões ativas do usuário;
- tentativa de reutilização de refresh token deve revogar a cadeia da sessão;
- tokens e hashes nunca aparecem em resposta, log ou evento.

## Contrato de dados protegidos

O banco operacional segue o contrato definido com o banco legado. Dados
compartilhados chegam pelo backend/RPA já mascarados, anonimizados ou
tokenizados. A integração registra apenas metadados e o checksum do payload em
`legacy_sync_record`; o payload pessoal bruto não é persistido.

Para registros novos, a API usa tokens versionados como
`CPF_SHA256_<64-hex>`, `EMAIL_SHA256_<64-hex>`, `PHONE_SHA256_<64-hex>` e
`AUTH_SHA256_<64-hex>`. Valores legados já aprovados, como `CPF_TKN_*`,
`EMAIL_EMP_*` e contatos mascarados, continuam aceitos durante a transição.
SHA-256 deve ser calculado pela aplicação com segredo do ambiente para campos
de baixa entropia. O banco valida formato e recusa dados abertos.

O módulo de clientes obedece ao mesmo princípio, mesmo sem origem no legado:

- nome, CPF, e-mail, telefone, UID externo e endereço são tokens protegidos;
- data de nascimento exata não é armazenada; somente `birth_year`;
- consentimentos são versionados e auditados em `customer_consent`;
- a role `mottainai_customer_api` usa `fn_bootstrap_customer_context` e só
  enxerga o próprio cliente por RLS.

## Auditoria

`audit_log` registra tabela, operação, registro, usuário, empresa, loja, IP,
aplicação cliente, transação e estados anterior/novo. Antes da gravação são
removidos recursivamente `password_hash`, hashes de token, documentos e dados
pessoais, inclusive quando estiverem aninhados em JSON.

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
- [ ] Senhas usam BCrypt; tokens aleatórios usam gerador criptográfico e SHA-256.
- [ ] Backends enviam somente valores compatíveis com o contrato protegido.
- [ ] Login do aplicativo cliente recebeu membership em `mottainai_customer_api`.
- [ ] TLS obrigatório e credenciais fora do código.
- [ ] Backup restaurado com sucesso em ambiente isolado.
- [ ] Alertas e retenção de auditoria configurados.
