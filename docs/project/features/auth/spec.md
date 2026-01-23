# API Spec: Auth Feature

> **Source**: Extracted from `/docs/api.md`  
> **Last Updated**: January 2026

---

## Server Info

| Environment | URL                           |
|-------------|-------------------------------|
| Development | `https://nazaka-dev.ethaq.ly/` |
| Production | TBD                           |

---

## OTP Endpoints

### Send OTP SMS

Sends an OTP code via SMS to the customer's phone number.

```http
POST /api/v1/otp/requests
```

**Request Body:**

| Field | Validation | Type | Example |
|-------|------------|------|---------|
| `phone_number` | `required` | `numeric` | `0912345678` |

**Phone Format (Libyan Only):**
- Must start with: `091`, `092`, `093`, `094`, or `095`
- Total digits: 10
- Example: `0912345678`

**Response:** Returns an `OtpUuid` needed for verification.

---

### Verify OTP

Verifies the OTP code sent to the customer.

```http
POST /api/v1/otp/requests/{OtpUuid}/verify
```

**Path Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `OtpUuid` | `uuid` | UUID returned from Send OTP request |

**Request Body:**

| Field | Validation | Type | Example |
|-------|------------|------|---------|
| `device_token` | `required` | `string` | `"FCM_TOKEN_123ABC"` |
| `device_name` | `required` | `string` | `"iPhone 15 Pro"` |
| `code` | `required` | `string` | `"12345"` |

**Response:** Returns auth token.

**Notes:**
- Store the returned Bearer token for authenticated requests

---

### Logout

Logs out the current user and invalidates the session.

```http
POST /api/v1/logout
Authorization: Bearer <token>
```

**Request Body:** None

---

## Auth Flow Mapping

| Screen | API Endpoint(s) |
|--------|-----------------|
| Phone Entry | `POST /api/v1/otp/requests` |
| OTP Verify | `POST /api/v1/otp/requests/{uuid}/verify` |
| Logout | `POST /api/v1/logout` |

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `200` | Success | Proceed |
| `401` | Unauthorized | Redirect to login |
| `422` | Validation Error | Show field errors |
| `429` | Rate Limited | Show cooldown message |
| `500` | Server Error | Log to Sentry, show generic error |

---

## References

- [Full API Documentation](/docs/api.md)
- [Auth PRD](./prd.md)
- [🔐 Authentication Architecture](/docs/architecture/authentication.md) - **MANDATORY** token storage & performance rules

