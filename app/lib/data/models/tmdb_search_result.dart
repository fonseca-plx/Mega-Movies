/// Lightweight model for a single result from the TMDB search/movie endpoints.
///
/// Maps the fields most commonly used across the app for list and grid displays.
final class TmdbSearchResult {
  const TmdbSearchResult({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    this.posterPath,
    this.backdropPath,
  });

  final int id;
  final String title;

  /// ISO 8601 date string (e.g. "1994-07-06"). May be empty for unreleased films.
  final String releaseDate;
  final double voteAverage;

  /// Relative poster path returned by TMDB (e.g. "/abc.jpg"). Null when absent.
  final String? posterPath;

  /// Relative backdrop path returned by TMDB. Null when absent.
  final String? backdropPath;

  /// Constructs the full poster URL for a given [size].
  ///
  /// Recommended sizes: `w92`, `w154`, `w185`, `w342`, `w500`, `w780`, `original`.
  String? posterUrl([String size = 'w342']) =>
      posterPath != null ? 'https://image.tmdb.org/t/p/$size$posterPath' : null;

  /// Constructs the full backdrop URL for a given [size].
  ///
  /// Recommended sizes: `w300`, `w780`, `w1280`, `original`.
  String? backdropUrl([String size = 'w780']) => backdropPath != null
      ? 'https://image.tmdb.org/t/p/$size$backdropPath'
      : null;

  /// Release year extracted from [releaseDate], or null when unavailable.
  int? get year {
    if (releaseDate.length < 4) return null;
    return int.tryParse(releaseDate.substring(0, 4));
  }

  factory TmdbSearchResult.fromJson(Map<String, dynamic> json) {
    return TmdbSearchResult(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      releaseDate: json['release_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }
}
