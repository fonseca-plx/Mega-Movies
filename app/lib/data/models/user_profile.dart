/// Immutable domain model for the signed-in user's profile.
///
/// Maps to the `UserPublic` schema returned by the `/auth/me` and
/// `/auth/login` endpoints.
final class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.joinedAt,
    this.photo,
  });

  final int id;
  final String fullName;
  final String? photo;
  final String email;
  final DateTime joinedAt;

  /// The first letter of [fullName], used as a fallback avatar.
  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }
}
