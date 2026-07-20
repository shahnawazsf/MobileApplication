# Feature: Modal alert for wrong userId/password on login

**Date:** 2026-07-20
**Files:** `app/lib/features/auth/presentation/providers/auth_provider.dart`,
`app/lib/features/auth/presentation/screens/login_screen.dart`
**Affects:** Login screen — what the user sees when the userId/password is
rejected

## Request

Show an alert when the userId/password is wrong, instead of relying on the
easy-to-miss error snackbar every other failure already used.

## Design

Split login failures into two buckets:

- **Wrong userId/password** → modal `AlertDialog` ("Login Failed" / the
  backend's message / OK button) — deliberately blocking, since credential
  mistakes are the case a user is most likely to otherwise miss.
- **Everything else** (network unreachable, server error, etc.) → keeps the
  existing red snackbar, which is less disruptive and appropriate for
  transient failures.

`AuthState` gained an `isCredentialsError` flag; `login_screen.dart`'s
`ref.listen` branches on it to call the new `_showAlert()` instead of
`_showSnack()`.

## A wrong assumption caught during testing

The original code (and its own comments) assumed the backend always
responds `200 OK` with `{success: false, message: ...}` for a rejected
login, and that `AuthRepository.login()`'s direct `throw
ApiException(loginResponse.message)` was therefore the only source of a
credentials error.

Testing against the real backend showed that's wrong — a bad password
actually gets **HTTP 401**, still with a `{success:false, message:...}`
JSON body:

```json
{"success":false,"message":"N","token":null,"userName":"N","userGroupId":"N","userEmpCode":"N","userDesc":"N","status":"FALSE"}
```

Because it's a non-2xx status, Dio raises a `DioException` *before*
`AuthRepository.login()`'s own `LoginResponseModel.fromJson` /
`success` check ever runs — that whole code path is effectively dead for
this endpoint. The error instead flows through `DioClient`'s `onError`
interceptor, which wraps it as `ApiException(message, statusCode: 401)`
inside a new `DioException`.

`AuthNotifier`'s `_describe()` helper now checks for **both** shapes:

```dart
(String message, bool isCredentialsError) _describe(Object e) {
  if (e is ApiException) return (e.message, true);
  if (e is DioException && e.error is ApiException) {
    final api = e.error as ApiException;
    return (api.message, api.statusCode == 401);
  }
  return (e.toString(), false);
}
```

This also fixes a latent display bug from
`docs/fixes/friendly-connection-error-message.md`: previously nothing
unwrapped `DioException.error` before calling `.toString()` on it, so any
network-layer error would render as `DioException [type]: null` followed by
the actual message on a second line, instead of just the clean message.

## Verification

Ran on Chrome web (`flutter run -d chrome --web-port=5001`) against the
real local backend, submitted the login form with a wrong userId/password,
and confirmed:
- Network tab: `POST /api/Auth/login` → `401`.
- A modal "Login Failed" `AlertDialog` appears (scrim + OK button), not the
  snackbar — screenshot confirmed.
