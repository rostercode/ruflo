#!/bin/bash
# Batman Batcave — Startup Script
# Starts Batman with a clean, stripped environment.
# NO credentials from your main shell leak through.
#
# All project-specific config lives in batman.config.json.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$SCRIPT_DIR/batman.config.json"
CLI_BIN="$SCRIPT_DIR/v3/@claude-flow/cli/bin/cli.js"

# Validate config exists
if [ ! -f "$CONFIG" ]; then
  echo "ERROR: Batman config not found. Run setup first."
  echo "Expected: $CONFIG"
  exit 1
fi

# Read project info from config
PROJECT_NAME="$(jq -r '.project.name' "$CONFIG")"
LOCKED_COMMIT="$(jq -r '.upstream.lockedCommit' "$CONFIG")"
VERSION="$(jq -r '.upstream.version' "$CONFIG")"

# Load ONLY the batcave env
set -a
source "$SCRIPT_DIR/.env.batcave"
set +a

# Verify no dangerous env vars leaked — read blocked patterns from config
while IFS= read -r key; do
  if env | grep -qi "$key"; then
    echo "SECURITY VIOLATION: Found $key in environment. Aborting."
    exit 1
  fi
done < <(jq -r '.security.blockedEnvPatterns[]' "$CONFIG")

echo "=== $PROJECT_NAME Batman Batcave ==="
echo "Commit: $LOCKED_COMMIT (v$VERSION audited)"
echo "Auto-update: DISABLED"
echo "Auto-install: DISABLED"
echo "Env spreading: PATCHED"
echo "PreToolUse hooks: REMOVED"
echo "============================="

# Run whatever command was passed
if [ $# -eq 0 ]; then
  echo "Usage: ./summon-batman.sh <command>"
  echo "  ./summon-batman.sh --version"
  echo "  ./summon-batman.sh doctor"
  echo "  ./summon-batman.sh init"
  echo "  ./summon-batman.sh mcp start"
  echo "  ./summon-batman.sh daemon start --foreground"
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
