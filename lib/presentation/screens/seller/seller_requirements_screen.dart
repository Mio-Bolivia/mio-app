import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/seller_requirements_provider.dart';
import '../../providers/user_provider.dart';

class SellerRequirementsScreen extends ConsumerStatefulWidget {
  const SellerRequirementsScreen({super.key});

  @override
  ConsumerState<SellerRequirementsScreen> createState() =>
      _SellerRequirementsScreenState();
}

class _SellerRequirementsScreenState
    extends ConsumerState<SellerRequirementsScreen> {
  final _bankAccountController = TextEditingController();
  final _bankFormKey = GlobalKey<FormState>();
  final _identityHeaderFocusNode = FocusNode();
  final _bankHeaderFocusNode = FocusNode();
  XFile? _identityImage;
  bool _identityExpanded = false;
  bool _bankExpanded = false;
  bool _identityLoading = false;
  bool _bankLoading = false;
  bool _sellerLoading = false;

  @override
  void dispose() {
    _bankAccountController.dispose();
    _identityHeaderFocusNode.dispose();
    _bankHeaderFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
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
                isExpanded: _identityExpanded,
                focusNode: _identityHeaderFocusNode,
                onTap: () => setState(() => _identityExpanded = !_identityExpanded),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Sube una foto legible de tu documento.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    Semantics(
                      button: true,
                      enabled: !requisitos.identityVerified,
                      label: 'Subir documento de identidad',
                      hint: 'Doble toque para elegir camara o galeria',
                      child: InkWell(
                        onTap: requisitos.identityVerified
                            ? null
                            : _showImageSourceDialog,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: _identityImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey[500],
                                      size: 36,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Toca para seleccionar imagen',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(_identityImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            requisitos.identityVerified || _identityLoading
                            ? null
                            : _uploadIdentityDocument,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          foregroundColor: Colors.white,
                        ),
                        child: _identityLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Verificar identidad'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _RequirementCard(
                icon: Icons.account_balance_outlined,
                title: 'Cuenta de banco',
                detail: 'Donde recibirás tus pagos',
                isCompleted: requisitos.bankAccountVerified,
                isExpanded: _bankExpanded,
                focusNode: _bankHeaderFocusNode,
                onTap: () => setState(() => _bankExpanded = !_bankExpanded),
                child: Form(
                  key: _bankFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _bankAccountController,
                        enabled:
                            !requisitos.bankAccountVerified && !_bankLoading,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Numero de cuenta',
                          hintText: 'Ingresa tu numero de cuenta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.account_balance),
                        ),
                        validator: (value) {
                          final accountNumber = value?.trim() ?? '';
                          if (accountNumber.isEmpty) {
                            return 'Ingresa un numero de cuenta';
                          }
                          if (accountNumber.length < 8) {
                            return 'La cuenta debe tener al menos 8 digitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              requisitos.bankAccountVerified || _bankLoading
                              ? null
                              : _saveBankAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                          ),
                          child: _bankLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Guardar cuenta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: requisitos.allCompleted && !_sellerLoading
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
                  child: _sellerLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 80);
    if (image != null && mounted) {
      setState(() {
        _identityImage = image;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadIdentityDocument() async {
    if (_identityImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una imagen primero')),
      );
      return;
    }

    setState(() => _identityLoading = true);
    try {
      final documentId = await ref
          .read(userProvider.notifier)
          .uploadIdentityDocument(_identityImage!.path);
      if (documentId != null && documentId.isNotEmpty) {
        ref.read(sellerRequirementsProvider.notifier).setIdentityVerified(true);
        if (mounted) {
          setState(() {
            _identityExpanded = false;
          });
          FocusScope.of(context).requestFocus(_identityHeaderFocusNode);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identidad verificada')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo verificar la identidad')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _identityLoading = false);
      }
    }
  }

  Future<void> _saveBankAccount() async {
    if (!(_bankFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final accountNumber = _bankAccountController.text.trim();

    setState(() => _bankLoading = true);
    try {
      final success = await ref
          .read(userProvider.notifier)
          .saveBankAccount(accountNumber);
      if (success) {
        ref.read(sellerRequirementsProvider.notifier).setBankAccountVerified(
          true,
        );
        if (mounted) {
          setState(() {
            _bankExpanded = false;
          });
          FocusScope.of(context).requestFocus(_bankHeaderFocusNode);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cuenta guardada exitosamente')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo guardar la cuenta')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _bankLoading = false);
      }
    }
  }

  Future<void> _becomeSeller(BuildContext context, WidgetRef ref) async {
    setState(() => _sellerLoading = true);
    try {
      await ref.read(userProvider.notifier).becomeSeller();

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
    } finally {
      if (mounted) {
        setState(() => _sellerLoading = false);
      }
    }
  }
}

class _RequirementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final bool isCompleted;
  final bool isExpanded;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final Widget child;

  const _RequirementCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.isCompleted,
    required this.isExpanded,
    required this.focusNode,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final trailingIcon = isCompleted
        ? Icons.check_circle
        : (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down);
    final trailingColor = isCompleted
        ? const Color(0xFF00C853)
        : Colors.grey.shade600;

    return Semantics(
      button: true,
      toggled: isExpanded,
      enabled: true,
      label: title,
      hint: isExpanded ? 'Colapsar seccion' : 'Expandir seccion',
      child: InkWell(
        focusNode: focusNode,
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isCompleted ? const Color(0xFF00C853) : Colors.grey.shade300,
              width: isCompleted ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
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
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    trailingIcon,
                    color: trailingColor,
                  ),
              ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: child,
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 180),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
