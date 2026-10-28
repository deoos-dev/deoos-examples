# Counting House refund

A refund saga in the shape of Steve Yegge's Counting House: the model proposes a write and does not perform it. The workflow re-reads the ledger, waits for a person, then posts the refund to a billing ledger, a CRM file, and a notification log. Each write uses an idempotency key and is read back. If the notification step refuses, the ledger and the CRM are compensated.

Avery Chen was charged 4200 cents on invoice `inv-42`. The systems are JSON files. The proposer shipped here is a deterministic stub. No API key is used.

From the repository root:

```sh
docker compose run --build --rm counting-house
```

The demo runs five cases on the real engine: approval, a crash after the ledger write and before its checkpoint, rejection, compensation, and an over-invoice proposal that must write nothing. It also writes `evals.jsonl` (proposal, approval, outcome, and a correctness label). Evidence stays in `outputs/counting-house/`.

To drive one case after `. ./scripts/prepare_local.sh`, pick an empty directory and use one task id:

```sh
python python/counting-house/refund.py submit --id refund-001 --office /tmp/refund-001
```

`work` polls until you stop it, so run it in a second shell, then approve from the first:

```sh
python python/counting-house/refund.py work
python python/counting-house/refund.py approve --id refund-001 --by dana
```

`reject` declines a waiting case. Start `work` again after a crash; the same task continues. `export --out` writes the eval rows. The workflow is `refund.py`. The crash-recovery check is `demo.py`, which `tests/counting_house.py` calls.
