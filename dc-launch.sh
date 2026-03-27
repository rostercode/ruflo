#!/bin/bash
# DC Launch — fires a prompt to Claude Code from VS Code terminal
# Usage: dc <prompt-file>
# Example: dc prompts/build-log-system.md
#
# Shell alias `dc` in ~/.zshrc points here.
# Reads project path from batman.config.json via jq.
# Writes build status to ~/.dc-build-status.json.
# Fires macOS notification on completion.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$SCRIPT_DIR/batman.config.json"
STATUS_FILE="$HOME/.dc-build-status.json"

# --- Dependency check ---
if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required but not installed. Run: brew install jq"
  exit 1
fi

# --- Validate config ---
if [ ! -f "$CONFIG" ]; then
  echo "ERROR: Batman config not found at $CONFIG"
  exit 1
fi

# --- Read project path (expand ~ to $HOME) ---
PROJECT_DIR="$(jq -r '.project.path' "$CONFIG" | sed "s|^~|$HOME|")"

# --- Find Claude Code binary ---
CLAUDE_BIN="$(find "$HOME/.vscode/extensions" -path "*/anthropic.claude-code-*/resources/native-binary/claude" -type f | head -1)"

if [ -z "$CLAUDE_BIN" ] || [ ! -x "$CLAUDE_BIN" ]; then
  echo "ERROR: Claude Code binary not found in VS Code extensions"
  exit 1
fi

# --- Validate prompt file ---
PROMPT_FILE="$1"

if [ -z "$PROMPT_FILE" ]; then
  echo "Usage: dc <prompt-file>"
  echo "Example: dc prompts/build-log-system.md"
  exit 1
fi

PROMPT_PATH="$PROJECT_DIR/$PROMPT_FILE"

if [ ! -f "$PROMPT_PATH" ]; then
  echo "ERROR: Prompt file not found: $PROMPT_PATH"
  exit 1
fi

# --- Write "running" status ---
START_TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
START_EPOCH="$(date +%s)"

cat > "$STATUS_FILE" <<EOF
{
  "status": "running",
  "prompt_file": "$PROMPT_FILE",
  "started_at": "$START_TS",
  "pid": $$
}
EOF

echo "DC Build started: $PROMPT_FILE"
echo "PID: $$ | Status: $STATUS_FILE"
echo ""

# --- Run Claude Code ---
# set +e so non-zero exit from Claude Code doesn't kill the wrapper
set +e
cd "$PROJECT_DIR" && cat "$PROMPT_FILE" | "$CLAUDE_BIN" -p --permission-mode auto
EXIT_CODE=$?
set -e

# --- Calculate duration ---
END_EPOCH="$(date +%s)"
DURATION=$((END_EPOCH - START_EPOCH))
END_TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# --- Determine result ---
if [ "$EXIT_CODE" -eq 0 ]; then
  RESULT="success"
  SOUND="Glass"
else
  RESULT="failed"
  SOUND="Basso"
fi

# --- Write completion status ---
cat > "$STATUS_FILE" <<EOF
{
  "status": "$RESULT",
  "exit_code": $EXIT_CODE,
  "prompt_file": "$PROMPT_FILE",
  "started_at": "$START_TS",
  "finished_at": "$END_TS",
  "duration_seconds": $DURATION
}
EOF

# --- macOS notification ---
osascript -e "display notification \"$PROMPT_FILE — $RESULT in ${DURATION}s\" with title \"DC Build Complete\" sound name \"$SOUND\"" 2>&1 || true

# --- Banner ---
echo ""
echo "======================================="
echo "  DC BUILD: $RESULT — ${DURATION}s"
echo "======================================="

exit $EXIT_CODE
