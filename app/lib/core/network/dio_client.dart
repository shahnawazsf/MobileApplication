import 'package:dio/dio.dart'; // HTTP client
import '../config/env.dart'; // backend base URL
import '../storage/secure_storage.dart'; // where the bearer token is read from
import 'api_exception.dart'; // wraps raw Dio errors into a UI-friendly message

class DioClient {
  final Dio dio; // the configured client every repository sends requests through
  final SecureStorage _secureStorage; // used by the request interceptor to attach the token

  DioClient(this._secureStorage)
      : dio = Dio(BaseOptions( // BaseOptions applied to every request made with this Dio instance
          baseUrl: Env.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async { // runs before every outgoing request
        final token = await _secureStorage.readToken();
        if (token != null) { // no header at all when signed out, rather than "Bearer null"
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // continue sending the (possibly modified) request
      },
      onError: (DioException e, handler) { // runs on any non-2xx response or connection failure
        final message = _messageFor(e);
        return handler.reject(DioException( // replace the raw DioException with one carrying an ApiException
          requestOptions: e.requestOptions,
          error: ApiException(message, statusCode: e.response?.statusCode),
        ));
      },
    ));
  }
}

// Connection-level failures never carry a response body, so `e.message` is
// all Dio has — and that text is the raw platform/XHR message (e.g. "The
// connection errored: The XMLHttpRequest onError callback was called..."),
// not something to show a user. Swap those for one plain, actionable line;
// anything with a real response keeps using the backend's own message.
String _messageFor(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Unable to connect. Please check your internet connection and try again.';
    default:
      return e.response?.data?['message'] ?? e.message ?? 'Network error';
  }
}
