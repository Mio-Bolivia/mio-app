import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Terms and Privacy Policy'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Términos de Servicio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Al usar esta aplicación, aceptas nuestros términos y condiciones. '
              'Todos los datos que proporciones serán tratados de acuerdo a nuestra '
              'política de privacidad.',
            ),
            SizedBox(height: 16),
            Text(
              'Política de Privacidad',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Nosotros respetamos tu privacidad. Tu información personal '
              '(nombre, teléfono) será usada únicamente para purposes de '
              'autenticación y comunicación relacionada a la app.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
