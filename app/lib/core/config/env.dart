class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL', // override at build/run time: --dart-define=API_BASE_URL=...
    //defaultValue: 'http://10.0.2.2:8080/api', // Android emulator -> host localhost

    defaultValue: 'https://localhost:7161/api', // local backend; Swagger UI at /swagger/index.html
  );
}
