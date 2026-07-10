import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mega_movies/data/models/user_profile.dart';
import 'package:mega_movies/data/services/auth_service.dart';

/// Manages authentication state for the entire application.
///
/// Extends [ChangeNotifier] so the [GoRouter] and UI widgets can observe
/// session changes reactively via [ListenableBuilder].
class AuthRepository extends ChangeNotifier {
  AuthRepository({AuthService? service, FlutterSecureStorage? storage})
    : _service = service ?? AuthService(),
      _storage = storage ?? const FlutterSecureStorage();

  final AuthService _service;
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';

  UserProfile? _currentUser;

  /// The currently authenticated user, or `null` if not signed in.
  UserProfile? get currentUser => _currentUser;

  /// Whether there is an active authenticated session.
  bool get isAuthenticated => _currentUser != null;

  // ---------------------------------------------------------------------------
  // Session initialisation
  // ---------------------------------------------------------------------------

  /// Restores a previously saved session from secure storage.
  ///
  /// Called once on app start. If a valid token is found, the user profile is
  /// fetched from `/auth/me`. On any error the local token is discarded.
  Future<void> loadSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return;

    try {
      final profile = await _service.getMe(token);
      _currentUser = profile;
      notifyListeners();
    } catch (e) {
      log('Session restore failed, clearing token: $e', name: 'AuthRepository');
      await _storage.delete(key: _tokenKey);
    }
  }

  // ---------------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------------

  /// Registers a new account.
  ///
  /// Does **not** automatically sign the user in — call [login] afterwards.
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
  }) => _service.register(fullName: fullName, email: email, password: password);

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  /// Signs the user in, persists the JWT and notifies listeners.
  Future<void> login({required String email, required String password}) async {
    final result = await _service.login(email: email, password: password);
    await _storage.write(key: _tokenKey, value: result.token);
    _currentUser = result.profile;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  /// Signs the user out, invalidates the token on the server and clears state.
  Future<void> logout() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      await _service.logout(token);
      await _storage.delete(key: _tokenKey);
    }
    _currentUser = null;
    notifyListeners();
  }
}
