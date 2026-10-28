# Library hello

One greeting step. The Rust engine runs inside this Python process. No server.

From the repository root, after `. ./scripts/prepare_local.sh`:

```sh
python python/library/hello.py
```

Prints `Hello, World!`. Pass a task id as the first argument to reuse one; otherwise each run submits a new id.
