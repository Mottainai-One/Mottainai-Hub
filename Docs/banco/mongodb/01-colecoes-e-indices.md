# MongoDB collections and indexes

This catalog lists the fields declared in the AI schema. **Required** means the validator requires the field; additional fields may exist and are not listed here. Types including `null` accept a null value, but that does not make the field required.

The `strict` and `error` settings below are those declared in the repository; verify that they are applied to an instance with `python scripts/setup_mongo.py --check` in the AI project. Indexes are not foreign keys: relationships between documents depend on the application.

## `agent_contexts`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId | Yes |
| `agent` | string | Yes |
| `currentSkill` | string / null | No |
| `state` | object | No |
| `createdAt` | date | Yes |
| `updatedAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_agent_contexts_updatedAt` | `updatedAt: -1` | No |
| `ux_agent_contexts_conversation_agent` | `conversationId: 1`, `agent: 1` | Yes |

## `agent_executions`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId / null | No |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `tools` | array of string / null | No |
| `executionFlow` | array of string / null | No |
| `status` | enum: running, completed, error | Yes |
| `latency` | double / null | No |
| `startedAt` | date | Yes |
| `finishedAt` | date / null | No |
| `error` | object / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `agent_1_status_1` | `agent: 1`, `status: 1` | No |
| `empresaId_1_createdAt_-1` | `empresaId: 1`, `createdAt: -1` | No |
| `ix_agent_executions_agent_status_startedAt` | `agent: 1`, `status: 1`, `startedAt: -1` | No |
| `ix_agent_executions_conversation_startedAt` | `conversationId: 1`, `startedAt: -1` | No |

## `agent_fallbacks`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `sourceAgent` | string | Yes |
| `fallbackAgent` | string | Yes |
| `reason` | string | Yes |
| `active` | bool | Yes |
| `createdAt` | date | Yes |
| `updatedAt` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ux_agent_fallbacks_source_fallback` | `sourceAgent: 1`, `fallbackAgent: 1` | Yes |

## `agent_policies`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `agent` | string | Yes |
| `scope` | object | Yes |
| `canUseRag` | bool / null | No |
| `canUseTools` | bool / null | No |
| `canReadMemory` | bool / null | No |
| `canWriteMemory` | bool / null | No |
| `active` | bool | Yes |
| `createdAt` | date | Yes |
| `updatedAt` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ux_agent_policies_agent` | `agent: 1` | Yes |

## `ai_results`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId | Yes |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `type` | enum: recommendation, prediction, analysis, summary | Yes |
| `result` | object | Yes |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_ai_results_agent_type_createdAt` | `agent: 1`, `type: 1`, `createdAt: -1` | No |
| `ix_ai_results_conversation_createdAt` | `conversationId: 1`, `createdAt: -1` | No |

## `cache_queries`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `queryHash` | string | Yes |
| `response` | string | Yes |
| `expiresAt` | date | Yes |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_cache_queries_expiresAt` | `expiresAt: 1` | No |
| `ux_cache_queries_queryHash` | `queryHash: 1` | Yes |

## `conversation_events`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId | Yes |
| `type` | enum: conversation_started, intent_detected, agent_selected, tool_called, fallback_used, response_sent, conversation_closed, error | Yes |
| `payload` | object / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_conversation_events_conversation_createdAt` | `conversationId: 1`, `createdAt: 1` | No |
| `ix_conversation_events_type_createdAt` | `type: 1`, `createdAt: -1` | No |

## `conversations`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `sessionId` | string | Yes |
| `empresaId` | int | Yes |
| `usuarioId` | int | Yes |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `status` | string | Yes |
| `title` | string / null | No |
| `startedAt` | date | Yes |
| `lastInteraction` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `empresaId_1_status_1` | `empresaId: 1`, `status: 1` | No |
| `ix_conversations_empresa_usuario_lastInteraction` | `empresaId: 1`, `usuarioId: 1`, `lastInteraction: -1` | No |
| `ix_conversations_agent_status` | `agent: 1`, `status: 1` | No |
| `ix_conversations_empresa_usuario_startedAt` | `empresaId: 1`, `usuarioId: 1`, `startedAt: -1` | No |
| `ix_conversations_lastInteraction` | `lastInteraction: -1` | No |
| `ux_conversations_sessionId` | `sessionId: 1` | Yes |

## `embeddings_cache`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `hash` | string | Yes |
| `embedding` | array of double | Yes |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ux_embeddings_cache_hash` | `hash: 1` | Yes |

