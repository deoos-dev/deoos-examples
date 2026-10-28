# Server hello

Same greeting as the library example, talking to `deoos-server` over HTTP. The worker has no storage credentials.

From the repository root, after `. ./scripts/prepare_local.sh`, start the server in one shell:

```sh
ENGINE_BIND=127.0.0.1:7331 ENGINE_TOKEN=dev-token "$ENGINE_BINARY"
```

In another shell that has the same setup sourced:

```sh
DEOOS_MODE=server ENGINE_URL=http://127.0.0.1:7331 ENGINE_TOKEN=dev-token python python/server/hello.py
```

Prints `Hello, World!`.
