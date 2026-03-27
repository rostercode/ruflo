# Batman Batcave

Portable multi-agent execution engine. Hardened fork of [ruflo](https://github.com/ruvnet/ruflo) — stripped of auto-install, env spreading, and dangerous hooks.

## Prerequisites

- **Node.js** (v18+)
- **jq** (`brew install jq`)
- **Claude Code CLI** (for MCP server mode)

## Setup

1. **Unzip** the batcave to any directory
2. **Edit `batman.config.json`** for your project:
   ```json
   {
     "project": {
       "name": "YourProject",
       "path": "~/path/to/your/project",
       "branch": "your-branch"
     }
   }
   ```
3. **Run**: `./summon-batman.sh --version` to verify

## Configuration

All project-specific values live in **`batman.config.json`**:

| Field | Purpose |
|---|---|
| `project.name` | Display name in startup banner |
| `project.path` | Working directory for bat-signal tasks |
| `project.branch` | Git branch of the locked fork |
| `upstream.repo` | Upstream repo for audit reference |
| `upstream.lockedCommit` | Pinned commit hash (never update without re-audit) |
| `upstream.version` | Human-readable version string |
| `upstream.auditDate` | Date of last security audit |
| `security.blockedEnvPatterns` | Env var patterns blocked from leaking |
| `mcp.serverName` | MCP server name (should match mcp-config.json key) |

## Changing Blocked Env Patterns

Edit `batman.config.json` > `security.blockedEnvPatterns`. Both `bat-signal.sh` and `summon-batman.sh` read from this list at runtime.

```json
"blockedEnvPatterns": [
  "SUPABASE",
  "AWS",
  "OPENAI",
  "DATABASE_URL"
]
```

## Updating the Locked Commit

After a full security audit of a new upstream commit:

1. Update the code in the batcave directory
2. Edit `batman.config.json`:
   ```json
   "upstream": {
     "lockedCommit": "new-hash",
     "version": "new-version",
     "auditDate": "YYYY-MM-DD"
   }
   ```
3. Re-run all Phase 5 audits from the batcave plan

## Usage

```bash
# Check version
./summon-batman.sh --version

# Health check
./summon-batman.sh doctor

# Initialize in project directory
./bat-signal.sh init

# Start swarm daemon
./bat-signal.sh daemon start

# Start as MCP server (for Claude Code integration)
./summon-batman.sh mcp start
```

## Security

- Batman **never** sees env vars matching blocked patterns
- Auto-install is **killed** — no silent npm installs
- Env spreading is **patched** — explicit allowlist only
- PreToolUse hooks are **removed** — no command modification
- MCP config points to **local build**, not npm registry
- Never update upstream without a full re-audit
