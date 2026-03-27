#!/bin/bash
# Batman Bat-Signal — Cowork-to-Batman Bridge
# Usage: ./bat-signal.sh <command> [args...]
#
# All project-specific config lives in batman.config.json.
#
# Examples:
#   ./bat-signal.sh init                    # Initialize Batman in test project
#   ./bat-signal.sh daemon start            # Start swarm daemon
#   ./bat-signal.sh daemon stop             # Stop daemon
#   ./bat-signal.sh --version               # Check version
#   ./bat-signal.sh doctor                  # Health check

set -e

BATCAVE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$BATCAVE_DIR/batman.config.json"
CLI_BIN="$BATCAVE_DIR/v3/@claude-flow/cli/bin/cli.js"

# Validate config exists
if [ ! -f "$CONFIG" ]; then
  echo "ERROR: Batman config not found. Run setup first."
  echo "Expected: $CONFIG"
  exit 1
fi

# Read project path from config (expand ~ to $HOME)
PROJECT_PATH="$(jq -r '.project.path' "$CONFIG" | sed "s|^~|$HOME|")"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "ERROR: Project path does not exist: $PROJECT_PATH"
  echo "Update project.path in batman.config.json"
  exit 1
fi

# Load batcave env
set -a
source "$BATCAVE_DIR/.env.batcave"
set +a

# Security gate — read blocked patterns from config
while IFS= read -r key; do
  if env | grep -qi "$key"; then
    echo "BLOCKED: $key found in environment"
    exit 1
  fi
done < <(jq -r '.security.blockedEnvPatterns[]' "$CONFIG")

# Run in project context with clean env
cd "$PROJECT_PATH"
exec env -i \
  HOME="$HOME" \
  PATH="$PATH" \
  TMPDIR="${TMPDIR:-/tmp}" \
  NODE_ENV="development" \
  ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  CLAUDE_FLOW_AUTO_UPDATE="false" \
  CLAUDE_FLOW_DEBUG="true" \
  node "$CLI_BIN" "$@"
