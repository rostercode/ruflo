# SENTNL — VS Code Execution Context

## Role
You are the execution layer for the SENTNL project. You handle BOTH tracks — the PWA web app (T1) and the BLE reverse engineering (T2).

### System Roles (Know Your Lane)
| Role | Tool | What It Does |
|---|---|---|
| **Brain / Planner** | Cowork (Claude Desktop) | Architecture, specs, task lists, prompts — NEVER writes code. Sends build prompts via DC skill (visible in VS Code terminal by default) |
| **Design** | Google Stitch + Gemini Pro | UI generation, 3D renders, component mockups — generates visuals |
| **Engineering** | VS Code + Claude Code (YOU) | Code writing, building, testing, debugging — executes build prompts |
| **Multi-Agent** | Batman (sandboxed, via Bat-Signal bridge) | Dispatching bats for parallel execution when 3+ concurrent subtasks |

**You (VS Code) receive build prompts from Cowork via the DC skill, which launches them visibly in your terminal. You execute them. You do not plan or design.**
When you receive a design-related task, the design should already have been generated in Google Stitch. Your job is to convert the adapted design into production Next.js components. If no design was provided for a major visual change, flag it — don't hand-code layouts from scratch.

## Before ANY Task
Read these files FIRST — every session, no exceptions:
1. `CLAUDE.md` (project root) — Identity, agents, architecture, rules
2. `claude-system/CLAUDE.md` — Global operating instructions
3. `docs/architecture.md` — System architecture, build phases, revenue model
4. `claude-system/references/trader-ring-platform.md` — Full platform reference

## Skills — Read On-Demand BEFORE Each Task
| Skill | Path | When to Read |
|---|---|---|
| **design** | `claude-system/skills/design/SKILL.md` | Any visual/UI work (Apple TV aesthetic, colors, layout) |
| **supabase-schema** | `claude-system/skills/supabase-schema/SKILL.md` | Database, RLS, client setup |
| **marketplace** | `claude-system/skills/marketplace/SKILL.md` | Stripe Connect, creator dashboard |
| **ble-protocol** | `claude-system/skills/ble-protocol/SKILL.md` | BLE work, GATT services, packet format, commands |
| **ring-hardware** | `claude-system/skills/ring-hardware/SKILL.md` | Hardware constraints, QRing app, CLI harness, SQLite schema |
| **body-agent** | `claude-system/skills/body-agent/SKILL.md` | Readiness engine, thresholds |
| **reverse-engineering** | `claude-system/skills/reverse-engineering/SKILL.md` | RE methodology, QRing SQLite schema, discovery safety |

If a skill contradicts research docs, the skill wins — skills are more recent.

## Hard Rules
- PWA ONLY. No React Native. No app stores. No Expo. No Capacitor. Ever.
- Stack: Next.js 16+ (App Router, Turbopack), TypeScript, Tailwind CSS, Supabase
- Ring chip: RTL8762ESF (Realtek). NEVER flash SR08 firmware. Different chip = brick.
- BLE via Web Bluetooth API in browser. Python bleak for local testing only.
- All secrets from .env only. Never hardcode keys. Never display secrets in output.
- No AMOVAN branding in buyer-facing materials.
- 30% marketplace cut via Stripe Connect. Never change the split.
- **Always control ring through QRing app via CLI harness. Never bypass with direct BLE.**
- Settings.json DENIES: curl, wget, npx -y, pip install -e. Do NOT use these.
- Next.js project already scaffolded at `code/web-app/`. Do NOT re-init or npm install.

## Environment
- Python: `/opt/homebrew/bin/python3.12` (bleak already installed — do NOT pip install it)
- Node: v25.8.1 / npm 11.11.0
- Supabase CLI: v2.78.1, linked to project cbchopwkezenraebmmwd
- Docker: v29.2.1

## Project Paths
- Root: `~/Desktop/SENTNL PROJECT/`
- Web app: `~/Desktop/SENTNL PROJECT/code/web-app/`
- Agent code: `~/Desktop/SENTNL PROJECT/code/agents/`
- Research: `~/Desktop/SENTNL PROJECT/SmartRing_ReverseEngineering/`

## Design Language
Full spec in `claude-system/skills/design/SKILL.md` — READ IT before any visual work.

**Design workflow:** Google Stitch generates → Cowork adapts → VS Code builds production code.
Do NOT hand-code full page layouts from scratch. If no Stitch design was provided, flag it.

Quick reference (Apple TV aesthetic):
- BG: #1C1C1E | Cards: #2C2C2E | Borders: #3A3A3C | Text: #F5F5F7 | Muted: #8E8E93
- Accents: Green #6EC89B | Yellow #D4A843 | Red #E8736C
- No shadows. No light mode. No gradients on cards. Dark theme throughout.
- Font: Oxygen (Google Fonts), 300/400/700 weights
- Stitch exports: adapt colors to SENTNL tokens, convert to TSX, wire Zustand + Supabase

## Ring — Quick Reference
Ring: R11_7307 | MAC: 31:32:46:36:73:07 | Firmware: RT11_1.00.31_250825
QRing app holds EXCLUSIVE BLE connection. CLI: `python3 code/agents/qring_cli.py status`
Full details → `claude-system/skills/ring-hardware/SKILL.md` and `claude-system/skills/ble-protocol/SKILL.md`

## Critical Rule — READ PROJECT BEFORE DOING ANYTHING
When switching contexts, read relevant folders, skills, and existing code FIRST. Never rediscover what's documented. Never assume raw BLE when QRing holds connection. When the user says "read the project" — STOP and read immediately.

---

## ABSOLUTE LAW: Prompt Delivery Format
**When you write a prompt for JX (Google Stitch, VS Code, Claude Code, any AI tool, any purpose), you MUST paste the full prompt text directly into the chat in copy-paste-ready format. No exceptions.**

Rules:
1. NEVER just give a file path and say "it's there" — always output the full text in chat
2. Write the prompt to file AND paste it in the conversation
3. The chat output is the primary delivery — the file is the backup
4. This applies to: design prompts, build prompts, clone prompts, system prompts, any prompt
5. If the prompt is longer than 500 lines, break it into clearly labeled parts
6. This rule is GLOBAL — it applies in every session, every project, every context

**Violation of this rule = failed delivery.**

---

## Reference Repos (read research docs, do NOT clone)
1. github.com/tahnok/colmi_r02_client — Python BLE client (primary)
2. github.com/qlam-ai/qring — Protocol docs
3. github.com/ringverse/protocol — Deep RE
4. codeberg.org/Freeyourgadget/Gadgetbridge — Java (PR #3896 QRing)
5. github.com/atc1441/ATC_SR08_Ring — Display ref ONLY (never flash)
