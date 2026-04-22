import 'package:flutter/material.dart';
import '../thumb_components/thumb_components.dart';
import '../../core/utils/validators/email_validator.dart';
import '../../core/utils/validators/password_validator.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onLoginPressed,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MioTextField(
            controller: widget.emailController,
            label: 'Email',
            hintText: 'correo@ejemplo.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: EmailValidator.validate,
          ),

          const SizedBox(height: 18),
          MioTextField(
            controller: widget.passwordController,
            label: 'Contraseña',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
              ),
            ),
            validator: PasswordValidator.validate,
          ),
          const SizedBox(height: 36),
          MioPrimaryButton(
            label: 'Iniciar sesión',
            onPressed: widget.onLoginPressed,
          ),
        ],
      ),
    );
  }
}
