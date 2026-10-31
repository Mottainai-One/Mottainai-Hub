# API SQL Operacional

## Responsabilidade

Serviço Spring Boot destinado à operação de lojas e às ferramentas das equipes. O repositório descreve recursos de funcionários, empresas, lojas, catálogo, estoque, compras, promoções, alertas e reposição.

**Implementação:** [Mottainai-Api-SQL-Operacional](https://github.com/Mottainai-One/Mottainai-Api-SQL-Operacional)

## Arquitetura observada na `main`

O README e o código da branch `main` consultados em 2026-10-31 descrevem:

- Aplicação Spring Boot sobre PostgreSQL operacional; a API valida o mapeamento do schema e não cria o schema automaticamente.
- Isolamento de acesso a dados por RLS, com contexto de equipe estabelecido no fluxo de serviços.
- Login operacional com Firebase ID token e senha da API, seguido da emissão de JWT próprio, revogável por sessão.
- Permissões derivadas dos papéis e permissões armazenados no banco.
- Proteção de dados pessoais usando tokens, HMAC para busca e payloads criptografados AES-256-GCM, conforme descrito pelo repositório.
- OpenAPI/Swagger e a documentação técnica mantida junto à implementação.

O README da implementação informa 36 controllers e 177 operações HTTP mapeadas nessa branch. Esses números descrevem o código observado e podem mudar; não são uma garantia para outras branches ou implantações.

## Limite em relação à API Cliente

Apesar da separação dos serviços, a `main` consultada ainda mantém rotas `/api/v1/client/**`, `/api/v1/customer-catalog/**` e `/api/v1/customers/**`, tratadas pelo próprio README da API Operacional como transitórias. Não conclua que esses contratos já foram migrados para o repositório Cliente. Confirme cada rota na versão implantada e acompanhe a migração antes de remover dependências.

## Contratos e execução

Consulte o [README do repositório](https://github.com/Mottainai-One/Mottainai-Api-SQL-Operacional/blob/main/README.md), `API_DOCUMENTATION_COMPLETA.md`, os arquivos em `docs/`, os controllers e a configuração de segurança na branch usada pelo ambiente. Eles contêm a lista de rotas, modelos de requisição e resposta, requisitos de execução e detalhes de autorização. Este Hub não replica o catálogo completo para evitar divergência entre cópias.

Não use valores de ambiente, credenciais ou endpoints de ambientes reais em exemplos. Configuração e comportamento de produção devem ser conferidos com a equipe responsável pelo ambiente.
