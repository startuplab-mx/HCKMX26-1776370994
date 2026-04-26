import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_supabase.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(AppSupabase.client);
});

class AuthStateModel {
  const AuthStateModel({this.isLoading = false, this.errorMessage});
  final bool isLoading;
  final String? errorMessage;
  AuthStateModel copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthStateModel(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthController extends StateNotifier<AuthStateModel> {
  AuthController(this._repository) : super(const AuthStateModel());
  final AuthRepository _repository;
  User? get currentUser => _repository.currentUser;
  Stream<AuthState> get authStateChanges => _repository.authStateChanges;
  Future<bool> signUp({
    required String email,
    required String password,
    required String nickname,
    required String ageRange,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signUp(
        email: email,
        password: password,
        nickname: nickname,
        ageRange: ageRange,
      );
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ocurrió un error inesperado.',
      );
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signIn(email: email, password: password);
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ocurrió un error inesperado.',
      );
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resetPassword(email);
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo enviar el correo.',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStateModel>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return AuthController(repository);
    });
