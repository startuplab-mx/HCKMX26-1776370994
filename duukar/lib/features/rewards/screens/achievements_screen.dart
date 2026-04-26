import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/nav_helper.dart';
import '../../../core/widgets/app_bottom_nav.dart';

// ---------------------------------------------------------------------------
// Mock data — swap for real backend models
// ---------------------------------------------------------------------------

class _BadgeData {
  const _BadgeData({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.isUnlocked,
  });
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool isUnlocked;
}

// TODO: obtener logros desde RewardsRepository
final _mockBadges = <_BadgeData>[
  const _BadgeData(
    title: 'Navegante Seguro',
    description: 'Navegaste con seguridad 7 días seguidos.',
    icon: Icons.shield_rounded,
    iconColor: Color(0xFF2D81FF),
    bgColor: Color(0xFFDDEEFF),
    isUnlocked: true,
  ),
  const _BadgeData(
    title: 'Experto en Privacidad',
    description: 'Configuraste todos los ajustes de privacidad correctamente.',
    icon: Icons.lock_rounded,
    iconColor: Color(0xFFF4B740),
    bgColor: Color(0xFFFFF0D6),
    isUnlocked: true,
  ),
  const _BadgeData(
    title: 'Reacción Rápida',
    description: 'Resolviste una alerta de seguridad en menos de 5 segundos.',
    icon: Icons.bolt_rounded,
    iconColor: Color(0xFF8B6EF5),
    bgColor: Color(0xFFEFEBFF),
    isUnlocked: true,
  ),
  const _BadgeData(
    title: 'Aliado de la Red',
    description: 'Te conectaste de forma segura con 3 amigos.',
    icon: Icons.people_rounded,
    iconColor: Color(0xFF46B97A),
    bgColor: Color(0xFFDFF5EB),
    isUnlocked: true,
  ),
  const _BadgeData(
    title: 'Duki Detective',
    description: 'Identificaste 5 amenazas en línea con Duki.',
    icon: Icons.search_rounded,
    iconColor: Color(0xFF2D81FF),
    bgColor: Color(0xFFDDEEFF),
    isUnlocked: true,
  ),
  const _BadgeData(
    title: 'Héroe del Reporte',
    description: 'Enviaste tu primer reporte de seguridad.',
    icon: Icons.flag_rounded,
    iconColor: Color(0xFFE35D6A),
    bgColor: Color(0xFFFDE8EA),
    isUnlocked: false,
  ),
  const _BadgeData(
    title: 'Maestro de Lecciones',
    description: 'Completaste todas las lecciones obligatorias.',
    icon: Icons.school_rounded,
    iconColor: Color(0xFFF4B740),
    bgColor: Color(0xFFFFF0D6),
    isUnlocked: false,
  ),
  const _BadgeData(
    title: 'Rey de la Racha',
    description: 'Mantuviste una racha de 30 días de seguridad.',
    icon: Icons.local_fire_department_rounded,
    iconColor: Color(0xFFE35D6A),
    bgColor: Color(0xFFFDE8EA),
    isUnlocked: false,
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Pantalla de recompensas e insignias del usuario.
/// Solo frontend — datos mockeados. TODO: conectar con RewardsRepository.
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  // TODO: conectar filtro/ordenamiento con RewardsRepository
  bool _showRecent = false;

  int get _currentNavIndex {
    final location = GoRouterState.of(context).uri.toString();
    final idx = NavHelper.indexForLocation(location);
    return idx < 0 ? 3 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => NavHelper.goToTab(context, i),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            _AchievementsHeader(),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Level Card ─────────────────────────────────────
                    // TODO: obtener nivel y XP de UserRepository
                    const _LevelCard(
                      level: 12,
                      title: 'Explorador',
                      xp: 750,
                      xpMax: 1000,
                    ),

                    const SizedBox(height: 16),

                    // ── Stats Row ──────────────────────────────────────
                    Row(
                      children: [
                        // TODO: obtener Puntaje de Seguridad de UserRepository
                        Expanded(
                          child: _StatCard(
                            label: 'Puntaje de Seguridad',
                            value: '98%',
                            icon: Icons.shield_outlined,
                            iconColor: const Color(0xFF2D81FF),
                            bgColor: const Color(0xFFE6F0FF),
                            valueFontSize: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // TODO: obtener total insignias de RewardsRepository
                        Expanded(
                          child: _StatCard(
                            label: 'Total Insignias',
                            value: '5 Ganadas',
                            icon: Icons.auto_awesome_rounded,
                            iconColor: const Color(0xFFF4B740),
                            bgColor: const Color(0xFFFFF3E0),
                            valueFontSize: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── Streak Card ────────────────────────────────────
                    // TODO: obtener racha de UserRepository
                    const _StreakCard(days: 12),

                    const SizedBox(height: 28),

                    // ── Tienda de Duki ─────────────────────────────────
                    _DukiShopBanner(
                      // TODO: navegar a shop screen real
                      onTap: () => context.go(AppRoutes.shop),
                    ),

                    const SizedBox(height: 28),

                    // ── Mis Logros header ──────────────────────────────
                    Row(
                      children: [
                        Text('Mis logros', style: AppTextStyles.titleMedium),
                        const Spacer(),
                        _FilterButton(
                          label: 'Filtrar',
                          active: false,
                          onTap: () {
                            // TODO: mostrar bottom sheet de filtros por categoría
                          },
                        ),
                        const SizedBox(width: 8),
                        _FilterButton(
                          label: 'Reciente',
                          active: _showRecent,
                          onTap: () =>
                              setState(() => _showRecent = !_showRecent),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Badge Grid ─────────────────────────────────────
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _mockBadges.length,
                      itemBuilder: (_, i) => _BadgeCard(data: _mockBadges[i]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AchievementsHeader
// ---------------------------------------------------------------------------

class _AchievementsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text('Duukar', style: AppTextStyles.titleAppBar),
          const Spacer(),
          // Coin circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF4B740),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF4B740).withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 12)),
                  Text(
                    '120',
                    // TODO: obtener monedas de UserRepository
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontFamily: 'Fredoka',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _LevelCard
// ---------------------------------------------------------------------------

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.title,
    required this.xp,
    required this.xpMax,
  });

  final int level;
  final String title;
  final int xp;
  final int xpMax;

  @override
  Widget build(BuildContext context) {
    final progress = xp / xpMax;
    final remaining = xpMax - xp;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Color(0xFF2D81FF),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nivel $level: $title',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Te faltan $remaining XP para el Nivel ${level + 1}!',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Nivel $level',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '$xp / $xpMax XP',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE9F2FA),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StatCard
// ---------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.valueFontSize,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final double valueFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _StreakCard
// ---------------------------------------------------------------------------

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.days});
  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFF2D81FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Racha Segura',
                style: AppTextStyles.labelSmall.copyWith(
                  color: const Color(0xFF2D81FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$days Días',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFE35D6A),
            size: 28,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FilterButton
// ---------------------------------------------------------------------------

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: active ? AppColors.primaryPressed : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BadgeCard
// ---------------------------------------------------------------------------

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.data});
  final _BadgeData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: data.isUnlocked ? AppColors.border : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge icon with check overlay
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: data.isUnlocked
                      ? data.bgColor
                      : AppColors.muted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.icon,
                  color: data.isUnlocked
                      ? data.iconColor
                      : AppColors.textSecondary.withOpacity(0.4),
                  size: 30,
                ),
              ),
              if (data.isUnlocked)
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF46B97A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              if (!data.isUnlocked)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.textSecondary,
                    size: 12,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            data.title,
            style: AppTextStyles.labelLarge.copyWith(
              fontSize: 14,
              color: data.isUnlocked
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            data.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.3,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DukiShopBanner
// ---------------------------------------------------------------------------

class _DukiShopBanner extends StatelessWidget {
  const _DukiShopBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6ECBF5), // AppColors.primary
              Color(0xFF2D81FF), // deep blue
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D81FF).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Círculo decorativo fondo
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: 60,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // Duki image centrada verticalmente a la derecha
            Positioned(
              right: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: Image.asset(
                  'assets/img/duki_modista.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Sparkles decorativas
            const Positioned(
              top: 12,
              right: 120,
              child: Text('✨', style: TextStyle(fontSize: 16)),
            ),
            const Positioned(
              bottom: 14,
              right: 130,
              child: Text('⭐', style: TextStyle(fontSize: 11)),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 140, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NUEVO',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tienda de Duki',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Skins, accesorios y más 🛍️',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
