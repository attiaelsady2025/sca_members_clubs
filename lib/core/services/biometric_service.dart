import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (_) {
      return false;
    } on MissingPluginException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return <BiometricType>[];
    } on MissingPluginException catch (_) {
      return <BiometricType>[];
    } catch (_) {
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'يرجى المصادقة لتسجيل الدخول إلى حسابك',
      );
      return didAuthenticate;
    } on PlatformException catch (_) {
      return false;
    } on MissingPluginException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}
