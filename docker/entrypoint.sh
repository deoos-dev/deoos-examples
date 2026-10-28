#!/bin/sh
set -eu

demo=${1:?Choose hacker-news, devto-etl, payment-resume, document-index, or counting-house.}
shift
case "$demo" in
  hacker-news)
    exec python /app/tests/hacker_news_demo.py \
      --endpoint http://rustfs:9000 --directory /app/outputs/hacker-news "$@"
    ;;
  counting-house)
    exec python /app/python/counting-house/demo.py \
      --endpoint http://rustfs:9000 --directory /app/outputs/counting-house "$@"
    ;;
  devto-etl|payment-resume|document-index)
    case "$demo" in
      devto-etl) script=devto_etl_demo.py ;;
      payment-resume) script=payment_resume_demo.py ;;
      document-index) script=document_index_demo.py ;;
    esac
    exec python "/app/tests/$script" \
      --endpoint http://rustfs:9000 --directory "/app/outputs/$demo" \
      --server "$ENGINE_BINARY" --node-sdk "$DEOOS_NODE_SDK" "$@"
    ;;
  *) echo "Unknown demo: $demo" >&2; exit 1 ;;
esac
