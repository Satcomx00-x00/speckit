# Feature Specification: User Authentication

**Branch**: `001-user-authentication`  
**Date**: 2025-01-15  
**Status**: `APPROVED`  
**Input**: Add user registration, login, logout, and password reset to the API

---

## User Scenarios & Testing

### [US1] [P1] User Registration

**Story**: As a new visitor, I want to create an account with my email and password so that I can access protected features.

**Scenario 1: Successful registration**
- **Given** a visitor is on the registration page with a valid email address not yet in the system
- **When** they submit the form with a valid email and a password meeting complexity requirements
- **Then** their account is created, a verification email is sent, and they see a "Check your email" confirmation page

**Scenario 2: Duplicate email**
- **Given** a visitor attempts to register with an email already in the system
- **When** they submit the registration form
- **Then** they see the error "An account with this email already exists" and the form is not submitted

**Scenario 3: Weak password**
- **Given** a visitor enters a password shorter than 8 characters or without a number
- **When** they submit the registration form
- **Then** they see inline validation: "Password must be at least 8 characters and contain one number"

**Independent Test**: Create a new user via `POST /auth/register` with a unique email — assert HTTP 201, user exists in DB, verification email queued.

---

### [US2] [P1] User Login

**Story**: As a registered user, I want to log in with my email and password so that I can access my account.

**Scenario 1: Successful login**
- **Given** a registered user with a verified email
- **When** they submit valid credentials
- **Then** they receive a signed JWT access token (expires in 15 minutes) and a refresh token (expires in 7 days), and are redirected to the dashboard

**Scenario 2: Invalid credentials**
- **Given** a user submits an incorrect password
- **When** the login form is submitted
- **Then** they see "Invalid email or password" (no hint about which field is wrong) and the failed attempt is logged

**Scenario 3: Unverified email**
- **Given** a registered user who has not verified their email
- **When** they attempt to log in
- **Then** they see "Please verify your email before logging in" with a "Resend verification email" link

**Scenario 4: Account lockout**
- **Given** a user has failed login 5 times in 15 minutes
- **When** they attempt another login
- **Then** they see "Account temporarily locked. Try again in 15 minutes." and no further attempts are processed

**Independent Test**: Register + verify a user, call `POST /auth/login` — assert HTTP 200, response contains `accessToken` and `refreshToken` fields.

---

### [US3] [P1] User Logout

**Story**: As a logged-in user, I want to log out so that my session is invalidated and no one else can use it.

**Scenario 1: Successful logout**
- **Given** a logged-in user with a valid refresh token
- **When** they call the logout endpoint with their refresh token
- **Then** the refresh token is invalidated in the database, the access token cannot be used to refresh, and a 200 response confirms logout

**Scenario 2: Logout invalidates refresh token**
- **Given** a user logs out
- **When** their (now invalidated) refresh token is used to request a new access token
- **Then** the server returns HTTP 401 and the token is rejected

**Independent Test**: Login → logout → attempt token refresh — assert HTTP 401 on refresh.

---

### [US4] [P1] Token Refresh

**Story**: As a logged-in user, I want my access token to be refreshable without re-entering my password so that my session remains active.

**Scenario 1: Successful refresh**
- **Given** a user with a valid, non-expired, non-revoked refresh token
- **When** they call `POST /auth/refresh`
- **Then** they receive a new access token (new 15-minute expiry)

**Scenario 2: Expired refresh token**
- **Given** a user whose refresh token has expired (>7 days)
- **When** they call `POST /auth/refresh`
- **Then** they receive HTTP 401 and must log in again

**Independent Test**: Login → wait for access token to expire (or mock time) → refresh → assert new valid access token returned.

---

### [US5] [P2] Password Reset

**Story**: As a user who forgot their password, I want to reset it via email so that I can regain access to my account.

**Scenario 1: Request password reset**
- **Given** a user provides a registered email address
- **When** they submit the "forgot password" form
- **Then** a password-reset email is sent to that address with a link valid for 1 hour

**Scenario 2: Unknown email**
- **Given** a user submits an unregistered email address
- **When** they submit the form
- **Then** they see the same "Check your email" message (no enumeration of valid emails)

**Scenario 3: Successful password reset**
- **Given** a user clicks a valid reset link
- **When** they submit a new password meeting complexity requirements
- **Then** their password is updated, all existing refresh tokens are revoked, and they are prompted to log in