## `feedbacks`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `messageId` | objectId | Yes |
| `usuarioId` | int | Yes |
| `agent` | string / null | No |
| `rating` | enum: positive, negative, neutral | Yes |
| `comment` | string / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_feedbacks_messageId` | `messageId: 1` | No |
| `ix_feedbacks_usuario_createdAt` | `usuarioId: 1`, `createdAt: -1` | No |

## `intent_catalog`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `key` | string | Yes |
| `label` | string | No |
| `description` | string / null | No |
| `agent` | string | Yes |
| `skill` | string | No |
| `examples` | array of string / null | No |
| `confidenceThreshold` | double / null | No |
| `active` | bool | Yes |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_intent_catalog_agent_active` | `agent: 1`, `active: 1` | No |
| `ix_intent_catalog_skill` | `skill: 1` | No |
| `ux_intent_catalog_key` | `key: 1` | Yes |

## `memories`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `usuarioId` | int | Yes |
| `empresaId` | int | Yes |
| `preferences` | array of string / null | No |
| `facts` | array of string / null | No |
| `lastAgent` | string / null | No |
| `lastSkill` | string / null | No |
| `updatedAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_memories_updatedAt` | `updatedAt: -1` | No |
| `ux_memories_empresa_usuario` | `empresaId: 1`, `usuarioId: 1` | Yes |

## `messages`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId | Yes |
| `role` | enum: user, assistant, system, tool | Yes |
| `content` | string | Yes |
| `agent` | string / null | No |
| `skill` | string / null | No |
| `model` | string / null | No |
| `sources` | array of object / null | No |
| `inputTokens` | int / long / null | No |
| `outputTokens` | int / long / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_messages_agent_skill_createdAt` | `agent: 1`, `skill: 1`, `createdAt: -1` | No |
| `ix_messages_conversation_createdAt` | `conversationId: 1`, `createdAt: 1` | No |

## `metrics`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId / null | No |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `model` | string / null | No |
| `inputTokens` | int / long / null | No |
| `outputTokens` | int / long / null | No |
| `latency` | double / null | No |
| `estimatedCost` | double / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `agent_1_createdAt_-1` | `agent: 1`, `createdAt: -1` | No |
| `createdAt_-1` | `createdAt: -1` | No |
| `ix_metrics_empresa_createdAt` | `empresaId: 1`, `createdAt: -1` | No |
| `ix_metrics_agent_skill_createdAt` | `agent: 1`, `skill: 1`, `createdAt: -1` | No |
| `ix_metrics_conversation_createdAt` | `conversationId: 1`, `createdAt: -1` | No |

## `prompt_evaluations`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `promptVersion` | string | Yes |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `score` | double | Yes |
| `feedback` | string / null | No |
| `evaluator` | string / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_prompt_evaluations_empresa_createdAt` | `empresaId: 1`, `createdAt: -1` | No |
| `ix_prompt_evaluations_createdAt` | `createdAt: -1` | No |
| `ix_prompt_evaluations_prompt_agent` | `promptVersion: 1`, `agent: 1` | No |

