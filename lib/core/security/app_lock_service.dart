import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Stores the app PIN (salted SHA-256, never the raw digits) in the platform
/// keystore and wraps fingerprint / Face ID unlock.
class AppLockService {
  AppLockService._();
  static final AppLockService instance = AppLockService._();

  static const _kPinHash = 'app_lock.pin_hash';
  static const _kPinSalt = 'app_lock.pin_salt';
  static const _kBiometric = 'app_lock.biometric';

  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  Future<bool> hasPin() async => (await _storage.read(key: _kPinHash)) != null;

  Future<void> savePin(String pin) async {
    final salt = _randomSalt();
    await _storage.write(key: _kPinSalt, value: salt);
    await _storage.write(key: _kPinHash, value: _hash(pin, salt));
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _kPinSalt);
    final hash = await _storage.read(key: _kPinHash);
    if (salt == null || hash == null) return false;
    return _hash(pin, salt) == hash;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _kPinHash);
    await _storage.delete(key: _kPinSalt);
    await _storage.delete(key: _kBiometric);
  }

  Future<bool> isBiometricEnabled() async =>
      (await _storage.read(key: _kBiometric)) == 'true';

  Future<void> setBiometricEnabled(bool enabled) =>
      _storage.write(key: _kBiometric, value: '$enabled');

  /// True when the device has fingerprint / face enrolled.
  Future<bool> canUseBiometrics() async {
    try {
      if (!await _localAuth.isDeviceSupported()) return false;
      return (await _localAuth.getAvailableBiometrics()).isNotEmpty;
    } catch (e) {
      debugPrint('AppLockService.canUseBiometrics: $e');
      return false;
    }
  }

  /// Shows the system prompt. With [biometricOnly] false the device
  /// passcode is accepted too (used to confirm "Forgot PIN").
  Future<bool> authenticate({
    required String reason,
    bool biometricOnly = true,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: biometricOnly,
      );
    } on LocalAuthException catch (e) {
      debugPrint('AppLockService.authenticate: ${e.code.name}');
      return false;
    } catch (e) {
      debugPrint('AppLockService.authenticate: $e');
      return false;
    }
  }

  /// Whether the device has any lock (passcode, pattern or biometrics).
  Future<bool> isDeviceSecured() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  static String _hash(String pin, String salt) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();

  static String _randomSalt() {
    final rnd = Random.secure();
    return base64UrlEncode(List<int>.generate(16, (_) => rnd.nextInt(256)));
  }
}
