import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/models/user_profile.dart';
import 'package:mega_movies/data/services/mock_movie_service.dart';
import 'package:mega_movies/data/services/tmdb_movie_service.dart';

/// Single source of truth for movie and profile data.
class MovieRepository {
  MovieRepository({TmdbMovieService? tmdbService})
    : _tmdbService = tmdbService ?? TmdbMovieService();

  final TmdbMovieService _tmdbService;

  List<Movie> getAll() => MockMovieService.allMovies;

  Movie? getById(String id) {
    try {
      return MockMovieService.allMovies.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Movie> search(String query) {
    if (query.isEmpty) return getAll();
    final q = query.toLowerCase();
    return MockMovieService.allMovies
        .where(
          (m) =>
              m.title.toLowerCase().contains(q) ||
              m.director.toLowerCase().contains(q) ||
              m.genres.any((g) => g.toLowerCase().contains(q)),
        )
        .toList();
  }

  /// Searches TMDB for movies matching [query].
  ///
  /// Returns an empty list when [query] is blank.
  /// Throws [TmdbException] on API errors.
  Future<List<TmdbSearchResult>> searchTmdb(String query) =>
      _tmdbService.searchMovies(query);

  List<Movie> getWatchlist(List<String> ids) =>
      MockMovieService.allMovies.where((m) => ids.contains(m.id)).toList();

  UserProfile getProfile() => MockMovieService.currentUser;

  Movie get featuredMovie => MockMovieService.allMovies.first;

  List<Movie> get criticallyAcclaimed =>
      MockMovieService.allMovies.skip(2).take(3).toList();

  List<Movie> get similarTo => MockMovieService.allMovies.skip(5).toList();
}
