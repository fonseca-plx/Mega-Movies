/// A movie genre returned by the TMDB `/genre/movie/list` endpoint.
final class TmdbGenre {
  const TmdbGenre({required this.id, required this.name});

  final int id;
  final String name;

  factory TmdbGenre.fromJson(Map<String, dynamic> json) {
    return TmdbGenre(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}
