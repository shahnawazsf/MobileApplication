# Fix: Android Gradle build crashed with Kotlin incremental-compiler errors

**Date:** 2026-07-20
**File:** `app/android/gradle.properties`
**Affects:** `flutter run -d <android-emulator-or-device>` (Gradle
`assembleDebug`) on this machine, where the project lives on `D:\` and the
Gradle/pub caches live on `C:\`

## Symptom

`flutter run -d emulator-5554` failed partway through `assembleDebug` with a
Kotlin daemon stack trace, in two different shapes depending on prior build
state:

```
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in
D:\Testing\projects\MobileApplication\app\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: ...
```

and, after clearing that cache and retrying:

```
Suppressed: java.lang.IllegalArgumentException: this and base files have different roots:
C:\Users\...\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.27\android\src\main\kotlin\...\LegacySharedPreferencesPlugin.kt
and D:\Testing\projects\MobileApplication\app\android.
	at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:119)
	at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
```

## Root cause

The Kotlin Gradle plugin's incremental compiler tries to store build-cache
paths *relative to the project root* (`RelocatableFileToPathConverter`) so
the cache is portable across machines. On Windows, `Path.relativeTo()`
throws `IllegalArgumentException` when the two paths are on **different
drive letters** — there is no relative path from `C:\...` to `D:\...`.

Here the project root is `D:\Testing\projects\MobileApplication\app`, but
plugin sources referenced during compilation come from the pub cache at
`C:\Users\<user>\AppData\Local\Pub\Cache\...`. Every incremental Kotlin
compile hits this the moment it needs to record a source file from a
different drive, which corrupts the incremental cache mid-write. That
corruption is what produced the *first* error shape ("could not close
incremental caches") on the next build attempt — a stale/half-written cache
directory, not a new instance of the same bug.

Killing stray Gradle/Kotlin daemons and deleting the corrupted cache
directory only fixed the first symptom; the underlying cross-drive crash
reproduced immediately on the next build.

## Fix

Disable Kotlin incremental compilation for this project, in
`app/android/gradle.properties`:

```properties
# Works around a Kotlin incremental-compiler crash (RelocatableFileToPathConverter
# throws on paths across different Windows drive letters) when the project root
# and the Gradle/pub caches live on different drives.
kotlin.incremental=false
```

This makes every Kotlin compilation a full (non-incremental) build, which is
slightly slower per build but avoids the crash entirely. The real fix would
be keeping the Flutter SDK, pub cache, and project on the same drive letter,
but that's a machine-level setup change, not something to force via the
repo.

After changing the property, a full clean was needed once to clear out the
already-corrupted cache:

```powershell
Remove-Item -Recurse -Force app/build
```

(`gradlew --stop` first, to make sure no daemon was still holding the old
cache files open.)

## Verification

Ran `flutter run -d emulator-5554` end-to-end: `assembleDebug` completed
without errors, the app installed and launched on the emulator, and the
login screen rendered correctly (confirmed via `adb shell screencap`).
