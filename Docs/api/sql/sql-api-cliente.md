# API SQL Cliente

## Responsabilidade

Serviço SQL destinado aos fluxos do aplicativo do consumidor. O escopo descrito para o produto inclui autenticação e experiências de perfil, catálogo, fidelidade e localização. A disponibilidade de cada recurso depende da implementação na branch consumida pelo aplicativo.

**Implementação:** [Mottainai-Api-SQL-Cliente](https://github.com/Mottainai-One/Mottainai-Api-SQL-Cliente)

## Estado observado na `main`

Em 2026-10-31, o README e a árvore da branch `main` descreviam apenas uma estrutura inicial Spring Boot, com classe de inicialização e teste de contexto. Não havia controllers de negócio, integração PostgreSQL, configuração Firebase, Spring Security ou dependência OpenAPI nessa branch. Assim, esta documentação não anuncia endpoints de cliente como disponíveis na `main`.

O README do repositório informa que funcionalidades de perfil, catálogo, fidelidade, geofencing e autenticação aparecem em branches de desenvolvimento. Verifique a branch escolhida e sua implementação antes de usar seus contratos; documentação em uma branch não comprova incorporação à `main`, implantação ou homologação ponta a ponta.

## Contratos e integração

Use o [repositório SQL Cliente](https://github.com/Mottainai-One/Mottainai-Api-SQL-Cliente) como referência para código, documentação e branches do serviço. Antes de integrar um fluxo, confirme na mesma revisão:

1. que o controller e o contrato estão presentes;
2. qual mecanismo de autenticação e autorização está configurado;
3. quais configurações externas e dados de banco são necessários;
4. se a versão foi integrada, implantada e validada para o ambiente consumidor.

O banco operacional, suas migrations e políticas são administrados separadamente. Não inferir que Firebase, recuperação de senha, endpoints Swagger ou integração ponta a ponta estão disponíveis sem evidência na branch e no ambiente em uso.

## Relação com a API Operacional

A API Cliente e a API Operacional são serviços distintos. A API Operacional ainda documenta algumas rotas de cliente como transitórias; consulte o [guia operacional](sql-api-operacional.md) e confirme o estado de migração antes de depender dessas rotas. Para contratos do consumidor, prefira a implementação SQL Cliente assim que eles estiverem presentes na branch adotada.
