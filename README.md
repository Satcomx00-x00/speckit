# Speckit — Spec-Driven Development Toolkit

> **Stop vibe-coding. Start spec-coding.**

Speckit is a framework that brings structured, spec-driven development to AI-assisted coding. Instead of prompting AI agents with vague requests and hoping for the best, Speckit gives you a repeatable 5-phase loop: **specify → clarify → plan → tasks → implement** — with each phase producing a durable, reviewable artifact.

Works out-of-the-box with **GitHub Copilot**, **Claude Code**, and any AI agent that supports slash commands.

---

## The Core Flip

| Vibe Coding | Spec-Driven (Speckit) |
|-------------|----------------------|
| "Build me a login system" | Structured spec with user stories, acceptance criteria, and requirements |
| AI guesses what you want | AI asks targeted clarifying questions |
| Undocumented decisions | Every decision is in `specs/NNN/plan.md` |
| Tests added as an afterthought | Tests written before implementation (TDD-enforced) |
| Refactor the whole thing | Incremental phases with checkpoints |
| What did the AI actually do? | Traceable task list with exact file paths |

---

## The 5-Phase Loop

| Phase | Command | Output | Purpose |
|-------|---------|--------|---------|
| **1. Specify** | `/speckit.specify` | `specs/NNN/spec.md` | Translate a feature idea into user stories, acceptance criteria, and functional requirements |
| **2. Clarify** | `/speckit.clarify` | Updated `spec.md` | Resolve every `[NEEDS CLARIFICATION]` before planning begins |
| **3. Plan** | `/speckit.plan` | `research.md`, `data-model.md`, `contracts/`, `plan.md` | Choose approach, check constitution gates, define architecture |
| **4. Tasks** | `/speckit.tasks` | `tasks.md` | Generate an ordered, TDD-compliant task list with exact file paths and parallelism markers |
| **5. Implement** | `/speckit.implement` | Working code, committed by phase | Execute tasks in TDD order; commit after each phase checkpoint |

> **Bonus commands**: `/speckit.constitution` (define project rules), `/speckit.analyze` (quality check), `/speckit.checklist` (completion audit)

---

## Quick Start

### 1. Add Speckit to your project

```bash
# Clone speckit
git clone https://github.com/Satcomx00-x00/speckit.git

# Or use it directly as a template repository on GitHub
```

### 2. Bootstrap your project

```bash
# Bash (macOS/Linux)
bash scripts/init.sh --integration all

# PowerShell (Windows)
.\scripts\init.ps1 -Integration all
```

This creates `.specify/`, installs slash commands for Copilot and Claude, and generates a starter constitution.

### 3. Define your project constitution

```
/speckit.constitution A TypeScript REST API for a SaaS app. Team of 3. Jest for testing. PostgreSQL for storage. GDPR compliance required.
```

### 4. Write your first spec

```
/speckit.specify Add user authentication with email/password login, registration, and password reset
```

### 5. Clarify ambiguities

```
/speckit.clarify
```

### 6. Plan, generate tasks, and implement

```
/speckit.plan
/speckit.tasks
/speckit.implement
```

---

## Directory Structure

```
speckit/
├── .specify/                    # Speckit configuration and templates
│   ├── memory/
│   │   ├── constitution.md      # Your project's non-negotiable rules
│   │   └── context.md           # Auto-generated AI context (run update-context.sh)
│   ├── templates/               # Base templates for all spec documents
│   │   ├── spec-template.md
│   │   ├── plan-template.md
│   │   ├── tasks-template.md
│   │   ├── research-template.md
│   │   └── data-model-template.md
│   ├── extensions/              # Add custom slash commands
│   ├── presets/                 # Pre-configured stacks (rest-api, cli-tool, etc.)
│   ├── overrides/               # Override default templates for your project
│   └── scripts/
│       ├── update-context.sh    # Rebuild AI context (Bash)
│       └── update-context.ps1   # Rebuild AI context (PowerShell)
│
├── .github/
│   └── copilot-instructions.d/  # GitHub Copilot slash commands
│       ├── speckit.constitution.md
│       ├── speckit.specify.md
│       ├── speckit.plan.md
│       ├── speckit.tasks.md
│       ├── speckit.implement.md
│       ├── speckit.clarify.md
│       ├── speckit.analyze.md
│       └── speckit.checklist.md
│
├── .claude/
│   └── commands/                # Claude Code slash commands
│       └── speckit.*.md         # Same 8 commands, Claude format
│
├── specs/                       # One directory per feature
│   └── 000-example/             # Fully filled-in example (auth feature)
│       ├── spec.md
│       ├── plan.md
│       ├── tasks.md
│       ├── research.md
│       ├── data-model.md
│       └── contracts/
│           └── api.md
│
├── scripts/
│   ├── init.sh                  # Bootstrap speckit in a new project (Bash)
│   └── init.ps1                 # Bootstrap speckit in a new project (PowerShell)
│
├── LICENSE
└── README.md
```

---

## The Three Pillars

