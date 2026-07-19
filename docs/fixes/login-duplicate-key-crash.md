# Fix: Duplicate `'loading'` key crash on Login

**Date:** 2026-07-19
**File:** `app/lib/core/widgets/gradient_button.dart`
**Affects:** Login screen "Log In" button (any `GradientButton` with `isLoading`)

## Symptom

Tapping "Log In" (especially rapidly / more than once) crashed with:

```
EXCEPTION CAUGHT BY WIDGETS LIBRARY
Duplicate keys found.
If multiple keyed widgets exist as children of another widget, they must have unique keys.
Stack(alignment: Alignment.center, fit: loose) has multiple children with key [<[<[<'loading'>]>]>].

The relevant error-causing widget was:
  AnimatedSwitcher
  AnimatedSwitcher:file:///.../gradient_button.dart:53:20
```

## Root cause

`GradientButton` gated its press-animation callbacks on `_enabled` (false while
`isLoading` is true), but **not** `onTap`:

```dart
onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
onTap: widget.onPressed, // always fired, even while loading/disabled
```

Because `onTap` was never disabled, a fast double-tap on "Log In" called
`_submit()` twice, which kicked off two overlapping `AuthNotifier.login()`
calls (`auth_provider.dart`). Each call does:

```dart
state = state.copyWith(isLoading: true, error: null);
...
state = state.copyWith(isLoading: false, ...);
```

When the two calls raced, `authState.isLoading` could flip
`true → false → true` faster than the `AnimatedSwitcher`'s 200ms cross-fade
could finish animating the previous spinner (`ValueKey('loading')`) out. That
left two widgets keyed `'loading'` alive at once inside the switcher's
internal `Stack`, which Flutter's widget library rejects as a duplicate key.

## Fix

Gate `onTap` the same way as the other gesture callbacks, so a tap is ignored
once the button is loading or disabled:

```dart
onTap: _enabled ? widget.onPressed : null,
```

This stops the double-submit race at the source — `isLoading` now only ever
flips once per real tap, so the `AnimatedSwitcher` never ends up with two
same-keyed children mid-transition.

## Verification

Ran the app (`flutter run -d chrome --web-port=5001` against the local
backend) and exercised the login flow, including repeated rapid taps on
"Log In" — no crash, single spinner shown while the request is in flight.
