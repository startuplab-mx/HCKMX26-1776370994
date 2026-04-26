import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/app_supabase.dart';
import '../../../core/utils/local_prefs.dart';

/// Splash screen — auto-navigates to the correct destination after a short
/// delay depending on session state and onboarding flags:
///
///   No authenticated user:
///     welcome_seen == false  → /welcome
///     welcome_seen == true   → /login
///
///   Authenticated user:
///     duki_intro_seen == false            → /intro-duki
///     navigation_tutorial_seen == false   → /navigation-tutorial
///     mandatory_lessons_completed == false → /mandatory-lesson-1
///     else                                → homeKids (6-11) | homeTeens (12+)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    final user = AppSupabase.currentUser;

    if (user == null) {
      // ── Unauthenticated ──────────────────────────────────────────────────
      final welcomeSeen = await LocalPrefs.isWelcomeSeen();
      if (!mounted) return;
      context.go(welcomeSeen ? AppRoutes.login : AppRoutes.welcome);
      return;
    }

    // ── Authenticated — check onboarding steps in order ──────────────────
    final dukiIntroSeen = await LocalPrefs.isDukiIntroSeen();
    if (!mounted) return;
    if (!dukiIntroSeen) {
      context.go(AppRoutes.introDuki);
      return;
    }

    final navTutorialSeen = await LocalPrefs.isNavigationTutorialSeen();
    if (!mounted) return;
    if (!navTutorialSeen) {
      context.go(AppRoutes.navigationTutorial);
      return;
    }

    final lessonsCompleted = await LocalPrefs.isMandatoryLessonsCompleted();
    if (!mounted) return;
    if (!lessonsCompleted) {
      context.go(AppRoutes.mandatoryLesson1);
      return;
    }

    // ── All onboarding done — route by age ───────────────────────────────
    context.go(AppSupabase.homeRouteForCurrentUser());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / mascota Duki de frente
              Image.asset(
                'assets/img/duukar_logo.png',
                width: 180,
                fit: BoxFit.contain,
              ),
              Text(
                'Duukar',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 40,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'versión 0.1.0',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
