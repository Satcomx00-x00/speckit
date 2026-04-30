# Task List: [FEATURE_NAME]

**Feature**: [NNN-kebab-case-name]  
**Date**: [YYYY-MM-DD]  
**Spec**: [specs/NNN-feature/spec.md](./spec.md)  
**Plan**: [specs/NNN-feature/plan.md](./plan.md)

---

## Format Legend

```
- [ ] TXXX [P?] [USN?] Description — exact/path/to/file.ext
         │     │   │
         │     │   └── User story reference (US1, US2, ...)
         │     └────── [P] = can run in parallel with other [P] tasks
         └──────────── Task ID (sequential)
```

- `[P]` — parallel-safe: this task touches different files than other `[P]` tasks in the same group
- `[US1]` — maps to User Story 1 from `spec.md`
- Tasks without `[P]` are sequential; complete them in order

---

## Dependencies

```
Phase 1 (Setup) → Phase 2 (Foundational) → Phase 3 (US1) → Phase 4 (US2) → Phase N (Polish)
                                                ↗
                                          Phase 3b (US1 tests) runs parallel with Phase 3a
```

---

## Phase 1: Setup

> Create project structure and install dependencies. No business logic yet.

- [ ] T001 [P] Setup project directory structure — [project root]
- [ ] T002 [P] Initialize package manager / dependency file — [package.json | pyproject.toml | go.mod]
- [ ] T003 [P] Install runtime dependencies — [dependency list]
- [ ] T004 [P] Install dev/test dependencies — [dev dependency list]
- [ ] T005 Configure test runner — [jest.config.ts | pytest.ini | etc.]
- [ ] T006 Configure linter and formatter — [.eslintrc | .ruff.toml | etc.]
- [ ] T007 Create entry point file — [src/index.ts | main.py | main.go]

---

## Phase 2: Foundational

> Implement the building blocks that all user stories depend on. No UI or endpoints yet.

- [ ] T008 Write schema/type definitions for [EntityName] — [src/models/entity.ts]
- [ ] T009 Write schema/type definitions for [EntityName] — [src/models/entity2.ts]
- [ ] T010 [P] Create database migration / schema file — [db/schema.sql | migrations/001_init.sql]
- [ ] T011 [P] Write tests for [utility function] — [tests/utility.test.ts]
- [ ] T012 Implement [utility function] — verify T011 FAILS first — [src/utils/utility.ts]
- [ ] T013 [P] Write tests for [data access layer] — [tests/db.test.ts]
- [ ] T014 Implement [data access layer] — verify T013 FAILS first — [src/db/repository.ts]

**Phase 2 Checkpoint**: [Utility and data layer tests pass. No endpoints yet.]

---

## Phase 3: [US1 Title] (P1)

> Implement User Story 1 end-to-end.

- [ ] T015 [P] [US1] Write unit tests for [US1 business logic] — [tests/feature.test.ts]
- [ ] T016 [P] [US1] Write integration tests for [US1 endpoint/flow] — [tests/feature.integration.test.ts]
- [ ] T017 [US1] Implement [US1 business logic] — verify T015 FAILS first — [src/feature/service.ts]
- [ ] T018 [US1] Implement [US1 endpoint / entry point] — verify T016 FAILS first — [src/feature/controller.ts]
- [ ] T019 [P] [US1] Write tests for [US1 edge case EC-001] — [tests/feature-edge.test.ts]
- [ ] T020 [US1] Handle edge case EC-001 in [module] — verify T019 FAILS first — [src/feature/service.ts]

**Phase 3 Checkpoint**: [US1 acceptance scenario passes. Edge cases handled.]

---

## Phase 4: [US2 Title] (P1)

> Implement User Story 2 end-to-end.

- [ ] T021 [P] [US2] Write unit tests for [US2 business logic] — [tests/feature2.test.ts]
- [ ] T022 [US2] Implement [US2 business logic] — verify T021 FAILS first — [src/feature2/service.ts]
- [ ] T023 [US2] Implement [US2 endpoint / entry point] — [src/feature2/controller.ts]

**Phase 4 Checkpoint**: [US2 acceptance scenario passes.]

---

## Phase 5: [US3 Title] (P2)

> Implement User Story 3 end-to-end.

- [ ] T024 [P] [US3] Write tests for [US3 flow] — [tests/feature3.test.ts]
- [ ] T025 [US3] Implement [US3 flow] — verify T024 FAILS first — [src/feature3/handler.ts]

**Phase 5 Checkpoint**: [US3 acceptance scenario passes.]

---

## Final Phase: Polish & Cross-Cutting

> Non-functional requirements, documentation, cleanup.

- [ ] T026 [P] Add input validation for all endpoints/inputs — [src/middleware/validate.ts]
- [ ] T027 [P] Add error handling and error messages — [src/middleware/errors.ts]
- [ ] T028 [P] Update README with usage instructions — [README.md]
- [ ] T029 [P] Update API documentation — [specs/NNN-feature/contracts/api.md]
- [ ] T030 Run full test suite — verify all tests pass
- [ ] T031 Run linter — fix all errors and warnings
- [ ] T032 Final manual walkthrough of all acceptance scenarios in spec.md

**Final Checkpoint**: ✅ All tasks checked, all tests pass, all acceptance scenarios verified.

---

## Parallel Execution Guide

> For teams or AI agents that can work in parallel.

### Group A (Phase 1 — all parallel-safe)
```
T001, T002, T003, T004 can all run simultaneously
```

### Group B (Phase 2 — some parallel)
```
T008, T009 → T010, T011, T013 in parallel → T012 (needs T011), T014 (needs T013)
```

### Group C (Phase 3+4 after foundational complete)
```
T015, T016, T019, T021 can be written in parallel (all are test files)
Then implement in order: T017→T018→T020, T022→T023
```

---

## Implementation Strategy

### MVP First
Complete all P1 user stories (Phase 3, Phase 4) before starting P2 stories (Phase 5).

### Incremental Delivery
Each phase produces working, tested code. No half-finished phases.

### Parallel Team
Assign phases to different engineers/agents. Each phase is independently mergeable once its checkpoint passes.
