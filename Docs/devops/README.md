# DevOps — Documentação Geral

Bem-vindo à documentação de **DevOps** do ecossistema **Mottainai**. Esta pasta reúne toda a operação de desenvolvimento e infraestrutura do projeto: desde o fluxo de revisão de código (Code Review + PR) até a orquestração de containers, passando por nuvem, pipelines de CI/CD e a central de automações (Agile/Automation Hub).

## O que é DevOps no contexto Mottainai

DevOps é a cultura que une **desenvolvimento (Dev)** e **operações (Ops)** para entregar software de forma **rápida, confiável e observável**. No Mottainai isso se traduz em automatizar o máximo possível o ciclo de vida da plataforma:

```
[Código] → [Review automático] → [CI valida] → [Container] → [Orquestração] → [Cloud] → [Monitoramento]
```

Cada etapa abaixo é detalhada em um arquivo próprio.

## Mapa da pasta

| Arquivo | Tema | Requisito(s) atendido(s) |
|---|---|---|
| [`README.md`](README.md) | Visão geral de DevOps (este arquivo) | — |
| [`01-docker.md`](01-docker.md) | Conteinerização com Docker | M3 |
| [`02-kubernetes.md`](02-kubernetes.md) | Orquestração com Kubernetes (K3s) | M3 |
| [`03-cloud.md`](03-cloud.md) | Infraestrutura em nuvem | M2 |
| [`04-ci-cd.md`](04-ci-cd.md) | Pipelines de CI/CD (GitHub Actions) | E3 |
| [`05-code-review-pr.md`](05-code-review-pr.md) | Code Review + PR + PR Bot | M1, E2 |
| [`06-automation-hub.md`](06-automation-hub.md) | Automation Hub — RPAs e monitoramento | complementar |

## Principais repositórios

| Repositório | Responsabilidade | Link |
|---|---|---|
| `mottainai-pr-bot` | Bot de PRs (GitHub App + Probot + Gemini) e deploy | https://github.com/Mottainai-One/mottainai-pr-bot |
| `Mottainai-Banco-Operacional` | Banco de dados do projeto (PostgreSQL + scripts) | https://github.com/Mottainai-One/Mottainai-Banco-Operacional |
| `Mottainai-Hub-` | Repositório central da documentação/ecossistema | https://github.com/Mottainai-One/Mottainai-Hub- |

## Pilares de DevOps cobertos

1. **Automação de processos** — PRs criados/revisados automaticamente por IA; pipelines que rodam sozinhos.
2. **Conteinerização** — aplicação empacotada em imagem Docker reproduzível.
3. **Orquestração** — serviços gerenciados por Kubernetes (K3s) com autoscaling e health checks.
4. **Infraestrutura como nuvem** — banco gerenciado na Aiven e app na nuvem (Render/AWS).
5. **CI/CD** — validação (CI) e implantação (CD) automatizadas com GitHub Actions.
6. **Observabilidade e monitoramento** — logs de execução (`job_log`), health checks, HPA e central de RPAs.
7. **Qualidade e segurança** — revisão de código, gitleaks (segredos), branch protection, backups.

## Como navegar

- Comece pelo [`04-ci-cd.md`](04-ci-cd.md) para entender o pipeline de entrega ponta a ponta.
- Veja [`02-kubernetes.md`](02-kubernetes.md) para o deploy orquestrado e o autoscaling.
- Explore [`06-automation-hub.md`](06-automation-hub.md) para a camada de operação contínua e monitoramento.

---

*Última atualização: 13/08/2026 · Disciplina: Desenvolvimento de Operações Ágeis*
