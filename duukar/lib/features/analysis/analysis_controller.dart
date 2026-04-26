import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'analysis_model.dart';
import 'analysis_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final analysisRepositoryProvider = Provider<AnalysisRepository>((_) {
  return AnalysisRepository();
});

// ---------------------------------------------------------------------------
// State model
// ---------------------------------------------------------------------------

class AnalysisState {
  const AnalysisState({this.isLoading = false, this.result, this.errorMessage});

  final bool isLoading;
  final AnalysisResult? result;
  final String? errorMessage;

  bool get hasResult => result != null;
  bool get hasError => errorMessage != null;

  AnalysisState copyWith({
    bool? isLoading,
    AnalysisResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return AnalysisState(
      isLoading: isLoading ?? this.isLoading,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

class AnalysisController extends StateNotifier<AnalysisState> {
  AnalysisController(this._repo) : super(const AnalysisState());

  final AnalysisRepository _repo;

  // ── Public API ──────────────────────────────────────────────────────────

  /// Analyze a plain text string.
  /// Returns the [AnalysisResult] on success, or null on error.
  Future<AnalysisResult?> analyzeText(String text) async {
    state = state.copyWith(
      isLoading: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final result = await _repo.analyzeText(text);

      // Fire-and-forget save to Supabase
      unawaited(
        _repo.saveAnalysis(
          result: result,
          inputType: AnalysisInputType.text,
          sourceText: text.length > 2000 ? text.substring(0, 2000) : text,
        ),
      );

      state = state.copyWith(isLoading: false, result: result);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _humanizeError(e));
      return null;
    }
  }

  /// Analyze an image file.
  /// Returns the [AnalysisResult] on success, or null on error.
  Future<AnalysisResult?> analyzeImage(File imageFile) async {
    state = state.copyWith(
      isLoading: true,
      clearResult: true,
      clearError: true,
    );

    try {
      final result = await _repo.analyzeImage(imageFile);

      // Fire-and-forget save to Supabase
      unawaited(
        _repo.saveAnalysis(result: result, inputType: AnalysisInputType.image),
      );

      state = state.copyWith(isLoading: false, result: result);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _humanizeError(e));
      return null;
    }
  }

  /// Reset state (e.g. when navigating back to start a new analysis).
  void reset() {
    state = const AnalysisState();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  String _humanizeError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Connection refused')) {
      return 'Sin conexión a internet. Revisá tu red e intentá de nuevo.';
    }
    if (msg.contains('TimeoutException')) {
      return 'Duki tardó demasiado en responder. Intentá de nuevo.';
    }
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Error de autenticación con el servicio de análisis.';
    }
    if (msg.contains('429')) {
      return 'Demasiadas solicitudes. Esperá un momento e intentá de nuevo.';
    }
    if (msg.contains('vacío') || msg.contains('empty')) {
      return 'Por favor ingresá texto o una imagen para analizar.';
    }
    return 'Ocurrió un error al analizar. Intentá de nuevo.';
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final analysisControllerProvider =
    StateNotifierProvider<AnalysisController, AnalysisState>((ref) {
      final repo = ref.watch(analysisRepositoryProvider);
      return AnalysisController(repo);
    });

// ---------------------------------------------------------------------------
// Dart helper (not yet in dart:async in older SDKs — inline it)
// ---------------------------------------------------------------------------

void unawaited(Future<void> future) {
  // intentionally unawaited
}
