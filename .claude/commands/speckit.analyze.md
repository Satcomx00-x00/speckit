---
description: "Analyze the quality of the current feature's spec, plan, and tasks. Reports pass/fail for each quality checklist item with specific fix recommendations."
---

You are performing a quality analysis of the specification and plan documents.

## Prerequisites
- Identify the feature: use `$ARGUMENTS` if provided, otherwise auto-detect from the most recently modified spec
- Read `specs/NNN-feature/spec.md`
- Read `specs/NNN-feature/plan.md` — if it exists
- Read `specs/NNN-feature/tasks.md` — if it exists
- Read `.specify/memory/constitution.md`

## Analysis

Run each checklist section and report Pass ✅ / Fail ❌ / Not Applicable ⬜ for each item.

### Specification Quality

- [ ] **All user stories independently testable** — each story can be tested without other stories being complete
- [ ] **All requirements specific and measurable** — no vague language ("fast", "easy", "good")
- [ ] **No `[NEEDS CLARIFICATION]` markers remain** — all ambiguities resolved
- [ ] **No `[ASSUMPTION]` markers remain unvalidated**
- [ ] **Success criteria are measurable** — each SC has a concrete measurement method
- [ ] **Edge cases documented** — at least 3 edge cases in the edge case table
- [ ] **Out of Scope section present** — explicitly lists what is excluded
- [ ] **All FR-* requirements map to a user story**

### Plan Quality (if plan.md exists)

- [ ] **Constitution Simplicity Gate passed** — ≤3 services, no future-proofing, no speculative abstractions
- [ ] **Constitution Anti-Abstraction Gate passed** — framework used directly, single model per entity
- [ ] **All FR-* requirements addressed** in the plan's implementation phases
- [ ] **Technology choices are justified** — research.md exists or decisions are explained inline
- [ ] **Project structure selected and justified** (Option 1/2/3)
- [ ] **Complexity violations documented** in Complexity Tracking table (if any)
- [ ] **Open questions listed** in the Open Questions table

### Task Quality (if tasks.md exists)

- [ ] **All plan phases represented** — Setup, Foundational, one phase per user story, Polish
- [ ] **Every task has an exact file path** — no "create the service file" without a path
- [ ] **TDD order respected** — test tasks precede implementation tasks
- [ ] **Phase checkpoints defined** — each phase ends with a checkpoint describing what must pass
- [ ] **Parallelism correctly identified** — `[P]` tasks touch different files and have no shared deps
- [ ] **Tasks cover all FR-* requirements** — trace each functional requirement to at least one task

## Output

For each checklist section, output a table:

| Item | Status | Issue (if failed) |
|------|--------|-------------------|
| All user stories independently testable | ✅ | — |
| ... | ❌ | FR-003 says "should perform well" — not measurable |

Then:
- **Summary**: X/Y checks passed
- **Issues list**: For each ❌, include file + line reference and specific fix recommended
- **Verdict**: ✅ Ready for next phase | ⚠️ Fix issues before proceeding | ❌ Blocked

Feature: $ARGUMENTS (or auto-detect)
