# Order

Same order workflow as `python/order`: child tasks, a timer, and an approval signal.

From the repository root, after `. ./scripts/prepare_local.sh`:

```sh
node typescript/order/order.mjs submit --id order-002
node typescript/order/order.mjs work
```

`work` polls until you stop it. Approve from another shell with `node typescript/order/order.mjs approve --id order-002`. Use a new id for a new order. An id already submitted with the same definition returns the existing task.
