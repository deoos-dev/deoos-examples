# Hacker News

Same DuckDB collection as `python/hacker-news`. Keep one Node worker per database file.

The Docker demo runs the Python recovery check. To run this client, after `. ./scripts/prepare_local.sh`:

```sh
node typescript/hacker-news/hacker_news.mjs submit --id hn-002 --database "$PWD/outputs/hn-ts.duckdb" --count 20
node typescript/hacker-news/hacker_news.mjs work --once
```

`tests/hacker_news.py` kills a worker in each language and resumes with the other.
