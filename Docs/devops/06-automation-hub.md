# Automação e operações de dados

## Fluxos verificados

O repositório Mottanai-RPA contém dois fluxos PostgreSQL principais:

| Fluxo | Origem → destino | Frequência declarada no snapshot consultado | Finalidade |
|---|---|---|---|
| Legado → operacional | Legado → MOTTAINAI | origin/main declara */5 * * * * e reconciliação completa diária às 01:01 America/Sao_Paulo | Sincronizar dados transacionais para o operacional |
| Operacional → analítico | MOTTAINAI → MOTTAINAI_ANALITICO | Diário às 02:00 America/Sao_Paulo, com execução manual | Publicar lote para BI |
| Analítico → BI | MOTTAINAI_ANALITICO → Databricks Gold/dashboard | Job Databricks previsto para 02:30 America/Sao_Paulo | Preflight → Bronze → Silver → Gold → refresh do dashboard |

A carga operacional→analítico não lê o legado. O job Databricks tem uma execução separada e deve partir do lote publicado. O bundle BI configura uma execução sequencial às 02:30, com concorrência máxima 1. Manter o runbook e o estado atual desse job junto à documentação técnica do BI no workspace Databricks.

## Legado → operacional

O workflow .github/workflows/legacy-to-operational.yml em origin/main declara sincronização a cada cinco minutos e uma execução diária às 01:01 em America/Sao_Paulo que força reconciliação completa. A execução manual oferece dry-run e opção force_full. Há clones/branches locais com cron de 30 minutos; não usar essa cópia antiga como representação da branch principal. O cron configura a cadência, mas monitorar execuções e atraso para confirmar funcionamento operacional.

Usar GitHub Secrets, SSL e concorrência controlada; logs sem segredo ou dados sensíveis. Para validar sem persistir, preferir dry-run. Execução manual real requer autorização e conferência do destino.

## Operacional → analítico

Workflow .github/workflows/operational-to-analytics.yml declara 02:00 São Paulo e workflow_dispatch. Usa credenciais distintas para leitura e escrita, valida variáveis e publica batch.

O contrato BI usa batch_id, cutoff, status e metadata.publication_contract. Databricks deve aguardar publicação bem-sucedida com contrato esperado antes de rodar Bronze/Silver/Gold.

## QA da RPA

qa.yml constrói Dockerfile.qa e roda testes com --network none, sem banco ou credencial produtiva. Isso comprova testes herméticos, não integração end-to-end. Integração requer bancos descartáveis, dados sintéticos e secrets QA.

Compose QA não ativa schedules produtivos nem executa carga contra Aiven.

## Observabilidade e recuperação

Acompanhar ID de execução, início/fim/duração, status/erro, batch/cutoff, contagens lidas/escritas, atraso no destino, retries, sobreposição e reconciliação. Nunca registrar valores de segredo nem payload pessoal integral.

O job_log varia por contrato/versão; não presumir colunas success, start_time ou records_processed para todos os jobs.

Em falha: identificar fluxo e execução; verificar status, cutoff, conexão e schema sem revelar credenciais; confirmar se houve publicação parcial; corrigir no repo proprietário; validar em QA/dry-run; reexecutar pelo mecanismo idempotente sem apagar checkpoints; reconciliar destino; registrar causa e prevenção em PR/runbook.
