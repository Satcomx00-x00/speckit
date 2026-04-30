---
description: "Check completion status of the current feature against a comprehensive checklist covering documentation, implementation, quality, and git hygiene."
---

You are checking the completion status of the current feature.

## Prerequisites
- Identify current feature from active git branch or `$ARGUMENTS`
- Read all documents in `specs/NNN-feature/`
- Check the codebase for implemented tasks and passing tests

## Checklist

Run each item and report Pass ✅ / Fail ❌ / Not Applicable ⬜.

### Documentation

- [ ] `spec.md` exists
- [ ] `spec.md` has no `[NEEDS CLARIFICATION]` markers
- [ ] `spec.md` has no unvalidated `[ASSUMPTION]` markers
- [ ] `plan.md` exists
- [ ] `tasks.md` exists
- [ ] `data-model.md` exists (required if the feature introduces or modifies data)
- [ ] `contracts/api.md` exists (required if the feature introduces or modifies an API)
- [ ] `research.md` exists

### Implementation

- [ ] All tasks in `tasks.md` are checked off (`- [x]`)
- [ ] No tasks are marked `[BLOCKED]`
- [ ] Test suite passes (`npm test` / `pytest` / `go test ./...` — whichever applies)
- [ ] Linter passes with no errors
- [ ] No hardcoded secrets or credentials in source code (Article IX)
- [ ] No new dependencies added without justification (Article III)

### Quality

- [ ] Every acceptance scenario from `spec.md` is verifiable (manually walkable or automated)
- [ ] All Success Criteria (SC-001...) from `spec.md` are met
- [ ] Constitution principles followed — no violations in Complexity Tracking table (or violations are documented with approval)
- [ ] README updated if user-facing behavior changed

### Git hygiene

- [ ] All implementation is committed (no uncommitted changes)
- [ ] Commit messages follow the convention: `feat(NNN): description`
- [ ] Branch name matches the feature number and name

## Output

Produce a checklist table with pass/fail for each item:

| Category | Item | Status |
|----------|------|--------|
| Documentation | spec.md exists | ✅ |
| ... | ... | ... |

Then:
- **Percentage complete**: X/Y items passing (N%)
- **Blocking items** (must be resolved before done): list each ❌ item
- **Verdict**: ✅ Feature complete and ready for review | ⚠️ Almost done — N items remaining | ❌ Blocked

Feature: $ARGUMENTS (or auto-detect from active branch)
