#!/usr/bin/env bash
set -euo pipefail

URL="${1:-http://localhost:8080/actuator/health}"

echo "Checking $URL ..."
status="$(curl -s "$URL" | grep -o '"status":"[^"]*"' || true)"
echo "Result: $status"

if [[ "$status" != *'"status":"UP"'* ]]; then
  echo "Healthcheck FAILED"
  exit 1
fi

echo "Healthcheck OK"
