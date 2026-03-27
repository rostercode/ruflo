#!/bin/bash
# DC Watch — file-based trigger watcher for Claude Code builds
# Usage: dc-watch (runs in VS Code terminal, watches ~/.dc-trigger for changes)
#
# Start once in a VS Code terminal. Cowork fires builds by writing
# a prompt path to ~/.dc-trigger via dc-trigger.sh.

TRIGGER_FILE="$HOME/.dc-trigger"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DC_LAUNCH="$SCRIPT_DIR/dc-launch.sh"

# --- Dependency check ---
if ! command -v fswatch &>/dev/null; then
  echo "ERROR: fswatch is required. Run: brew install fswatch"
  exit 1
fi

if [ ! -x "$DC_LAUNCH" ]; then
  echo "ERROR: dc-launch.sh not found or not executable at $DC_LAUNCH"
  exit 1
fi

# --- Create trigger file if missing ---
[ ! -f "$TRIGGER_FILE" ] && touch "$TRIGGER_FILE"

# --- Clean exit on Ctrl+C ---
cleanup() {
  echo ""
  echo "DC Watch stopped."
  exit 0
}
trap cleanup SIGINT SIGTERM

# --- Banner ---
echo "======================================="
echo "  DC WATCH — waiting for builds..."
echo "  Trigger file: $TRIGGER_FILE"
echo "  Press Ctrl+C to stop"
echo "======================================="
echo ""

# --- Watch loop ---
while true; do
  # Block until trigger file changes
  fswatch -1 "$TRIGGER_FILE" >/dev/null 2>&1

  # Small delay to ensure write is complete
  sleep 0.2

  # Read prompt path
  PROMPT="$(cat "$TRIGGER_FILE" 2>/dev/null | tr -d '[:space:]')"

  # Skip empty triggers
  if [ -z "$PROMPT" ]; then
    continue
  fi

  # Clear trigger file immediately to prevent re-fires
  > "$TRIGGER_FILE"

  echo "======================================="
  echo "  BUILD TRIGGERED: $PROMPT"
  echo "  $(date '+%Y-%m-%d %H:%M:%S')"
  echo "======================================="
  echo ""

  # Run dc-launch.sh — don't exit on failure
  "$DC_LAUNCH" "$PROMPT" || true

  echo ""
  echo "======================================="
  echo "  DC WATCH — waiting for builds..."
  echo "======================================="
  echo ""
done
