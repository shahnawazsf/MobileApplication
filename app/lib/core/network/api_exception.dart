/// Custom exception carrying a message that's already safe to show the user,
/// instead of a raw DioException/PlatformException.
class ApiException implements Exception { // implements Exception: Dart's marker interface for "this is an exception type", with no required members of its own — thrown for both HTTP-level errors and backend-signaled login failures
  final String message; // shown directly to the user via a snackbar
  final int? statusCode; // null for non-HTTP failures (e.g. backend success:false with no bad status code)
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message; // so `e.toString()` in AuthNotifier's catch blocks yields the plain message
}
