# Payment

Same charge, approval, and fulfil workflow as `python/payment`. Idempotency keys are `ctx.idempotencyKey`.

`docker compose run --build --rm payment-resume` runs this file and the Python workflow. The module is `payment_resume.mjs`.
