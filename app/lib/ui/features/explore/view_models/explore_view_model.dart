import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/data/services/tmdb_movie_service.dart';

/// ViewModel for the Explore screen.
///
/// Manages the asynchronous TMDB search state and notifies the UI of changes.
class ExploreViewModel extends ChangeNotifier {
  ExploreViewModel({MovieRepository? repository})
    : _repository = repository ?? MovieRepository();

  final MovieRepository _repository;

  List<TmdbSearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasSearched = false;

  /// Results returned by the last successful TMDB search.
  List<TmdbSearchResult> get searchResults => _searchResults;

  /// True while a search request is in flight.
  bool get isLoading => _isLoading;

  /// Non-null when the last search ended with an error.
  String? get errorMessage => _errorMessage;

  /// True once the user has submitted at least one search.
  ///
  /// Allows the UI to distinguish "initial state" from "empty results."
  bool get hasSearched => _hasSearched;

  /// Executes a TMDB movie search for [query].
  ///
  /// Clears previous results when [query] is empty.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _hasSearched = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
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
      _isLoading = false;
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
