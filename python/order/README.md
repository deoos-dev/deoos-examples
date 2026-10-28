# Order

A durable order: validate and price run as child tasks, the workflow sleeps, then it waits for an approval signal. No payment service is called. Python and TypeScript share task ids, so a TypeScript worker can finish a Python submission.

From the repository root, after `. ./scripts/prepare_local.sh`:

```sh
python python/order/order.py submit --id order-001
python python/order/order.py work
```

`work` polls until you stop it. In another shell, once it is running:

```sh
python python/order/order.py approve --id order-001
```

The worker then finishes the order. `inspect --id order-001` prints it. `--decline` records a rejection. `work --once` polls a single time, which is only one step of the order.
