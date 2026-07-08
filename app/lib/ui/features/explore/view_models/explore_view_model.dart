import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mega_movies/data/models/tmdb_genre.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/data/services/tmdb_movie_service.dart';

/// ViewModel for the Explore screen.
///
/// Manages two independent async states:
/// - **Default content** (trending, popular, genres) — loaded on first build.
/// - **Search results** — loaded when the user submits a query.
class ExploreViewModel extends ChangeNotifier {
  ExploreViewModel({MovieRepository? repository})
    : _repository = repository ?? MovieRepository();

  final MovieRepository _repository;

  // ---------------------------------------------------------------------------
  // Default content state
  // ---------------------------------------------------------------------------

  List<TmdbSearchResult> _trendingMovies = [];
  List<TmdbSearchResult> get trendingMovies => _trendingMovies;

  List<TmdbSearchResult> _popularMovies = [];
  List<TmdbSearchResult> get popularMovies => _popularMovies;

  List<TmdbGenre> _genres = [];
  List<TmdbGenre> get genres => _genres;

  bool _isLoadingDefault = true;
  bool get isLoadingDefault => _isLoadingDefault;

  // ---------------------------------------------------------------------------
  // Search state
  // ---------------------------------------------------------------------------

  List<TmdbSearchResult> _searchResults = [];
  List<TmdbSearchResult> get searchResults => _searchResults;

  bool _isLoadingSearch = false;
  bool get isLoading => _isLoadingSearch;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Loads default content (trending, popular, genres) in parallel.
  ///
  /// No-op if content was already loaded successfully.
  Future<void> loadDefaultContent() async {
    if (!_isLoadingDefault && _trendingMovies.isNotEmpty) return;

    _isLoadingDefault = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getTrending(window: 'week', limit: 20),
        _repository.getPopular(limit: 20),
        _repository.getGenres(),
      ]);

      _trendingMovies = results[0] as List<TmdbSearchResult>;
      _popularMovies = results[1] as List<TmdbSearchResult>;
      _genres = results[2] as List<TmdbGenre>;
    } catch (e) {
      log('Error loading default content: $e', name: 'ExploreViewModel');
      // Silent failure — sections will be empty but app won't crash.
    } finally {
      _isLoadingDefault = false;
      notifyListeners();
    }
  }

  /// Executes a TMDB movie search for [query].
  ///
  /// Clears previous results when [query] is empty (resets to default view).
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _hasSearched = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoadingSearch = true;
    _errorMessage = null;
    _hasSearched = true;
    notifyListeners();

    try {
      _searchResults = await _repository.searchTmdb(query);
    } on TmdbException catch (e) {
      log('TmdbException: $e', name: 'ExploreViewModel');
      _errorMessage = _friendlyMessage(e.statusCode);
      _searchResults = [];
    } catch (e) {
      log('Unexpected error during search: $e', name: 'ExploreViewModel');
      _errorMessage =
          'Não foi possível conectar ao servidor. Verifique sua conexão.';
      _searchResults = [];
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  String _friendlyMessage(int statusCode) => switch (statusCode) {
    401 => 'Chave de API inválida. Configure TMDB_API_KEY corretamente.',
    404 => 'Recurso não encontrado na API.',
    429 => 'Muitas requisições. Tente novamente em instantes.',
    _ => 'Erro ao buscar filmes (código $statusCode).',
  };
}
