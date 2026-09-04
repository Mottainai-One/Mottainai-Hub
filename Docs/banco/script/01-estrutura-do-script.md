# 01 — Estrutura do Script (arquivo a arquivo)

Detalhamento de cada script SQL do banco operacional Mottainai, os objetos criados e as dependências entre arquivos. Ordem de execução garantida pelo `install.sql`.

## `00_DataBase.sql` — Extensões e Schemas

Responsável pela infraestrutura inicial do banco:

- **Extensões:** `uuid-ossp`, `pgcrypto`, `btree_gin`.
- **Schemas:** `mottainai` (operacional/OLTP) e `mottainai_analytics` (analítico/OLAP).
- **`search_path`:** `mottainai, public` para os scripts seguintes.
- **Observação:** não realiza `DROP SCHEMA ... CASCADE` — seguro para executar em bancos compartilhados.

## `01_Enums.sql` — Tipos Enum

Todos os estados de negócio como tipos do PostgreSQL (24 enums):

| Enum | Valores |
|---|---|
| `purchase_order_status` | PENDING, APPROVED, CANCELED |
| `receiving_status` | PENDING, CONFIRMED, DIVERGENT |
| `sale_status` | COMPLETED, CANCELED, RETURNED |
| `pos_cancel_status` | PENDING, APPROVED, REJECTED, EXECUTED, CANCELED |
| `pos_cancel_target` | ITEM, SALE |
| `sale_item_status` | SOLD, CANCELED, RETURNED |
| `promotion_status` | DRAFT, PENDING_APPROVAL, APPROVED, REJECTED, EXPIRED |
| `movement_type` | IN, OUT, ADJUSTMENT, TRANSFER, DONATION, DISPOSAL |
| `inventory_type` | NORMAL, CONSIGNED, QUARANTINE |
| `priority_level` | LOW, MEDIUM, HIGH, CRITICAL |
| `payment_method` | CASH, CARD, PIX, BOLETO |
| `inventory_status` | IN_PROGRESS, COMPLETED, CANCELED |
| `alert_status` | ACTIVE, ANALYZING, RESOLVED, IGNORED |
| `alert_type` | EXPIRATION, CRITICAL_STOCK, RUPTURE, SLOW_MOVING, OVERSTOCK |
| `suggested_action_status` | PENDING, APPROVED, REJECTED, EXECUTED |
| `suggested_action_type` | PROMOTION, TRANSFER, DONATION, DISPOSAL, REORDER |
| `pre_list_status` | GENERATED, IN_PROGRESS, COMPLETED, CANCELED |
| `transfer_status` | REQUESTED, IN_TRANSIT, COMPLETED, CANCELED |
| `donation_status` | REGISTERED, COMPLETED, CANCELED |
| `audit_operation` | INSERT, UPDATE, DELETE |
| `ai_model_type` | FORECAST, RECOMMENDATION, CLASSIFICATION, OPTIMIZATION |
| `event_status` | PENDING, PROCESSING, COMPLETED, FAILED, CANCELED |
| `log_level` | DEBUG, INFO, WARN, ERROR, FATAL |
| `migration_type` | SQL, JAVA, GROOVY, SCRIPT |

## `02_functions.sql` — Funções de Negócio

19 funções:

| Função | Papel |
|---|---|
| `fn_validate_cpf(p_cpf)` | Valida dígitos verificadores de CPF |
| `fn_validate_email(p_email)` | Valida formato de e-mail |
| `fn_validate_cnpj(p_cnpj)` | Valida dígitos verificadores de CNPJ |
| `fn_set_session_context(...)` | Define contexto de sessão (usuário/empresa/loja) para RLS e auditoria |
| `fn_get_current_user_id()` / `fn_get_current_company_id()` / `fn_get_current_store_id()` | Leitura do contexto de sessão |
| `fn_generate_sku(...)` / `fn_generate_product_sku(...)` | Geração determinística de SKU |
| `fn_calculate_average_consumption(...)` | Consumo médio diário (janela configurável) |
| `fn_calculate_coverage(...)` | Cobertura do estoque em dias |
| `fn_calculate_criticality(...)` | Criticidade do estoque (usada pelo motor) |
| `fn_calculate_economy(...)` | Economia estimada (combate a desperdício) |
| `fn_calculate_avg_cost(...)` | **Custo médio ponderado** do produto (RF16) |
| `fn_suggest_sale_price(...)` | Sugestão de preço de venda a partir do custo médio (RF16) |
| `fn_refresh_product_price(...)` | Atualiza preço do produto disparado no recebimento |
| `fn_select_batch_fefo(...)` | Seleciona lote **FEFO** com `FOR UPDATE SKIP LOCKED` |
| `fn_atomic_update_inventory(...)` | Movimenta estoque de forma atômica com *optimistic locking* |
| `fn_publish_event(...)` | Publica evento na fila assíncrona |

