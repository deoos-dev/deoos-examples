# Agent run resume

Restarting an agent from the first prompt calls the same tools again and pays for them again. A timeout on a charge is worse when the retry invents a new idempotency key.

> Restarted the same agent three times today. Each time it re-called the same tools and burned the same credits before it failed at the same step. The model is not the problem. The process is not durable.
>
> — [Ayaz Hamza Altay](https://x.com/ayazaltai/status/2109269035883925859)

> The payment SDK had idempotency keys. The agent still charged twice. After a timeout, the framework retried as a new tool call. New session. New auto-generated key. Second charge.
>
> — [Prasanth Kuna](https://x.com/prasanth_kuna/status/2107539999059296359)

> One failed agent in a workflow reruns every agent that started after it, even the ones that already finished.
>
> — [Tidyowl](https://x.com/tidyowl/status/2114420311798304877), describing a runner that replays from the first unfinished step

`plan`, `research`, `draft`, `check`, and `publish` each call a local canned model and then one tool. `publish` charges with `ctx.idempotencyKey("publish")`. If that HTTP call times out after the charge was recorded, the same step retries the same key. `report` returns the token spend of the saved steps.

From the repository root, after RustFS is up:

```sh
docker compose run --build --rm agent-run-resume
```

The demo kills the worker after `draft` is saved, lets `check` throw once, and then finishes. The model is called once for plan, research, draft, and publish, and twice for check. The charge ledger has one effect. Both charge attempts carry the same key. The test prints `credits burned without deoos vs with` from that ledger: the durable total, and what the same crashes would have cost if each attempt had started over at `plan`.

The saved report does not include the failed check. That attempt never checkpointed, so its tokens are only in the model ledger. Evidence stays in `outputs/agent-run-resume/`.

The workflow is `agent_run.mjs`. The Python twin is `python/agent-run-resume`.
