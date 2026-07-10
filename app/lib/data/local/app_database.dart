import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Drift table definition for the user's watchlist.
///
/// The `UNIQUE(userId, movieId)` constraint prevents duplicate entries
/// and is enforced at the database level via [insertOnConflictUpdate].
class WatchlistEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get movieId => integer()();
  TextColumn get title => text()();
  TextColumn get posterPath => text().nullable()();
  IntColumn get year => integer().nullable()();
  RealColumn get voteAverage => real().withDefault(const Constant(0))();
  DateTimeColumn get addedAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {userId, movieId},
  ];
}

/// Application-level SQLite database managed by Drift.
///
/// Uses [driftDatabase] which automatically selects the correct backend:
/// - **Web**: OPFS-based SQLite via WASM
/// - **Android / iOS**: native SQLite file
@DriftDatabase(tables: [WatchlistEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() =>
      driftDatabase(name: 'mega_movies_db');

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Returns all watchlist entries for [userId], newest first.
  Future<List<WatchlistEntry>> getWatchlist(int userId) =>
      (select(watchlistEntries)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
          .get();

  /// Inserts [entry] or replaces the existing row if the (userId, movieId) pair
  /// already exists.
  Future<void> addToWatchlist(WatchlistEntriesCompanion entry) =>
      into(watchlistEntries).insertOnConflictUpdate(entry);

  /// Removes the entry for [movieId] belonging to [userId].
  Future<void> removeFromWatchlist(int userId, int movieId) => (delete(
    watchlistEntries,
  )..where((t) => t.userId.equals(userId) & t.movieId.equals(movieId))).go();

  /// Returns `true` if [movieId] is in [userId]'s watchlist.
  Future<bool> isInWatchlist(int userId, int movieId) async {
    final entry =
        await (select(watchlistEntries)..where(
              (t) => t.userId.equals(userId) & t.movieId.equals(movieId),
            ))
            .getSingleOrNull();
    return entry != null;
  }
}
