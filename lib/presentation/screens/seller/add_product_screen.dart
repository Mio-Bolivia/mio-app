import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../thumb_components/thumb_components.dart';
import '../../widgets/product_form_header.dart';
import '../../widgets/product_form_section.dart';
import '../../widgets/product_image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _precioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _imagenes = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _imagenes.addAll(images);
      });
    }
  }

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagenes.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagenes.removeAt(index);
    });
  }

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      if (_imagenes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agrega al menos una foto del producto'),
          ),
        );
        return;
      }
      final productName = _nameController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$productName agregado a tu tienda')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductFormHeader(),
                ProductFormSection(
                  title: 'Información básica',
                  child: Column(
                    children: [
                      MioTextField(
                        controller: _nameController,
                        label: 'Nombre del producto',
                        hintText: 'Ej: Camiseta deportiva unisex',
                        prefixIcon: Icons.sell_outlined,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el nombre del producto';
                          }
                          if (value.trim().length < 3) {
                            return 'El nombre debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      MioTextField(
                        controller: _descriptionController,
                        label: 'Descripción',
                        hintText:
                            'Color, talla, material y demás detalles importantes.',
                        prefixIcon: Icons.description_outlined,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa una descripcion';
                          }
                          if (value.trim().length < 20) {
                            return 'Agrega mas detalle para ayudar al comprador';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                ProductFormSection(
                  title: 'Fotos del producto',
                  subtitle: 'Agrega una o más fotos',
                  child: ProductImagePicker(
                    images: _imagenes,
                    onPickImages: _pickImages,
                    onTakePhoto: _takePhoto,
                    onRemoveImage: _removeImage,
                  ),
                ),
                ProductFormSection(
                  title: 'Precio del producto',
                  child: MioTextField(
                    controller: _precioController,
                    label: 'Precio',
                    hintText: '0.00',
                    prefixText: 'Bs. ',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el precio';
                      }
                      final precio = double.tryParse(value);
                      if (precio == null || precio <= 0) {
                        return 'Precio inválido';
                      }
                      return null;
                    },
                  ),
                ),
                MioPrimaryButton(
                  label: 'Agregar a mi tienda',
                  onPressed: _addProduct,
                  showArrow: false,
                  showGlow: false,
                  backgroundColor: AppColors.secondary,
                  leading: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tip: mientras mas clara sea la informacion, mas confianza genera tu producto.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
