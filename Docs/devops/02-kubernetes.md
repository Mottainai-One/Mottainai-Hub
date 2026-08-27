# Kubernetes — Orquestração de Containers (K3s)

Parte do requisito **M3 (Docker + Kubernetes)**. Este documento explica como o Mottainai **orquestra** seus containers com **Kubernetes**, usando **K3s** (distribuição leve do Kubernetes) rodando via **k3d** no ambiente local.

## Por que Kubernetes?

Enquanto o Docker executa um container, o **Kubernetes gerencia muitos containers**: replica, reinicia se cair, escala conforme a carga, expõe serviços e faz balanceamento. É o "sistema operacional de containers" — coração do DevOps de infraestrutura.

## Cluster local com K3s + k3d

Criamos um cluster chamado `mottainai`:

```bash
k3d cluster create mottainai \
  --image rancher/k3s:v1.30.11-k3s1 \
  --agents 1
```

> **Nota de compatibilidade:** na máquina (Windows, Docker com **cgroup v1**), versões do k3s acima de `1.30` não sobem. A versão **`v1.30.11-k3s1`** é a compatível.

### Kubeconfig

O kubeconfig aponta para o **endereço local do cluster** usando a porta mapeada (`127.0.0.1:<porta>`). Isso contorna o fato de `host.docker.internal` resolver para um IP de VPN que não conecta.

```
cluster: k3d-mottainai-server-0   (k3s v1.30.11)
node:   k3d-mottainai-server-0    Ready
```

## Manifests com Kustomize

O projeto usa **Kustomize** para gerenciar a configuração em camadas:

```
k8s/
├── base/                    # padrão comum (dev + prod)
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── hpa.yaml
│   └── kustomization.yaml
└── overlays/
    ├── dev/                 # 1 réplica (dev)
    └── prod/                # 3 réplicas + imagem de produção
```

### Deployment

Define **quantos pods** devem rodar, a imagem, os recursos e as **probes de saúde**:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mottainai-pr-bot
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mottainai-pr-bot
  template:
    metadata:
      labels:
        app: mottainai-pr-bot
    spec:
      containers:
        - name: bot
          image: mottainai-pr-bot:latest
          imagePullPolicy: IfNotPresent   # usa a imagem local do k3d
          ports:
            - containerPort: 3000
          startupProbe:                    # espera o app subir
            httpGet:
              path: /ping
              port: 3000
            failureThreshold: 30
          readinessProbe:                  # pronto para receber tráfego
            httpGet:
              path: /ping
              port: 3000
          livenessProbe:                   # se travou, reinicia o pod
            httpGet:
              path: /ping
              port: 3000
          resources:
            requests:
              cpu: 100m
            limits:
              cpu: 500m
```

> **`imagePullPolicy: IfNotPresent`** é essencial no k3d: usa a imagem importada localmente em vez de tentar (e falhar) buscar do registry.

### Service (ClusterIP)

Expõe o app dentro do cluster na porta 3000, com balanceamento entre os pods:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mottainai-pr-bot
spec:
  selector:
    app: mottainai-pr-bot
  ports:
    - port: 3000
      targetPort: 3000
```

### ConfigMap

Configuração não-sensível (não contém segredos):

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mottainai-config
data:
  LOG_LEVEL: "info"
  PORT: "3000"
```

### Secret

Segredos vão no **Secret** (injetado a partir do `.env`, **sem segredo no YAML**):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mottainai-secrets
type: Opaque
stringData: {}
# os valores são injetados no deploy (não versionados)
```

### HPA — Autoscaling (horizontal)

Escala automaticamente conforme a carga de CPU:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mottainai-pr-bot
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mottainai-pr-bot
  minReplicas: 2
  maxReplicas: 6
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
```

> `stabilizationWindowSeconds=300` evita que o HPA suba/desça réplicas rápido demais (oscilação).

## Overlays (dev e prod)

| Overlay | Réplicas | Imagem |
|---|---|---|
| `dev` | 1 | `mottainai-pr-bot:latest` |
| `prod` | 3 | `ghcr.io/mottainai-one/mottainai-pr-bot:latest` |

## Deploy validado

Cluster rodando com 2 pods, probes respondendo e HPA ativo:

```
pod/mottainai-pr-bot-6ccc96f8ff-6kmps   1/1   Running
pod/mottainai-pr-bot-6ccc96f8ff-mptp4   1/1   Running
service/mottainai-pr-bot   ClusterIP   ...   3000/TCP
hpa/mottainai-pr-bot        2 min, max 6, CPU 1%/70%
```

## Comandos úteis

```bash
# aplicar com kustomize
kubectl apply -k k8s/overlays/dev

# ver pods
kubectl get pods

# ver HPA
kubectl get hpa

# testar health check
kubectl exec deploy/mottainai-pr-bot -- curl -s localhost:3000/ping
# PONG
```

## Conexão com DevOps

- **Autoscaling** → escala automática conforme a demanda (eficiência de recursos).
- **Health checks** → o Kubernetes sabe quando um pod está saudável e reinicia se preciso (self-healing).
- **Declarativo** → o estado desejado está no YAML (Infraestrutura como Código).
- **Rollout e rollback** → deploy controlado com `kubectl` (integra ao CD).

## Links

- Manifests (base): https://github.com/Mottainai-One/mottainai-pr-bot/tree/main/k8s/base
- Overlay dev: https://github.com/Mottainai-One/mottainai-pr-bot/tree/main/k8s/overlays/dev
- Overlay prod: https://github.com/Mottainai-One/mottainai-pr-bot/tree/main/k8s/overlays/prod
- Base do container: [`01-docker.md`](01-docker.md)
