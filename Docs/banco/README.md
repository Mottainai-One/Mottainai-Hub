# Bancos de Dados Mottainai

> Referência oficial de arquitetura e operação · PostgreSQL 15+ · atualização 2026-10-02

O Mottainai utiliza **dois bancos PostgreSQL independentes**. Essa separação
impede que consultas pesadas de BI concorram com vendas, estoque e operações de
caixa, além de permitir políticas próprias de acesso, retenção e escalabilidade.

| Banco | Schema principal | Responsabilidade | Pode receber escrita da API transacional? |
|---|---|---|---|
| `mottainai_operational` | `mottainai` | Cadastros, usuários, produtos, estoque, compras, vendas, PDV e auditoria | Sim, por meio da role `mottainai_api` |
| `mottainai_analytics` | `mottainai_analytics` | Modelo estrela, histórico, indicadores, BI, previsões e recomendações | Não; somente pipeline de ingestão |

## Regra de integração

Os bancos não usam FK, `dblink` nem transação distribuída entre si. O banco
operacional publica eventos confirmados em `event_queue`. Um pipeline
idempotente valida a versão do evento e carrega dimensões e fatos no analítico.

```text
API / PDV / Apps
       |
       v
mottainai_operational -- event_queue --> pipeline --> mottainai_analytics
       ^                                             |
       |--------- recomendação aprovada via API -----+
```

O banco operacional é a fonte oficial do estado atual. O analítico é a fonte
para histórico, agregações e dashboards. Uma recomendação analítica somente
vira ação operacional depois de passar pela API e pelas regras transacionais.

## Características do banco operacional atual

- produto pertence obrigatoriamente a uma empresa;
- SKU e código de barras são únicos dentro da empresa;
- RLS isola empresa e loja;
- operadores veem somente sua loja; administradores veem lojas da empresa;
- sessões de funcionários são revogáveis e armazenam somente hash do refresh token;
- a role `mottainai_api` não possui login, DDL ou `BYPASSRLS`;
- contexto RLS é validado e limitado à transação;
- views operacionais executam com os privilégios do chamador;
- auditoria é imutável para a API e remove CPF e hashes dos registros JSON;
- compra, movimentação, venda e auditoria usam partições mensais.

## Navegação

| Área | Documento inicial |
|---|---|
| Entidades e regras de negócio | [Modelo conceitual](modelo-conceitual/README.md) |
| Tabelas, campos e relacionamentos | [Modelo lógico](model-logico/README.md) |
| Segurança e acesso da API | [Arquitetura de segurança](seguranca/01-arquitetura-de-seguranca.md) |
| Instalação, migrations e manutenção | [Guia operacional](operacao/README.md) |
| Organização dos scripts SQL | [Scripts do banco](script/README.md) |

## Fontes versionadas

- [Mottainai-Banco-Operacional](https://github.com/Mottainai-One/Mottainai-Banco-Operacional)
- [Mottainai-Hub](https://github.com/Mottainai-One/Mottainai-Hub)

O código SQL executável permanece no repositório do banco. O Hub mantém a
documentação de arquitetura e não deve ser usado como origem de migrations.
