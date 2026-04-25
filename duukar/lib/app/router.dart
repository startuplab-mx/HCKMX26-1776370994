import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    _route(AppRoutes.splash, 'splash', 'Splash', 'Pantalla inicial de Duukar'),
    _route(
      AppRoutes.welcome,
      'welcome',
      'Bienvenida', // title <- solo demo
      'Portada y acceso inicial', // subtitle <- tmb solo demo
    ),
    _route(AppRoutes.login, 'login', 'Inicia sesión', 'Acceso de usuario'),
    _route(
      AppRoutes.register,
      'register',
      'Crear cuenta',
      'Registro de usuario',
    ),
    _route(
      AppRoutes.forgotPassword,
      'forgot-password',
      'Recuperar contraseña',
      'Flujo de recuperación',
    ),
    _route(
      AppRoutes.verifyAccount,
      'verify-account',
      'Verificar cuenta',
      'Confirmación inicial',
    ),
    _route(
      AppRoutes.introDuki,
      'intro-duki',
      'Conoce a Duki',
      'Presentación del asistente',
    ),
    _route(
      AppRoutes.navigationTutorial,
      'navigation-tutorial',
      'Tutorial',
      'Espacios principales de la app',
    ),
    _route(
      AppRoutes.mandatoryLesson1,
      'mandatory-lesson-1',
      'Lección 1',
      'Clase obligatoria inicial',
    ),
    _route(
      AppRoutes.mandatoryLesson2,
      'mandatory-lesson-2',
      'Lección 2',
      'Señales de alerta',
    ),
    _route(
      AppRoutes.mandatoryLesson3,
      'mandatory-lesson-3',
      'Lección 3',
      'Decisiones seguras',
    ),
    _route(
      AppRoutes.reward,
      'reward',
      'Recompensa',
      'Primera misión completada',
    ),
    _route(AppRoutes.homeKids, 'home-kids', 'Home 6-11', 'Inicio infantil'),
    _route(
      AppRoutes.homeTeens,
      'home-teens',
      'Home 12-17',
      'Inicio adolescentes',
    ),
    _route(
      AppRoutes.askDuki,
      'ask-duki',
      'Pregúntale a Duki',
      'Consulta captura, enlace o texto',
    ),
    _route(
      AppRoutes.analysisType,
      'analysis-type',
      'Tipo de análisis',
      'Modo Radar de humo',
    ),
    _route(
      AppRoutes.analyzing,
      'analyzing',
      'Analizando',
      'Procesando contenido',
    ),
    _route(
      AppRoutes.analysisResult,
      'analysis-result',
      'Resultado',
      'Riesgo, señales y explicación',
    ),
    _route(
      AppRoutes.reportForm,
      'report-form',
      'Reportar',
      'Formulario de reporte',
    ),
    _route(
      AppRoutes.reportsHistory,
      'reports-history',
      'Historial de reportes',
      'Reportes enviados',
    ),
    _route(
      AppRoutes.achievements,
      'achievements',
      'Logros',
      'Insignias y avance',
    ),
    _route(AppRoutes.shop, 'shop', 'Tienda Duki', 'Skins y personalización'),
    _route(
      AppRoutes.progress,
      'progress',
      'Tu progreso',
      'Nivel, racha y módulos',
    ),
    _route(
      AppRoutes.settings,
      'settings',
      'Configuración',
      'Perfil y privacidad',
    ),
  ],
);

GoRoute _route(String path, String name, String title, String subtitle) {
  return GoRoute(
    path: path,
    name: name,
    builder: (context, state) =>
        _RoutePlaceholderScreen(title: title, subtitle: subtitle),
  );
}

class _RoutePlaceholderScreen extends StatelessWidget {
  const _RoutePlaceholderScreen({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
