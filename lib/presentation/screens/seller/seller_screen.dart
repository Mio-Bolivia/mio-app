import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../thumb_components/thumb_components.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SellerRequirementsView();
  }
}

class _SellerRequirementsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              '¿Quieres convertirte en vendedor?',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Completa los requisitos y empieza\na gestionar tu propia tienda',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            MioPrimaryButton(
              label: 'Convertirme en vendedor',
              onPressed: () => context.push('/seller-requirements'),
              showArrow: false,
              showGlow: false,
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