## `03_tables.sql` — Tabelas

71 tabelas (68 operacionais + 3 arquivos `*_archive` criados com `LIKE`), agrupadas:

- **Cadastro/multitenancy:** `schema_version`, `subscription_plan`, `address`, `company`, `employee_role`, `retail_store`, `employee`, `app_user`.
- **Catálogo e compras:** `product_category`, `tax_profile`, `product`, `supplier`, `supplier_product`, `purchase_order`, `purchase_order_item`, `receiving`, `receiving_item`.
- **Estoque:** `batch`, `inventory`, `inventory_movement`.
- **Vendas/PDV:** `customer`, `customer_auth`, `pos_terminal`, `pos_shift`, `pos_cash_movement`, `sales_transaction`, `sale_item`, `sale_payment`, `fiscal_document`, `pos_cancel_request`.
- **Inteligência/regras:** `alert`, `suggested_action`, `promotion`, `promotion_item`, `customer_geofence`, `loyalty_account`, `loyalty_transaction`, `loyalty_reward`, `loyalty_redemption`, `ai_model`, `ai_prediction`, `ai_recommendation`, `ai_feedback`, `ai_execution`, `engine_scan_log`, `engine_suggestion`, `system_rule`.
- **Logística/sustentabilidade:** `transfer`, `transfer_item`, `donation`, `donation_item`, `disposal`, `disposal_item`.
- **Reposição:** `replenishment_pre_list`, `replenishment_pre_list_item`, `replenishment_execution`, `replenishment_execution_item`.
- **Observabilidade:** `audit_log`, `system_log`, `error_log`, `integration_log`, `job_log`, `event_queue`, `kpi_cache`, `query_performance`.
- **Históricos:** `product_history`, `supplier_history`, `product_price_history`.
- **Arquivos:** `audit_log_archive`, `inventory_movement_archive`, `sales_transaction_archive`.

O arquivo também embute funções e triggers de geração/atualização de SKU de `product`.

## `04_constraints.sql` — Row Level Security

Habilita **RLS** e cria políticas por `company_id` em 6 tabelas:

`company`, `retail_store`, `employee`, `inventory`, `sales_transaction`, `purchase_order`.

As políticas usam `fn_get_current_company_id()` (contexto de sessão), garantindo o **isolamento multitenancy** do SaaS.

## `05_index.sql` — Índices

- **Únicos parciais:** `employee(cpf)` e `supplier(cnpj)` onde `active = true AND deleted_at IS NULL`.
- **Parciais (apenas colunas, sem funções):** produto/categoria ativos, alertas `ACTIVE` por loja/prioridade.
- **Compostos de consulta:** `batch(product_id, expiration_date)`, `alert(store_id, status, created_at)`, `inventory(store_id, batch_id)`, `sales_transaction(store_id, status, sale_date)`, entre outros.
- **Apoio a FK:** índices para todas as colunas de chave estrangeira mais consultadas.

## `06_triggers.sql` — Triggers

10 triggers (com funções de trigger):

| Trigger | Evento | Intenção |
|---|---|---|
| `trg_product_generate_sku` | `product` INSERT | Gera SKU automático |
| `trg_product_update_sku` | `product` UPDATE | Regenera SKU quando o nome muda |
| `trg_soft_delete_product` | `product` UPDATE/DELETE | Soft delete e restrição de exclusão |
| `trg_create_batch` | `receiving_item` AFTER INSERT | Cria `batch` automático |
| `trg_select_batch_fefo` | `sale_item` BEFORE INSERT | Seleciona lote FEFO na venda |
| `trg_audit_disposal` / `trg_audit_transfer` / `trg_audit_donation` | logística | Auditam as três operações |
| `trg_product_history` | `product` BEFORE UPDATE | Grava histórico de alterações |
| `trg_batch_update_cost` | `batch` INSERT/UPDATE | Atualiza custo médio do produto |

## `07_views.sql` — Camada de Leitura

