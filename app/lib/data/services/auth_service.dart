import 'dart:convert';
import 'dart:developer';

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
/// All methods throw [AuthException] on non-2xx responses.
class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Change to your local IP when testing on a physical device.
  static const String _baseUrl = 'http://10.0.2.2:8000';

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

    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    _checkStatus(response);
    return UserProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    _checkStatus(response);

    final authHeader = response.headers['authorization'] ?? '';
    if (!authHeader.startsWith('Bearer ')) {
      throw const AuthException('Authorization header missing or malformed');
    }

    final token = authHeader.substring(7); // strip "Bearer "
    final profile = UserProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    return (profile: profile, token: token);
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  /// Invalidates the session token on the server.
  Future<void> logout(String token) async {
    try {
      await _client.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
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
    final response = await _client.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    _checkStatus(response);
    return UserProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _checkStatus(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String message = 'Request failed (${response.statusCode})';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['detail'] is String) {
        message = body['detail'] as String;
      }
    } catch (_) {}

    throw AuthException(message);
  }
}
