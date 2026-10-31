# Redis: structures and notifications

## Flow

```text
Authorized producer -> Redis Stream -> Redis API consumer group
                    -> notification hash + inbox + counter
App -> authenticated Redis API -> list and mark as read
```

The default Stream is `mottainai:v1:notification:stream` and the default group
is `notification-writers`. Both are configurable. The consumer creates the
group and Stream if needed, polls up to 100 records per one-second cycle, and
recovers pending deliveries using `XPENDING` and `XCLAIM`; the default minimum
idle time is 60,000 ms.

## Stream input contract

| Field | Rule |
|---|---|
| `company_id`, `user_id` | Required positive integers. |
| `title` | Required, nonempty, up to 120 characters. |
| `body` | Required, nonempty, up to 1,000 characters. |
| `priority` | Required: 1, 2 or 3. |
| `id` | Optional; up to 128 characters and no `:`. If absent or blank, becomes `stream-<record-id>`. |

The consumer writes the notification and acknowledges it with `XACK`. Invalid
messages are logged and acknowledged without being written; this version does
not implement a dead-letter queue. Write or acknowledgement failures leave the
delivery pending for retry. Acknowledgement does not delete the Stream entry.

## Notification keys

| Pattern | Type | Purpose |
|---|---|---|
| `mottainai:v1:notification:stream` | Stream | Incoming events. |
| `mottainai:v1:notification:data:{company}:{user}:{id}` | Hash | `id`, `title`, `body`, `priority`, `status`, `created_at`. |
| `mottainai:v1:notification:inbox:{company}:{user}` | Sorted set | IDs ordered by priority and, for ties, creation time. |
| `mottainai:v1:notification:unread:{company}:{user}` | Numeric string | Unread notification count. |

The hash has a TTL of 604,800 seconds (7 days), subject to the server's memory
policy. Lua scripts perform writes and reconciliation atomically. Repeating an
ID while its hash exists preserves its content, state and TTL; after expiration
the same ID can create a new notification. Without an explicit ID, the ID
derived from the Stream entry prevents duplication on redelivery of that entry,
but separate publications create separate notifications.

Listing and marking as read reconcile the index and counter against existing
hashes, removing expired references. Reading does not extend the hash TTL.
Reconciliation scans the entire inbox, so its cost grows with the number of
indexed entries. The index and counter expire according to the longest remaining
TTL among active hashes; when none remain, both are removed.

## Other AI uses of Redis

The [AI keyspace](https://github.com/Mottainai-One/Mottainai-IA/blob/021fdc0/app/cache/keyspace.py)
also defines `mottainai:v1:rate-limit:...`, `:rag:...`,
`:alert-webhook-sent:...`, `:auth:revoked:...` and `:idempotency:...`.
The RAG cache has a configurable TTL, defaulting to 300 seconds. Idempotency
locks can remain after an ambiguous failure and require reconciliation; do not
treat them as disposable cache without evaluating the write flow. Separate key
prefixes do not prove isolation in separate instances.
