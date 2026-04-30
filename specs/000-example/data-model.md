# Data Model: User Authentication

**Feature**: `001-user-authentication`  
**Date**: 2025-01-15  
**Spec**: [specs/000-example/spec.md](./spec.md)

---

## Entities

### users

**Description**: Represents a registered user account. This is the canonical identity record for the application.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `TEXT (UUID v4)` | ✅ | Primary key; generated at insert |
| `email` | `TEXT` | ✅ | Normalized to lowercase before storage; used as login identifier |
| `password_hash` | `TEXT` | ✅ | bcrypt hash of the user's password (cost factor 12) |
| `verified` | `INTEGER (0/1)` | ✅ | Whether the email has been verified; default `0` |
| `verification_token` | `TEXT` | ❌ | One-time token sent in verification email; null after verification |
| `verification_token_expires_at` | `TEXT (ISO 8601)` | ❌ | Expiry timestamp for verification token; null after verification |
| `failed_attempts` | `INTEGER` | ✅ | Count of consecutive failed login attempts; default `0`; reset on successful login |
| `locked_until` | `TEXT (ISO 8601)` | ❌ | Timestamp until which account is locked; null if not locked |
| `created_at` | `TEXT (ISO 8601)` | ✅ | UTC timestamp of account creation |
| `updated_at` | `TEXT (ISO 8601)` | ✅ | UTC timestamp of last modification |

**PII Fields**: `email` _(stored normalized; never logged; subject to deletion on account closure per Article IX)_

**Indexes**:
- Primary: `id`
- Unique: `email` _(enforces no duplicate accounts)_

---

### sessions

**Description**: Represents an active refresh token issued to a user. Enables server-side revocation on logout.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `TEXT (UUID v4)` | ✅ | Primary key |
| `user_id` | `TEXT (UUID v4)` | ✅ | FK → `users.id`; the user this session belongs to |
| `refresh_token_hash` | `TEXT` | ✅ | bcrypt hash of the refresh token value (cost factor 10) |
| `expires_at` | `TEXT (ISO 8601)` | ✅ | When this refresh token expires (7 days from creation) |
| `revoked` | `INTEGER (0/1)` | ✅ | Whether this token has been explicitly revoked; default `0` |
| `created_at` | `TEXT (ISO 8601)` | ✅ | UTC timestamp of session creation |

**PII Fields**: _None — refresh_token_hash is a hash of a random value, not user data_

**Indexes**:
- Primary: `id`
- FK Index: `user_id` _(for "revoke all sessions for user" queries)_
- Index: `expires_at` _(for cleanup queries)_

---

### password_reset_tokens

**Description**: A single-use token that authorizes a password reset. Generated on "forgot password" requests.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `TEXT (UUID v4)` | ✅ | Primary key |
| `user_id` | `TEXT (UUID v4)` | ✅ | FK → `users.id` |
| `token_hash` | `TEXT` | ✅ | SHA-256 hash of the reset token sent in the email |
| `expires_at` | `TEXT (ISO 8601)` | ✅ | When this token expires (1 hour from creation) |
| `used` | `INTEGER (0/1)` | ✅ | Whether this token has been used; default `0` |
| `created_at` | `TEXT (ISO 8601)` | ✅ | UTC timestamp of token creation |

**PII Fields**: _None — token_hash is a hash of a random value_

**Indexes**:
- Primary: `id`
- FK Index: `user_id`
- Index: `expires_at` _(for cleanup queries)_

---

## Relationships

```
users ──< sessions
  one-to-many: one user can have many active sessions (multiple devices)

users ──< password_reset_tokens
  one-to-many: one user can have multiple reset tokens (but only one valid at a time)
```

| From | To | Type | Description |
|------|----|------|-------------|
| `users` | `sessions` | one-to-many | A user may be logged in from multiple devices simultaneously |
| `users` | `password_reset_tokens` | one-to-many | A user may request multiple resets; old ones expire |

---

## Constraints

| Constraint | Entity | Rule |
|------------|--------|------|
| Unique email | `users` | `email` must be unique across all rows |
| Non-null password | `users` | `password_hash` cannot be null or empty |
| Valid lockout | `users` | `locked_until` must be a valid ISO 8601 timestamp or null |
| Referential integrity | `sessions` | `user_id` must reference an existing `users.id` |
| Cascade delete | `sessions` | Deleted when parent user is deleted |
| Referential integrity | `password_reset_tokens` | `user_id` must reference an existing `users.id` |
| Cascade delete | `password_reset_tokens` | Deleted when parent user is deleted |
| No reuse | `password_reset_tokens` | A token with `used = 1` must never be accepted |

---

## Storage Notes

| Property | Value |
|----------|-------|
| Storage engine | SQLite (dev/test via `better-sqlite3`) |
| Schema location | `src/db/schema.sql` |
| Migration tool | Manual SQL migrations in `src/db/migrations/` |

---

## SQL Schema

```sql
CREATE TABLE IF NOT EXISTS users (
  id                              TEXT PRIMARY KEY,
  email                           TEXT NOT NULL UNIQUE,
  password_hash                   TEXT NOT NULL,
  verified                        INTEGER NOT NULL DEFAULT 0,
  verification_token              TEXT,
  verification_token_expires_at   TEXT,
  failed_attempts                 INTEGER NOT NULL DEFAULT 0,
  locked_until                    TEXT,
  created_at                      TEXT NOT NULL,
  updated_at                      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  id                  TEXT PRIMARY KEY,
  user_id             TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  refresh_token_hash  TEXT NOT NULL,
  expires_at          TEXT NOT NULL,
  revoked             INTEGER NOT NULL DEFAULT 0,
  created_at          TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_sessions_user_id   ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_expires_at ON sessions(expires_at);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id          TEXT PRIMARY KEY,
  user_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash  TEXT NOT NULL,
  expires_at  TEXT NOT NULL,
  used        INTEGER NOT NULL DEFAULT 0,
  created_at  TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_prt_user_id   ON password_reset_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_prt_expires_at ON password_reset_tokens(expires_at);
```

---

## Migration Notes

### New Installation
1. Run `node scripts/migrate.js` or execute `src/db/schema.sql` directly
2. No seed data required for auth module

### Upgrading from Previous Version
N/A — this is the initial version of the auth module.

**Breaking changes**: None (initial schema)

**Rollback**: Drop all three tables and their indexes.
