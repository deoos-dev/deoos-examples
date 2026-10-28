# Payment

Charge a fake payment API, wait for an approval signal, then fulfil. The charge and the fulfilment each send `ctx.idempotency_key`. A saved charge is not sent again. A crash after the HTTP call and before the checkpoint retries with the same key.

From the repository root:

```sh
docker compose run --build --rm payment-resume
```

The fake API keeps keys for 24 hours and advances a virtual clock, so the demo does not wait a day. One case resumes after the key has expired and must not call charge again. The other crashes inside the call/commit gap and must produce one charge. Both run in Python and TypeScript, library and server mode. Evidence stays in `outputs/payment-resume/`.

This does not reconcile an uncommitted charge after the provider has forgotten the key. That needs the provider's own records.

The workflow is `payment_resume.py`.
