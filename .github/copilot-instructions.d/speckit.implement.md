You are executing the implementation tasks for a feature.

## Prerequisites
- Identify the current feature from the active git branch or `$ARGUMENTS`
- **Required**: `specs/NNN-feature/tasks.md`
- **Required**: `specs/NNN-feature/plan.md`
- Read `specs/NNN-feature/spec.md` — for acceptance criteria
- Read `specs/NNN-feature/data-model.md` — if it exists
- Read `specs/NNN-feature/contracts/` — if it exists
- Read `.specify/memory/constitution.md` — for architectural rules

## Your task
Execute tasks from tasks.md in order, respecting all dependencies and TDD rules.

### Execution Rules

1. **Work task by task**: Complete T001, verify it's done, then T002, etc.
2. **Respect `[P]` groups**: When you reach a group of `[P]` tasks, you may execute them together. They are parallel-safe (different files, no shared state).
3. **TDD — tests first**:
   - When a test task (e.g., T015) precedes an implementation task (T016):
     1. Write the test → run it → **confirm it FAILS** (red)
     2. Write the implementation → run the test → **confirm it PASSES** (green)
     3. Refactor if needed → confirm it still PASSES
   - Never write implementation before its test task is complete
4. **Commit after each phase**: When a phase checkpoint is reached and all phase tests pass:
   ```
   git add -A
   git commit -m "feat(NNN): complete Phase X — description"
   ```
5. **Checkpoint validation**: At each phase checkpoint, verify the user story works end-to-end before starting the next phase
6. **Never skip tasks**: Do not mark a task `[x]` without completing it. If blocked, note the blocker in the task and stop.
7. **Update tasks.md**: Change `- [ ]` to `- [x]` as each task is completed

### Constitution compliance
While implementing, verify:
- No new dependencies added without justification (Article III)
- No abstractions added that aren't in the plan (Article VIII)
- No PII handled without the data model's guidance (Article IX)
- Tests written before implementation (Article II)

### Completion Criteria
A task is complete when:
- Code is written per the task description
- Tests pass (if task has associated tests)
- The change is committed

## Output
- Progress update as each phase completes (e.g., "✅ Phase 1 complete: 7 tasks done")
- Phase checkpoint summaries: which acceptance scenario(s) now pass
- Final summary: all tasks completed, all tests green, feature working end-to-end

Focus on: $ARGUMENTS (or all tasks if empty)
