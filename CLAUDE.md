# SENTNL PROJECT

## Identity
Product: **Sentnl** — your personal agentic trading team on your wrist.
Tagline: "Most traders can't afford a risk manager, a trading psychologist, a discipline coach, and a data analyst. Sentnl puts the whole team on your finger."

## Development Environment — Roles & Enforcement
| Role | Tool | Responsibility |
|---|---|---|
| **Brain / Planner** | Cowork (Claude Desktop) | Architecture, specs, task lists, coordination, research, prompts |
| **Design** | Google Stitch + Gemini Pro | UI generation, 3D renders, component design, visual mockups |
| **Engineering** | VS Code + Claude Code (via DC skill) | Code writing, building, testing, debugging, deployments |
| **Multi-Agent** | Batman (sandboxed, via Bat-Signal bridge) | Parallel task execution, dispatching bats (3+ concurrent subtasks) |
| **Database** | Supabase (project: cbchopwkezenraebmmwd) | Postgres DB, Auth, RLS, Edge Functions |
| **Local Dev** | Docker Desktop + Supabase CLI | Local Supabase instance, migrations |
### WORKFLOW ENFORCEMENT — HARD HOOK (PERMANENT)

These rules are absolute. They govern every session. They prevent workflow drift.

**THE FLOW: Cowork → Stitch → Cowork → VS Code**
1. Cowork writes the spec or prompt
2. Google Stitch / Gemini Pro generates the design (when visual work is involved)
3. Cowork adapts output (swap colors for SENTNL tokens, plan architecture, finalize build prompt)
4. DC skill launches build prompt in VS Code terminal (VISIBLE by default — user watches Claude Code work live)
5. VS Code builds → Cowork audits the result

**COWORK DOES NOT WRITE CODE.**
Cowork plans, specs, researches, and produces prompts. All code execution goes through the DC skill to VS Code. The DC skill defaults to VISIBLE mode — it opens a VS Code terminal and runs Claude Code interactively so the user sees it working. Headless mode (`-p` flag) is only used when the user explicitly requests background execution. If Cowork is about to write >10 lines of code (.tsx, .ts, .py, .css), STOP — use the DC skill instead. The only exception is small config edits, CLAUDE.md updates, and prompt files.

**DESIGN IS NOT HAND-CODED.**
New screens, layouts, and major visual changes go through Google Stitch / Gemini Pro first. Cowork adapts the output. VS Code builds production components from the adapted designs. The only exception is small tweaks (<5 CSS properties) to existing components. Never hand-code a full page layout from scratch — generate it first.

**BATMAN FOR PARALLEL ENGINEERING.**
When a task has 3+ independent subtasks that can run concurrently, dispatch bats via the Bat-Signal bridge to the Batcave (VS Code). Single-file or sequential tasks go direct to VS Code via DC. Batman runs in its sandboxed clean room — it never sees Supabase, Telegram, OpenAI, Google, or Stripe keys.

**VIOLATION DETECTION:**
If Cowork is doing any of these, it's a workflow violation — stop and correct:
- Writing .tsx/.ts/.py/.css files directly → use DC skill
- Hand-coding CSS layouts from scratch → use Stitch first
- Running npm/node/python build commands → use DC skill (except audit/verify commands)
- Producing files >20 lines of code → send to VS Code
- Designing UI without generating in Stitch first → use Stitch
- Running DC skill in headless mode without user requesting it → use visible mode
## The Agent Team
| Agent | Job |
|---|---|
| Body Agent | Ring monitors HR, HRV, sleep, stress, SpO2 24/7 |
| Read Agent | Daily reads — customizable market brief + news |
| Signal Agent | Customizable trade signals — paste any Pine Script |
| Grade Agent | Weekly performance grades A through F |
| Pattern Agent | Best time of day and best trade types from history |
| Health Agent | Full health dashboard with 30-day trends |
| AI Agent | Personalized recommendations synthesizing all data |
| Discipline Agent | Enforces protocol — no trade without body clearance |
| Journal Agent | Logs everything automatically via Obsidian vault |

## Ring Hardware — Quick Reference
Ring: **R11_7307** | MAC: `31:32:46:36:73:07` | Chip: RTL8762ESF (Realtek) | Firmware: RT11_1.00.31_250825
QRing app holds EXCLUSIVE BLE connection. **Always control ring through QRing app via CLI harness. Never bypass with direct BLE.**
CLI: `python3 code/agents/qring_cli.py status` (instant check) | `all` (full dump) | `sync` (trigger sync)
Full details → `claude-system/skills/ring-hardware/SKILL.md` and `claude-system/skills/ble-protocol/SKILL.md`

