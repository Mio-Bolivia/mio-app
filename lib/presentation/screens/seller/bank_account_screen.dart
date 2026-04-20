import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/seller_requirements_provider.dart';
import '../../thumb_components/thumb_components.dart';

class BankAccountScreen extends ConsumerStatefulWidget {
  const BankAccountScreen({super.key});

  @override
  ConsumerState<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends ConsumerState<BankAccountScreen> {
  final _accountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _saveBankAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref
          .read(userProvider.notifier)
          .saveBankAccount(_accountController.text);
      if (!success) {
        throw Exception('No se pudo guardar la cuenta');
      }

      ref
          .read(sellerRequirementsProvider.notifier)
          .setBankAccountVerified(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta guardada exitosamente')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar cuenta: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = ref
        .watch(sellerRequirementsProvider)
        .bankAccountVerified;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta de Banco'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingresa tu cuenta de banco',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aquí recibirás tus pagos por ventas.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                MioTextField(
                  controller: _accountController,
                  label: 'Número de cuenta',
                  hintText: 'Ingresa tu número de cuenta',
                  prefixIcon: Icons.account_balance_outlined,
                  enabled: !isCompleted,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un número de cuenta';
                    }
                    if (value.length < 8) {
                      return 'La cuenta debe tener al menos 8 dígitos';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                MioPrimaryButton(
                  label: isCompleted ? 'Cuenta guardada' : 'Aceptar',
                  onPressed: isCompleted || _isLoading
                      ? null
                      : _saveBankAccount,
                  isLoading: _isLoading,
                  showArrow: false,
                  showGlow: false,
                  backgroundColor: isCompleted
                      ? Colors.grey.shade400
                      : AppColors.secondary,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
