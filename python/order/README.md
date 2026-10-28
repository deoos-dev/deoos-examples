# Order

A durable order: validate and price run as child tasks, the workflow sleeps, then it waits for an approval signal. No payment service is called. Python and TypeScript share task ids, so a TypeScript worker can finish a Python submission.

From the repository root, after `. ./scripts/prepare_local.sh`:

```sh
python python/order/order.py submit --id order-001 && python python/order/order.py work --once
python python/order/order.py approve --id order-001 && python python/order/order.py work --once
```

`inspect --id order-001` prints the saved order. `work` without `--once` polls until you stop it. `--decline` on `approve` records a rejection.
