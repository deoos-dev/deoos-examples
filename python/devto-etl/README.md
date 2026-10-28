# DEV articles to CSV

Fetch three pages of [DEV](https://dev.to) articles, normalize them, and atomically replace a CSV. Pagination overlap keeps the first copy of an article id. Array cells are JSON so Python and TypeScript write the same file.

From the repository root:

```sh
docker compose run --build --rm devto-etl
```

The demo captures the three live responses once, then replays those bytes. It kills the worker after page 2 is checkpointed, and again after the CSV write before that checkpoint commits. Each page is fetched once per workflow. Both languages and both modes (library and server) must match. Output stays in `outputs/devto-etl/`.

The workflow itself is `devto_etl.py`. Replacement workers need the same output path.
