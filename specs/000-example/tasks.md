# Task List: User Authentication

**Feature**: `001-user-authentication`  
**Date**: 2025-01-15  
**Spec**: [specs/000-example/spec.md](./spec.md)  
**Plan**: [specs/000-example/plan.md](./plan.md)

---

## Format Legend

```
- [ ] TXXX [P?] [USN?] Description — exact/path/to/file.ext
```

- `[P]` = parallel-safe (different files, no shared deps)
- `[US1]` = maps to User Story 1 (registration)
- `[US2]` = maps to User Story 2 (login)
- `[US3]` = maps to User Story 3 (logout)
- `[US4]` = maps to User Story 4 (token refresh)
- `[US5]` = maps to User Story 5 (password reset)

---

## Phase 1: Setup

- [x] T001 [P] Initialize Node.js project with TypeScript — `package.json`, `tsconfig.json`
- [x] T002 [P] Install runtime dependencies: express, better-sqlite3, jsonwebtoken, bcryptjs, nodemailer, zod — `package.json`
- [x] T003 [P] Install dev dependencies: jest, ts-jest, supertest, @types/* — `package.json`
- [x] T004 [P] Configure Jest — `jest.config.ts`
- [x] T005 Configure ESLint and Prettier — `.eslintrc.json`, `.prettierrc`
- [x] T006 Create Express app entry point — `src/app.ts`, `src/index.ts`
- [x] T007 Create database schema file — `src/db/schema.sql`

**Phase 1 Checkpoint**: `npm run build` succeeds; `npm test` runs (0 tests, 0 failures).

---

## Phase 2: Foundational

- [x] T008 [P] Write tests for db connection module — `tests/db/db.test.ts`
- [x] T009 [P] Implement SQLite database connection singleton — verify T008 FAILS first — `src/db/db.ts`
- [x] T010 [P] Write tests for JWT token helpers (sign + verify) — `tests/shared/token.test.ts`
- [x] T011 [P] Implement JWT sign/verify helpers — verify T010 FAILS first — `src/shared/token.ts`
- [x] T012 [P] Write tests for custom error classes — `tests/shared/errors.test.ts`
- [x] T013 Implement custom error classes (NotFoundError, UnauthorizedError, ConflictError, ValidationError) — verify T012 FAILS first — `src/shared/errors.ts`
- [x] T014 Implement test database helpers (setup, teardown, seed) — `tests/helpers/db.ts`, `tests/helpers/fixtures.ts`
- [x] T015 Define Zod schemas for all auth request/response shapes — `src/auth/auth.schema.ts`

**Phase 2 Checkpoint**: All foundational tests pass. No business logic implemented yet.

---

## Phase 3: Registration (US1, P1)

- [x] T016 [P] [US1] Write unit tests for registration service (happy path, duplicate email, weak password) — `tests/auth/register.test.ts`
- [x] T017 [P] [US1] Write integration tests for `POST /auth/register` — `tests/auth/register.integration.test.ts`
- [x] T018 [US1] Implement registration service (hash password, normalize email, insert user, queue verification email) — verify T016 FAILS first — `src/auth/auth.service.ts`
- [x] T019 [US1] Implement `POST /auth/register` route handler — verify T017 FAILS first — `src/auth/auth.controller.ts`
- [x] T020 [US1] Implement email verification endpoint `POST /auth/verify-email` — `src/auth/auth.controller.ts`

**Phase 3 Checkpoint**: `POST /auth/register` returns HTTP 201; duplicate email returns 409; weak password returns 422. Verification email is queued.

---

## Phase 4: Login (US2, P1)

- [x] T021 [P] [US2] Write unit tests for login service (valid creds, invalid creds, unverified account, lockout) — `tests/auth/login.test.ts`
- [x] T022 [P] [US2] Write integration tests for `POST /auth/login` — `tests/auth/login.integration.test.ts`
- [x] T023 [US2] Implement login service (verify email+password, check verification, check lockout, issue tokens) — verify T021 FAILS first — `src/auth/auth.service.ts`
- [x] T024 [US2] Implement `POST /auth/login` route handler — verify T022 FAILS first — `src/auth/auth.controller.ts`
- [x] T025 [US2] Implement account lockout logic (increment failed_attempts, set locked_until) — `src/auth/auth.service.ts`

**Phase 4 Checkpoint**: Login returns JWT access + refresh tokens; 5th failed attempt triggers lockout; unverified accounts are rejected.

---

## Phase 5: Logout & Token Refresh (US3 + US4, P1)

- [x] T026 [P] [US3] Write tests for logout (valid token, already-revoked token) — `tests/auth/logout.test.ts`
- [x] T027 [P] [US4] Write tests for token refresh (valid refresh, expired refresh, revoked refresh) — `tests/auth/refresh.test.ts`
- [x] T028 [US3] Implement logout service (revoke refresh token in DB) — verify T026 FAILS first — `src/auth/auth.service.ts`
- [x] T029 [US3] Implement `POST /auth/logout` route handler — `src/auth/auth.controller.ts`
- [x] T030 [US4] Implement token refresh service (validate refresh token, issue new access token) — verify T027 FAILS first — `src/auth/auth.service.ts`
- [x] T031 [US4] Implement `POST /auth/refresh` route handler — `src/auth/auth.controller.ts`

**Phase 5 Checkpoint**: Logout invalidates refresh token; subsequent refresh with revoked token returns 401.

---

## Phase 6: Password Reset (US5, P2)

- [ ] T032 [P] [US5] Write tests for password reset request (known email, unknown email) — `tests/auth/password-reset.test.ts`
- [ ] T033 [P] [US5] Write tests for password reset completion (valid token, expired token, used token) — `tests/auth/password-reset.test.ts`
- [ ] T034 [US5] Implement forgot-password service (generate reset token, queue email, no email enumeration) — verify T032 FAILS first — `src/auth/auth.service.ts`
- [ ] T035 [US5] Implement `POST /auth/forgot-password` route handler — `src/auth/auth.controller.ts`
- [ ] T036 [US5] Implement reset-password service (validate token, update password hash, revoke all sessions) — verify T033 FAILS first — `src/auth/auth.service.ts`
- [ ] T037 [US5] Implement `POST /auth/reset-password` route handler — `src/auth/auth.controller.ts`

**Phase 6 Checkpoint**: Password reset flow works end-to-end; old sessions revoked after reset; expired tokens rejected.

---

## Final Phase: Polish & Cross-Cutting

- [ ] T038 [P] Implement request validation middleware (Zod schemas on all auth routes) — `src/auth/auth.middleware.ts`
- [ ] T039 [P] Implement global error handler (maps custom errors to HTTP status codes) — `src/shared/errors.ts`, `src/app.ts`
- [ ] T040 [P] Add rate limiting to `POST /auth/login` (max 20 req/min per IP) — `src/auth/auth.middleware.ts`
- [ ] T041 [P] Update README with auth API usage — `README.md`
- [ ] T042 Run full test suite — verify all tests pass: `npm test`
- [ ] T043 Run coverage check — verify auth module ≥ 90%: `npm test -- --coverage`
- [ ] T044 Run linter — fix all errors: `npm run lint`
- [ ] T045 Final walkthrough of all acceptance scenarios in spec.md

**Final Checkpoint**: ✅ All 45 tasks checked, all tests pass at ≥90% coverage, linter clean, all acceptance scenarios verified.

---

## Parallel Execution Guide

### Group A (Phase 1, all parallel)
T001, T002, T003, T004 can run simultaneously.

### Group B (Phase 2, some parallel)
T008 + T010 + T012 in parallel → T009 (needs T008), T011 (needs T010), T013 (needs T012) → T014, T015

### Group C (Phases 3–6 test files, all parallel)
T016, T017, T021, T022, T026, T027, T032, T033 can all be written simultaneously — they're all test files.

### Implementation order within each phase
Must be sequential within phase: tests first, then implementation.

---

## Implementation Strategy

**MVP First**: Complete Phases 1–5 (P1 stories: register, login, logout, refresh) before Phase 6 (password reset, P2).

**Incremental Delivery**: Each phase produces working, committed, tested code. Deploy-ready after Phase 5.

**TDD strictly enforced**: Every implementation task references the test task that must fail first.
