#!/bin/bash
# DC Status — check the last build status
# Usage: dc-status (or: bash ~/Desktop/batcave/dc-status.sh)
# Returns JSON from ~/.dc-build-status.json with live process check

STATUS_FILE="$HOME/.dc-build-status.json"

# --- No builds yet ---
if [ ! -f "$STATUS_FILE" ]; then
  echo '{"status": "no_builds"}'
  exit 0
fi

# --- Check jq availability ---
if ! command -v jq &>/dev/null; then
  # Fallback: output raw file without enrichment
  cat "$STATUS_FILE"
  exit 0
fi

# --- If status says "running", verify PID is alive ---
STATUS="$(jq -r '.status' "$STATUS_FILE")"

if [ "$STATUS" = "running" ]; then
  PID="$(jq -r '.pid' "$STATUS_FILE")"
  # Use ps -p to check if process is alive (stdout to /dev/null, stderr stays visible)
  if ! ps -p "$PID" > /dev/null; then
    # Process died without writing completion — mark as crashed
    NOW="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    PROMPT="$(jq -r '.prompt_file' "$STATUS_FILE")"
    STARTED="$(jq -r '.started_at' "$STATUS_FILE")"
    cat > "$STATUS_FILE" <<EOF
{
  "status": "crashed",
  "exit_code": -1,
  "prompt_file": "$PROMPT",
  "started_at": "$STARTED",
  "finished_at": "$NOW",
  "duration_seconds": -1,
  "message": "Process $PID no longer running — build may have crashed"
}
EOF
  fi
fi

# --- Count live Claude Code processes ---
CLAUDE_RUNNING="$(ps aux | grep 'native-binary/claude' | grep -v grep | wc -l | tr -d ' ')"

# --- Output enriched status ---
jq --arg running "$CLAUDE_RUNNING" '. + {claude_code_processes: ($running | tonumber)}' "$STATUS_FILE"
