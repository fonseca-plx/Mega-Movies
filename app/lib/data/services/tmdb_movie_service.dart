import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mega_movies/data/models/tmdb_cast_member.dart';
import 'package:mega_movies/data/models/tmdb_genre.dart';
import 'package:mega_movies/data/models/tmdb_movie_details.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';

/// Exception thrown when the TMDB API returns an unexpected status code.
final class TmdbException implements Exception {
  const TmdbException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'TmdbException($statusCode): $message';
}

/// Service responsible for all communication with the TMDB REST API v3.
///
/// The API key must be provided at build time via `--dart-define=TMDB_API_KEY=<key>`.
class TmdbMovieService {
  TmdbMovieService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _apiKey = String.fromEnvironment('TMDB_API_KEY');
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const Map<String, String> _defaultParams = {
    'language': 'pt-BR',
    'api_key': _apiKey,
  };

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  /// Searches for movies matching [query] on TMDB.
  ///
  /// Returns an empty list when [query] is blank.
  Future<List<TmdbSearchResult>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = _uri('/search/movie', {
      'query': query.trim(),
      'include_adult': 'false',
      'page': '1',
    });

    log('search: $query', name: 'TmdbMovieService');
    return _fetchResults(uri);
  }

  // ---------------------------------------------------------------------------
  // Movie lists
  // ---------------------------------------------------------------------------

  /// Returns the top-rated movies of all time, up to [limit] items.
  Future<List<TmdbSearchResult>> getTopRated({int limit = 10}) async {
    final uri = _uri('/movie/top_rated', {'page': '1'});
    log('top_rated', name: 'TmdbMovieService');
    final results = await _fetchResults(uri);
    return results.take(limit).toList();
  }

  /// Returns movies currently trending.
  ///
  /// [window] must be `'day'` or `'week'`.
  Future<List<TmdbSearchResult>> getTrending({
    String window = 'week',
    int limit = 20,
  }) async {
    final uri = _uri('/trending/movie/$window', {});
    log('trending/$window', name: 'TmdbMovieService');
    final results = await _fetchResults(uri);
    return results.take(limit).toList();
  }

  /// Returns the most popular movies right now, up to [limit] items.
  Future<List<TmdbSearchResult>> getPopular({int limit = 20}) async {
    final uri = _uri('/movie/popular', {'page': '1'});
    log('popular', name: 'TmdbMovieService');
    final results = await _fetchResults(uri);
    return results.take(limit).toList();
  }

  /// Discovers movies filtered by [genreIds] and sorted by [sortBy].
  ///
  /// [sortBy] accepts TMDB sort options such as `popularity.desc`,
  /// `vote_average.desc`, `release_date.desc`, etc.
  Future<List<TmdbSearchResult>> discoverByGenres(
    List<int> genreIds, {
    String sortBy = 'popularity.desc',
    int limit = 20,
    int voteCountMin = 100,
  }) async {
    final uri = _uri('/discover/movie', {
      'with_genres': genreIds.join(','),
      'sort_by': sortBy,
      'vote_count.gte': '$voteCountMin',
      'page': '1',
    });
    log('discover genres=${genreIds.join(',')}', name: 'TmdbMovieService');
    final results = await _fetchResults(uri);
    return results.take(limit).toList();
  }

  // ---------------------------------------------------------------------------
  // Movie detail & related
  // ---------------------------------------------------------------------------

  /// Fetches the full details of a single movie by its TMDB [id].
  ///
  /// Credits (cast) are appended in the same request to avoid an extra round-trip.
  Future<TmdbMovieDetails> getMovieDetails(int id) async {
    final uri = _uri('/movie/$id', {'append_to_response': 'credits'});
    log('details: $id', name: 'TmdbMovieService');

    final response = await _client.get(uri);
    _assertOk(response, 'movie/$id');

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return TmdbMovieDetails.fromJson(body);
  }

  /// Returns movies recommended based on the given [movieId].
  Future<List<TmdbSearchResult>> getRecommendations(int movieId) async {
    final uri = _uri('/movie/$movieId/recommendations', {'page': '1'});
    log('recommendations: $movieId', name: 'TmdbMovieService');
    return _fetchResults(uri);
  }

  // ---------------------------------------------------------------------------
  // Metadata
  // ---------------------------------------------------------------------------

  /// Returns the official list of TMDB movie genres.
  Future<List<TmdbGenre>> getGenres() async {
    final uri = _uri('/genre/movie/list', {});
    log('genres', name: 'TmdbMovieService');

    final response = await _client.get(uri);
    _assertOk(response, 'genre/movie/list');

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['genres'] as List<dynamic>? ?? [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(TmdbGenre.fromJson)
        .toList();
  }

  /// Returns the top-billed cast for a movie. Kept for standalone use.
  Future<List<TmdbCastMember>> getCredits(int movieId) async {
    final uri = _uri('/movie/$movieId/credits', {});
    log('credits: $movieId', name: 'TmdbMovieService');

    final response = await _client.get(uri);
    _assertOk(response, 'movie/$movieId/credits');

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final cast = body['cast'] as List<dynamic>? ?? [];
    return cast
        .whereType<Map<String, dynamic>>()
        .take(10)
        .map(TmdbCastMember.fromJson)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Builds a URI merging [_defaultParams] with extra [params].
  Uri _uri(String path, Map<String, String> params) => Uri.parse(
    '$_baseUrl$path',
  ).replace(queryParameters: {..._defaultParams, ...params});

  /// GETs [uri] and parses the `results` array as [TmdbSearchResult] list.
  Future<List<TmdbSearchResult>> _fetchResults(Uri uri) async {
    final response = await _client.get(uri);
    _assertOk(response, uri.path);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>? ?? [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(TmdbSearchResult.fromJson)
        .toList();
  }

  /// Throws [TmdbException] when the response status is not 200.
  void _assertOk(http.Response response, String label) {
    if (response.statusCode != 200) {
      throw TmdbException(response.statusCode, 'Failed: $label');
    }
  }
}
