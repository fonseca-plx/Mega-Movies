import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mega_movies/data/models/tmdb_search_result.dart';

/// Exception thrown when the TMDB API returns an unexpected status code.
final class TmdbException implements Exception {
  const TmdbException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'TmdbException($statusCode): $message';
}

/// Service responsible for communicating with the TMDB REST API.
///
/// The API key must be provided at build time via `--dart-define=TMDB_API_KEY=<key>`.
class TmdbMovieService {
  TmdbMovieService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _apiKey = String.fromEnvironment('TMDB_API_KEY');
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  /// Searches for movies matching [query] on TMDB.
  ///
  /// Returns an empty list when [query] is blank.
  /// Throws [TmdbException] on HTTP errors or [Exception] on network failures.
  Future<List<TmdbSearchResult>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('$_baseUrl/search/movie').replace(
      queryParameters: {
        'query': query.trim(),
        'api_key': _apiKey,
        'language': 'pt-BR',
        'include_adult': 'false',
        'page': '1',
      },
    );

    log('TMDB search: $query', name: 'TmdbMovieService');

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw TmdbException(
        response.statusCode,
        'Failed to search movies for query "$query"',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>? ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(TmdbSearchResult.fromJson)
        .toList();
  }
}
