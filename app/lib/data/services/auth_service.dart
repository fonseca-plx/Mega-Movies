import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:mega_movies/data/models/user_profile.dart';

/// Thrown when an API call to the auth service fails.
final class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Low-level HTTP client for the MegaMovies authentication API.
///
/// All methods throw [AuthException] on non-2xx responses or network errors.
class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Base URL resolved at runtime:
  /// - Web (Chrome): `localhost:8000`
  /// - Android emulator: `10.0.2.2:8000` (host machine alias)
  /// - Physical device: replace with your machine's LAN IP, e.g. `192.168.1.x:8000`
  static String get _baseUrl =>
      kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

  // ---------------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------------

  /// Creates a new user account and returns the created [UserProfile].
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
    String? photo,
  }) async {
    final body = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'password': password,
      if (photo != null) 'photo': photo,
    };

    log('POST $_baseUrl/auth/register — email=$email', name: 'AuthService');

    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      log('register → ${response.statusCode}', name: 'AuthService');
      _checkStatus(response);
      return UserProfile.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      log('register error: $e', name: 'AuthService');
      throw AuthException(_friendlyError(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  /// Authenticates the user and returns the [UserProfile] along with the JWT.
  ///
  /// The token is extracted from the `Authorization` response header.
  Future<({UserProfile profile, String token})> login({
    required String email,
    required String password,
  }) async {
    log('POST $_baseUrl/auth/login — email=$email', name: 'AuthService');

    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      log(
        'login → ${response.statusCode} | headers=${response.headers}',
        name: 'AuthService',
      );
      _checkStatus(response);

      final authHeader = response.headers['authorization'] ?? '';
      if (!authHeader.startsWith('Bearer ')) {
        throw const AuthException('Authorization header ausente ou malformado');
      }

      final token = authHeader.substring(7); // strip "Bearer "
      final profile = UserProfile.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      return (profile: profile, token: token);
    } on AuthException {
      rethrow;
    } catch (e) {
      log('login error: $e', name: 'AuthService');
      throw AuthException(_friendlyError(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  /// Invalidates the session token on the server.
  Future<void> logout(String token) async {
    log('POST $_baseUrl/auth/logout', name: 'AuthService');
    try {
      await _client
          .post(
            Uri.parse('$_baseUrl/auth/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      // Best-effort: local session is cleared regardless.
      log('Logout request failed (ignored): $e', name: 'AuthService');
    }
  }

  // ---------------------------------------------------------------------------
  // Me
  // ---------------------------------------------------------------------------

  /// Fetches the profile of the currently authenticated user.
  Future<UserProfile> getMe(String token) async {
    log('GET $_baseUrl/auth/me', name: 'AuthService');

    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/auth/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      log('getMe → ${response.statusCode}', name: 'AuthService');
      _checkStatus(response);
      return UserProfile.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      log('getMe error: $e', name: 'AuthService');
      throw AuthException(_friendlyError(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _checkStatus(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String message = 'Falha na requisição (${response.statusCode})';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['detail'] is String) {
        message = body['detail'] as String;
      }
    } catch (_) {}

    log('_checkStatus error: $message', name: 'AuthService');
    throw AuthException(message);
  }

  /// Returns a user-friendly Portuguese message for common network errors.
  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('socket') ||
        msg.contains('connection refused') ||
        msg.contains('network') ||
        msg.contains('timeout') ||
        msg.contains('xmlhttprequest')) {
      return 'Não foi possível conectar ao servidor. '
          'Verifique se a API está rodando.';
    }
    return 'Erro inesperado: $e';
  }
}
