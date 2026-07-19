import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Keychain/Keystore-backed storage, not plain prefs

class SecureStorage {
  final _storage = const FlutterSecureStorage(); // one instance per SecureStorage, wraps the platform secure store
  static const _tokenKey = 'auth_token'; // key the bearer token is stored under
  static const _rememberMeKey = 'remember_me'; // key the remember-me flag is stored under

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey); // null when never logged in / after logout
  Future<void> clearToken() => _storage.delete(key: _tokenKey); // called on logout

  Future<void> saveRememberMe(bool value) =>
      _storage.write(key: _rememberMeKey, value: value.toString()); // stored as a string like all secure-storage values
  Future<bool> readRememberMe() async =>
      (await _storage.read(key: _rememberMeKey)) == 'true'; // treats missing/anything-else as false
}
