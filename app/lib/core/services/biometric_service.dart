import 'dart:io'; // Platform.isAndroid/isIOS
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/services.dart'; // PlatformException
import 'package:local_auth/local_auth.dart'; // Face ID / fingerprint API

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication(); // plugin instance wrapping the native biometric APIs

  bool get isSupportedPlatform => // local_auth has no web/desktop implementation
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<bool> get isAvailable async {
    if (!isSupportedPlatform) return false; // short-circuit before touching Platform on web (would throw)
    final canCheck = await _auth.canCheckBiometrics; // device has biometric hardware enrolled
    final deviceSupported = await _auth.isDeviceSupported(); // OS/device supports biometric auth at all
    return canCheck && deviceSupported;
  }

  Future<bool> authenticate({String reason = 'Sign in to your account'}) async {
    if (!await isAvailable) return false; // avoid calling into a plugin that isn't usable here
    try {
      return await _auth.authenticate( // shows the native Face ID/fingerprint prompt
        localizedReason: reason, // text shown in the system prompt
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true), // no PIN fallback; survives app backgrounding
      );
    } on PlatformException {
      return false; // treat any native-side failure (cancelled, locked out, etc.) as "not authenticated"
    }
  }
}
