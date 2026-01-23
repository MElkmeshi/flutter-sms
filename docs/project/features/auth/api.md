# Auth API

> Authentication endpoints for OTP and logout.

---

## Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/otp/requests` | Send OTP SMS | No |
| POST | `/api/v1/otp/requests/{uuid}/verify` | Verify OTP | No |
| POST | `/api/v1/logout` | Logout user | Yes |

---

## Send OTP SMS

Sends an OTP code to the customer's phone number.

```http
POST /api/v1/otp/requests
```

### Request Body

| Field | Type | Validation | Example |
|-------|------|------------|---------|
| `phone_number` | `string` | Required, numeric | `"0910000000"` |

### Response

Returns OTP request UUID for verification.

---

## Verify OTP

Verifies the OTP code sent to the customer.

```http
POST /api/v1/otp/requests/{OtpUuid}/verify
```

### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `OtpUuid` | `string` | UUID from Send OTP response |

### Request Body

| Field | Type | Validation | Example |
|-------|------|------------|---------|
| `device_token` | `string` | Required | `"123ABC"` |
| `device_name` | `string` | Required | `"iPhone 7"` |
| `code` | `string` | Required | `"11111"` |

### Response

Returns authentication token on success.

---

## Logout

Logs out the current user and invalidates their token.

```http
POST /api/v1/logout
Authorization: Bearer <token>
```

---

## Dart Implementation

```dart
// lib/api/endpoints.dart
static const String otpRequest = '/api/v1/otp/requests';
static String otpVerify(String uuid) => '/api/v1/otp/requests/$uuid/verify';
static const String logout = '/api/v1/logout';
```

```dart
// feature/auth/data/auth_api.dart
class AuthApi {
  const AuthApi(this._dio);
  final Dio _dio;

  Future<OtpResponse> sendOtp(String phoneNumber) async {
    final response = await _dio.post(
      Endpoints.otpRequest,
      data: {'phone_number': phoneNumber},
    );
    return OtpResponse.fromJson(response.data);
  }

  Future<AuthResponse> verifyOtp({
    required String otpUuid,
    required String code,
    required String deviceToken,
    required String deviceName,
  }) async {
    final response = await _dio.post(
      Endpoints.otpVerify(otpUuid),
      data: {
        'code': code,
        'device_token': deviceToken,
        'device_name': deviceName,
      },
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post(Endpoints.logout);
  }
}
```
