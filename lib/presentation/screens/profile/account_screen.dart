import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../thumb_components/thumb_components.dart';

/// Account overview: summary, grouped cards, logout (reference layout).
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const _radius = 22.0;

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar sesión'),
        content: const Text(
          'Vas a salir de tu cuenta. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          MioPrimaryButton(
            label: 'Salir',
            onPressed: () => Navigator.pop(ctx, true),
            fullWidth: false,
            showArrow: false,
            showGlow: false,
            backgroundColor: Colors.red.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            fontSize: 14,
          ),
        ],
      ),
    );
    if (go != true || !context.mounted) return;
    await ref.read(userProvider.notifier).logout();
    if (context.mounted) {
      context.go('/login');
    }
  }

  void _soon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — próximamente')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final user = userState.user;

    if (user == null) {
      return const Center(child: Text('No hay sesión activa'));
    }

    final displayName = user.name?.trim().isNotEmpty == true
        ? user.name!.trim()
        : 'Usuario';

    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            const Text(
              'Cuenta',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D3D),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 20),
            _HeroSummary(
              user: user,
              displayName: displayName,
              onEditAvatar: () => context.push('/profile/edit'),
            ),
            const SizedBox(height: 24),
            _SectionCard(
              accent: AppColors.primary,
              icon: Icons.person_outline_rounded,
              title: 'Mis datos',
              child: Column(
                children: [
                  _DataRow(
                    label: 'Nombre',
                    value: displayName,
                  ),
                  Divider(height: 20, color: Colors.grey.shade200),
                  _DataRow(
                    label: 'Teléfono',
                    value: user.phone?.isNotEmpty == true
                        ? user.phone!
                        : '—',
                  ),
                  Divider(height: 20, color: Colors.grey.shade200),
                  _DataRow(
                    label: 'Dirección de envío',
                    value: user.shippingAddress?.isNotEmpty == true
                        ? user.shippingAddress!
                        : 'Sin dirección',
                    multiline: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              accent: AppColors.tertiary,
              icon: Icons.lock_outline_rounded,
              title: 'Seguridad',
              child: Column(
                children: [
                  _NavRow(
                    label: 'Cambiar contraseña',
                    trailing: Icons.chevron_right_rounded,
                    onTap: () => _soon(context, 'Cambiar contraseña'),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  _NavRow(
                    label: 'Autenticación 2FA',
                    trailingWidget: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ACTIVO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    onTap: () => _soon(context, '2FA'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              accent: AppColors.primary,
              icon: Icons.help_outline_rounded,
              title: 'Ayuda',
              child: Column(
                children: [
                  _NavRow(
                    label: 'Centro de soporte',
                    trailing: Icons.open_in_new_rounded,
                    onTap: () => _soon(context, 'Centro de soporte'),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  _NavRow(
                    label: 'Términos y condiciones',
                    trailing: Icons.description_outlined,
                    onTap: () => _soon(context, 'Términos'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: userState.isLoading
                  ? null
                  : () => _confirmLogout(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade200, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'CERRAR SESIÓN',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'VERSIÓN ${AppConstants.appVersion} — ${AppConstants.appName}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary({
    required this.user,
    required this.displayName,
    required this.onEditAvatar,
  });

  final User user;
  final String displayName;
  final VoidCallback onEditAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEditAvatar,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color(0xFF1A1D3D),
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? const Icon(Icons.person_rounded,
                          size: 56, color: Colors.white)
                      : null,
                ),
              ),
            ),
            Positioned(
              right: -4,
              bottom: 2,
              child: Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  onTap: onEditAvatar,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1D3D),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (user.isSeller) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.tertiary.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded,
                    size: 18, color: AppColors.tertiary),
                const SizedBox(width: 6),
                Text(
                  'CUENTA VENDEDOR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.tertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.child,
  });

  final Color accent;
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AccountScreen._radius),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AccountScreen._radius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: accent.withValues(alpha: 0.65)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: accent, size: 22),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1D3D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      child,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1D3D),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.label,
    this.trailing,
    this.trailingWidget,
    required this.onTap,
  });

  final String label;
  final IconData? trailing;
  final Widget? trailingWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D3D),
                  ),
                ),
              ),
              if (trailingWidget != null)
                trailingWidget!
              else if (trailing != null)
                Icon(trailing, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
