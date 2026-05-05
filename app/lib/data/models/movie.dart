/// Immutable domain model for a movie.
final class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.duration,
    required this.rating,
    required this.genres,
    required this.synopsis,
    required this.director,
    required this.posterUrl,
    required this.backdropUrl,
    required this.cast,
    this.ageRating = 'PG',
  });

  final String id;
  final String title;
  final int year;

  /// Runtime in minutes.
  final int duration;
  final double rating;
  final List<String> genres;
  final String synopsis;
  final String director;
  final String posterUrl;
  final String backdropUrl;
  final List<CastMember> cast;
  final String ageRating;

  /// Formats [duration] as "Xh Ym".
  String get formattedDuration {
    final h = duration ~/ 60;
    final m = duration % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

/// Immutable model for a single cast member.
final class CastMember {
  const CastMember({
    required this.name,
    required this.character,
    required this.photoUrl,
  });

  final String name;
  final String character;
  final String photoUrl;
}
