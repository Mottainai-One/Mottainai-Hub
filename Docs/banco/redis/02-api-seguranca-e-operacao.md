# Redis: API, security and operations

## Notification API

| Method and route | Behavior |
|---|---|
| `GET /livez` | Process liveness; does not query Redis. |
| `GET /readyz` | Checks Redis connectivity. |
| `GET /v1/notifications?limit=20` | Lists the inbox and unread count; limit is between 1 and 100. |
| `POST /v1/notifications/{id}/read` | Idempotently marks a notification as read; returns 404 if not found. |

The API has no HTTP route for creating notifications. Notification routes require
an HS256 Bearer JWT with `exp`, `sub`, `empresa_id` and `role`. Accepted roles
are `CLIENTE`, `ESTOQUISTA`, `GERENTE` and `DONO`; company and user are taken
from the token. The secret must contain at least 32 characters. Configuration
uses `REDIS_URL` and `JWT_SECRET`, plus optional `NOTIFICATION_STREAM_KEY`,
`NOTIFICATION_STREAM_GROUP` and `NOTIFICATION_STREAM_RECLAIM_IDLE_MS`.
Protect credentials and restrict Redis network access to authorized services.

## Persistence, memory and retention

The API compose configuration connects to a separately provisioned Redis. Its
README records an observed environment with AOF, `maxmemory 256mb` and
`volatile-lru`; this does not establish the configuration of another
environment. Under memory pressure `volatile-lru` can evict keys with TTL before
their expiry. The API does not assign a TTL to or automatically trim the
Stream, so monitor growth, consumers and pending messages. A retention policy
must preserve messages still needed; do not run `XTRIM`, `XDEL` or broad cleanup
without understanding consumer groups and possible data loss.

Monitor availability, memory, evictions, Stream size, lag and pending deliveries.
Investigate persistent failures before removing locks or keys. AOF is not a
substitute for a tested backup; define a restoration strategy for the actual
deployment. Notifications may contain sensitive information: avoid copying
payloads into logs or tickets.

## Verification

In the API repository, `mvn verify` runs the configured test suite. Integration
tests require a dedicated test Redis and `REDIS_TEST_HOST` (optional port:
`REDIS_TEST_PORT`). Do not point tests at a production instance. `/readyz`
checks connectivity but does not validate end-to-end notification delivery or
Stream retention.

**Scope:** the actual Redis instance, memory policy, effective persistence and
end-to-end delivery were not inspected.
