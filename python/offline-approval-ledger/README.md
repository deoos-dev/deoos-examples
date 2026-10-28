# Offline approval ledger

An approval that nobody can tie back to the transfer is not an approval. The worker may also sit on that wait for hours, including on a machine that cannot phone home.

> I once watched an agent run a pre-approved payment flow and afterward nobody could reconstruct which approval mapped to which transfer. Approval gets you permission, but without a clean audit trail you are just hoping execution matched.
>
> — [E1ev3n](https://x.com/harden_369741/status/2112727626930598169)

> you wake up and find your agent has been sitting there waiting for approval for 9 hours
>
> — [Prasad Pilla](https://x.com/prasad_pilla/status/2105575860464206207)

`intake` reads a local invoice. `propose_transfer` applies amount and currency rules and does not call a model. The task then `ctx.wait_signal("approval")`. The signal carries `approval_id`, `approver`, `approved`, and `note`. The transfer posts that approval id to a fake bank with `ctx.idempotency_key("transfer")`. `reconcile` writes one ledger row: `approval_id`, `transfer_id`, `idempotency_key`, `task_id`.

Build the bundle on a connected machine, from the repository root:

```sh
./scripts/bundle_offline.sh
```

That downloads the deoos 0.7.2 Linux archives, checks `SHA256SUMS`, pulls the pinned RustFS image, builds `deoos-examples:offline` with `--build-arg DEOOS_TARBALL`, and writes `outputs/offline-bundle.tar`.

On the isolated host:

```sh
docker load -i outputs/offline-bundle.tar
docker compose -f compose.offline.yaml run --rm offline-approval-ledger
```

`compose.offline.yaml` has no build step. Its network is `internal: true`, so the worker cannot open HTTPS to github.com. The demo checks that first. It then kills the worker while the task is waiting, sends the approval with no worker running, kills the next worker after the bank has accepted the transfer and before that step is checkpointed, and lets a new worker process finish. There is one transfer. Its body carries the approval id. The ledger row maps that id to the transfer id. `intake` and `propose_transfer` do not run again.

An internal network has no route from the host back to the task, so this run does the kill and the signal inside the one container. A new process resumes the same task the way a replacement container would. Evidence stays in `outputs/offline-approval-ledger/`.

The workflow is `approval_ledger.py`. The invoice is `invoice.json`.
