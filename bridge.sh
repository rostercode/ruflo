#!/bin/bash
# SENTNL Cowork-to-Ruflo Bridge
# Usage: ./bridge.sh <command> [args...]
#
# Examples:
#   ./bridge.sh init                    # Initialize Ruflo in test project
#   ./bridge.sh daemon start            # Start swarm daemon
#   ./bridge.sh daemon stop             # Stop daemon
#   ./bridge.sh --version               # Check version
#   ./bridge.sh doctor                  # Health check

set -e

SANDBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_BIN="$SANDBOX_DIR/v3/@claude-flow/cli/bin/cli.js"
TEST_PROJECT="/Users/chase/Desktop/ruflo-test-project"

# Load sandbox env
set -a
source "$SANDBOX_DIR/.env.sandbox"
set +a

# Security gate
DANGEROUS_KEYS="SUPABASE TELEGRAM OPENAI GOOGLE STRIPE"
for key in $DANGEROUS_KEYS; do
  if env | grep -qi "$key"; then
    echo "BLOCKED: $key found in environment"
    exit 1
  fi
done

# Run in test project context with clean env
cd "$TEST_PROJECT"
exec env -i \
  HOME="$HOME" \
  PATH="$PATH" \
  TMPDIR="${TMPDIR:-/tmp}" \
  NODE_ENV="development" \
  ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  CLAUDE_FLOW_AUTO_UPDATE="false" \
  CLAUDE_FLOW_DEBUG="true" \
  node "$CLI_BIN" "$@"
