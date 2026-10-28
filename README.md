# deoos examples

Runnable examples for [deoos](https://github.com/deoos-dev/deoos), a durable execution engine on object storage. Each example is a small workflow. The crash-recovery demos and `tests/` run that workflow on the real engine, kill the worker, and check the saved result. Nothing here mocks the engine.

The engine and both clients are [deoos 0.7.2](https://github.com/deoos-dev/deoos/releases/tag/0.7.2), git `457efe57737c7ed5fefb3ea9dcf99869c11760a6`. `deoos.lock` records that pin. There are no engine or client changes between that tag and the commits these examples were taken from, so the published release is the runtime. `scripts/install_deoos.sh` downloads that release, checks `SHA256SUMS`, and installs the Python wheel, the Node package, and `deoos-server`. The Docker image does the same.

## Setup

Docker is enough for the five crash-recovery demos. The other examples need the SDK and local [RustFS](https://github.com/rustfs/rustfs):

```sh
. ./scripts/prepare_local.sh
```

That installs deoos, starts RustFS on `127.0.0.1:19000`, creates the bucket `deoos-examples`, and exports the local storage variables. Leave that shell open. Python commands below use the virtualenv it put on `PATH`. TypeScript commands use `node` and `node_modules/deoos`.

## Examples

Python and TypeScript implement the same workflows, except Counting House, which is Python only.

| Example | What it shows | Run |
| --- | --- | --- |
| [Hacker News](python/hacker-news/README.md) | Save a live top-stories snapshot to DuckDB, kill the worker after 20 rows, resume | `docker compose run --build --rm hacker-news` |
| [DEV articles](python/devto-etl/README.md) | Fetch articles to CSV, kill after a checkpoint and again in the write gap | `docker compose run --build --rm devto-etl` |
| [Payment](python/payment/README.md) | Charge, wait for approval, fulfil; replay a saved charge after the idempotency window | `docker compose run --build --rm payment-resume` |
| [Document index](python/document-index/README.md) | Index local text files, kill during read and during publish, search the result | `docker compose run --build --rm document-index` |
| [Counting House](python/counting-house/README.md) | Refund saga: the model proposes, a person approves, writes are checked and compensated | `docker compose run --build --rm counting-house` |
| [Library hello](python/library/README.md) | One step, engine inside the process | `python python/library/hello.py` |
| [Server hello](python/server/README.md) | Same greeting against `deoos-server` | see the example README |
| [Order](python/order/README.md) | Child tasks, a timer, and an approval signal | `python python/order/order.py submit --id order-001` then `python python/order/order.py work` |
| [HTTP integrations](python/integrations/README.md) | Webhook retry, invoice approval, scheduled page import | `python tests/use_cases.py` |

After setup, the TypeScript twins are the same arguments with `node typescript/<example>/<file>.mjs`. Paths are in each example README.

`docker compose up -d` starts only RustFS. The demo services build `docker/Dockerfile` and run the behavioral checks under `tests/`. Results stay in `outputs/`.

## Tests

`tests/` is behavioral end-to-end coverage against the real engine and RustFS. `./scripts/test.sh` runs it: HTTP integrations, payment, Counting House, document index, DEV CSV, and both Hacker News checks (the short demo and the cross-language crash matrix). GitHub Actions runs that script, then `docker compose run --build --rm counting-house`.

Start RustFS first (`docker compose up -d rustfs`, or the setup command above). Install with `./scripts/install_deoos.sh` and `source .deoos/env.sh` if you are not using `prepare_local.sh`.

## Where these files came from

Example programs are from [deoos](https://github.com/deoos-dev/deoos) commit `3ca611698b1b11efd73c142a9ac54c9369885448` (`main`). Counting House is from commit `3e9e2db6a537aa7c34f7e0f49f7acfbacd18a91c` on `cursor/counting-house-63d8` ([pull request 3](https://github.com/deoos-dev/deoos/pull/3)), which is not merged. The engine pin is tag `0.7.2`.

| This repo | Core path |
| --- | --- |
| `python/library/hello.py` | `examples/library_python.py` |
| `typescript/library/hello.mjs` | `examples/library_typescript.mjs` |
| `python/server/hello.py` | `examples/server_python.py` |
| `typescript/server/hello.mjs` | `examples/server_typescript.mjs` |
| `python/order/order.py` | `examples/workflow_python.py` |
| `typescript/order/order.mjs` | `examples/workflow_typescript.mjs` |
| `python/hacker-news/hacker_news.py` | `examples/hacker_news.py` |
| `typescript/hacker-news/hacker_news.mjs` | `examples/hacker_news.mjs` |
| `tests/hacker_news_demo.py` | `examples/hacker_news_demo.py` |
| `tests/hacker_news.py` | `tests/hacker_news.py` |
| `python/devto-etl/devto_etl.py` | `examples/devto_etl.py` |
| `typescript/devto-etl/devto_etl.mjs` | `examples/devto_etl.mjs` |
| `tests/devto_etl_demo.py` | `examples/devto_etl_demo.py` |
| `python/payment/payment_resume.py` | `examples/payment_resume.py` |
| `typescript/payment/payment_resume.mjs` | `examples/payment_resume.mjs` |
| `tests/payment_resume_demo.py` | `examples/payment_resume_demo.py` |
| `tests/payment_resume.py` | `tests/payment_resume.py` |
| `python/document-index/document_index.py` | `examples/document_index.py` |
| `typescript/document-index/document_index.mjs` | `examples/document_index.mjs` |
| `tests/document_index_demo.py` | `examples/document_index_demo.py` |
| `python/integrations/use_cases.py` | `examples/use_cases.py` |
| `typescript/integrations/use_cases.mjs` | `examples/use_cases.mjs` |
| `tests/use_cases.py` | `tests/use_cases.py` |
| `python/counting-house/refund.py` | `examples/counting_house/refund.py` |
| `python/counting-house/demo.py` | `examples/counting_house/demo.py` |
| `tests/counting_house.py` | `tests/counting_house.py` |

These core paths are the same workflows, wrapped by Docker rather than copied as files: `examples/hacker-news`, `examples/devto-etl`, `examples/payment-resume`, `examples/counting-house`, `examples/Dockerfile`, `examples/docker_runner.sh`, `examples/.dockerignore`, `examples/README.md`, `examples/counting_house/README.md`.
