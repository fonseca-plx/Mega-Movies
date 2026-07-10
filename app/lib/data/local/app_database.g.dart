// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WatchlistEntriesTable extends WatchlistEntries
    with TableInfo<$WatchlistEntriesTable, WatchlistEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchlistEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voteAverageMeta = const VerificationMeta(
    'voteAverage',
  );
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
    'vote_average',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    movieId,
    title,
    posterPath,
    year,
    voteAverage,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watchlist_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchlistEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('vote_average')) {
      context.handle(
        _voteAverageMeta,
        voteAverage.isAcceptableOrUnknown(
          data['vote_average']!,
          _voteAverageMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, movieId},
  ];
  @override
  WatchlistEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchlistEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      voteAverage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vote_average'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $WatchlistEntriesTable createAlias(String alias) {
    return $WatchlistEntriesTable(attachedDatabase, alias);
  }
}

class WatchlistEntry extends DataClass implements Insertable<WatchlistEntry> {
  final int id;
  final int userId;
  final int movieId;
  final String title;
  final String? posterPath;
  final int? year;
  final double voteAverage;
  final DateTime addedAt;
  const WatchlistEntry({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.title,
    this.posterPath,
    this.year,
    required this.voteAverage,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['movie_id'] = Variable<int>(movieId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['vote_average'] = Variable<double>(voteAverage);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  WatchlistEntriesCompanion toCompanion(bool nullToAbsent) {
    return WatchlistEntriesCompanion(
      id: Value(id),
      userId: Value(userId),
      movieId: Value(movieId),
      title: Value(title),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      voteAverage: Value(voteAverage),
      addedAt: Value(addedAt),
    );
  }

  factory WatchlistEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchlistEntry(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      movieId: serializer.fromJson<int>(json['movieId']),
      title: serializer.fromJson<String>(json['title']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      year: serializer.fromJson<int?>(json['year']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'movieId': serializer.toJson<int>(movieId),
      'title': serializer.toJson<String>(title),
      'posterPath': serializer.toJson<String?>(posterPath),
      'year': serializer.toJson<int?>(year),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  WatchlistEntry copyWith({
    int? id,
    int? userId,
    int? movieId,
    String? title,
    Value<String?> posterPath = const Value.absent(),
    Value<int?> year = const Value.absent(),
    double? voteAverage,
    DateTime? addedAt,
  }) => WatchlistEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    movieId: movieId ?? this.movieId,
    title: title ?? this.title,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    year: year.present ? year.value : this.year,
    voteAverage: voteAverage ?? this.voteAverage,
    addedAt: addedAt ?? this.addedAt,
  );
  WatchlistEntry copyWithCompanion(WatchlistEntriesCompanion data) {
    return WatchlistEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      title: data.title.present ? data.title.value : this.title,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      year: data.year.present ? data.year.value : this.year,
      voteAverage: data.voteAverage.present
          ? data.voteAverage.value
          : this.voteAverage,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchlistEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('movieId: $movieId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('year: $year, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    movieId,
    title,
    posterPath,
    year,
    voteAverage,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchlistEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.movieId == this.movieId &&
          other.title == this.title &&
          other.posterPath == this.posterPath &&
          other.year == this.year &&
          other.voteAverage == this.voteAverage &&
          other.addedAt == this.addedAt);
}

class WatchlistEntriesCompanion extends UpdateCompanion<WatchlistEntry> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> movieId;
  final Value<String> title;
  final Value<String?> posterPath;
  final Value<int?> year;
  final Value<double> voteAverage;
  final Value<DateTime> addedAt;
  const WatchlistEntriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.movieId = const Value.absent(),
    this.title = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.year = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  WatchlistEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int movieId,
    required String title,
    this.posterPath = const Value.absent(),
    this.year = const Value.absent(),
    this.voteAverage = const Value.absent(),
    required DateTime addedAt,
  }) : userId = Value(userId),
       movieId = Value(movieId),
       title = Value(title),
       addedAt = Value(addedAt);
  static Insertable<WatchlistEntry> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? movieId,
    Expression<String>? title,
    Expression<String>? posterPath,
    Expression<int>? year,
    Expression<double>? voteAverage,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (movieId != null) 'movie_id': movieId,
      if (title != null) 'title': title,
      if (posterPath != null) 'poster_path': posterPath,
      if (year != null) 'year': year,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  WatchlistEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? movieId,
    Value<String>? title,
    Value<String?>? posterPath,
    Value<int?>? year,
    Value<double>? voteAverage,
    Value<DateTime>? addedAt,
  }) {
    return WatchlistEntriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      year: year ?? this.year,
      voteAverage: voteAverage ?? this.voteAverage,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchlistEntriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('movieId: $movieId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('year: $year, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WatchlistEntriesTable watchlistEntries = $WatchlistEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [watchlistEntries];
}

typedef $$WatchlistEntriesTableCreateCompanionBuilder =
    WatchlistEntriesCompanion Function({
      Value<int> id,
      required int userId,
      required int movieId,
      required String title,
      Value<String?> posterPath,
      Value<int?> year,
      Value<double> voteAverage,
      required DateTime addedAt,
    });
typedef $$WatchlistEntriesTableUpdateCompanionBuilder =
    WatchlistEntriesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> movieId,
      Value<String> title,
      Value<String?> posterPath,
      Value<int?> year,
      Value<double> voteAverage,
      Value<DateTime> addedAt,
    });

class $$WatchlistEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WatchlistEntriesTable> {
  $$WatchlistEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get voteAverage => $composableBuilder(
    column: $table.voteAverage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchlistEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchlistEntriesTable> {
  $$WatchlistEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voteAverage => $composableBuilder(
    column: $table.voteAverage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchlistEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchlistEntriesTable> {
  $$WatchlistEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
    column: $table.voteAverage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$WatchlistEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchlistEntriesTable,
          WatchlistEntry,
          $$WatchlistEntriesTableFilterComposer,
          $$WatchlistEntriesTableOrderingComposer,
          $$WatchlistEntriesTableAnnotationComposer,
          $$WatchlistEntriesTableCreateCompanionBuilder,
          $$WatchlistEntriesTableUpdateCompanionBuilder,
          (
            WatchlistEntry,
            BaseReferences<
              _$AppDatabase,
              $WatchlistEntriesTable,
              WatchlistEntry
            >,
          ),
          WatchlistEntry,
          PrefetchHooks Function()
        > {
  $$WatchlistEntriesTableTableManager(
    _$AppDatabase db,
    $WatchlistEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchlistEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchlistEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchlistEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> movieId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<double> voteAverage = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => WatchlistEntriesCompanion(
                id: id,
                userId: userId,
                movieId: movieId,
                title: title,
                posterPath: posterPath,
                year: year,
                voteAverage: voteAverage,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int movieId,
                required String title,
                Value<String?> posterPath = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<double> voteAverage = const Value.absent(),
                required DateTime addedAt,
              }) => WatchlistEntriesCompanion.insert(
                id: id,
                userId: userId,
                movieId: movieId,
                title: title,
                posterPath: posterPath,
                year: year,
                voteAverage: voteAverage,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchlistEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchlistEntriesTable,
      WatchlistEntry,
      $$WatchlistEntriesTableFilterComposer,
      $$WatchlistEntriesTableOrderingComposer,
      $$WatchlistEntriesTableAnnotationComposer,
      $$WatchlistEntriesTableCreateCompanionBuilder,
      $$WatchlistEntriesTableUpdateCompanionBuilder,
      (
        WatchlistEntry,
        BaseReferences<_$AppDatabase, $WatchlistEntriesTable, WatchlistEntry>,
      ),
      WatchlistEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WatchlistEntriesTableTableManager get watchlistEntries =>
      $$WatchlistEntriesTableTableManager(_db, _db.watchlistEntries);
}
