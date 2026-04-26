import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../features/auth/auth_controller.dart';

// ---------------------------------------------------------------------------
// Public helper — llamar desde cualquier pantalla que tenga [BuildContext].
// ---------------------------------------------------------------------------

/// Muestra el bottom sheet de perfil con datos del usuario y opción de logout.
void showProfileBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    // Shape redondeado arriba, alineado al estilo Duukar
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    backgroundColor: AppColors.card,
    isScrollControlled: true,
    builder: (_) => const _ProfileSheet(),
  );
}

// ---------------------------------------------------------------------------
// _ProfileSheet — widget interno que consume el auth state
// ---------------------------------------------------------------------------

class _ProfileSheet extends ConsumerWidget {
  const _ProfileSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    final user = authController.currentUser;

    // Extrae nickname y email de forma defensiva
    final nickname =
        (user?.userMetadata?['nickname'] as String?)?.trim().isNotEmpty == true
        ? user!.userMetadata!['nickname'] as String
        : null;
    final email = user?.email?.trim().isNotEmpty == true ? user!.email : null;

    final displayName = nickname ?? email?.split('@').first ?? 'Usuario';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ────────────────────────────────────────────
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ── Avatar + datos ─────────────────────────────────────────
            Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Nickname + email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (email != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Divider ────────────────────────────────────────────────
            const Divider(color: AppColors.border, height: 1, thickness: 1),

            const SizedBox(height: 8),

            // ── Logout option ──────────────────────────────────────────
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                  size: 20,
                ),
              ),
              title: Text(
                'Cerrar sesión',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.danger,
                ),
              ),
              onTap: () => _onLogoutTap(context, authController),
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirmation + sign-out ──────────────────────────────────────────────

  Future<void> _onLogoutTap(
    BuildContext context,
    AuthController authController,
  ) async {
    final rootContext = context;

    // Cierra el bottom sheet primero para que el dialog quede limpio
    Navigator.of(context).pop();

    // Muestra confirmación
    final confirmed = await showDialog<bool>(
      context: rootContext,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('¿Cerrar sesión?', style: AppTextStyles.titleMedium),
        content: Text(
          '¿Seguro que querés salir? Podés volver cuando quieras. 👋',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          // Cancelar
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Confirmar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Sign out y navegar a login
    await authController.signOut();
    if (rootContext.mounted) {
      rootContext.go(AppRoutes.login);
    }
  }
}
