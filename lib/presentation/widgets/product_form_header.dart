import 'package:flutter/material.dart';

class ProductFormHeader extends StatelessWidget {
  const ProductFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF00C853).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF00C853),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Crea una publicacion atractiva para vender mas rapido.',
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Informacion basica',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
