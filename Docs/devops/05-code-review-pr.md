# Code Review + PR + PR Bot

Parte dos requisitos **M1 (CodeReview + PR + aprovações)** e **E2 (Template de PR)**. Este documento explica como o Mottainai automatiza o ciclo de **revisão de código**, garantindo qualidade e rastreabilidade nos Pull Requests.

## Por que automatizar Code Review?

Revisão de código é o primeiro filtro de qualidade. Automatizar o ciclo (criar PR, revisar, aprovar, mesclar) torna o fluxo **consistente, rápido e sem gargalos humanos** — um dos pilares centrais de DevOps.

## O Mottainai PR Bot

Um **GitHub App** que automatiza todo o ciclo de PRs da organização, usando **Probot** + IA (**Gemini**).

### Funcionalidades

1. **Auto-criação de PR** a cada push em branch não-protegida.
2. **Review por IA (Gemini)** — gera resumo, pontos de atenção e descrição sugerida.
3. **Aplicação da descrição** via label `ai:apply-description`.
4. **Branch protection** com **2 approvals obrigatórios**.
5. **Auto-merge** (squash) após **CI verde + aprovações**.
6. **Branches protegidas**: `main, develop, front-end, dados, back-end`.

## Branch Protection (regra de proteção)

| Regra | Valor |
|---|---|
| Branches protegidas | `main, develop, front-end, dados, back-end` |
| Aprovações obrigatórias | **2** |
| CI obrigatório | Sim — merge bloqueado se o pipeline falhar |
| Merge | Squash (histórico limpo) |
| Auto-merge | Acionado pelo bot após aprovações + CI verde |

## Template de PR (E2)

Todos os PRs respeitam um **template padronizado**, definido no repositório da organização (`.github`) e também gerado pelo bot:

```markdown
## O que foi feito
<!-- resumo gerado por IA -->

## Revisão
<!-- pontos de atenção -->

## Tipo de mudança
- [ ] feat / fix / docs / refactor / test / chore
```

- Template da organização: https://github.com/Mottainai-One/.github/blob/main/pull_request_template.md
- Geração automática no bot: https://github.com/Mottainai-One/mottainai-pr-bot/blob/main/src/github/prTemplate.ts

## Fluxo do código até a main

```
[Push em branch] → [Bot cria PR]
   → [IA faz review + descrição]
   → [CI roda e valida]
   → [2 aprovações humanas]
   → [Auto-merge (squash)]
   → [CD dispara deploy] (ver 04-ci-cd.md)
```

## Conexão com DevOps

- **Automação** → PR criado e revisado por IA sem intervenção manual.
- **Qualidade como porta de entrada** → CI + aprovações bloqueiam merge ruim.
- **Governança** → branches protegidas e regras definidas por código.
- **Rastreabilidade** → cada mudança tem PR com contexto gerado automaticamente.
- **Integração com CI/CD** → o merge aciona a pipeline de deploy (E3).

## Links

- Repositório do bot: https://github.com/Mottainai-One/mottainai-pr-bot
- Template da organização: https://github.com/Mottainai-One/.github/blob/main/pull_request_template.md
- Pipeline de entrega: [`04-ci-cd.md`](04-ci-cd.md)
