# Nightly batch resume

A nightly job of 10,000 orders dies part way through and, on the next start, sends the early emails again.

> Picture a nightly CronJob that processes payments. One night it runs twice, and nothing in Kubernetes is broken. The real fix is in your code: the job has to be idempotent. Record which batches are done, and make a rerun skip them.
>
> — [Prateek Jain](https://x.com/PrateekJainDev/status/2107904291969142820)

> A nightly job syncs 10,000 orders. It dies at 7,000 and restarts from the first one. Customers get duplicate emails.
>
> — [Read the Diff](https://x.com/read__the__diff/status/2109962754542956799)

`load_orders` reads 10,000 seeded orders from a local file. The run then does 100 batches of 100. Each batch is one `ctx.step("batch-NNN")`. Inside a batch, every order is a `POST /send` with `ctx.idempotency_key(f"email-{order_id}")`. The summary step is the task result. The task id is `nightly-<date>`, so a second submit with the same inputs attaches to that task instead of starting another one.

From the repository root, after RustFS is up:

```sh
docker compose run --build --rm nightly-batch-resume
```

The demo kills the worker with SIGKILL after batch 70 is saved, kills the next worker inside batch 71, and submits the same task both while batch 71 is in flight and after the run completes. Batches 1–70 run once. The sends that left batch 71 before the kill are retried with the same key, and the mailer keeps one effect per key. The ledger ends at 10,000 unique sends. The second trigger returns the same summary.

The engine history keeps the last 32 events and does not store payloads, so this demo does not read it. The mailer ledger and one counter file per batch are the record. Evidence stays in `outputs/nightly-batch-resume/`.

To write the order file yourself:

```sh
python python/nightly-batch-resume/seed_orders.py orders.jsonl
```

The workflow is `nightly_batch.py`. The TypeScript twin is `typescript/nightly-batch-resume`.
