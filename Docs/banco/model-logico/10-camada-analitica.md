# 10 — Camada Analítica

Segmento **BI / Dashboard** do banco: um conjunto de **views** que reúnem indicadores a partir do schema operacional `mottainai`. Servem para dashboards e relatórios gerenciais sem duplicar dados em tabelas de cubo.

A camada analítica está organizada em **dois níveis**:

1. **Schema `public`** — views utilitárias de estoque e uma **view materializada** de dashboard.
2. **Schema `mottainai_analytics`** — conjunto de views de indicadores de negócio (default).

> As views analíticas operam com `search_path = mottainai_analytics, mottainai, public`.

## Views utilitárias (schema `public`)

| View | Papel |
|---|---|
| `vw_expiring_products` | Produtos próximos do vencimento (FEFO) |
| `vw_critical_stock` | Itens abaixo do mínimo (estoque crítico) |
| `vw_stock_coverage` | Cobertura de estoque por produto/loja |
| `vw_monthly_summary` | Resumo mensal de vendas/estoque |
| `vw_active_customer_promotions` | Promoções ativas (app cliente mobile) |

**View materializada (schema `public`):**

| View | Papel |
|---|---|
| `mv_dashboard_metrics` | Indicadores agregados de dashboard, pré-calculados e atualizados via `REFRESH MATERIALIZED VIEW` (com índice único por loja) |

## Views de indicadores (schema `mottainai_analytics`)

Todas as views deste schema são **views comuns** (não materializadas), agrupadas por especialidade:

### Comercial / Vendas
| View | Indicador |
|---|---|
| `vw_sales_daily_kpis` | KPIs de venda diários |
| `vw_sales_trend` | Tendência de vendas no tempo |
| `vw_top_selling_products` | Produtos mais vendidos |
| `vw_top_selling_categories` | Categorias de maior saída |
| `vw_seasonality_by_weekday` | Sazonalidade por dia da semana |
| `vw_payment_analysis` | Análise de formas de pagamento |
| `vw_customer_purchase_behavior` | Comportamento de compra do cliente |
| `vw_customer_purchase_history` | Histórico de compras (mobile) |
| `vw_monthly_summary` | Histórico mensal gerencial |

### Estoque / Ruptura / Vencimento
| View | Indicador |
|---|---|
| `vw_inventory_turnover` | Giro e cobertura de estoque |
| `vw_stockout_analysis` | Análise de risco de ruptura |
| `vw_expiration_loss_forecast` | Previsão de perda por vencimento |
| `vw_product_risk_ranking` | Ranking consolidado de risco |
| `vw_top_loss_products` | Ranking de produtos com mais perdas |
| `vw_replenishment_performance` | Assertividade do abastecimento |

### Transferências / Sustentabilidade / Valor recuperado
| View | Indicador |
|---|---|
| `vw_transfer_analysis` | Análise de transferências |
| `vw_transfer_effectiveness` | Efetividade das transferências |
| `vw_saved_value` | Valor recuperado / perdas evitadas |
| `vw_sustainability_dashboard` | Indicadores de sustentabilidade |
| `vw_promotion_performance` | Efetividade das promoções |

### IA / Motor
| View | Indicador |
|---|---|
| `vw_ai_performance` | Performance dos modelos de IA |
| `vw_ai_recommendation_effectiveness` | Efetividade das recomendações de IA |
| `vw_ai_action_funnel` | Funil de risco/ação da IA |
| `vw_engine_diagnostics` | Diagnóstico do motor (varreduras) |
| `vw_engine_suggestion_metrics` | Métricas de sugestões do motor |

### Fidelidade / Cliente
| View | Indicador |
|---|---|
| `vw_customer_loyalty_analysis` | Análise de fidelidade/cliente |
| `vw_active_customer_promotions` | Promoções ativas (mobile) |

### Gestão / Dashboard
| View | Indicador |
|---|---|
| `vw_store_performance` | Performance por loja |
| `vw_executive_dashboard` | Dashboard executivo consolidado |

## Convenções da camada analítica

- **Somente leitura:** nenhuma DML via views; a escrita continua no schema `mottainai`.
- **Granularidade:** agregada por (dimensão + período) — sem linha a linha transacional.
- **Nomes:** semânticos e alinhados ao negócio.

---

*Próximo: [11 — Enums](11-enums.md)*
