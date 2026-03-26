# SENTNL Ruflo Sandbox — Local Config

## Local Build Only
All commands use the local binary at `v3/@claude-flow/cli/bin/cli.js`.
Never use npx or npm registry commands.

## Environment
Only these vars are available in the sandbox:
- ANTHROPIC_API_KEY (from .env.sandbox)
- CLAUDE_FLOW_AUTO_UPDATE=false
- CLAUDE_FLOW_DEBUG=true
- NODE_ENV=development
- PATH, HOME, TMPDIR
