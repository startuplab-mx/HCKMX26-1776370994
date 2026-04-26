import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository(this._client);
  final SupabaseClient _client;
  User? get currentUser => _client.auth.currentUser;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String nickname,
    required String ageRange,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'nickname': nickname,
        'age_range': ageRange,
      },
    );
  }
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  Future<void> resetPassword(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }
  Future<void> signOut() {
    return _client.auth.signOut();
  }
}