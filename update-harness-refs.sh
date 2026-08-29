#!/bin/bash
set -euo pipefail

# Update harness base URLs to latest commit on main and recompute sha256 digests

AGENTS_REPO="fullsend-ai/agents"
HARNESS_DIR=".fullsend/harness"

echo "Fetching latest commit from $AGENTS_REPO main branch..."
LATEST_COMMIT=$(curl -sL "https://api.github.com/repos/$AGENTS_REPO/commits/main" | jq -r '.sha')
echo "Latest commit: $LATEST_COMMIT"

# Update triage.yaml
echo ""
echo "Updating triage.yaml..."
TRIAGE_FILE="triage.yaml"
TRIAGE_URL="https://raw.githubusercontent.com/$AGENTS_REPO/$LATEST_COMMIT/harness/$TRIAGE_FILE"
TRIAGE_SHA256=$(curl -sL "$TRIAGE_URL" | sha256sum | awk '{print $1}')
echo "  New sha256: $TRIAGE_SHA256"

sed -i "s|base: https://raw.githubusercontent.com/$AGENTS_REPO/[^/]*/harness/$TRIAGE_FILE#sha256=[a-f0-9]*|base: https://raw.githubusercontent.com/$AGENTS_REPO/$LATEST_COMMIT/harness/$TRIAGE_FILE#sha256=$TRIAGE_SHA256|" "$HARNESS_DIR/triage.yaml"
echo "  Updated $HARNESS_DIR/triage.yaml"

# Update code.yaml
echo ""
echo "Updating code.yaml..."
CODE_FILE="code.yaml"
CODE_URL="https://raw.githubusercontent.com/$AGENTS_REPO/$LATEST_COMMIT/harness/$CODE_FILE"
CODE_SHA256=$(curl -sL "$CODE_URL" | sha256sum | awk '{print $1}')
echo "  New sha256: $CODE_SHA256"

sed -i "s|base: https://raw.githubusercontent.com/$AGENTS_REPO/[^/]*/harness/$CODE_FILE#sha256=[a-f0-9]*|base: https://raw.githubusercontent.com/$AGENTS_REPO/$LATEST_COMMIT/harness/$CODE_FILE#sha256=$CODE_SHA256|" "$HARNESS_DIR/code.yaml"
echo "  Updated $HARNESS_DIR/code.yaml"

echo ""
echo "Done! All harness files updated to commit $LATEST_COMMIT"
