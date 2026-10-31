# MongoDB for the AI layer

MongoDB stores conversations, messages, memory, agent executions, metrics, RAG
content and AI configuration. The Mongo API queries and curates a subset of
these collections; the AI layer also accesses the database directly. PostgreSQL
remains responsible for the transactional data described in the [database index](../README.md).

## Reading order

1. [Collections, fields and indexes](01-colecoes-e-indices.md)
2. [API, integration and operations](02-api-integracao-e-operacao.md)

The catalog reflects the schema at AI commit `021fdc0` and the API at commit
`8b3544e`. It describes the versioned contract; it does not establish the
configuration or contents of a running instance. The executable source of
truth for the schema and indexes is
[`scripts/mongo/schema.json`](https://github.com/Mottainai-One/Mottainai-IA/blob/021fdc0/scripts/mongo/schema.json).
