import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Everything the login form's UI needs to render itself: the current field
/// values, whether each field has been "touched" (so errors don't appear
/// before the user has had a chance to type), and small UI toggles like
/// password-obscuring. Immutable — every change produces a brand-new
/// instance via [copyWith] rather than mutating this one in place.
class LoginFormState {
  final String userId; // raw text currently in the User ID field
  final String password; // raw text currently in the Password field
  final bool obscurePassword; // whether the password field is masked; toggled by the eye icon
  final bool rememberMe; // checkbox state, passed through to AuthRepository.login on submit
  final bool userIdTouched; // becomes true once the user types/blurs — gates when userIdError shows
  final bool passwordTouched; // same, for the password field

  const LoginFormState({
    this.userId = '',
    this.password = '',
    this.obscurePassword = true, // masked by default
    this.rememberMe = false,
    this.userIdTouched = false,
    this.passwordTouched = false,
  });

  // 3-20 chars, letters/digits/dot/underscore — a plain username shape, not an email
  static final _userIdRegex = RegExp(r'^[a-zA-Z0-9_.]{3,20}$');

  String? get userIdError {
    if (!userIdTouched) return null; // don't show an error before the user has interacted with the field
    if (userId.isEmpty) return 'User ID is required';
    if (!_userIdRegex.hasMatch(userId)) {
      return '3-20 characters: letters, numbers, "." or "_"';
    }
    return null; // valid
  }

  String? get passwordError {
    if (!passwordTouched) return null;
    if (password.isEmpty) return 'Password is required'; // no length rule — backend doesn't enforce one
    return null;
  }

  // gates whether _submit() in login_screen.dart actually calls the login API
  bool get isValid => _userIdRegex.hasMatch(userId) && password.isNotEmpty;

  // copyWith: returns a new LoginFormState with the same field values as
  // this one, except any fields explicitly passed in below — the standard
  // way to "update" an immutable object in Dart/Flutter.
  LoginFormState copyWith({
    String? userId,
    String? password,
    bool? obscurePassword,
    bool? rememberMe,
    bool? userIdTouched,
    bool? passwordTouched,
  }) =>
      LoginFormState(
        userId: userId ?? this.userId,
        password: password ?? this.password,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        rememberMe: rememberMe ?? this.rememberMe,
        userIdTouched: userIdTouched ?? this.userIdTouched,
        passwordTouched: passwordTouched ?? this.passwordTouched,
      );
}

/// A [StateNotifier] owns one piece of state (here, [LoginFormState]) behind
/// a `state` property. Widgets that `watch` [loginFormProvider] rebuild
/// automatically every time `state` is reassigned, so each method below just
/// swaps in a new state via [LoginFormState.copyWith] instead of mutating
/// fields directly.
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(const LoginFormState()); // starts blank/untouched

  void setUserId(String value) =>
      state = state.copyWith(userId: value, userIdTouched: true); // marks touched so validation can now show

  void setPassword(String value) =>
      state = state.copyWith(password: value, passwordTouched: true);

  void toggleObscurePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword); // flips the mask on/off

  void toggleRememberMe() => state = state.copyWith(rememberMe: !state.rememberMe);
}

/// The Riverpod provider the login screen watches/reads to get the
/// [LoginFormNotifier] (to call its methods) and the current
/// [LoginFormState] (to render field values/errors).
final loginFormProvider = // .autoDispose resets form state when the login screen is left and re-entered
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(),
);
