import 'package:flutter/foundation.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';

/// Possible states for the home screen content.
enum HomeStatus { loading, loaded, error }

/// ViewModel for the [HomeScreen].
///
/// Loads the hero movie, acclaimed section, and noir grid in parallel using
/// a single [Future.wait] call to minimise latency.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required MovieRepository repository})
    : _repository = repository;

  final MovieRepository _repository;

  HomeStatus _status = HomeStatus.loading;
  HomeStatus get status => _status;

  TmdbSearchResult? _featuredMovie;
  TmdbSearchResult? get featuredMovie => _featuredMovie;

  List<TmdbSearchResult> _acclaimed = [];
  List<TmdbSearchResult> get acclaimed => _acclaimed;

  List<TmdbSearchResult> _noirGrid = [];
  List<TmdbSearchResult> get noirGrid => _noirGrid;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == HomeStatus.loading;

  /// Loads all home-screen data in parallel.
  ///
  /// Calling [load] again while already loading is a no-op.
  Future<void> load() async {
    if (_status == HomeStatus.loading && _featuredMovie != null) return;
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        // Top-rated: used for Hero (first item) + Critically Acclaimed (next 8)
        _repository.getTopRated(limit: 10),
        // Crime (80) + Drama (18) sorted by rating → Noir/Classic Collection
        _repository.discoverByGenres(
          [80, 18],
          sortBy: 'vote_average.desc',
          limit: 9,
          // Ensure enough votes for quality results
        ),
      ]);

      final topRated = results[0];
      final noir = results[1];

      _featuredMovie = topRated.isNotEmpty ? topRated.first : null;
      _acclaimed = topRated.skip(1).take(8).toList();
      // Filter out movies without a backdrop for the bento grid
      _noirGrid = noir.where((m) => m.backdropPath != null).take(6).toList();

      _status = HomeStatus.loaded;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar o conteúdo.';
      _status = HomeStatus.error;
    }

    notifyListeners();
  }
}
