import 'package:mega_movies/data/models/tmdb_cast_member.dart';

/// Full movie details returned by the TMDB `/movie/{id}` endpoint.
///
/// The [credits] field is only populated when the request uses
/// `append_to_response=credits`.
final class TmdbMovieDetails {
  const TmdbMovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.runtime,
    required this.genres,
    required this.credits,
    this.posterPath,
    this.backdropPath,
    this.tagline,
  });

  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final double voteAverage;

  /// Runtime in minutes. Zero when unavailable.
  final int runtime;
  final List<String> genres;

  /// Top-billed cast members. Empty when credits were not requested.
  final List<TmdbCastMember> credits;

  final String? posterPath;
  final String? backdropPath;
  final String? tagline;

  /// Constructs the full poster URL for a given [size].
  String? posterUrl([String size = 'w500']) =>
      posterPath != null ? 'https://image.tmdb.org/t/p/$size$posterPath' : null;

  /// Constructs the full backdrop URL for a given [size].
  String? backdropUrl([String size = 'w1280']) => backdropPath != null
      ? 'https://image.tmdb.org/t/p/$size$backdropPath'
      : null;

  /// Release year extracted from [releaseDate], or null when unavailable.
  int? get year {
    if (releaseDate.length < 4) return null;
    return int.tryParse(releaseDate.substring(0, 4));
  }

  /// Formats [runtime] as "Xh Ym".
  String get formattedRuntime {
    if (runtime <= 0) return '—';
    final h = runtime ~/ 60;
    final m = runtime % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  factory TmdbMovieDetails.fromJson(Map<String, dynamic> json) {
    final genreList = json['genres'] as List<dynamic>? ?? [];
    final castList =
        (json['credits'] as Map<String, dynamic>?)?['cast'] as List<dynamic>? ??
        [];

    return TmdbMovieDetails(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      runtime: json['runtime'] as int? ?? 0,
      genres: genreList
          .whereType<Map<String, dynamic>>()
          .map((g) => g['name'] as String? ?? '')
          .where((name) => name.isNotEmpty)
          .toList(),
      credits: castList
          .whereType<Map<String, dynamic>>()
          .take(10)
          .map(TmdbCastMember.fromJson)
          .toList(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      tagline: json['tagline'] as String?,
    );
  }
}
