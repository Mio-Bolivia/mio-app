import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../thumb_components/thumb_components.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bankAccountController;
  late TextEditingController _addressController;
  String _selectedCountryCode = '+57';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _bankAccountController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bankAccountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _initControllers(User? user) {
    if (!_isInitialized && user != null) {
      _nameController.text = user.name ?? '';
      _bankAccountController.text = user.bankAccount ?? '';
      _addressController.text = user.shippingAddress ?? '';
      if (user.phone != null && user.phone!.length > 3) {
        final code = CountryCode.available.cast<CountryCode?>().firstWhere(
          (c) => user.phone!.startsWith(c!.code),
          orElse: () => CountryCode.available.first,
        );
        if (code != null) {
          _selectedCountryCode = code.code;
          _phoneController.text = user.phone!.substring(code.code.length);
        }
      }
      _isInitialized = true;
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
    await ref
        .read(userProvider.notifier)
        .updateProfile(
          name: _nameController.text.trim(),
          phone: phone,
          bankAccount: _bankAccountController.text.trim(),
          shippingAddress: _addressController.text.trim(),
        );
    final userState = ref.read(userProvider);
    if (!mounted) return;
    if (userState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar: ${userState.error}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } else if (userState.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Perfil actualizado'),
          backgroundColor: AppColors.secondary,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final user = userState.user;
    _initControllers(user);

    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceMuted,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
          color: AppColors.formBlue,
        ),
        title: const Text(
          'Editar perfil',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.formBlue,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Actualiza tus datos personales y de envío.',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                MioTextField(
                  controller: _nameController,
                  label: 'Nombre completo',
                  hintText: 'Tu nombre',
                  prefixIcon: Icons.badge_outlined,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 118,
                      child: MioDropdownFormField<String>(
                        label: 'Código',
                        value: _selectedCountryCode,
                        prefixIcon: Icons.flag_outlined,
                        items: CountryCode.available.map((code) {
                          return DropdownMenuItem(
                            value: code.code,
                            child: Text('${code.flag} ${code.code}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCountryCode = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MioTextField(
                        controller: _phoneController,
                        label: 'Teléfono',
                        hintText: '600000000',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu teléfono';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                MioTextField(
                  controller: _addressController,
                  label: 'Dirección de envío',
                  hintText: 'Calle, número, ciudad',
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa una dirección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                MioTextField(
                  controller: _bankAccountController,
                  label: 'Cuenta bancaria',
                  hintText: 'Número de cuenta',
                  prefixIcon: Icons.account_balance_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa tu cuenta';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                MioPrimaryButton(
                  label: 'Guardar cambios',
                  onPressed: _onSave,
                  isLoading: userState.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
