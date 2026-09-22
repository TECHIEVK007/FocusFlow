import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/utils/app_settings.dart';

final authProvider = Provider((ref) => AuthService());

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final isAvailable = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!isAvailable) return true; // Fallback if unsupported

      final enabled = await AppSettings.getBiometrics();
      if (!enabled) return true;

      return await auth.authenticate(
        localizedReason: 'Please authenticate to access FocusFlow',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
