# MongoDB: API, integration and operations

## Relationships and responsibilities

- `conversations` identifies the session and company; `messages`, `agent_executions` and other collections can reference the conversation through `conversationId`.
- `rag_documents` belongs to a company; `rag_chunks.documentId` points to its document. The API checks the parent document to scope chunk access.
- `memories` associates a company with a user. `metrics` and executions provide observability; `requestId`, when present, helps correlate records. Older records may not contain this field.
- The schema also contains catalogs, policies, tool executions, an embeddings cache, evaluations and other collections; see the [complete catalog](01-colecoes-e-indices.md).

## Mongo API

The prefix is `/api/v1`. This table summarizes the [Mongo API controllers](https://github.com/Mottainai-One/Mottainai-Api-NoSQL/tree/8b3544e/src/main/java/com/mottainai/mongoapi/controller):

| Resource | Operations |
|---|---|
| `/conversations` | List, get by `sessionId` and list session messages. |
| `/metrics`, `/metrics/summary` | Query metrics and summary. |
| `/executions` | Query agent executions. |
| `/memories` | List, get and delete memory by company and user. |
| `/rag/documents` | List, get, create, update and delete documents; list and create chunks. |
| `/rag/chunks/{id}` | Update and delete a chunk. |
| `/rag/search` | Search documents by text. |

The company scope is supplied as a query parameter, path parameter or body
field depending on the route; see the controllers and DTOs for exact fields.
Lookups of resources belonging to another company return 404 where the resource
is checked. **A caller-supplied `empresaId` is not authentication or proof of
authorization by itself**: the inspected version does not declare Spring
Security. Protect the API behind an authenticated layer and validate the user's
relationship to the company before exposing it.

The metrics summary calculates `errorRate` as a proportion from 0 to 1; a
missing Judge score is not treated as a failure. `avgLatency` may be omitted
when no latency values exist in the group. Calculated response values should not
automatically be assumed to be stored fields.

## RAG and embeddings

The **AI layer's** `POST /rag/documents` upload creates chunks and embeddings.
The Java API maintains documents and chunks but does not generate embeddings
for chunks it creates. Changing chunk text invalidates the previous embedding;
changing only the number or metadata preserves it. To process pending vectors,
use the AI flow (`python scripts/generate_embeddings.py`) with the appropriate
environment configuration. The RAG cache can retain an earlier response until
expiry; the documented default is 300 seconds. Vector search and model
availability depend on the environment and were not validated here.

## Operations

1. Configure connections through the AI and API environment variables; never put credential-bearing URIs in shared documentation or logs.
2. In the AI repository, `python scripts/setup_mongo.py --check` compares the database with the declared schema and returns an error for discrepancies. The check does not prove that no extra collections or indexes exist.
3. `python scripts/setup_mongo.py` changes collections, validators and indexes and synchronizes the intent catalog. Run it only after reviewing impact, permissions and backups; `--seed-demo` adds demonstration data.
4. Monitor connectivity, validation failures, indexes and size. Back up and test restoration in an isolated environment according to the deployment policy; no configured backup was verified here.

**Scope:** the running MongoDB instance, effective indexes, access controls,
backups and end-to-end integration were not inspected. The AI's versioned
schema is the source of truth for validators and indexes, not the Hub.
