import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/nav_helper.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/profile_bottom_sheet.dart';
import '../../../core/widgets/section_card.dart';
import '../../profile/profile_controller.dart';
import '../../profile/profile_model.dart';

// ---------------------------------------------------------------------------
// Mock data models — swap out for real data later
// ---------------------------------------------------------------------------

class _CapsuleData {
  const _CapsuleData({
    required this.title,
    required this.duration,
    required this.tag,
    required this.topColor,
    required this.tagColor,
  });

  final String title;
  final String duration;
  final String tag;
  final Color topColor;
  final Color tagColor;
}

class _MilestoneData {
  const _MilestoneData({required this.label, required this.isUnlocked});

  final String label;
  final bool isUnlocked;
}

// ---------------------------------------------------------------------------
// Constants (mock data — not yet backend-driven)
// ---------------------------------------------------------------------------

const _kLessonsCompleted = 3;
const _kLessonsTotal = 8;
const _kProgressPercent = 0.37; // 37 %

final _capsules = <_CapsuleData>[
  const _CapsuleData(
    title: 'Contraseñas\nseguras',
    duration: '5 min',
    tag: 'Básico',
    topColor: Color(0xFF6ECBF5), // AppColors.primary
    tagColor: Color(0xFF46B97A), // AppColors.success
  ),
  const _CapsuleData(
    title: 'Engaños\nen internet',
    duration: '7 min',
    tag: 'Intermedio',
    topColor: Color(0xFFF4B740), // AppColors.warning
    tagColor: Color(0xFFF4B740),
  ),
  const _CapsuleData(
    title: '¿Quién es\ntu amigo?',
    duration: '6 min',
    tag: 'Básico',
    topColor: Color(0xFF46B97A), // AppColors.success
    tagColor: Color(0xFF46B97A),
  ),
  const _CapsuleData(
    title: 'Privacidad\ndigital',
    duration: '8 min',
    tag: 'Avanzado',
    topColor: Color(0xFFE35D6A), // AppColors.danger
    tagColor: Color(0xFFE35D6A),
  ),
];

final _milestones = <_MilestoneData>[
  const _MilestoneData(label: '1', isUnlocked: true),
  const _MilestoneData(label: '2', isUnlocked: true),
  const _MilestoneData(label: '3', isUnlocked: true),
  const _MilestoneData(label: '4', isUnlocked: false),
  const _MilestoneData(label: '5', isUnlocked: false),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Pantalla principal para el segmento infantil (6–11 años).
/// Carga datos de perfil reales desde Supabase; mantiene cápsulas mock.
class HomeKidsScreen extends ConsumerStatefulWidget {
  const HomeKidsScreen({super.key});

  @override
  ConsumerState<HomeKidsScreen> createState() => _HomeKidsScreenState();
}

class _HomeKidsScreenState extends ConsumerState<HomeKidsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = NavHelper.indexForLocation(
      GoRouterState.of(context).uri.toString(),
    );

    // Watch the profile async provider.
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      // Bottom nav — index derived from router; navigation via go_router.
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        onTap: (i) => NavHelper.goToTab(context, i),
      ),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildContent(context, null),
          data: (profile) => _buildContent(context, profile),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserProfile? profile) {
    // Use real values when available; fall back gracefully.
    final childName = profile?.nickname ?? 'Explorador';
    final coins = profile?.coins ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          _Header(
            coins: coins,
            onAvatarTap: () => showProfileBottomSheet(context),
          ),

          const Divider(color: AppColors.border, height: 1, thickness: 1),

          // ── Hero ────────────────────────────────────────────────
          _HeroSection(childName: childName),

          const SizedBox(height: 8),

          // ── Mi camino ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _MiCaminoCard(
              completed: _kLessonsCompleted,
              total: _kLessonsTotal,
              progress: _kProgressPercent,
              milestones: _milestones,
            ),
          ),

          const SizedBox(height: 20),

          // ── Cápsulas para hoy ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _CapsulasSectionHeader(
              onVerTodas: () {
                // TODO: navegar a listado completo
              },
            ),
          ),

          const SizedBox(height: 12),

          // Horizontal scroll
          SizedBox(
            height: 188,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _capsules.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _CapsuleCard(data: _capsules[i]),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.coins, required this.onAvatarTap});

  final int coins;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Brand
          Text('Duukar', style: AppTextStyles.titleAppBar),

          const Spacer(),

          // Coin circle — círculo amarillo
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
                    '$coins',
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

          // Avatar circular — tappable para abrir el perfil
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _HeroSection
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.childName});

  final String childName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background gradient blob
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.3, 0.4),
                  radius: 0.9,
                  colors: [AppColors.primaryLight, AppColors.background],
                ),
              ),
            ),
          ),

          // Duki image — alineada a la izquierda/centro
          Positioned(
            bottom: 0,
            left: 16,
            child: Image.asset(
              'assets/img/duuki_frente.png',
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 200,
                width: 140,
                child: Icon(
                  Icons.smart_toy_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // Speech bubble — top right, al estilo intro_duki
          Positioned(
            top: 24,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _SpeechBubble(text: '¡Hola $childName! 👋'),
                const SizedBox(height: 8),
                Text(
                  'Hoy aprenderemos\nalgo nuevo, ¿listos?',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Speech bubble decorativa
class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MiCaminoCard
// ---------------------------------------------------------------------------

class _MiCaminoCard extends StatelessWidget {
  const _MiCaminoCard({
    required this.completed,
    required this.total,
    required this.progress,
    required this.milestones,
  });

  final int completed;
  final int total;
  final double progress; // 0.0 – 1.0
  final List<_MilestoneData> milestones;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return SectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mi camino 🗺️', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    '$completed de $total lecciones',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              // Percentage badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$pct%',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primaryPressed,
                    fontFamily: 'Fredoka',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.muted,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Milestones row
          Row(
            children: milestones
                .map(
                  (m) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: _MilestoneBox(data: m),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MilestoneBox extends StatelessWidget {
  const _MilestoneBox({required this.data});

  final _MilestoneData data;

  @override
  Widget build(BuildContext context) {
    final unlocked = data.isUnlocked;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 44,
      decoration: BoxDecoration(
        color: unlocked ? AppColors.primary : AppColors.muted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: unlocked ? AppColors.primaryPressed : AppColors.border,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: unlocked
          ? Text(
              data.label,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontFamily: 'Fredoka',
              ),
            )
          : const Icon(
              Icons.lock_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// _CapsulasSectionHeader
// ---------------------------------------------------------------------------

class _CapsulasSectionHeader extends StatelessWidget {
  const _CapsulasSectionHeader({required this.onVerTodas});

  final VoidCallback onVerTodas;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Cápsulas para hoy 🎯', style: AppTextStyles.titleMedium),
        const Spacer(),
        GestureDetector(
          onTap: onVerTodas,
          child: Text(
            'Ver todas',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _CapsuleCard
// ---------------------------------------------------------------------------

class _CapsuleCard extends StatelessWidget {
  const _CapsuleCard({required this.data});

  final _CapsuleData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top color area
          Container(
            height: 72,
            color: data.topColor.withOpacity(0.25),
            alignment: Alignment.center,
            child: Icon(
              Icons.play_circle_fill_rounded,
              size: 36,
              color: data.topColor,
            ),
          ),

          // Content area
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 6),

                // Duration row
                Row(
                  children: [
                    const Icon(
                      Icons.timer_rounded,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Text(data.duration, style: AppTextStyles.bodySmall),
                  ],
                ),

                const SizedBox(height: 6),

                // Tag pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: data.tagColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.tag,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: data.tagColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
