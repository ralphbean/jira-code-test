#!/bin/bash
set -euo pipefail

# Update harness base URLs to latest commit on main, recompute sha256
# digests, and update the reusable-dispatch.yml workflow reference in
# fullsend-poll-jira.yaml to the latest fullsend commit.

AGENTS_REPO="fullsend-ai/agents"
FULLSEND_REPO="fullsend-ai/fullsend"
HARNESS_DIR=".fullsend/harness"
POLL_WORKFLOW=".github/workflows/fullsend-poll-jira.yaml"

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

# Update coder.yaml (which uses code.yaml from upstream)
echo ""
echo "Updating coder.yaml..."
CODE_FILE="code.yaml"
CODE_URL="https://raw.githubusercontent.com/$AGENTS_REPO/$LATEST_COMMIT/harness/$CODE_FILE"
CODE_SHA256=$(curl -sL "$CODE_URL" | sha256sum | awk '{print $1}')
echo "  New sha256: $CODE_SHA256"

sed -i "s|base: https://raw.githubusercontent.com/$AGENTS_REPO/[^/]*/harness/$CODE_FILE#sha256=[a-f0-9]*|base: https://raw.githubusercontent.com/$AGENTS_REPO/$LATEST_COMMIT/harness/$CODE_FILE#sha256=$CODE_SHA256|" "$HARNESS_DIR/coder.yaml"
echo "  Updated $HARNESS_DIR/coder.yaml"

# Update reusable-dispatch.yml reference in fullsend-poll-jira.yaml
echo ""
echo "Updating reusable-dispatch.yml reference in $POLL_WORKFLOW..."
FULLSEND_LATEST=$(curl -sL "https://api.github.com/repos/$FULLSEND_REPO/commits/main" | jq -r '.sha')
echo "  Latest fullsend commit: $FULLSEND_LATEST"

sed -i "s|uses: $FULLSEND_REPO/.github/workflows/reusable-dispatch.yml@[a-f0-9]\{40\}|uses: $FULLSEND_REPO/.github/workflows/reusable-dispatch.yml@$FULLSEND_LATEST|" "$POLL_WORKFLOW"
echo "  Updated $POLL_WORKFLOW"

echo ""
echo "Done! All harness files updated to commit $LATEST_COMMIT"
echo "  reusable-dispatch.yml ref updated to $FULLSEND_LATEST"
