#!/bin/bash
# SENTNL SANDBOX — Ruflo Startup Script
# This script starts Ruflo with a clean, stripped environment.
# NO credentials from your main shell leak through.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_BIN="$SCRIPT_DIR/v3/@claude-flow/cli/bin/cli.js"

# Load ONLY the sandbox env
set -a
source "$SCRIPT_DIR/.env.sandbox"
set +a

# Verify no dangerous env vars leaked
DANGEROUS_KEYS="SUPABASE TELEGRAM OPENAI GOOGLE STRIPE TWITTER SLACK PINATA WEB3"
for key in $DANGEROUS_KEYS; do
  if env | grep -qi "$key"; then
    echo "SECURITY VIOLATION: Found $key in environment. Aborting."
    exit 1
  fi
done

echo "=== SENTNL Ruflo Sandbox ==="
echo "Commit: 0590bf2 (v3.5.42 audited)"
echo "Auto-update: DISABLED"
echo "Auto-install: DISABLED"
echo "Env spreading: PATCHED"
echo "PreToolUse hooks: REMOVED"
echo "=========================="

# Run whatever command was passed
if [ $# -eq 0 ]; then
  echo "Usage: ./start-sandbox.sh <command>"
  echo "  ./start-sandbox.sh --version"
  echo "  ./start-sandbox.sh doctor"
  echo "  ./start-sandbox.sh init"
  echo "  ./start-sandbox.sh mcp start"
  echo "  ./start-sandbox.sh daemon start --foreground"
  exit 0
fi

exec env -i \
  HOME="$HOME" \
  PATH="$PATH" \
  TMPDIR="${TMPDIR:-/tmp}" \
  NODE_ENV="development" \
  ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  CLAUDE_FLOW_AUTO_UPDATE="false" \
  CLAUDE_FLOW_DEBUG="true" \
  node "$CLI_BIN" "$@"
