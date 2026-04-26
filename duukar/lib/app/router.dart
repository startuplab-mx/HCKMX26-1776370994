import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/verify_account_screen.dart';
import '../features/onboarding/screens/intro_duki_screen.dart';
import '../features/onboarding/screens/navigation_tutorial_screen.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/lessons/screens/mandatory_lesson_1_screen.dart';
import '../features/lessons/screens/mandatory_lesson_2_screen.dart';
import '../features/lessons/screens/mandatory_lesson_3_screen.dart';
import '../features/lessons/screens/reward_screen.dart';
import '../features/home/screens/home_kids_screen.dart';
import '../features/analysis/screens/ask_duki_screen.dart';
import '../features/analysis/screens/analysis_result_screen.dart';
import '../features/analysis/analysis_model.dart';
import '../features/reports/screens/report_form_screen.dart';
import '../features/rewards/screens/achievements_screen.dart';

import '../core/utils/nav_helper.dart';
import '../core/widgets/app_bottom_nav.dart';
import 'theme/app_text_styles.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verifyAccount = '/verify-account';
  static const introDuki = '/intro-duki';
  static const navigationTutorial = '/navigation-tutorial';
  static const mandatoryLesson1 = '/mandatory-lesson-1';
  static const mandatoryLesson2 = '/mandatory-lesson-2';
  static const mandatoryLesson3 = '/mandatory-lesson-3';
  static const reward = '/reward';
  static const homeKids = '/home-kids';
  static const homeTeens = '/home-teens';
  static const askDuki = '/ask-duki';
  static const analysisType = '/analysis-type';
  static const analyzing = '/analyzing';
  static const analysisResult = '/analysis-result';
  static const reportForm = '/report-form';
  static const reportsHistory = '/reports-history';
  static const achievements = '/achievements';
  static const shop = '/shop';
  static const progress = '/progress';
  static const settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // ── Onboarding ──────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      name: 'welcome',
      builder: (_, __) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.introDuki,
      name: 'intro-duki',
      builder: (_, __) => const IntroDukiScreen(),
    ),
    GoRoute(
      path: AppRoutes.navigationTutorial,
      name: 'navigation-tutorial',
      builder: (_, __) => const NavigationTutorialScreen(),
    ),

    // ── Auth ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyAccount,
      name: 'verify-account',
      builder: (_, __) => const VerifyAccountScreen(),
    ),

    // ── Lessons & Post-onboarding (placeholders) ─────────────────────
    GoRoute(
      path: AppRoutes.mandatoryLesson1,
      name: 'mandatory-lesson-1',
      builder: (_, __) => const MandatoryLesson1Screen(),
    ),
    GoRoute(
      path: AppRoutes.mandatoryLesson2,
      name: 'mandatory-lesson-2',
      builder: (_, __) => const MandatoryLesson2Screen(),
    ),
    GoRoute(
      path: AppRoutes.mandatoryLesson3,
      name: 'mandatory-lesson-3',
      builder: (_, __) => const MandatoryLesson3Screen(),
    ),
    GoRoute(
      path: AppRoutes.reward,
      name: 'reward',
      builder: (_, __) => const RewardScreen(),
    ),

    // ── Home ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.homeKids,
      name: 'home-kids',
      builder: (_, __) => const HomeKidsScreen(),
    ),
    _placeholder(
      AppRoutes.homeTeens,
      'home-teens',
      'Home 12-17',
      'Inicio adolescentes',
    ),

    // ── Features ─────────────────────────────────────────────────────
    // Tab-root for Ask Duki — real implementation with tutorial flow.
    GoRoute(
      path: AppRoutes.askDuki,
      name: 'ask-duki',
      builder: (_, __) => const AskDukiScreen(),
    ),
    _placeholder(
      AppRoutes.analysisType,
      'analysis-type',
      'Tipo de análisis',
      'Modo Radar de humo',
    ),
    _placeholder(
      AppRoutes.analyzing,
      'analyzing',
      'Analizando',
      'Procesando contenido',
    ),
    GoRoute(
      path: AppRoutes.analysisResult,
      name: 'analysis-result',
      builder: (context, state) {
        final result = state.extra as AnalysisResult?;
        if (result == null) {
          // Fallback if someone navigates here directly without a result
          return _RoutePlaceholderScreen(
            title: 'Resultado',
            subtitle: 'No hay resultado disponible.',
          );
        }
        return AnalysisResultScreen(result: result);
      },
    ),
    // Tab-root for Reportar
    GoRoute(
      path: AppRoutes.reportForm,
      name: 'report-form',
      builder: (_, __) => const ReportFormScreen(),
    ),
    _placeholder(
      AppRoutes.reportsHistory,
      'reports-history',
      'Historial de reportes',
      'Reportes enviados',
    ),
    // Tab-root for Recompensas
    GoRoute(
      path: AppRoutes.achievements,
      name: 'achievements',
      builder: (_, __) => const AchievementsScreen(),
    ),
    _placeholder(
      AppRoutes.shop,
      'shop',
      'Tienda Duki',
      'Skins y personalización',
    ),
    _placeholder(
      AppRoutes.progress,
      'progress',
      'Tu progreso',
      'Nivel, racha y módulos',
    ),
    _placeholder(
      AppRoutes.settings,
      'settings',
      'Configuración',
      'Perfil y privacidad',
    ),
  ],
);

GoRoute _placeholder(String path, String name, String title, String subtitle) {
  return GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        _RoutePlaceholderScreen(title: title, subtitle: subtitle),
  );
}

/// Placeholder for screens that are tab-roots in the bottom nav.
/// Shows [AppBottomNav] so users can navigate back to other tabs.
GoRoute _navPlaceholder(
  String path,
  String name,
  String title,
  String subtitle,
) {
  return GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        _NavPlaceholderScreen(title: title, subtitle: subtitle),
  );
}

// ---------------------------------------------------------------------------
// Placeholder screens
// ---------------------------------------------------------------------------

class _RoutePlaceholderScreen extends StatelessWidget {
  const _RoutePlaceholderScreen({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '🚧 En construcción',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Like [_RoutePlaceholderScreen] but includes [AppBottomNav].
/// Used for the three non-home tab-root routes so navigation is consistent.
class _NavPlaceholderScreen extends StatelessWidget {
  const _NavPlaceholderScreen({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final currentIndex = NavHelper.indexForLocation(
      GoRouterState.of(context).uri.toString(),
    );

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        onTap: (i) => NavHelper.goToTab(context, i),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '🚧 En construcción',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
