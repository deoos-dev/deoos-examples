# HTTP integrations

Three workflows against a simulated HTTP service: deliver a webhook and retry a 503, wait for an invoice approval and then issue it, and import pages as child tasks on a fixed interval. The service is the development stand-in from `tests/use_cases.py`. It remembers idempotency keys in memory. It is not an accounting system.

The behavioral check starts RustFS, the real engine, and that service, then runs every case in library and server mode with Python and TypeScript workers replacing each other:

```sh
docker compose up -d rustfs
python tests/use_cases.py
```

`./scripts/install_deoos.sh` and `source .deoos/env.sh` first, if you have not already sourced `scripts/prepare_local.sh`.

To drive one case yourself, in another terminal from the repository root:

```sh
python tests/use_cases.py --serve --port 18080
SERVICE_URL=http://127.0.0.1:18080 python python/integrations/use_cases.py submit webhook --id delivery-001 --event-id event-001
SERVICE_URL=http://127.0.0.1:18080 python python/integrations/use_cases.py work --once
```

`submit invoice`, `signal --id`, and `submit import` are the other commands. `--help` lists them. Stop the service when you are done; its ledger is memory only.
