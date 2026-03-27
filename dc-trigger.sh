#!/bin/bash
# DC Trigger — write a prompt path to the trigger file
# Usage: dc-trigger <prompt-file>
# Example: dc-trigger prompts/build-log-system.md
#
# Cowork calls this via Desktop Commander to fire builds
# into the dc-watch watcher running in VS Code terminal.

if [ -z "$1" ]; then
  echo "Usage: dc-trigger <prompt-file>"
  echo "Example: dc-trigger prompts/build-log-system.md"
  exit 1
fi

echo "$1" > "$HOME/.dc-trigger"
echo "Trigger fired: $1"
