import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // .animate().fadeIn()/.slideY() chaining used below
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/animated_gradient_background.dart';
// Unused while social login is hidden — see the commented-out block below.
// import '../../../../core/widgets/brand_glyphs.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/premium_text_field.dart';
// import '../../../../core/widgets/social_login_button.dart';
// import '../../data/repositories/auth_repository.dart';
import '../providers/auth_provider.dart';
import '../providers/login_form_provider.dart';

/// The initial screen for signed-out users — a form that reads/writes
/// [loginFormProvider] for field state/validation and calls [authProvider]
/// to actually attempt sign-in.
class LoginScreen extends ConsumerStatefulWidget { // ConsumerStatefulWidget: needs both `ref` and local State
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _userIdController = TextEditingController(); // owns the actual text in the User ID field
  final _passwordController = TextEditingController();
  bool _biometricsAvailable = false; // controls whether the fingerprint button is shown at all

  @override
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).biometricsAvailable.then((available) { // async check, resolved after first frame
      if (mounted) setState(() => _biometricsAvailable = available); // guard against setState after disposal
    });
  }

  @override
  void dispose() {
    _userIdController.dispose(); // TextEditingControllers must be disposed manually
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = ref.read(loginFormProvider);
    if (!form.isValid) {
      ref.read(loginFormProvider.notifier) // re-set the same values just to flip the "touched" flags on
        ..setUserId(form.userId) // so validation errors become visible even if the user never blurred the field
        ..setPassword(form.password);
      return; // don't call the API with invalid input
    }
    ref.read(authProvider.notifier).login(
          userId: form.userId,
          password: form.password,
          rememberMe: form.rememberMe,
        );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // avoid stacking snackbars if one is already showing
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null, // red background only for errors
        behavior: SnackBarBehavior.floating,
      ));
  }

  void _showAlert(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider); // rebuilds this screen whenever form fields change
    final formNotifier = ref.read(loginFormProvider.notifier); // read, not watch — this is for calling methods only
    final authState = ref.watch(authProvider); // rebuilds on isLoading/user/error changes
    final theme = Theme.of(context);

    ref.listen(authProvider, (previous, next) { // side effects (snackbars/dialogs) belong in listen, not in build()
      if (next.error != null && next.error != previous?.error) { // only show a NEW error, not the same one again
        if (next.isCredentialsError) {
          _showAlert('Login Failed, Invalid Credentials', 'Please check your User ID and Password and try again.'); // fixed copy — never show the backend's raw message text
        } else {
          _showSnack(next.error!, isError: true); // network/server errors — less disruptive toast
        }
      }
      if (next.isAuthenticated && previous?.isAuthenticated != true) { // fires once, right as login succeeds
        _showSnack('SDES Mobile Application, ${next.user!.name}!');
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true, // keeps the form visible above the on-screen keyboard
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView( // lets short screens/landscape keep the form reachable when it overflows
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440), // caps card width on tablet/web/wide screens
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Column only takes as much height as its children need
                  children: [
                    const BrandLogo(),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome back',
                      style: theme.textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0), // fades in while sliding up slightly
                    const SizedBox(height: 8),
                    Text(
                      'Saudi Development & Export Service',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65), // muted subtitle color
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms) // starts slightly after the heading for a staggered feel
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch, // form fields/buttons fill the card's width
                        children: [
                          PremiumTextField(
                            label: 'User ID',
                            icon: Icons.person_outline,
                            controller: _userIdController,
                            keyboardType: TextInputType.text,
                            autofillHints: const [AutofillHints.username],
                            errorText: formState.userIdError,
                            onChanged: formNotifier.setUserId,
                          ),
                          const SizedBox(height: 16),
                          PremiumTextField(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            controller: _passwordController,
                            obscureText: formState.obscurePassword, // masked unless the eye icon was tapped
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done, // last field — keyboard shows "done" not "next"
                            errorText: formState.passwordError,
                            onChanged: formNotifier.setPassword,
                            onSubmitted: (_) => _submit(), // pressing enter/done submits the form
                            suffixIcon: IconButton(
                              icon: Icon(
                                formState.obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: formNotifier.toggleObscurePassword,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: formState.rememberMe,
                                onChanged: (_) => formNotifier.toggleRememberMe(),
                              ),
                              Text('Remember me', style: theme.textTheme.bodyMedium),
                              const Spacer(), // pushes anything after it to the far right of the Row
                              // Forgot password hidden until /auth/forgot-password
                              // exists on the backend.
                              /*
                              TextButton(
                                onPressed: () => _showSnack(
                                  'Password reset isn\'t wired up yet — add a /auth/forgot-password endpoint to enable this.',
                                ),
                                child: const Text('Forgot password?'),
                              ),
                              */
                            ],
                          ),
                          const SizedBox(height: 8),
                          GradientButton(
                            label: 'Log In',
                            isLoading: authState.isLoading, // shows the spinner while the login call is in flight
                            onPressed: _submit,
                          ),
                          if (_biometricsAvailable) ...[ // spread-if: adds these widgets only when true
                            const SizedBox(height: 12),
                            Center(
                              child: IconButton.filledTonal(
                                icon: const Icon(Icons.fingerprint),
                                iconSize: 28,
                                tooltip: 'Sign in with biometrics',
                                onPressed: authState.isLoading
                                    ? null // disabled while another login attempt is already running
                                    : () => ref.read(authProvider.notifier).loginWithBiometrics(),
                              ),
                            ),
                          ],
                          // Social login hidden until real OAuth (client IDs +
                          // backend token exchange) is wired up — see
                          // AuthRepository.loginWithProvider.
                          /*
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: Divider(color: theme.dividerColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 11,
                                    letterSpacing: 0.6,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: theme.dividerColor)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SocialLoginButton(
                                label: 'Google',
                                icon: const GoogleGlyph(),
                                onPressed: () => ref
                                    .read(authProvider.notifier)
                                    .loginWithProvider(SocialProvider.google),
                              ),
                              const SizedBox(width: 12),
                              SocialLoginButton(
                                label: 'Apple',
                                icon: const AppleGlyph(),
                                onPressed: () => ref
                                    .read(authProvider.notifier)
                                    .loginWithProvider(SocialProvider.apple),
                              ),
                              const SizedBox(width: 12),
                              SocialLoginButton(
                                label: 'Microsoft',
                                icon: const MicrosoftGlyph(),
                                onPressed: () => ref
                                    .read(authProvider.notifier)
                                    .loginWithProvider(SocialProvider.microsoft),
                              ),
                            ],
                          ),
                          */
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 150.ms) // the card animates in last, after the heading text
                        .slideY(begin: 0.15, end: 0)
                        .scaleXY(begin: 0.98, end: 1), // subtle grow-in alongside the fade/slide
                    // Register hidden until a registration screen/endpoint exists.
                    /*
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () => _showSnack('Registration screen coming soon.'),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                    */
                    const SizedBox(height: 8),
                    Wrap( // wraps to a second line on narrow screens instead of overflowing horizontally
                      alignment: WrapAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {}, // placeholder — no privacy policy page yet
                          child: const Text('Privacy Policy'),
                        ),
                        Text('•', style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () {}, // placeholder — no terms page yet
                          child: const Text('Terms & Conditions'),
                        ),
                      ],
                    ),
                    Text(
                      'v1.0.0', // hardcoded — not read from pubspec.yaml's version field
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
