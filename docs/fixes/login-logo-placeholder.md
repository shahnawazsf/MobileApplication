# Fix: Login screen used a placeholder icon instead of the real brand logo

**Date:** 2026-07-19
**Files:** `app/lib/features/auth/presentation/screens/login_screen.dart`,
`app/pubspec.yaml`, `app/assets/images/logo.png` (new)
**Affects:** Login screen brand mark (the circle above "Welcome back")

## Symptom

The gradient circle at the top of the login screen showed a generic Material
bolt icon (`Icons.bolt_rounded`) instead of the company's actual logo. The
code even had a comment flagging this:

```dart
child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 36), // placeholder mark — swap for a real app logo
```

## Root cause

No brand asset had been wired into the project yet — `pubspec.yaml` had no
`assets:` section at all, so there was nowhere for a real logo to come from.

## Fix

1. Added `app/assets/images/logo.png` (the red/blue "M" arrow mark).
2. Registered it in `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/logo.png
   ```
3. Swapped the placeholder `Icon` for the real asset in `_Logo`
   (`login_screen.dart`), adding padding so the mark doesn't touch the edge
   of the 72x72 gradient circle:
   ```dart
   padding: const EdgeInsets.all(14),
   child: Image.asset('assets/images/logo.png', fit: BoxFit.contain), // brand mark
   ```

Two logo variants existed (a mark-only version and a full horizontal lockup
with Arabic + English company name). The mark-only version was chosen since
the full lockup's English name duplicates the subtitle text already shown
below the heading ("Saudi Development & Export Service").

## Verification

Ran the app on the Android emulator (`flutter run -d emulator-5554`) and
confirmed via screenshot (`adb shell screencap`) that the real logo renders
correctly inside the gradient circle, in place of the bolt icon.
