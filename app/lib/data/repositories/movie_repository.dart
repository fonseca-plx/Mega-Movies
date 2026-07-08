import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/models/tmdb_cast_member.dart';
import 'package:mega_movies/data/models/tmdb_genre.dart';
import 'package:mega_movies/data/models/tmdb_movie_details.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/models/user_profile.dart';
import 'package:mega_movies/data/services/mock_movie_service.dart';
import 'package:mega_movies/data/services/tmdb_movie_service.dart';

/// Single source of truth for movie and profile data.
///
/// Local mock data is still used for the user profile and watchlist while
/// TMDB integration is expanded in future phases.
class MovieRepository {
  MovieRepository({TmdbMovieService? tmdbService})
    : _tmdbService = tmdbService ?? TmdbMovieService();

  final TmdbMovieService _tmdbService;

  // ---------------------------------------------------------------------------
  // Local / mock (used by ProfileScreen)
  // ---------------------------------------------------------------------------

  Movie? getById(String id) {
    try {
      return MockMovieService.allMovies.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Movie> getWatchlist(List<String> ids) =>
      MockMovieService.allMovies.where((m) => ids.contains(m.id)).toList();

  UserProfile getProfile() => MockMovieService.currentUser;

  // ---------------------------------------------------------------------------
  // TMDB — lists
  // ---------------------------------------------------------------------------

  /// Top-rated movies of all time.
  Future<List<TmdbSearchResult>> getTopRated({int limit = 10}) =>
      _tmdbService.getTopRated(limit: limit);

  /// Currently trending movies (daily or weekly).
  Future<List<TmdbSearchResult>> getTrending({
    String window = 'week',
    int limit = 20,
  }) => _tmdbService.getTrending(window: window, limit: limit);

  /// Most popular movies right now.
  Future<List<TmdbSearchResult>> getPopular({int limit = 20}) =>
      _tmdbService.getPopular(limit: limit);

  /// Discovers movies filtered by genre IDs.
  Future<List<TmdbSearchResult>> discoverByGenres(
    List<int> genreIds, {
    String sortBy = 'popularity.desc',
    int limit = 20,
  }) => _tmdbService.discoverByGenres(genreIds, sortBy: sortBy, limit: limit);

  // ---------------------------------------------------------------------------
  // TMDB — search
  // ---------------------------------------------------------------------------

  /// Searches TMDB for movies matching [query].
  Future<List<TmdbSearchResult>> searchTmdb(String query) =>
      _tmdbService.searchMovies(query);

  // ---------------------------------------------------------------------------
  // TMDB — detail & related
  // ---------------------------------------------------------------------------

  /// Full movie details including cast (via append_to_response=credits).
  Future<TmdbMovieDetails> getMovieDetails(int id) =>
      _tmdbService.getMovieDetails(id);

  /// Recommended movies based on a given movie.
  Future<List<TmdbSearchResult>> getRecommendations(int movieId) =>
      _tmdbService.getRecommendations(movieId);

  /// Top-billed cast for a movie (standalone call).
  Future<List<TmdbCastMember>> getCredits(int movieId) =>
      _tmdbService.getCredits(movieId);

  // ---------------------------------------------------------------------------
  // TMDB — metadata
  // ---------------------------------------------------------------------------

  /// Official list of movie genres.
  Future<List<TmdbGenre>> getGenres() => _tmdbService.getGenres();
}
