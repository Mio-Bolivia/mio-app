import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/seller_requirements_provider.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints/user_endpoints.dart';
import '../../providers/user_provider.dart';

class SellerRequirementsScreen extends ConsumerWidget {
  const SellerRequirementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requisitos = ref.watch(sellerRequirementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Requisitos para ser Vendedor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completa los siguientes requisitos\npara convertirte en vendedor:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Necesitas completar todos los pasos\nantes de abrir tu tienda.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              _RequirementCard(
                icon: Icons.badge_outlined,
                title: 'Verifica tu identidad',
                detail: 'Verifica tu documento',
                isCompleted: requisitos.identityVerified,
                onTap: () {
                  context.push('/seller/identity-verification');
                },
              ),
              const SizedBox(height: 16),
              _RequirementCard(
                icon: Icons.account_balance_outlined,
                title: 'Cuenta de banco',
                detail: 'Donde recibirás tus pagos',
                isCompleted: requisitos.bankAccountVerified,
                onTap: () {
                  context.push('/seller/bank-account');
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: requisitos.allCompleted
                      ? () => _becomeSeller(context, ref)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    requisitos.allCompleted
                        ? 'Abrir Mi Tienda'
                        : 'Completa los requisitos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _becomeSeller(BuildContext context, WidgetRef ref) async {
    try {
      final apiClient = ApiClient.instance;
      await apiClient.post(UserEndpoints.becomeSeller);

      final userNotifier = ref.read(userProvider.notifier);
      final currentUser = ref.read(userProvider).user;

      if (currentUser != null) {
        userNotifier.updateUser(currentUser.copyWith(isSeller: true));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Felicidades! Ya eres vendedor')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al hacerte vendedor: $e')),
        );
      }
    }
  }
}

class _RequirementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final bool isCompleted;
  final VoidCallback onTap;

  const _RequirementCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCompleted ? const Color(0xFF00C853) : Colors.grey.shade300,
            width: isCompleted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF00C853).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : icon,
                color: isCompleted
                    ? const Color(0xFF00C853)
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.chevron_right,
              color: isCompleted
                  ? const Color(0xFF00C853)
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
