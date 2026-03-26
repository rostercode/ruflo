# SENTNL Ruflo Sandbox — LOCKED

This is a hardened, sandboxed fork of claude-flow v3.5.42.
All upstream agent skills, plugins, auto-install, and npm registry references have been removed.

## Rules (Permanent)
- This sandbox runs ONLY the local build at `v3/@claude-flow/cli/bin/cli.js`
- NEVER use `npx claude-flow@alpha` or any npm registry command
- NEVER auto-install packages
- NEVER reference or use API keys other than ANTHROPIC_API_KEY
- NEVER spawn agents outside the ruflo-test-project directory
- NEVER run hooks that intercept commands or files
- All coordination is directed by Cowork (Claude Desktop) via bridge.sh

## Available Commands (local build only)
```bash
./bridge.sh --version
./bridge.sh doctor
./bridge.sh daemon start --foreground
./bridge.sh task run --spec /path/to/spec.md
```

## Security
- 6 patches applied (auto-install killed, env spreading killed x3, hooks stripped x2)
- Clean-room env: only 8 vars visible (ANTHROPIC_API_KEY, PATH, HOME, TMPDIR, NODE_ENV, CLAUDE_FLOW_*)
- Zero access to: Supabase, Telegram, OpenAI, Google, Stripe, Pinata, or any financial keys
