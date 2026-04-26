import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_model.dart';

/// Reads profile data from the `profiles` table.
///
/// The `profiles` table is expected to have at minimum:
///   id (uuid, FK → auth.users.id)
///   nickname (text)
///   coins (int, default 0)
///   current_level (int, default 1)
///   streak_days (int, default 0)
///   age_range (text, nullable)
class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  /// Fetch the profile for the given [userId].
  ///
  /// Returns [UserProfile.empty] if the row does not exist yet (graceful
  /// fallback so new users don't crash the home screen).
  Future<UserProfile> fetchProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      // Try to get a display name from auth metadata as fallback.
      final meta = _client.auth.currentUser?.userMetadata;
      final fallbackNickname = meta?['nickname'] as String?;
      return UserProfile.empty(userId, nickname: fallbackNickname);
    }

    return UserProfile.fromMap(response);
  }
}
