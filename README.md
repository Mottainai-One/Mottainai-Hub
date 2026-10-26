# Mottainai Hub

Repositório central de documentação do ecossistema Mottainai. Reúne guias de arquitetura, operação, banco de dados, APIs e aplicativos; não contém a implementação dos serviços.

## Navegação

- [Banco de dados](Docs/banco/README.md): índices da documentação operacional e analítica.
- [Operação dos bancos](Docs/banco/operacao/README.md): instalação, sessões/RLS e operação.
- [API SQL](Docs/api/sql/sql-api-full-documentation.md): documentação da API operacional.
- [DevOps](Docs/devops/README.md): Docker, Kubernetes, cloud, CI/CD, automação e revisão de código.
- [Aplicativo operacional](Docs/mobile/MOTTAINAI-OPERACIONAL-FUNCIONAL-E-TECNICO.md): documentação funcional e técnica.
- [Aplicativo cliente](Docs/mobile/MOBILE-CLIENTE.md): documentação funcional e técnica.
- [UX e pesquisa](Docs/ux/00-indice-e-status-da-rubrica.pdf): índice dos materiais de pesquisa e design.
- [Histórico](CHANGELOG.MD): alterações registradas nesta documentação.

Os documentos de banco estão agrupados por operação, modelo conceitual, modelo lógico e scripts em Docs/banco. Os materiais de UX estão em PDF; os guias de API, DevOps e aplicativos estão em Markdown.

## Como interpretar a documentação

Alguns documentos técnicos registram checkouts locais, branches de integração e estados observados em datas específicas. Eles distinguem implementação local, publicação e homologação. Para comportamento executável, confira o código e os arquivos de configuração da branch usada; em caso de divergência, não trate um estado local ou planejado como publicado.

## Como contribuir

Edite a documentação na pasta correspondente e confira os links relativos antes de abrir uma pull request. Preserve o escopo e as limitações registrados pelos projetos; a documentação deste repositório não substitui os contratos mantidos nos repositórios de implementação.
