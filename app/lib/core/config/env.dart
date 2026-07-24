/// Compile-time configuration read via `--dart-define`, with sane defaults
/// for local development so the app runs without any flags.
class Env {
  // String.fromEnvironment reads a value baked in at build time (via
  // `flutter run --dart-define=API_BASE_URL=...`), not at runtime — there's
  // no way to change this after the app is compiled.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL', // override at build/run time: --dart-define=API_BASE_URL=...
    //defaultValue: 'http://10.0.2.2:8080/api', // Android emulator -> host localhost

    defaultValue: 'https://localhost:7161/api', // local backend; Swagger UI at /swagger/index.html
  );

  // Same idea but for a bool flag: when true, AuthNotifier.login skips the
  // real network call and signs in with fake data (see auth_provider.dart) —
  // handy for UI work without a backend running.
  static const bool debugLoginBypass = bool.fromEnvironment(
    'DEBUG_LOGIN_BYPASS',
    defaultValue: false,
  );
}
