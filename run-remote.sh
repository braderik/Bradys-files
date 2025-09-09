#!/usr/bin/env bash
set -euo pipefail

TARGET_HOST="${TARGET_HOST:-mac-home}"
REMOTE_CMD="${REMOTE_CMD:-bash -lc ~/scripts/backup.sh}"

echo "Connecting to $TARGET_HOST …"
ssh -o ConnectTimeout=8 "$TARGET_HOST" "$REMOTE_CMD"
echo "Done."
