import 'package:flutter_riverpod/flutter_riverpod.dart'; // Provider/StateNotifierProvider machinery
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

final secureStorageProvider = Provider((ref) => SecureStorage()); // single shared SecureStorage instance

final dioClientProvider = Provider((ref) => DioClient(ref.read(secureStorageProvider))); // Dio wired to read the stored token

final biometricServiceProvider = Provider((ref) => BiometricService()); // single shared local_auth wrapper

final authRepositoryProvider = Provider((ref) => // wires the repository's two dependencies together
    AuthRepository(ref.read(dioClientProvider), ref.read(secureStorageProvider)));

class AuthState {
  final bool isLoading; // true while a login/logout call is in flight — drives spinners/disabled buttons
  final User? user; // null when signed out, populated after a successful login
  final String? error; // last error message, shown as a snackbar then not re-shown until it changes

  const AuthState({this.isLoading = false, this.user, this.error});

  bool get isAuthenticated => user != null; // the single source of truth the router redirect reads

  AuthState copyWith({bool? isLoading, User? user, String? error}) => AuthState(
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        error: error, // deliberately NOT `error ?? this.error` — callers must pass null to clear a stale error
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository; // performs the actual network/storage work
  final BiometricService _biometricService; // checks/performs biometric authentication

  AuthNotifier(this._repository, this._biometricService) : super(const AuthState()); // starts signed out

  Future<void> login({
    required String userId,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null); // clear any previous error before retrying
    try {
      final user = await _repository.login(
        userId: userId,
        password: password,
        rememberMe: rememberMe,
      );
      state = state.copyWith(isLoading: false, user: user); // success — AuthState.isAuthenticated flips true
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString()); // failure — surfaced via ref.listen in the UI
    }
  }

  Future<void> loginWithProvider(SocialProvider provider) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.loginWithProvider(provider); // currently always throws UnimplementedError
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> get biometricsAvailable => _biometricService.isAvailable; // used by the screen to show/hide the button

  Future<void> loginWithBiometrics() async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _biometricService.authenticate(); // prompts Face ID/fingerprint
    if (!success) {
      state = state.copyWith(isLoading: false, error: 'Biometric authentication failed');
      return;
    }
    final token = await _repository.readStoredToken(); // biometrics unlock an existing session, they don't create one
    if (token == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'No saved session — sign in with your password first',
      );
      return;
    }
    state = state.copyWith(isLoading: false); // token exists — treat as still signed in (state.user is unchanged)
  }

  Future<void> logout() async {
    await _repository.logout(); // clears the stored token
    state = const AuthState(); // reset to the signed-out default state
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider), ref.read(biometricServiceProvider)),
);
