import '../../../../core/network/api_exception.dart'; // thrown when the backend reports a login failure
import '../../../../core/network/dio_client.dart'; // wraps Dio with the base URL and auth-header interceptor
import '../../../../core/storage/secure_storage.dart'; // persists token + remember-me flag securely
import '../../domain/entities/user.dart'; // domain object this repository returns
import '../models/login_response_model.dart'; // JSON shape of the /Auth/login response

enum SocialProvider { google, apple, microsoft } // supported (currently unimplemented) OAuth providers

class AuthRepository {
  final DioClient _client; // HTTP client for talking to the backend
  final SecureStorage _secureStorage; // where the token/remember-me flag live

  AuthRepository(this._client, this._secureStorage); // both deps injected via Riverpod providers

  Future<User> login({
    required String userId, // typed into the login form; also becomes User.id since the response has no id field
    required String password,
    bool rememberMe = false, // whether to persist the remember-me flag after a successful login
  }) async {
    final response = await _client.dio.post('/Auth/login', data: { // POST /api/Auth/login (base URL includes /api)
      'userId': userId,
      'password': password,
    });

    final loginResponse = LoginResponseModel.fromJson(response.data); // parse the flat JSON response
    if (!loginResponse.success) { // success/failure is signaled by this field, not the HTTP status code
      throw ApiException(loginResponse.message); // surface the backend's message as the error text
    }

    // No token issued yet by this backend — store one if/when it appears.
    if (loginResponse.token != null) {
      await _secureStorage.saveToken(loginResponse.token!); // only persist a token if one was actually returned
    }
    await _secureStorage.saveRememberMe(rememberMe); // always record the remember-me choice, token or not

    return loginResponse.toEntity(userId); // map the response onto the domain User, threading in the login ID
  }

  /// Social OAuth requires provider client IDs and backend token exchange
  /// that aren't configured yet — wire this up once those are available.
  Future<User> loginWithProvider(SocialProvider provider) {
    throw UnimplementedError( // deliberately fails loudly rather than pretending to succeed
      '${provider.name} sign-in is not configured yet. Add client credentials '
      'and a backend token-exchange endpoint before enabling this button.',
    );
  }

  Future<String?> readStoredToken() => _secureStorage.readToken(); // used by biometric re-auth to confirm a session exists

  Future<void> logout() => _secureStorage.clearToken(); // clears the stored token, ending the session
}