- **Operacionais (`mottainai`):** `vw_expiring_products`, `vw_critical_stock`, `vw_stock_coverage`, `vw_monthly_summary`, `vw_active_customer_promotions`.
- **Materializada:** `mv_dashboard_metrics`.
- **Analíticas (`mottainai_analytics`, 29 views):** vendas/KPIs (`vw_sales_daily_kpis`, `vw_sales_trend`, `vw_top_selling_products`, `vw_monthly_summary`, `vw_payment_analysis`, `vw_store_performance`, `vw_executive_dashboard`), estoque/perdas (`vw_inventory_turnover`, `vw_stockout_analysis`, `vw_expiration_loss_forecast`, `vw_product_risk_ranking`, `vw_top_loss_products`), reposição/transferência (`vw_replenishment_performance`, `vw_transfer_analysis`, `vw_transfer_effectiveness`), IA (`vw_ai_performance`, `vw_ai_recommendation_effectiveness`, `vw_ai_action_funnel`), sustentabilidade (`vw_saved_value`, `vw_sustainability_dashboard`), promoção/cliente (`vw_promotion_performance`, `vw_customer_loyalty_analysis`, `vw_customer_purchase_behavior`, `vw_customer_purchase_history`, `vw_active_customer_promotions`), sazonalidade/ranking (`vw_seasonality_by_weekday`, `vw_top_selling_categories`) e motor (`vw_engine_diagnostics`, `vw_engine_suggestion_metrics`).

## `08_seed.sql` — Dados Iniciais

- **Planos:** Free, Basic, Professional, Enterprise.
- **Cargos:** Administrator (100) → Intern (20), com `permission_level`.
- **Categorias:** Electronics, Food, Beverages, Cleaning, Personal Care, Clothing.
- **Perfil fiscal:** `DEFAULT` (CFOP 5102, CST ICMS 102).
- **Modelos de IA:** DemandForecast, ReplenishmentOptimizer, InventoryClassifier.
- **`schema_version`:** 9 versões de migração registradas.

Todas as cargas usam `ON CONFLICT ... DO NOTHING` (idempotente).

## `09_procedures.sql` — Partições e Regras

- **Partições futuras:** `sp_create_future_partitions()` cria partições mensais (+6 meses) para `purchase_order`, `inventory_movement`, `sales_transaction` e `audit_log`.
- **Partições antigas:** `sp_drop_old_partitions(p_months_to_keep DEFAULT 12)` remove partições vencidas.
- **Sustentabilidade:** `fn_calculate_sustainability_metrics(store, inicio, fim)` — doações, descartes e unidades promocionais.
- **Promoções:** `sp_decide_promotion(...)` aprova/rejeita promoção em fluxo de aprovação do gerente.
- **Cancelamento de caixa:** `fn_request_pos_cancellation(...)` + `sp_decide_pos_cancellation(...)` — fluxo de solicitação e decisão de cancelamento de venda/item.
- **Grants:** bloco comentado de exemplo para o papel `app_user`.

## `10_tests.sql` — Suíte de Testes

| Função | Valida |
|---|---|
| `test_01_validation()` | CPF e CNPJ válidos/inválidos |
| `test_02_fefo()` | FEFO seleciona o lote de menor validade |
| `test_03_inventory()` | Estoque não fica negativo (`fn_atomic_update_inventory`) |
| `test_04_audit()` | Auditoria registrada para `disposal` |
| `test_05_avg_cost()` | Custo médio ponderado e sugestão de preço |
| `test_06_engine_diagnostic()` | Motor: varreduras, sugestões e views de diagnóstico |

`run_all_tests()` executa todos e retorna `(test_name, result)`. A suíte **não roda automaticamente** no `install.sql`; precisa da carga do `dataLoad.sql` antes.

## `dataLoad.sql` — Carga de Dados de Teste (seed)

Gera massa de dados verossímil (500+ registros por tabela principal):

- **Idempotente:** limpa tabelas (filhos antes dos pais), reseta sequences e cria partições retroativa (-3 a +6 meses).
- **Cadastrais:** 10 endereços, 1 empresa, 5 lojas, 25 funcionários + 25 usuários, 12 categorias, 60 produtos, 10 fornecedores, 100+ associações `supplier_product`.
- **Estoque:** 600+ lotes, 600+ saldos de inventário, 500+ movimentações.
- **Vendas:** 600+ vendas com ~1.800 itens e pagamentos.
- **Inteligência:** 125+ alertas e ações sugeridas, 125+ pré-listas de reposição, transferências, doações, descartes, previsões/recomendações IA.
- **Governança:** KPI cache, `query_performance`, `system_log`/`error_log`/`job_log`, 100+ eventos.
- **Motor:** regras (`system_rule`), varreduras (`engine_scan_log`) e sugestões (`engine_suggestion`).
- **Resumo:** ao final imprime contagens por tabela (`RAISE NOTICE`).

> ⚠️ Exclusivo para ambiente de **teste/seed** — não faz parte da instalação de produção (`install.sql` não o invoca).

## `install.sql` — Orquestrador

Executa os scripts na ordem `00 → 10` com mensagens de progresso. Ao final, orienta que os testes sejam rodados manualmente (`SELECT * FROM run_all_tests();`) após o `dataLoad.sql`.

---

*Detalhamento gerado a partir do script `mottainai_v6.0` — Enterprise Final Edition (branch `feat/atender-scope-statement` do repositório `Mottainai-Banco-Operacional`).*