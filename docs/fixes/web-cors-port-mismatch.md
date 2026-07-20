# Fix: Login failed on web with a generic network error (wrong `--web-port`)

**Date:** 2026-07-19
**Files:** none (run configuration only — no code changed)
**Affects:** `flutter run -d chrome` / `-d edge`, any web run against the
local backend

## Symptom

Running the app in Chrome via `flutter run -d chrome --web-port=8765`
(an arbitrary port) and attempting to log in produced:

```
DioException [unknown]: null
Error: The connection errored: The XMLHttpRequest onError callback was called.
This typically indicates an error on the network layer.
```

Chrome DevTools network tab showed the request actually reaching the
backend — `OPTIONS /api/Auth/login` returned `204`, `POST /api/Auth/login`
got a real response — but the browser still blocked the response from
reaching the app's JavaScript.

## Root cause

The local backend's CORS policy allowlists exactly one origin,
`http://localhost:5001` (see `docs/DEVELOPER_GUIDE.md` §"Backend base URL" /
"`--web-port` is pinned..."). `flutter run -d chrome` picks a **random**
free port unless `--web-port` is passed explicitly, so any origin other
than `http://localhost:5001` gets its response blocked by the browser's CORS
enforcement — which Dio surfaces as an opaque "network layer" error rather
than a CORS-specific one.

## Fix

Always launch the web target on the pinned port:

```powershell
flutter run -d chrome --web-port=5001
```

If port 5001 is ever unavailable, either free it (a stale process can hold
it — check with `netstat -ano | grep :5001` and stop the offending PID) or
pick a new port and update `WithOrigins(...)` in the backend's `Program.cs`
to match, then **restart the backend** (CORS middleware only picks up the
change on a real restart, not a hot reload).

## Verification

Relaunched on port 5001 and confirmed the login POST request no longer
triggers a `DioException` network-layer error in the browser console.
