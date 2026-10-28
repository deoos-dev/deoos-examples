# Document index

Read local UTF-8 text files, checkpoint each document, and publish one searchable JSON index. Search matches lowercase ASCII words. Original text, including a BOM and CRLF, is kept.

From the repository root:

```sh
docker compose run --build --rm document-index
```

The demo writes eight sample files, kills the worker after four reads have committed, then kills the other language after the index is published and before that checkpoint commits. Recovery keeps the saved documents and replaces the index with the same bytes. Python and TypeScript search must agree. Files stay in `outputs/document-index/`.

The index path belongs to the worker host. One workflow owns one output path. This is not PDF extraction or semantic search.

The workflow is `document_index.py`.
