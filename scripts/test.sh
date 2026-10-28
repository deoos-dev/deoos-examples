#!/bin/sh
# Behavioral end-to-end tests against the real engine and local RustFS.
set -eu
cd "$(dirname "$0")/.."
if [ ! -f .deoos/env.sh ]; then
  ./scripts/install_deoos.sh
fi
# shellcheck disable=SC1091
. ./.deoos/env.sh
python - <<'PY'
import sys
import urllib.request
try:
    urllib.request.urlopen("http://127.0.0.1:19000/health", timeout=2)
except OSError:
    sys.exit("Start RustFS first: docker compose up -d rustfs")
PY
python tests/use_cases.py
python tests/payment_resume.py
python tests/counting_house.py
python tests/document_index_demo.py
python tests/devto_etl_demo.py
python tests/hacker_news_demo.py
python tests/hacker_news.py
