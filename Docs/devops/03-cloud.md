# Cloud — Infraestrutura em Nuvem

Parte do requisito **M2 (Cloud para hospedar o projeto)**. Este documento explica como o Mottainai **hospeda** seus serviços em infratestrutura de **nuvem**, garantindo disponibilidade sem depender de uma máquina local.

## Princípio

O projeto não deve rodar apenas na máquina de quem desenvolve, mas em **nuvem pública**, com disponibilidade, gerenciamento e escala. Para o TCC escolhemos serviços com **custo zero** (free tier) sem abrir mão de boas práticas.

## Componentes de nuvem

### 1. Banco de dados gerenciado — Aiven (PostgreSQL)

O banco transacional do Mottainai (`mottainai` + `mottainai_analytics`) está em **PostgreSQL gerenciado na Aiven**:

- **Banco gerenciado** → backups, atualizações, monitoramento e alta disponibilidade por conta do provedor.
- **Sem instalar/administrar o banco** → a operação de infraestrutura de dados fica simplificada.

### 2. Aplicação (PR Bot) — Render / AWS Free Tier

O **Mottainai PR Bot** é hospedado na nuvem:

- **Render** (plano free) — definido em `render.yaml` no repositório, com deploy automático a partir do Git.
- **Decisão arquitetural documentada** de uso de **AWS Free Tier** (EC2 `t2.micro` + ECR + VPC) com custo estimado **$0/mês**, como alternativa de cloud madura.

> ✅ Escolha com custo zero, ideal para o contexto acadêmico, documentada em `decisoes-arquiteturais.md`.

## Config de hospedagem (render.yaml)

```yaml
services:
  - type: web
    name: mottainai-pr-bot
    runtime: node
    buildCommand: npm ci && npm run build
    startCommand: node dist/index.js
    envVars:
      - key: APP_ID
        sync: false   # segredo
      - key: PRIVATE_KEY
        sync: false   # segredo
      - key: WEBHOOK_SECRET
        sync: false   # segredo
      - key: GEMINI_API_KEY
        sync: false   # segredo
```

> Segredos são configurados no painel (nunca versionados).

## Conexão com DevOps

- **Disponibilidade** → serviços publicamente acessíveis 24/7.
- **Infraestrutura como serviço (Iaas/PaaS)** → subir app e banco sem administrar hardware.
- **Gerenciamento de segredos** → chaves ficam no provedor, fora do código.
- **Observabilidade** → monitoramento e logs fornecidos pelo provedor integrados às métricas das RPAs.

## Links

- Config de hospedagem (Render): https://github.com/Mottainai-One/mottainai-pr-bot/blob/main/render.yaml
- Decisões arquiteturais: [`06-automation-hub.md`](06-automation-hub.md) (seção 1.2/1.5) — ou o arquivo de decisões na raiz