**Scenario 4: Expired reset link**
- **Given** a user clicks a reset link older than 1 hour
- **When** the link is processed
- **Then** they see "This reset link has expired. Request a new one." and the link is invalidated

**Independent Test**: Request reset for valid email → extract token from queue → use token → assert password updated, old tokens revoked.

---

## Edge Cases

| ID | Edge Case | Expected Behavior |
|----|-----------|-------------------|
| EC-001 | User registers with email containing uppercase letters (e.g., `Test@Example.COM`) | Email is normalized to lowercase before storage and uniqueness check |
| EC-002 | Password contains spaces | Spaces are allowed; password is validated after trimming leading/trailing spaces only |
| EC-003 | Concurrent login requests with same credentials | Both succeed; two independent refresh tokens are issued |
| EC-004 | Password reset token used twice | First use succeeds; second use returns "Token already used" error |
| EC-005 | User account deleted while refresh token is valid | Refresh returns HTTP 401 with "Account not found" |
| EC-006 | Login attempt after account lockout period expires | Lockout counter resets; login proceeds normally |

---

## Functional Requirements

| ID | Requirement | User Story | Priority |
|----|-------------|------------|----------|
| FR-001 | The system shall accept registration with a valid email address and password | US1 | P1 |
| FR-002 | Password must be at least 8 characters and contain at least one number | US1 | P1 |
| FR-003 | The system shall send a verification email after registration | US1 | P1 |
| FR-004 | Email addresses shall be normalized to lowercase before storage | US1 | P1 |
| FR-005 | The system shall reject duplicate email addresses at registration | US1 | P1 |
| FR-006 | Successful login shall return a JWT access token (15-min TTL) and a refresh token (7-day TTL) | US2 | P1 |
| FR-007 | Login error messages shall not distinguish between invalid email and invalid password | US2 | P1 |
| FR-008 | The system shall lock accounts after 5 failed logins within 15 minutes | US2 | P1 |
| FR-009 | Account lockout duration shall be 15 minutes | US2 | P1 |
| FR-010 | Unverified accounts shall not be allowed to log in | US2 | P1 |
| FR-011 | Logout shall invalidate the provided refresh token | US3 | P1 |
| FR-012 | A valid refresh token shall return a new access token | US4 | P1 |
| FR-013 | Password reset emails shall contain a link valid for exactly 1 hour | US5 | P2 |
| FR-014 | A used or expired password reset token shall be rejected | US5 | P2 |
| FR-015 | Password reset shall revoke all existing refresh tokens for the account | US5 | P2 |
| FR-016 | The "forgot password" flow shall not reveal whether an email is registered | US5 | P2 |

---

## Key Entities

| Entity | Description | New or Modified |
|--------|-------------|-----------------|
| User | Represents a registered user account | New |
| Session | Represents an active refresh token | New |
| PasswordResetToken | A one-time-use token for password reset | New |

---

## Success Criteria

| ID | Criterion | Measurement |
|----|-----------|-------------|
| SC-001 | All authentication endpoints respond in under 200ms at p99 | Load test with 100 concurrent users; measure p99 latency |
| SC-002 | Account lockout correctly blocks brute-force attacks | Automated test: 6 failed logins → 7th returns 429 within 15-minute window |
| SC-003 | No password stored in plaintext | Inspect DB: password field is a bcrypt hash (starts with `$2b$`) |
| SC-004 | Expired tokens are rejected | Integration test: use an expired access token → assert HTTP 401 |
| SC-005 | Email enumeration is not possible | Call `/auth/forgot-password` with unknown email → assert same response as known email |
| SC-006 | Test coverage ≥ 90% for all auth module files | Run `npm test -- --coverage`; auth module coverage must be ≥ 90% |

---

## Assumptions

1. The project uses an HTTP/JSON REST API (not GraphQL or gRPC)
2. Email delivery is handled by an external SMTP service; this spec covers queuing the email, not delivery infrastructure
3. The client (web/mobile app) is responsible for storing tokens securely; the API is not responsible for client-side storage
4. There is no social/OAuth login in this spec — that is a separate feature

---

## Out of Scope

- OAuth2 / social login (Google, GitHub, etc.) — separate spec required
- Multi-factor authentication (MFA/TOTP) — separate spec required
- Role-based access control (RBAC) — separate spec required
- Admin user management UI — separate spec required
- Session management UI (list active sessions, revoke individual sessions) — separate spec required
