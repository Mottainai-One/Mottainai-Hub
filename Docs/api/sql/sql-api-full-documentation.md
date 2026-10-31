# APIs SQL do Mottainai

## Arquitetura

A antiga API SQL unificada foi separada em dois serviços com responsabilidades distintas: a **API SQL Operacional**, voltada à operação de lojas e equipes, e a **API SQL Cliente**, destinada aos fluxos do aplicativo do consumidor. A separação reduz o escopo de cada serviço e permite manter e carregar cada API de acordo com seu público. Este Hub documenta a divisão; os repositórios de implementação são a referência para contratos e comportamento.

| Serviço | Repositório | Responsabilidade |
| --- | --- | --- |
| SQL Operacional | [Mottainai-Api-SQL-Operacional](https://github.com/Mottainai-One/Mottainai-Api-SQL-Operacional) | Operação de lojas, equipes, catálogo, estoque e rotinas relacionadas. |
| SQL Cliente | [Mottainai-Api-SQL-Cliente](https://github.com/Mottainai-One/Mottainai-Api-SQL-Cliente) | Experiências do consumidor no aplicativo, como perfil, catálogo e fidelidade quando implementadas na versão consultada. |

## Documentação por serviço

- [API SQL Operacional](sql-api-operacional.md)
- [API SQL Cliente](sql-api-cliente.md)

## Estado conferido

Os guias foram alinhados à branch `main` dos repositórios consultados em 2026-10-31. No estado observado, a API Operacional tem uma aplicação Spring Boot com controllers e documentação de rotas no próprio repositório. A `main` da API Cliente contém a estrutura inicial da aplicação, sem controllers de negócio; funcionalidades descritas como objetivo do produto não devem ser tratadas como endpoints disponíveis nessa branch.

O código da API Operacional ainda lista rotas `/api/v1/client/**`, `/api/v1/customer-catalog/**` e `/api/v1/customers/**` como transitórias. A existência dessas rotas no serviço Operacional não altera a divisão de responsabilidade documentada: registre e consuma contratos de cliente no repositório SQL Cliente quando eles forem implementados e incorporados à branch de referência. Não presuma que rotas transitórias já foram migradas ou removidas.

## Fonte de verdade e manutenção

Este Hub apresenta a arquitetura e direciona para cada implementação. Para métodos, payloads, autenticação, permissões, configuração e disponibilidade de uma rota, consulte a branch efetivamente implantada do respectivo repositório. A implementação e sua documentação versionada prevalecem sobre este resumo. Ao alterar contratos, atualize o guia do serviço correspondente e registre a branch e a data conferidas.
