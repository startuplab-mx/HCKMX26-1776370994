import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/router.dart';

class AppSupabase {
  const AppSupabase._();

  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;

  /// Returns the correct home route based on the authenticated user's age range.
  ///
  /// Age range is stored as `age_range` in user metadata during sign-up.
  /// - `'6-11'`  → [AppRoutes.homeKids]
  /// - anything else (e.g. `'12-15'`) → [AppRoutes.homeTeens]
  ///
  /// Falls back to [AppRoutes.homeKids] if metadata is absent.
  static String homeRouteForCurrentUser() {
    final meta = currentUser?.userMetadata;
    final ageRange = meta?['age_range'] as String? ?? '';
    return ageRange == '6-11' ? AppRoutes.homeKids : AppRoutes.homeTeens;
  }
}