## `prompts`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `version` | string | Yes |
| `systemPrompt` | string | Yes |
| `temperature` | double / null | No |
| `model` | string | Yes |
| `active` | bool | Yes |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_prompts_agent_skill_active` | `agent: 1`, `skill: 1`, `active: 1` | No |
| `ux_prompts_agent_skill_version` | `agent: 1`, `skill: 1`, `version: 1` | Yes |

## `rag_chunks`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `documentId` | objectId | Yes |
| `chunk` | int | Yes |
| `text` | string | Yes |
| `embedding` | array of double / null | No |
| `metadata` | object / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `documentId_1` | `documentId: 1` | No |
| `documentId_1_chunk_1` | `documentId: 1`, `chunk: 1` | No |
| `ux_rag_chunks_document_chunk` | `documentId: 1`, `chunk: 1` | Yes |

## `rag_documents`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `empresaId` | int | Yes |
| `title` | string | Yes |
| `category` | enum: MANUAL, FAQ, PROCEDIMENTO, TREINAMENTO, POLITICA | Yes |
| `version` | string | Yes |
| `metadata` | object / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `empresaId_1` | `empresaId: 1` | No |
| `ux_rag_documents_empresa_slug` | `empresaId: 1`, `slug: 1` | Yes |
| `ix_rag_documents_empresa_category_createdAt` | `empresaId: 1`, `category: 1`, `createdAt: -1` | No |
| `tx_rag_documents_title` | `title: text` | No |
| `ux_rag_documents_empresa_title_version` | `empresaId: 1`, `title: 1`, `version: 1` | Yes |

## `response_explanations`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `messageId` | objectId | Yes |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `explanation` | string | Yes |
| `sources` | array of string / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_response_explanations_agent_createdAt` | `agent: 1`, `createdAt: -1` | No |
| `ux_response_explanations_messageId` | `messageId: 1` | Yes |

## `routing_logs`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId | Yes |
| `intent` | string | Yes |
| `selectedAgent` | string | Yes |
| `selectedSkill` | string / null | No |
| `confidence` | double / null | No |
| `createdAt` | date | Yes |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_routing_logs_conversation_createdAt` | `conversationId: 1`, `createdAt: -1` | No |
| `ix_routing_logs_intent_createdAt` | `intent: 1`, `createdAt: -1` | No |

## `skill_executions`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `empresaId` | int | Yes |
| `usuarioId` | int | Yes |
| `sessionId` | string | Yes |
| `conversationId` | objectId / null | No |
| `skill` | string | Yes |
| `version` | string | Yes |
| `status` | enum: success, denied, invalid_input, invalid_output, error, timeout | Yes |
| `input` | object / null | No |
| `output` | object / null | No |
| `error` | object / null | No |
| `latency` | double / null | No |
| `startedAt` | date | Yes |
| `finishedAt` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_skill_executions_empresa_skill_startedAt` | `empresaId: 1`, `skill: 1`, `startedAt: -1` | No |
| `ix_skill_executions_status` | `status: 1` | No |

## `skill_registry`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `empresaId` | int | Yes |
| `name` | string | Yes |
| `version` | string | Yes |
| `description` | string | Yes |
| `owner` | string | Yes |
| `entrypoint` | string | Yes |
| `timeoutSeconds` | double | Yes |
| `maxRetries` | int / null | No |
| `scope` | enum: read_only, write_with_approval | Yes |
| `requiredRoles` | array of string | Yes |
| `inputSchema` | object | Yes |
| `outputSchema` | object | Yes |
| `tags` | array of string / null | No |
| `active` | bool | Yes |
| `createdAt` | date | Yes |
| `updatedAt` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ux_skill_registry_empresa_name_version` | `empresaId: 1`, `name: 1`, `version: 1` | Yes |
| `ix_skill_registry_empresa_active` | `empresaId: 1`, `active: 1` | No |

## `tool_permissions`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `agent` | string | Yes |
| `tool` | string | Yes |
| `action` | string / null | No |
| `canExecute` | bool | No |
| `canRead` | bool | No |
| `active` | bool | Yes |
| `createdAt` | date | Yes |
| `updatedAt` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ux_tool_permissions_agent_tool` | `agent: 1`, `tool: 1` | Yes |

## `tool_runs`

Declared validation: `strict` / `error`.

| Field | Declared type or values | Required |
|---|---|---|
| `_id` | objectId | No |
| `conversationId` | objectId | Yes |
| `agent` | string | Yes |
| `skill` | string / null | No |
| `tool` | string | Yes |
| `input` | object / null | No |
| `output` | object / null | No |
| `status` | enum: running, success, error | Yes |
| `latency` | double / null | No |
| `error` | object / null | No |
| `startedAt` | date | Yes |
| `finishedAt` | date / null | No |

| Declared index | Keys (order) | Unique |
|---|---|---|
| `ix_tool_runs_agent_tool_startedAt` | `agent: 1`, `tool: 1`, `startedAt: -1` | No |
| `ix_tool_runs_conversation_startedAt` | `conversationId: 1`, `startedAt: -1` | No |
| `ix_tool_runs_status` | `status: 1` | No |
