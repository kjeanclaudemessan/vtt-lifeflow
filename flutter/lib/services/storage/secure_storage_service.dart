import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data.
///
/// Uses platform-specific secure storage:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
/// - Web: Encrypted in localStorage
///
/// Use this for sensitive data like tokens, passwords, etc.
/// For non-sensitive data, use [LocalStorageService].
///
/// Example:
/// ```dart
/// final secureStorage = locator<SecureStorageService>();
///
/// // Store tokens
/// await secureStorage.setAccessToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
/// await secureStorage.setRefreshToken('refresh_token_here');
///
/// // Retrieve tokens
/// final accessToken = await secureStorage.getAccessToken();
/// ```
class SecureStorageService {
  /// Storage instance with platform-specific options.
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
    webOptions: WebOptions(
      dbName: 'lifeflow_secure_storage',
      publicKey: 'lifeflow',
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TOKEN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Stores the access token.
  Future<void> setAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  /// Retrieves the access token.
  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  /// Stores the refresh token.
  Future<void> setRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves the refresh token.
  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Stores the token expiry time.
  Future<void> setTokenExpiry(DateTime expiry) {
    return _storage.write(
      key: _tokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  /// Retrieves the token expiry time.
  Future<DateTime?> getTokenExpiry() async {
    final value = await _storage.read(key: _tokenExpiryKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  /// Checks if the access token is valid (exists and not expired).
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;

    final expiry = await getTokenExpiry();
    if (expiry == null) return true; // No expiry set, assume valid

    return DateTime.now().isBefore(expiry);
  }

  /// Clears all authentication tokens.
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tokenExpiryKey);
  }

  /// Stores all tokens at once.
  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiry,
  }) async {
    await setAccessToken(accessToken);
    if (refreshToken != null) {
      await setRefreshToken(refreshToken);
    }
    if (expiry != null) {
      await setTokenExpiry(expiry);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GENERIC OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Writes a value securely.
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  /// Reads a value.
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  /// Deletes a value.
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  /// Deletes all stored values.
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

  /// Checks if a key exists.
  Future<bool> containsKey({required String key}) {
    return _storage.containsKey(key: key);
  }

  /// Gets all stored keys.
  Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores user credentials (for biometric login).
  Future<void> setCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_password', value: password);
  }

  /// Retrieves stored credentials.
  Future<({String? email, String? password})> getCredentials() async {
    final email = await _storage.read(key: 'user_email');
    final password = await _storage.read(key: 'user_password');
    return (email: email, password: password);
  }

  /// Clears stored credentials.
  Future<void> clearCredentials() async {
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_password');
  }

  /// Stores a PIN code.
  Future<void> setPin(String pin) {
    return _storage.write(key: 'user_pin', value: pin);
  }

  /// Retrieves the PIN code.
  Future<String?> getPin() {
    return _storage.read(key: 'user_pin');
  }

  /// Clears the PIN code.
  Future<void> clearPin() {
    return _storage.delete(key: 'user_pin');
  }
}
