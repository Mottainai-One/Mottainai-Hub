# Redis: notifications and AI usage

Redis supports the notification inbox consumed by the app and also stores keys
used by the AI layer. The [Redis API](https://github.com/Mottainai-One/Mottainai-Redis-Api/tree/8631908)
consumes Stream events and exposes the inbox over HTTP. The AI layer accesses
Redis directly for other functions. The actual topology and memory policy
depend on the deployment.

## Reading order

1. [Notification structures and flow](01-estruturas-e-notificacoes.md)
2. [API, security and operations](02-api-seguranca-e-operacao.md)

References: API commit `8631908` and AI commit `021fdc0`. This documentation
describes versioned code and does not prove the production configuration. Back
to the [database index](../README.md).
