/// A single cast member returned by the TMDB `/movie/{id}/credits` endpoint.
final class TmdbCastMember {
  const TmdbCastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  final int id;
  final String name;

  /// The character name played by this cast member.
  final String character;

  /// Relative path returned by TMDB (e.g. "/abc123.jpg"). Null when unavailable.
  final String? profilePath;

  /// Constructs the full profile image URL for a given [size].
  ///
  /// Recommended sizes: `w45`, `w185`, `h632`, `original`.
  String? profileUrl([String size = 'w185']) => profilePath != null
      ? 'https://image.tmdb.org/t/p/$size$profilePath'
      : null;

  factory TmdbCastMember.fromJson(Map<String, dynamic> json) {
    return TmdbCastMember(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}
