class Profile {
  final DateTime updatedAt;
  final String username;
  final String? fullName;
  final String? avatarUrl;
  final DateTime birthDate;
  final int countryId;

  Profile({
    required this.updatedAt,
    required this.username,
    this.fullName,
    this.avatarUrl,
    required this.birthDate,
    required this.countryId,
  });

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        updatedAt: DateTime.parse(json['updated_at'] as String),
        username: json['username'] as String,
        fullName: json['full_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        birthDate: DateTime.parse(json['birth_date'] as String),
        countryId: json['country_id'] as int,
      );

  Map<String, dynamic> toMap() => {
        'updated_at': updatedAt.toIso8601String(),
        'username': username,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'birth_date': birthDate.toIso8601String(),
        'country_id': countryId,
      };
}
