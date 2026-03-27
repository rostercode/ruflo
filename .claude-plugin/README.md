# Batman Batcave Plugin

Hardened, sandboxed fork of claude-flow v3.5.42. Project-specific config in batman.config.json.

## Rules
- This plugin runs ONLY the local build at `v3/@claude-flow/cli/bin/cli.js`
- NEVER use `npx`, `npm install`, or any npm registry command
- NEVER auto-install packages
- NEVER enable PreToolUse, SessionStart, SessionEnd, or Stop hooks
- Only PostToolUse echo logging is permitted
- Blocked env patterns configured via batman.config.json

## MCP Server
Single local MCP server — no npm registry, no remote servers:
```json
{
  "ruflo-sandbox": {
    "command": "node",
    "args": ["v3/@claude-flow/cli/bin/cli.js", "mcp", "start"]
  }
}
```

## Security Patches (6 applied)
1. Auto-install killed
2. Env spreading killed (3 files)
3. PreToolUse hooks removed
4. Stop hook removed

## License
MIT — forked from github.com/ruvnet/claude-flow
