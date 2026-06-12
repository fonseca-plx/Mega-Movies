import 'package:flutter/foundation.dart';
import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';

/// Manages the search state for the Explore screen.
///
/// Exposes a filtered [results] list that updates whenever [search] is called.
/// Starts with all available movies loaded from [MovieRepository].
class ExploreViewModel extends ChangeNotifier {
  ExploreViewModel(this._repository) {
    _results = _repository.getAll();
  }

  final MovieRepository _repository;

  List<Movie> _results = [];
  String _query = '';

  /// Current search query.
  String get query => _query;

  /// Filtered movie list based on the current [query].
  List<Movie> get results => List.unmodifiable(_results);

  /// Filters the movie list by [query] and notifies listeners.
  void search(String query) {
    _query = query;
    _results = _repository.search(query);
    notifyListeners();
  }
}
