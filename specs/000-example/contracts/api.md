# API Contracts: User Authentication

**Feature**: `001-user-authentication`  
**Date**: 2025-01-15  
**Base URL**: `/auth`  
**Content-Type**: `application/json`

---

## Endpoints

### `POST /auth/register`

Create a new user account.

**Request**
```json
{
  "email": "user@example.com",
  "password": "securepass1"
}
```

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `email` | `string` | ✅ | Valid email format; max 254 chars |
| `password` | `string` | ✅ | Min 8 chars; must contain at least one digit |

**Response — 201 Created**
```json
{
  "message": "Account created. Check your email to verify your address."
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 409 Conflict | `EMAIL_TAKEN` | An account with this email already exists |
| 422 Unprocessable | `VALIDATION_ERROR` | Request body fails validation; `errors` array included |

```json
{
  "error": "EMAIL_TAKEN",
  "message": "An account with this email already exists"
}
```

---

### `POST /auth/verify-email`

Verify a user's email address using the token sent in the verification email.

**Request**
```json
{
  "token": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response — 200 OK**
```json
{
  "message": "Email verified successfully. You can now log in."
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 400 Bad Request | `INVALID_TOKEN` | Token not found or already used |
| 410 Gone | `TOKEN_EXPIRED` | Verification token has expired (>24 hours) |

---

### `POST /auth/login`

Authenticate a user and issue tokens.

**Request**
```json
{
  "email": "user@example.com",
  "password": "securepass1"
}
```

**Response — 200 OK**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
  "refreshToken": "a3f5b2c1-...",
  "expiresIn": 900
}
```

| Field | Type | Description |
|-------|------|-------------|
| `accessToken` | `string` | Signed JWT; valid for 15 minutes (900 seconds) |
| `refreshToken` | `string` | Opaque random token; valid for 7 days |
| `expiresIn` | `number` | Access token lifetime in seconds |

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 401 Unauthorized | `INVALID_CREDENTIALS` | Email or password is incorrect (do not distinguish) |
| 403 Forbidden | `EMAIL_NOT_VERIFIED` | Account exists but email is not verified |
| 429 Too Many Requests | `ACCOUNT_LOCKED` | Account is temporarily locked due to failed attempts |

```json
{
  "error": "ACCOUNT_LOCKED",
  "message": "Account temporarily locked. Try again in 15 minutes.",
  "retryAfter": "2025-01-15T10:30:00Z"
}
```

---

### `POST /auth/logout`

Revoke a refresh token. The access token expires naturally (15 min max).

**Request**
```json
{
  "refreshToken": "a3f5b2c1-..."
}
```

**Response — 200 OK**
```json
{
  "message": "Logged out successfully."
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 401 Unauthorized | `INVALID_TOKEN` | Refresh token not found or already revoked |

---

### `POST /auth/refresh`

Issue a new access token using a valid refresh token.

**Request**
```json
{
  "refreshToken": "a3f5b2c1-..."
}
```

**Response — 200 OK**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
  "expiresIn": 900
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 401 Unauthorized | `INVALID_TOKEN` | Refresh token not found, revoked, or expired |

---

### `POST /auth/forgot-password`

Request a password reset email.

> ⚠️ This endpoint always returns 200 to prevent email enumeration (FR-016).

**Request**
```json
{
  "email": "user@example.com"
}
```

**Response — 200 OK** _(always, regardless of whether email is registered)_
```json
{
  "message": "If that email is registered, a password reset link has been sent."
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 422 Unprocessable | `VALIDATION_ERROR` | `email` field missing or not a valid email format |
| 429 Too Many Requests | `RATE_LIMITED` | Too many reset requests for this IP |

---

### `POST /auth/reset-password`

Apply a new password using a valid reset token.

**Request**
```json
{
  "token": "secure-reset-token-value",
  "newPassword": "newSecurePass2"
}
```

**Response — 200 OK**
```json
{
  "message": "Password updated successfully. Please log in with your new password."
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 400 Bad Request | `INVALID_TOKEN` | Token not found or already used |
| 410 Gone | `TOKEN_EXPIRED` | Reset token has expired (>1 hour) |
| 422 Unprocessable | `VALIDATION_ERROR` | New password fails validation |

---

## Authentication

Protected endpoints (future features) use the access token as a Bearer token:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

The auth middleware returns:

| Status | Code | Description |
|--------|------|-------------|
| 401 Unauthorized | `MISSING_TOKEN` | Authorization header absent |
| 401 Unauthorized | `INVALID_TOKEN` | Token malformed or signature invalid |
| 401 Unauthorized | `TOKEN_EXPIRED` | Access token has expired |

---

## Common Error Shape

All error responses follow this shape:

```json
{
  "error": "ERROR_CODE",
  "message": "Human-readable description",
  "errors": [
    { "field": "email", "message": "Invalid email format" }
  ]
}
```

`errors` array is only present for `VALIDATION_ERROR` responses.
