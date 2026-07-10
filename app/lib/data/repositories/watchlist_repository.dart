import 'dart:developer';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:mega_movies/data/local/app_database.dart';
import 'package:mega_movies/data/models/tmdb_movie_details.dart';

/// Manages the user's watchlist state and provides an interface to persist
/// entries via [AppDatabase].
///
/// Extends [ChangeNotifier] so the UI can rebuild reactively whenever the
/// watchlist changes (entries added or removed).
class WatchlistRepository extends ChangeNotifier {
  WatchlistRepository({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  List<WatchlistEntry> _entries = [];
  Set<int> _movieIds = {};

  /// Immutable snapshot of the current watchlist, newest first.
  List<WatchlistEntry> get entries => List.unmodifiable(_entries);

  /// Returns `true` if the movie with [movieId] is in the watchlist.
  ///
  /// Uses an in-memory [Set] for O(1) lookup without touching the DB.
  bool isInWatchlist(int movieId) => _movieIds.contains(movieId);

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------

  /// Loads the watchlist for [userId] from the database.
  ///
  /// Should be called once after a successful login / session restore.
  Future<void> load(int userId) async {
    try {
      _entries = await _db.getWatchlist(userId);
      _movieIds = _entries.map((e) => e.movieId).toSet();
      notifyListeners();
    } catch (e) {
      log('Failed to load watchlist: $e', name: 'WatchlistRepository');
    }
  }

  /// Adds [movie] to the watchlist of [userId].
  ///
  /// If the movie is already present, the existing row is updated silently
  /// (no duplicate is created).
  Future<void> add(int userId, TmdbMovieDetails movie) async {
    try {
      final companion = WatchlistEntriesCompanion.insert(
        userId: userId,
        movieId: movie.id,
        title: movie.title,
        posterPath: Value(movie.posterPath),
        year: Value(movie.year),
        voteAverage: Value(movie.voteAverage),
        addedAt: DateTime.now(),
      );
      await _db.addToWatchlist(companion);
      await load(userId);
    } catch (e) {
      log('Failed to add to watchlist: $e', name: 'WatchlistRepository');
      rethrow;
    }
  }

  /// Removes the movie with [movieId] from [userId]'s watchlist.
  Future<void> remove(int userId, int movieId) async {
    try {
      await _db.removeFromWatchlist(userId, movieId);
      _entries = _entries.where((e) => e.movieId != movieId).toList();
      _movieIds.remove(movieId);
      notifyListeners();
    } catch (e) {
      log('Failed to remove from watchlist: $e', name: 'WatchlistRepository');
      rethrow;
    }
  }

  /// Clears the in-memory watchlist without touching the database.
  ///
  /// Called on logout so a subsequent user sees a clean state.
  void clear() {
    _entries = [];
    _movieIds = {};
    notifyListeners();
  }
}
