# Hacker News

Collect a fixed Hacker News snapshot into a local DuckDB file. Each story is its own checkpoint. One worker owns one database file.

Docker is the whole setup. From the repository root:

```sh
docker compose run --build --rm hacker-news
```

The demo collects 100 live items, kills the worker after 20 stored rows, waits out the lease, resumes, and checks that the first 20 rows were not rewritten. The database stays in `outputs/hacker-news/`. RustFS stays running.

To drive it yourself, after `. ./scripts/prepare_local.sh`:

```sh
python python/hacker-news/hacker_news.py submit --id hn-001 --database "$PWD/outputs/hn.duckdb" --count 20
python python/hacker-news/hacker_news.py work --once
```

`query --database` reads the file with no engine. The cross-language crash matrix is `python tests/hacker_news.py`.
