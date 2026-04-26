/// Represents a row from the `profiles` table in Supabase.
///
/// Only the fields that are actually used in the UI are mapped here;
/// everything else is ignored so we stay hackathon-lean.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.nickname,
    this.coins = 0,
    this.currentLevel = 1,
    this.streakDays = 0,
    this.ageRange,
  });

  final String id;
  final String nickname;
  final int coins;
  final int currentLevel;
  final int streakDays;
  final String? ageRange;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String? ?? '',
      nickname: (map['nickname'] as String?)?.trim().isNotEmpty == true
          ? map['nickname'] as String
          : 'Explorador',
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      currentLevel: (map['current_level'] as num?)?.toInt() ?? 1,
      streakDays: (map['streak_days'] as num?)?.toInt() ?? 0,
      ageRange: map['age_range'] as String?,
    );
  }

  /// Fallback when the DB row does not exist yet (new users).
  factory UserProfile.empty(String id, {String? nickname}) {
    return UserProfile(id: id, nickname: nickname ?? 'Explorador');
  }
}
