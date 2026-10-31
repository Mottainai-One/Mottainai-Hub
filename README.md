# Mottainai Hub

Central de documentação e arquitetura do ecossistema Mottainai. O Hub reúne guias de banco, APIs, aplicativos, front-end, DevOps, engenharia de software e UX; os repositórios de cada componente mantêm suas respectivas implementações.

## Como navegar

| Área | Comece por | Conteúdo |
|---|---|---|
| Projeto Mottainai | [Documentação geral](Docs/interdisciplinar/documentacao-geral-mottainai.md) | Finalidade, ecossistema e organização das equipes. |
| Inteligência artificial | [Documentação da IA](Docs/ia/documentacao-mottainai-ia.md) | Agentes, arquitetura, dados, segurança e integrações. |
| Bancos de dados | [Docs/banco/README.md](Docs/banco/README.md) | Arquitetura operacional e analítica, modelo de dados e segurança. |
| Operação dos bancos | [Docs/banco/operacao/README.md](Docs/banco/operacao/README.md) | Instalação, sessões/RLS, backup e procedimentos de limpeza e recarga. |
| API SQL | [Documentação da API](Docs/api/sql/sql-api-full-documentation.md) | Visão técnica, autenticação e rotas documentadas. |
| Mobile Cliente | [Guia funcional e técnico](Docs/mobile/MOBILE-CLIENTE.md) | Escopo, arquitetura e estado das integrações do app cliente. |
| Mobile Cliente — entrega | [Plano](Docs/mobile/cliente/PLANO-MOBILE-CLIENTE.md), [demandas de API](Docs/mobile/cliente/DEMANDAS-API-CLIENTE.md) e [testes](Docs/mobile/cliente/TESTES-ENTREGA-CLIENTE.md) | Contratos, dependências e roteiro de validação. |
| Mobile Operacional | [Guia funcional e técnico](Docs/mobile/MOTTAINAI-OPERACIONAL-FUNCIONAL-E-TECNICO.md) | Fluxos de produtos, estoque, avarias, alertas e integrações. |
| Front-end React | [Índice da documentação](Docs/dad/react/README.md) | Arquitetura, rotas, dados de demonstração, acessibilidade e qualidade. |
| DevOps | [Docs/devops/README.md](Docs/devops/README.md) | Containers, infraestrutura, CI/CD, revisão e automação. |
| Engenharia de software | [Docs/eqs](Docs/eqs) | Material da disciplina, incluindo documento em PDF. |
| UX | [Índice de UX](Docs/ux/00-indice-e-status-da-rubrica.pdf) | Pesquisa, protótipos, testes e materiais de design. |

## Papel no ecossistema

```text
Aplicativos e serviços → repositórios de implementação
                              │
                              └── contratos, estrutura e comportamento reais

Mottainai Hub → guias de arquitetura, operação, produto e referências
```

O banco operacional concentra dados transacionais, enquanto o analítico apoia históricos e indicadores, conforme a [visão de bancos](Docs/banco/README.md). A [documentação de tracking](Docs/banco/tracking) descreve aspectos específicos das duas fontes. O SQL executável e as migrations devem ser consultados no repositório responsável pelo banco.

## Estrutura

```text
.
├── Docs/
│   ├── api/sql/                 # documentação da API SQL
│   ├── banco/                   # modelos, segurança, operação e tracking
│   ├── dad/react/               # documentação do front-end React
│   ├── devops/                  # infraestrutura e entrega
│   ├── eqs/                     # engenharia de software
│   ├── ia/                      # inteligência artificial e integrações
│   ├── interdisciplinar/        # visão geral e organização do projeto
│   ├── mobile/                  # apps e documentação do cliente
│   └── ux/                      # materiais de pesquisa e design em PDF
├── CHANGELOG.MD
└── README.md
```

O diretório de documentação técnica reúne materiais adicionais. Consulte o conteúdo versionado em cada pasta para conhecer seu escopo.

## Contribuição

Atualize o guia da área afetada e indique a data e a versão ou branch analisada. Confira os links relativos e mantenha exemplos livres de credenciais e dados pessoais reais.
