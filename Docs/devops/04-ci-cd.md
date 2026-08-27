# CI/CD — Pipelines de Integração e Implantação

Parte do requisito **E3 (Pipeline de implantação)**. Este documento explica os **pipelines automatizados** do Mottainai com **GitHub Actions**: a camada de **CI** (validação) e a camada de **CD** (implantação).

## Conceito

- **CI (Integração Contínua)** → a cada push/PR, o código é **validado automaticamente**: compila, roda testes, checa qualidade e segurança. Se falhar, o merge é bloqueado.
- **CD (Implantação Contínua)** → após a validação, o código é **implantado automaticamente** (dev) ou com **aprovação manual** (prod).

## CI — Banco de Dados (`ci.yml`)

Pipeline com **8 jobs** de validação no `Mottainai-Banco-Operacional`:

1. **Validação do schema** em PostgreSQL 15 limpo
2. **Validação do dataLoad** (idempotência, 60 produtos)
3. **Lint SQL** (tabs, newline, BEGIN/COMMIT) — padrão do projeto
4. **Varredura de segredos** com **Gitleaks**
5. **Lint de documentação** (markdownlint)
6. **Checagem de `.env`** nunca commitado
7. **Padrão SQL** (sqlfluff, bloquenante)
8. **Boas práticas SQL** (sqlfluff completo, não bloquenante)

> Os jobs rodam em **paralelo** no GitHub Actions e **falham o PR** se qualquer checagem não passar — impedindo código ruim de entrar na `main`.

## CD — PR Bot (`cd.yml`)

Pipeline de implantação do `mottainai-pr-bot`, com **3 jobs**:

### Job 1 — Build e push da imagem
- Builda a imagem Docker.
- Publica no **GHCR** (GitHub Container Registry) com **tag por SHA** → facilita **rollback**.

```yaml
jobs:
  build-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/build-push-action@v5
        with:
          tags: |
            ghcr.io/mottainai-one/mottainai-pr-bot:${{ github.sha }}
            ghcr.io/mottainai-one/mottainai-pr-bot:latest
          push: true
```

### Job 2 — Deploy DEV (automático)
- Roda a cada merge na `main`.
- Aplica `k8s/overlays/dev` com `kubectl apply -k`.
- Aguarda o **rollout** concluir.

```yaml
  deploy-dev:
    needs: build-push
    if: github.event_name == 'push'
    steps:
      - run: kubectl apply -k k8s/overlays/dev
      - run: kubectl rollout status deployment/mottainai-pr-bot -n default
```

### Job 3 — Deploy PROD (manual + aprovação)
- Disparado manualmente (`workflow_dispatch`).
- Exige **aprovação** (environment protection rule).
- Aplica `k8s/overlays/prod` (3 réplicas, imagem de produção).

```yaml
  deploy-prod:
    needs: build-push
    if: github.event_name == 'workflow_dispatch'
    environment: production
    steps:
      - run: kubectl apply -k k8s/overlays/prod
```

## Fluxo de entrega ponta a ponta

```
[Push] → [CI valida banco+bot] → [CD build+push GHCR]
   → [Deploy DEV automático (K3s dev)]
   → [Aprovação manual] → [Deploy PROD (K3s prod, 3 réplicas)]
```

## Conexão com DevOps

- **Automação** → pipeline rodando sozinho a cada mudança.
- **Qualidade como porta de entrada** → nada entra na `main` sem passar no CI.
- **Deploy auditável** → tag por SHA + aprovação manual em prod (governança).
- **Rollback fácil** → histórico de SHAs das imagens permite voltar qualquer versão.
- **Integração com K8s** → o CD é quem aplica os manifests vistos em `02-kubernetes.md`.

## Links

- CI do banco: https://github.com/Mottainai-One/Mottainai-Banco-Operacional/blob/main/.github/workflows/ci.yml
- CD do bot: https://github.com/Mottainai-One/mottainai-pr-bot/blob/main/.github/workflows/cd.yml
- Orquestração: [`02-kubernetes.md`](02-kubernetes.md)
