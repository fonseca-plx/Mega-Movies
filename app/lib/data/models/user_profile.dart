/// Immutable domain model for the signed-in user's profile.
final class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.moviesWatched,
    required this.memberSince,
    required this.watchlistIds,
  });

  final String id;
  final String displayName;
  final String avatarUrl;
  final int moviesWatched;
  final int memberSince;
  final List<String> watchlistIds;
}
