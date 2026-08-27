# Docker — Conteinerização da Aplicação

Parte do requisito **M3 (Docker + Kubernetes)**. Este documento explica como o Mottainai **empacota a aplicação** em um container Docker, tornando o ambiente **reproduzível** em qualquer máquina.

## Por que Docker?

Sem containers, "na minha máquina funciona" é um problema constante. Com Docker, o **código, as dependências, as configurações e o runtime** viajam juntos em uma única imagem. Isso é base de DevOps: mesmo ambiente em dev, CI e produção.

## O Dockerfile (Multi-stage)

O `mottainai-pr-bot` usa um **Dockerfile multi-stage**: constrói em uma imagem cheia (com o toolchain) e entrega em uma imagem **enxuta e segura**.

```dockerfile
# Stage 1: build (imagem cheia, só para compilar)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: runtime (imagem enxuta, não-root)
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

**Bom praticar:**
- **Multi-stage** → imagem final pequena e sem lixo de build.
- **Usuário não-root** → segurança: o processo não roda com privilégios.
- **Imagem base `-alpine`** → leve e rápida de baixar.
- **`EXPOSE 3000`** → a porta que o Service do K8s depois vai expor.

## docker-compose.yml

Permite **subir localmente** sem precisar do Kubernertes, ótimo para desenvolvimento:

```yaml
services:
  bot:
    build: .
    ports:
      - "3000:3000"
    env_file:
      - .env
    restart: unless-stopped
```

> ⚠️ Em produção não usamos compose — usamos **Kubernetes** (K3s). O compose serve para o ambiente de dev rápido.

## Comandos úteis

```bash
# Construir a imagem
docker build -t mottainai-pr-bot:latest .

# Rodar localmente
docker run --rm -p 3000:3000 --env-file .env mottainai-pr-bot

# Ver a imagem construída
docker images
```

## Conexão com DevOps

- **Reprodutibilidade** → mesma imagem roda em dev, CI e produção.
- **Imutabilidade** → o artefato de deploy é único e versionável (por tag/SHA).
- **Segurança** → remoção de privilégios e imagem mínima reduzem a superfície de ataque.
- **Base para orquestração** → é a imagem que o Kubernetes (K3s) vai replicar e escalar.

## Links

- Dockerfile: https://github.com/Mottainai-One/mottainai-pr-bot/blob/main/Dockerfile
- Continue em: [`02-kubernetes.md`](02-kubernetes.md)
