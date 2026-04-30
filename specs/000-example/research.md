# Research: Authentication Libraries and Approach

**Feature**: `001-user-authentication`  
**Date**: 2025-01-15  
**Author**: AI Agent (speckit.plan)  
**Decision Status**: `DECIDED`

---

## Problem Statement

We need to implement stateless JWT-based authentication with refresh tokens, password hashing, and email verification for a Node.js/TypeScript REST API. The constitution requires minimal dependencies and using well-maintained libraries (Articles I and III). We need to decide on:

1. JWT library
2. Password hashing library
3. Token storage strategy (stateful vs stateless refresh tokens)

---

## Decision 1: JWT Library

### Option 1: `jsonwebtoken`

**Description**: The original and most widely used JWT library in the Node.js ecosystem. Synchronous and async signing/verification.

**Pros**:
- 65M+ weekly npm downloads; battle-tested
- Simple, intuitive API
- Strong community and security record
- TypeScript types via `@types/jsonwebtoken`

**Cons**:
- Not a native ES module (CommonJS)
- Slightly older API design
- Algorithm selection must be explicit

**Fit with constitution**:
- Library-First: ✅ Well-maintained, widely adopted
- Minimal Dependencies: ✅ Single package + types
- Simplicity Gate: ✅ Simple API, no abstraction needed

**Sample usage**:
```typescript
import jwt from 'jsonwebtoken';
const token = jwt.sign({ userId: '123' }, process.env.JWT_SECRET!, { expiresIn: '15m' });
const payload = jwt.verify(token, process.env.JWT_SECRET!) as { userId: string };
```

---

### Option 2: `jose`

**Description**: Modern JavaScript JWT library compliant with the full JOSE spec (JWS, JWE, JWK, JWKS). ESM-first.

**Pros**:
- ESM-native, Web Crypto API compatible
- Supports all modern algorithms including EdDSA
- Works in browser/edge runtimes

**Cons**:
- More complex API for simple use cases
- Overkill for a server-only app not using asymmetric JWK sets
- Steeper learning curve

**Fit with constitution**:
- Library-First: ✅
- Minimal Dependencies: ✅
- Simplicity Gate: ⚠️ More complex than needed for this scope

---

## Decision 1: Recommendation

**Chosen**: Option 1 — `jsonwebtoken`

**Rationale**: Our use case is straightforward server-side signing with a shared secret. `jsonwebtoken` is the right level of complexity. `jose` would be warranted if we needed asymmetric keys or edge runtime support — both are out of scope (Article VII: no future-proofing).

**Trade-offs accepted**: CommonJS module; acceptable since our build tool handles it.

---

## Decision 2: Password Hashing

### Option 1: `bcryptjs`

**Description**: Pure JavaScript bcrypt implementation. No native bindings.

**Pros**:
- No native compilation needed (no node-gyp issues)
- Works on all platforms without additional setup
- Well-understood algorithm; cost factor is configurable
- 12M+ weekly downloads

**Cons**:
- Slower than native bcrypt (~15% in benchmarks at cost factor 12)
- Pure JS means no WebAssembly acceleration

**Sample usage**:
```typescript
import bcrypt from 'bcryptjs';
const hash = await bcrypt.hash(password, 12);
const valid = await bcrypt.compare(password, hash);
```

---

### Option 2: `argon2`

**Description**: Winner of the Password Hashing Competition. Modern, more memory-hard than bcrypt.

**Pros**:
- More resistant to GPU cracking than bcrypt
- Recommended by OWASP for new systems

**Cons**:
- Requires native compilation (node-gyp); complicates CI/CD and Docker setup
- Higher memory usage per hash (by design)
- Less common in Node.js ecosystem, fewer resources

---

## Decision 2: Recommendation

**Chosen**: Option 1 — `bcryptjs`

**Rationale**: For a <10k DAU app with cost factor 12, bcryptjs provides sufficient security without native compilation complexity. The constraint "must run without Docker for local dev" (Technical Context) makes native bindings a liability. At scale, bcrypt with cost 12 handles ~5 hashes/second/CPU core — sufficient for expected signup volume.

**Trade-offs accepted**: Slightly weaker than argon2 against GPU attacks; acceptable given the scale and operational constraints. Document in constitution as a known trade-off (Article IX).

---

## Decision 3: Refresh Token Strategy

### Option 1: Stateful refresh tokens (DB-backed)

**Description**: Refresh tokens are random values stored (as hashes) in the database. Lookup on each refresh request.

**Pros**:
- Tokens can be revoked immediately (logout invalidates server-side)
- Enables "log out all devices" feature
- Supports token rotation (issue new refresh on each use)

**Cons**:
- One DB read per token refresh
- More complex to implement

---

### Option 2: Stateless refresh tokens (signed JWT)

**Description**: Refresh tokens are signed JWTs with embedded claims. No server-side state.

**Pros**:
- No DB lookup on refresh
- Simpler to implement

**Cons**:
- Cannot be revoked before expiry (logout doesn't truly invalidate)
- Logout is "client-side only" — server still honors the token
- US3 (logout invalidates session) and US5 (reset revokes all sessions) become impossible to implement correctly

---

## Decision 3: Recommendation

**Chosen**: Option 1 — Stateful refresh tokens

**Rationale**: The spec explicitly requires logout to invalidate the refresh token (US3, FR-011) and password reset to revoke all sessions (US5, FR-015). These requirements are impossible to satisfy correctly with stateless tokens. Stateless tokens would be a spec violation.

**Trade-offs accepted**: One DB read per token refresh (~1ms for SQLite). Acceptable given the performance goal of <200ms p99.

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| bcrypt timing differences leak valid emails | Low | High | Use constant-time comparison; always hash even when user not found |
| JWT secret accidentally committed to source control | Medium | Critical | Use env vars only; add `.env` to `.gitignore`; add secret scanning in CI |
| Refresh token database table grows unbounded | Medium | Low | Add a background job to delete expired sessions (out of scope for this spec) |
| bcryptjs performance degrades under load | Low | Medium | Monitor p99 latency; if hit, switch to argon2 or increase workers |

---

## Implementation Notes

- Set bcrypt cost factor via environment variable `BCRYPT_ROUNDS` (default: 12) so it can be lowered in test environments for speed
- JWT signing algorithm must be explicitly set to `HS256` — never rely on library defaults
- Never log email addresses or tokens — treat them as PII per Article IX
- Store refresh tokens as `bcrypt.hash(token, 10)` — use lower cost factor (10) since these aren't passwords and are high-volume
- Implement a `constant-time` email existence check at login to prevent timing attacks
