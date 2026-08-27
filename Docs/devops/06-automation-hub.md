# Automation Hub — Robôs de Operação (RPA) + Decisões Arquiteturais

Documento que une a **camada de operação contínua** do Mottainai (os RPAs do **Automation Hub**) e as **decisões arquiteturais** da estratégia de DevOps.

> 👉 O **guia passo a passo de como construir cada robô** está em:
> [`mottainai-automation-hub/GUIA_RPAs.md`](../../../../mottainai-automation-hub/GUIA_RPAs.md)

## O que é o Automation Hub

É a **central de automações (RPAs)** do projeto. Cada robô resolve um problema específico, trabalhando sobre o banco operacional para alimentar o **BI** e a **IA**. Todos seguem o mesmo padrão: escrevem no `job_log` e podem ser agendados — o que torna a operação **observável** (pilar de DevOps).

```
┌─────────────────────────┐
│    BANCO OPERACIONAL    │   PostgreSQL
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│  MOTTAINAI HUB (RPA)    │
└────────────┬────────────┘
      ┌──────┴──────┐
      ▼             ▼
  Data Mart     Logs/Métricas/Alertas
      └──────┬─────┘
             ▼
        DASHBOARD BI (+ IA)
```

## Os 9 robôs e a atuação em DevOps

| # | Robô | O que faz | Atuação em DevOps |
|---|---|---|---|
| 1 | **Data Pipeline** | ETL: extrai, valida, transforma e carrega o Data Mart | Automação / containerização / reprodutibilidade |
| 2 | **Data Guardian** | Auditoria de qualidade e integridade dos dados | Qualidade / governança / esteira de testes de dados |
| 3 | **Data Mart Updater** | Mantém o Data Mart atualizado (delta loading) | Agendamento / idempotência / sincronização |
| 4 | **Performance Monitor** | Mede tempo das consultas e gera alertas | Observabilidade / métricas / otimização contínua |
| 5 | **Backup Guardian** | Automatiza e valida backups | Resiliência / governança / recuperação |
| 6 | **Ops Monitor** | Saúde da app, banco, containers e jobs | Monitoramento de infraestrutura / disponibilidade |
| 7 | **Job Monitor** | Centraliza o status de todos os jobs (`job_log`) | Observabilidade / painel de automações |
| 8 | **Metrics Consolidator** | Consolida métricas de negócio + técnicas | Visão unificada / centralização / decisão de infra |
| 9 | **AI Data Preparation** | Prepara dados para os agentes de IA | MLOps / pipeline de dados para IA |

### Como o hub fortalece DevOps

| Pilar de DevOps | Robô(s) |
|---|---|
| Automação de processos | 1, 3, 4, 5, 6, 7, 8, 9 |
| Containerização | 1, 6 |
| Observabilidade / logs | 4, 6, 7 (`job_log`, `query_performance`) |
| Monitoramento de infra | 6, 7 |
| Agendamento de jobs | 3, 5, 7 |
| Qualidade e governança | 2 |
| Backup e recuperação | 5 |
| Métricas unificadas | 8 |
| MLOps | 9 |

## Observabilidade: a tabela `job_log`

O `job_log` é a **fonte única de verdade** das automações. Cada robô escreve: `job_name`, `job_type`, `start_time`, `end_time`, `duration_seconds`, `records_processed`, `success`, `details` (JSONB). O **Job Monitor** e o **Ops Monitor** leem daí para montar o painel — demonstrando observabilidade de ponta a ponta.

## Decisões arquiteturais (resumo DevOps)

As decisões de arquitetura do projeto consideraram: custo zero (acadêmico), observabilidade, segurança e escalabilidade.

| Decisão | Escolha | Por quê |
|---|---|---|
| Banco de dados | PostgreSQL gerenciado (Aiven) | Backups / HA / observabilidade sem administrar |
| Hospedagem app | Render (free) / AWS Free Tier | Disponibilidade com custo $0 |
| Container | Docker multi-stage | Exportação enxuta e segura |
| Orquestração | K3s (k3d, local) | Kubernetes leve, autoscaling, probes |
| CI/CD | GitHub Actions | CI (validação) + CD (deploy dev/prod) |
| Segredos | Env do provedor / K8s Secret | Nunca versionar credenciais |
| Monitoramento | Automation Hub (RPAs) + job_log | Observabilidade e operação contínua |

## Conexão com DevOps

O hub **não é só "subir o deploy"** — é **operar, automatizar e observar** todo o ciclo de vida da plataforma: do dado bruto ao dashboard e à IA. É a materialização prática da cultura DevOps dentro do Mottainai.

## Links

- Guia de construção: [`mottainai-automation-hub/GUIA_RPAs.md`](../../../../mottainai-automation-hub/GUIA_RPAs.md)
- Banco operacional: https://github.com/Mottainai-One/Mottainai-Banco-Operacional
