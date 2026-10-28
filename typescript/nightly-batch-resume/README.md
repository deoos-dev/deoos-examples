# Nightly batch resume

Same 10,000-order batch as `python/nightly-batch-resume`. Idempotency keys are `ctx.idempotencyKey`.

`docker compose run --build --rm nightly-batch-resume` runs this file and the Python workflow. The module is `nightly_batch.mjs`.
