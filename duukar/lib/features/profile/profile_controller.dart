import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_supabase.dart';
import 'profile_model.dart';
import 'profile_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(AppSupabase.client);
});

// ---------------------------------------------------------------------------
// Profile async provider
//
// Returns AsyncValue<UserProfile?> where null means "no user signed in".
// ---------------------------------------------------------------------------

final profileProvider = FutureProvider<UserProfile?>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;

  final repo = ref.read(profileRepositoryProvider);
  return repo.fetchProfile(userId);
});
