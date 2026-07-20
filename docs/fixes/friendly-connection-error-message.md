# Fix: Raw Dio/XHR error text shown to the user on connection failure

**Date:** 2026-07-20
**File:** `app/lib/core/network/dio_client.dart`
**Affects:** Any screen that surfaces `ApiException.message` on a failed API
call (currently the login screen's error snackbar)

## Symptom

When the API is unreachable (backend down, wrong host/port, no network),
the user saw the raw Dio/browser error text instead of a helpful message,
e.g. on web:

```
DioException [unknown]: null
Error: The connection errored: The XMLHttpRequest onError callback was called.
This typically indicates an error on the network layer. This indicates an
error which most likely cannot be solved by the library.
```

or on a native platform, the equivalent raw `SocketException` message.

## Root cause

`DioClient`'s error interceptor built the message shown to the user as:

```dart
final message = e.response?.data?['message'] ?? e.message ?? 'Network error';
```

For connection-level failures there is no `e.response` (the request never
got a reply), so it fell through to `e.message` — Dio's own diagnostic
string, written for developers debugging the HTTP layer, not for an app
user.

## Fix

Added a `_messageFor(DioException e)` helper in `dio_client.dart` that
checks `e.type` first. For the connection-related exception types —
`connectionError`, `connectionTimeout`, `sendTimeout`, `receiveTimeout` —
it now returns a fixed, friendly message instead of `e.message`:

```dart
case DioExceptionType.connectionError:
case DioExceptionType.connectionTimeout:
case DioExceptionType.sendTimeout:
case DioExceptionType.receiveTimeout:
  return 'Unable to connect. Please check your internet connection and try again.';
```

Everything else (a real HTTP response, e.g. 4xx/5xx, or `badResponse`)
keeps using the backend's own `message` field when present, exactly as
before — this only changes the case where the request never reached a
server at all.

## Verification

- `flutter analyze lib/core/network/dio_client.dart` — no issues.
- The fix targets `DioExceptionType.connectionError` specifically because
  that is the exact exception type observed earlier in this session's
  manual testing, when the login screen showed the raw
  `DioException [unknown]: null ... XMLHttpRequest onError callback...`
  text against an unreachable backend (see
  `docs/fixes/web-cors-port-mismatch.md`) — this change replaces that exact
  message with the friendly one.
- While building the follow-up fix in
  `docs/fixes/wrong-credentials-alert-dialog.md`, live testing against the
  real backend surfaced a second bug this fix alone didn't cover: nothing
  ever unwrapped `DioException.error` before calling `.toString()` on it,
  so *any* network-layer error — including this friendly message — would
  have rendered as `DioException [type]: null` followed by the real message
  on a second line. That's now fixed in `AuthNotifier._describe()`
  alongside the credentials-error work, confirmed via a live 401 response
  showing the clean, unwrapped message with no `DioException [...]` prefix.
  The `connectionError` (fully-unreachable-backend) case specifically still
  hasn't been re-triggered end-to-end since that fix, but it goes through
  the exact same unwrap path that's now confirmed working.
