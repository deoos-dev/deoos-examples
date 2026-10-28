# HTTP integrations

Same webhook, invoice, and scheduled import workflows as `python/integrations`.

`python tests/use_cases.py` runs this file and the Python workflow on the real engine. To drive one case, start the simulated service as in the Python README, then:

```sh
SERVICE_URL=http://127.0.0.1:18080 node typescript/integrations/use_cases.mjs submit webhook --id delivery-002 --event-id event-002
SERVICE_URL=http://127.0.0.1:18080 node typescript/integrations/use_cases.mjs work --once
```

A task id belongs to one definition. Use a new id for new work.
