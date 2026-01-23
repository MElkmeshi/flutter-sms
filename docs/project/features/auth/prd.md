# PRD: Auth Feature

> **Status**: Draft  
> **Last Updated**: January 2026  
> **Owner**: TBD

---

## Goal

Provide frictionless phone-based authentication with OTP verification.

---

## Non-goals

- Email/password authentication
- Social login (Google, Apple, Facebook)
- Biometric authentication
- Multi-factor authentication (beyond OTP)

---

## User Stories

- [ ] **US-AUTH-001**: As a user, I want to log in or register with my phone number so I can access the app quickly.
- [ ] **US-AUTH-002**: As a user, I want to continue as a guest so I can explore the app without signing up.
- [ ] **US-AUTH-003**: As a user, I want to verify my phone number via OTP so my account is secured.

---

## Screens

### Screen 1: Welcome

Entry point for authentication flow.

| Element | Type | Description |
|---------|------|-------------|
| Login / Register | `FilledButton` | Primary action — navigates to phone entry |
| Continue as Guest | `TextButton` | Secondary action — skips auth, enters app as guest |

**States:**
| State | Description |
|-------|-------------|
| Default | Both buttons enabled |
| Loading | N/A (no async on this screen) |

---

### Screen 2: Phone Entry

User enters their phone number.

| Element | Type | Description |
|---------|------|-------------|
| Phone Number | `TextField` | Phone input with country code picker |
| Login / Register | `FilledButton` | Submits phone number, triggers OTP |

**States:**
| State | Description |
|-------|-------------|
| Default | Empty phone field, button disabled |
| Valid | Phone number valid, button enabled |
| Loading | Submitting, button shows loading indicator |
| Error | Invalid phone or network error, show inline message |

**Validation:**
- **Libyan numbers only**: Must start with `091`, `092`, `093`, `094`, or `095`
- Format: 10 digits total (e.g., `0912345678`)

---

### Screen 3: OTP Verification

User enters 5-digit OTP code sent to their phone.

| Element | Type | Description |
|---------|------|-------------|
| OTP Fields | 5 × `TextField` | Individual digit inputs, auto-advance on entry |
| Confirm | `FilledButton` | Verifies OTP code |
| Retry Countdown | `Text` | Shows remaining time before resend allowed |
| Resend Code | `TextButton` | Visible after countdown, triggers new OTP |

**States:**
| State | Description |
|-------|-------------|
| Default | Empty OTP fields, confirm disabled, countdown active |
| Filled | All 5 digits entered, confirm enabled |
| Loading | Verifying OTP, confirm shows loading |
| Error | Invalid OTP, show error message, clear fields |
| Countdown Active | "Resend in 0:30" — resend button hidden |
| Countdown Complete | Resend button visible and enabled |

**Behavior:**
- Auto-submit when 5th digit entered (optional UX decision)
- Countdown starts at 30 seconds (configurable)
- Max 3 retry attempts before lockout

---

## Flow Diagram

```
┌─────────────────┐
│  Screen 1       │
│  Welcome        │
├─────────────────┤
│ [Login/Register]│──────────────────────────────────┐
│ [Continue Guest]│───► Enter app as guest           │
└─────────────────┘                                  │
                                                     ▼
                                           ┌─────────────────┐
                                           │  Screen 2       │
                                           │  Phone Entry    │
                                           ├─────────────────┤
                                           │ [Phone Number]  │
                                           │ [Login/Register]│
                                           └────────┬────────┘
                                                    │
                                                    ▼
                                           ┌─────────────────┐
                                           │  Screen 3       │
                                           │  OTP Verify     │
                                           ├─────────────────┤
                                           │ [OTP Fields]    │
                                           │ [Confirm]       │
                                           │ [Retry Timer]   │
                                           └────────┬────────┘
                                                    │
                                                    ▼
                                           ┌─────────────┐
                                           │  Home       │
                                           │  Screen     │
                                           └─────────────┘
```

---

## Functional Requirements

### FR-001: Phone Number Submission
- Validate phone format before submission
- Send OTP via SMS to provided number
- Store phone number for session

### FR-002: OTP Verification
- 5-digit numeric code
- Code expires after 5 minutes
- Max 3 verification attempts per code
- Max 5 OTP requests per hour (rate limiting)

### FR-003: Guest Mode
- Allow app access without authentication
- **Guests can ONLY view product listing**
- All other features require authentication
- Persist guest session locally
- Prompt to register for restricted actions

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Network offline | Show offline error, allow retry |
| Invalid phone number | Inline validation error |
| OTP expired | Show "Code expired" error, prompt resend |
| Wrong OTP 3 times | Request new code, show warning |
| Rate limited | Show cooldown message with timer |
| Phone already registered | Proceed as login |
| Guest tries restricted action | Prompt to register |
| App killed during OTP | Return to phone entry on reopen |

---

## Acceptance Criteria

### Screen 1: Welcome
- [ ] Login/Register button navigates to phone entry
- [ ] Continue as Guest enters app with limited access

### Screen 2: Phone Entry
- [ ] Phone field validates format
- [ ] Button disabled until valid phone entered
- [ ] Loading state shown during OTP request
- [ ] Error displayed for invalid phone or network issues

### Screen 3: OTP Verification
- [ ] 5 individual digit fields with auto-advance
- [ ] Confirm button disabled until all digits entered
- [ ] Countdown timer visible (30 seconds)
- [ ] Resend button appears after countdown
- [ ] Error shown for invalid OTP
- [ ] Navigates to Home on success

### General
- [ ] All errors logged to Sentry
- [ ] Analytics events: `auth_started`, `otp_requested`, `otp_verified`, `guest_continued`
- [ ] All strings use localization keys
- [ ] All UI follows Material 3 standards

---

## Resolved Questions

| Question | Answer |
|----------|--------|
| **Guest limitations** | Guests can only view **product listing** — all other features require auth |
| **OTP provider** | Backend API handles OTP — no client-side provider needed |
| **Phone format** | **Libyan numbers only**: `091`, `092`, `093`, `094`, `095` prefixes |

---

## References

- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Auth API Spec](./spec.md) — API endpoints and request/response specs