### 1. Constitution

The `.specify/memory/constitution.md` is your project's law. Nine articles covering:

- **Library-First**: Prefer proven libraries over custom implementations
- **Test-First**: Tests are written before code, always
- **Minimal Dependencies**: Every dep is a liability; justify each one
- **Single Source of Truth**: No duplication of logic or data
- **Explicit Over Implicit**: Readable > clever
- **Documentation as Code**: Decisions live in the repo
- **Simplicity Gate**: ≤3 services, no future-proofing
- **Anti-Abstraction Gate**: Use frameworks directly; one model per entity
- **Security Baseline**: No secrets in code; PII documented; vulnerabilities block merge

AI agents read the constitution before every command, ensuring every generated plan, task list, and implementation respects your rules.

### 2. Specs

Every feature starts as a specification in `specs/NNN-feature-name/`. A spec answers:
- **Who** needs it (user stories with priorities P1/P2/P3)
- **What** they need (Given/When/Then acceptance scenarios)
- **What's measurable** (success criteria)
- **What's excluded** (explicit out-of-scope section)

### 3. Traceability

From spec to code, everything is traceable:

```
spec.md (what)
  → plan.md (how)
    → tasks.md (atomic steps, exact file paths)
      → committed code (by phase)
```

---

## Command Reference

### For GitHub Copilot

| Command | Description |
|---------|-------------|
| `/speckit.constitution` | Create or update the project constitution |
| `/speckit.specify` | Generate a feature spec from a description |
| `/speckit.clarify` | Resolve `[NEEDS CLARIFICATION]` markers in the spec |
| `/speckit.plan` | Create research, data model, contracts, and implementation plan |
| `/speckit.tasks` | Generate an ordered TDD task list from the plan |
| `/speckit.implement` | Execute tasks from tasks.md in TDD order |
| `/speckit.analyze` | Quality-check spec, plan, and tasks against checklist |
| `/speckit.checklist` | Audit completion status of the current feature |

### For Claude Code

Same commands, colon syntax:

| Command | Description |
|---------|-------------|
| `/speckit:constitution` | Create or update the project constitution |
| `/speckit:specify` | Generate a feature spec from a description |
| `/speckit:clarify` | Resolve ambiguities in the spec |
| `/speckit:plan` | Create full implementation plan |
| `/speckit:tasks` | Generate TDD task list |
| `/speckit:implement` | Execute implementation tasks |
| `/speckit:analyze` | Quality check |
| `/speckit:checklist` | Completion audit |

All commands accept `$ARGUMENTS` for context. Example:
```
/speckit.specify Add a shopping cart that supports multiple currencies and tax calculation
```

---

## Customization

### Overrides

Replace any default template without modifying core files:

```bash
cp .specify/templates/spec-template.md .specify/overrides/spec-template.md
# Edit to your liking
```

The AI agents check `.specify/overrides/` before `.specify/templates/`.

See [`.specify/overrides/README.md`](.specify/overrides/README.md) for details.

### Extensions

Add custom slash commands specific to your project:

```bash
# Create .specify/extensions/my-command.md
# Copy to .github/copilot-instructions.d/ or .claude/commands/
```

See [`.specify/extensions/README.md`](.specify/extensions/README.md) for details.

### Presets

Pre-configured stacks for common project types:

```bash
bash scripts/init.sh --preset rest-api
```

See [`.specify/presets/README.md`](.specify/presets/README.md) for available presets and how to create your own.

---

## Why It Matters: Spec-Coding vs Vibe-Coding

**Vibe-coding** is prompting AI agents without a structured process. It produces code fast — but the code often misses requirements, lacks tests, ignores edge cases, and accumulates technical debt.

**Spec-coding** front-loads clarity. By the time an AI agent writes a line of code, it has:

1. ✅ Read the user stories and acceptance criteria
2. ✅ Resolved all ambiguities
3. ✅ Checked architectural constraints against the constitution
4. ✅ Defined the data model and API contracts
5. ✅ Generated an ordered, TDD-compliant task list

The result: code that **actually meets requirements**, has **tests from day one**, and leaves a **paper trail of every decision**.

---

## Example: See It In Action

The `specs/000-example/` directory contains a complete, filled-in example for a user authentication feature:

- [`spec.md`](specs/000-example/spec.md) — 5 user stories, 16 functional requirements, 6 success criteria
- [`plan.md`](specs/000-example/plan.md) — constitution check, project structure decision, architecture choices
- [`tasks.md`](specs/000-example/tasks.md) — 45 tasks across 7 phases with TDD ordering and parallel markers
- [`research.md`](specs/000-example/research.md) — JWT library, password hashing, and token strategy comparisons
- [`data-model.md`](specs/000-example/data-model.md) — User, Session, and PasswordResetToken with full SQL schema
- [`contracts/api.md`](specs/000-example/contracts/api.md) — Complete REST API contracts for 7 auth endpoints

---

## License

[MIT](LICENSE) — Copyright (c) 2025 Satcomx00-x00