## Build Status
| Track | Status | Details |
|---|---|---|
| T2 — BLE Reverse Engineering | **7/7 tasks complete** | All code built, compiles clean, CLI harness tested live |
| T1 — PWA Web App | **In progress** | Login page + particles, ring-scene 3D dashboard, home page rendering |
## Hard Rules
- PWA only. No app stores. No React Native.
- Ring chip: RTL8762ESF (Realtek). Never flash SR08 firmware.
- 30% marketplace cut via Stripe Connect.
- Never tell supplier about trading system.
- No AMOVAN branding in buyer materials.
- Track A (data pipeline) ships first.
- All secrets from .env only. Never display secrets in chat.
- **Always control the ring through QRing app via CLI harness. Never bypass the app with direct BLE.**

## Skills — Read On-Demand (NOT every session)
| Skill | Path | When to Read |
|---|---|---|
| **design** | `claude-system/skills/design/SKILL.md` | Any visual/UI work |
| **design-system** | `claude-system/skills/design-system/SKILL.md` | Colors, Tailwind tokens |
| **supabase-schema** | `claude-system/skills/supabase-schema/SKILL.md` | Database, RLS, client setup |
| **marketplace** | `claude-system/skills/marketplace/SKILL.md` | Stripe Connect, creator dashboard |
| **ble-protocol** | `claude-system/skills/ble-protocol/SKILL.md` | BLE work, GATT services, packet format |
| **ring-hardware** | `claude-system/skills/ring-hardware/SKILL.md` | Hardware constraints, QRing app, CLI harness |
| **body-agent** | `claude-system/skills/body-agent/SKILL.md` | Readiness engine, thresholds |
| **reverse-engineering** | `claude-system/skills/reverse-engineering/SKILL.md` | RE methodology, QRing SQLite schema |
## Key References
- `business/TraderRing_Marketplace_Expansion_1.pdf` — Full platform thesis + revenue model
- `business/SENTNL PLATFORM UPDATE.pdf` — Product rebrand + agent architecture
- `claude-system/references/trader-ring-platform.md` — Condensed platform reference
- `docs/MISTAKES.md` — Logged mistakes and rules to prevent repeats
- `docs/BATMAN_BATCAVE_PLAN.md` — Batman Batcave architecture + security audit

## Installed Tools
- **Python 3.12** — `/opt/homebrew/bin/python3.12` (bleak 2.1.1 for BLE work)
- **Supabase CLI** — v2.78.1, linked to project cbchopwkezenraebmmwd
- **Docker Desktop** — Local Supabase dev environment
- **VS Code** — v1.112.0, CLI at `/opt/homebrew/bin/code`
- **Node.js / npm** — For Next.js PWA development
- **Google Stitch MCP** — v0.5.1 (`/opt/homebrew/bin/stitch-mcp`), API key authed
- **Gemini CLI** — v0.34.0 (`/opt/homebrew/bin/gemini`)
- **Google GenAI Python** — google-genai v1.47.0
- **Batman** — `~/Desktop/batcave/bat-signal.sh` (sandboxed multi-agent, see `docs/BATMAN_BATCAVE_PLAN.md`)

## Batman (The Batcave) — Summary
Batman (claude-flow v3.5.42) — forked, locked, stripped, hardened for SENTNL. Dispatches bats for parallel task execution via the Bat-Signal bridge to the Batcave (VS Code).
- Fork: `rostercode/ruflo` branch `sentnl-sandbox`, locked to commit `0590bf2`
- Clean room: 5 env vars only (HOME, PATH, NODE_ENV, CLAUDE_FLOW_AUTO_UPDATE, CLAUDE_FLOW_DEBUG)
- Bat-Signal blocks: SUPABASE, TELEGRAM, OPENAI, GOOGLE, STRIPE keys
- Full audit details → `docs/BATMAN_BATCAVE_PLAN.md` and `docs/Batman_Security_Audit_2026-03-25.pdf`
## Critical Failure Pattern — READ PROJECT FIRST
When switching contexts (design → BLE, frontend → backend), read relevant folders, skills, and existing code FIRST. Never rediscover what's documented. Never assume raw BLE when QRing app holds connection. Never suggest polling intervals without justifying why. When the user says "read the project" — STOP and read immediately.
Full writeup → `docs/MISTAKES.md`

---

## ABSOLUTE LAW: Prompt Delivery Format
**When you write a prompt for JX, you MUST paste the full prompt text directly into the chat in copy-paste-ready format. ALWAYS. No exceptions. File save is the backup — chat output is the delivery.**