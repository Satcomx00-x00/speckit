---
description: "Generate an executable, ordered task list from the current feature's plan. Produces specs/NNN-feature/tasks.md with TDD-ordered tasks and parallelism markers."
---

You are generating an executable task list from an implementation plan.

## Prerequisites
- Identify the current feature: find `specs/NNN-*/plan.md` (most recent or from active git branch)
- **Required**: `specs/NNN-feature/plan.md`
- **Required**: `specs/NNN-feature/spec.md`
- Optional: `specs/NNN-feature/data-model.md`
- Optional: `specs/NNN-feature/contracts/`
- Optional: `specs/NNN-feature/research.md`
- Read `.specify/templates/tasks-template.md` for task format (or `.specify/overrides/tasks-template.md` if it exists)

## Your task
Generate an atomic, ordered, executable task list:

1. **Read all inputs** listed in prerequisites above
2. **Map user stories** from spec.md: identify all US1, US2, US3... by priority (P1 → P2 → P3)
3. **Create phases**:
   - **Phase 1: Setup** — project structure, dependency files, config (no business logic)
   - **Phase 2: Foundational** — data access layer, shared utilities, schemas (all user stories depend on this)
   - **Phase 3+: One phase per user story** — named after the story, P1 stories first
   - **Final Phase: Polish** — input validation, error handling, documentation, full test run
4. **Mark parallelism**:
   - `[P]` = this task can run in parallel with other `[P]` tasks in the same group (touches different files, no shared dependency)
   - `[USN]` = this task maps to User Story N from spec.md
5. **Include exact file paths** in every task description (e.g., `src/auth/service.ts`, not just "service file")
6. **Write tests FIRST** — for every implementation task, a corresponding test task must appear before it
   - Test task: `- [ ] TXXX [P] [USN] Write tests for X — tests/x.test.ts`
   - Impl task: `- [ ] TXXX [USN] Implement X — verify TXXX FAILS first — src/x.ts`

## Task format
```
- [ ] TXXX [P?] [USN?] Description with exact/path/to/file.ext
```
- Tasks are numbered sequentially from T001
- `[P]` is optional (omit if task has dependencies or ordering requirements)
- `[USN]` is optional (omit for setup/polish tasks)

## Phase checkpoint format
At the end of each phase, add:
```
**Phase N Checkpoint**: [What must be true before proceeding: tests that pass, behavior that works]
```

## Save to
`specs/NNN-feature/tasks.md`

## Output
- Confirmation that `specs/NNN-feature/tasks.md` was written
- Task count by phase
- Total tasks: X (Y parallel-safe, Z sequential)
- Next command: `/speckit:implement`
