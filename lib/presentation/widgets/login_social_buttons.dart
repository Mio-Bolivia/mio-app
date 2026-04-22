import 'package:flutter/material.dart';
import '../thumb_components/thumb_components.dart';

class LoginSocialButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  const LoginSocialButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'O CONTINUAR CON',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            MioSocialButton(
              label: 'Google',
              icon: Icon(Icons.g_mobiledata_rounded, size: 22),
              onPressed: onGooglePressed,
            ),
            const SizedBox(width: 12),
            MioSocialButton(
              label: 'Apple',
              icon: Icon(Icons.apple, size: 22),
              onPressed: onApplePressed,
            ),
          ],
        ),
      ],
    );
  }
}
