import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/user_service.dart'; // Assuming user_service.dart is in lib/services/
import '../services/api_service.dart'; // For ApiException if needed for error handling details

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController(); // For display name
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final userService = Provider.of<UserService>(context, listen: false);
        // Note: The current ApiService.register method takes a 'name' parameter,
        // but the LoginDto used for the API call /api/auth/register
        // only includes username and password.
        // If your backend supports 'name' during registration,
        // you'll need to adjust LoginDto or use a different DTO in ApiService.
        final success = await userService.register(
          _usernameController.text,
          _passwordController.text,
          name:
              _displayNameController.text.isNotEmpty
                  ? _displayNameController.text
                  : null,
        );

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro exitoso.'),
                backgroundColor: Colors.green,
              ),
            );
            context.go(
              '/',
            ); // Navigate to login screen after successful registration
          } else {
            // The UserService should ideally throw an error or return a more specific error message.
            // For now, using a generic message if success is false but no exception was caught.
            setState(() {
              _errorMessage =
                  'Error en el registro. El usuario podría ya existir o los datos son inválidos.';
              _isLoading = false;
            });
          }
        }
      } on ApiException catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            if (e.statusCode == 400 ||
                e.message.toLowerCase().contains('already exists')) {
              _errorMessage =
                  'Error de registro: El nombre de usuario ya existe. Por favor, elige otro.\n\nDetalles técnicos: ${e.message}';
            } else if (e.message.toLowerCase().contains('validation failed')) {
              _errorMessage =
                  'Error de registro: Los datos proporcionados no son válidos. Asegúrate de que la contraseña cumple los requisitos.\n\nDetalles técnicos: ${e.message}';
            } else {
              _errorMessage =
                  'Error de registro: ${e.message} (Código: ${e.statusCode})';
            }
          });
        }
        debugPrint('SignUp error (ApiException): $e');
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Error inesperado durante el registro: ${e.toString()}';
          });
        }
        debugPrint('SignUp error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_add_alt_1,
                    size: 80,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Crear Cuenta',
                  style: textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Únete a la aventura. Completa el formulario para registrarte.',
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.error.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.error,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Error de Registro',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: colorScheme.onErrorContainer),
                        ),
                        if (_errorMessage!.contains("Detalles técnicos:"))
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    final details =
                                        _errorMessage!
                                            .split('Detalles técnicos:')
                                            .last
                                            .trim();
                                    Clipboard.setData(
                                      ClipboardData(text: details),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Información de error copiada al portapapeles',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('Copiar detalles'),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Elige un nombre de usuario...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        maxLength: 64,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa un nombre de usuario.';
                          }
                          if (value.length < 3) {
                            return 'El nombre de usuario debe tener al menos 3 caracteres.';
                          }
                          if (value.length > 20) {
                            return 'El nombre de usuario no puede exceder los 20 caracteres.';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value)) {
                            return 'Solo letras, números y guiones bajos.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre para mostrar (Opcional)',
                          hintText: 'Cómo te verán los demás...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.badge_outlined),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        maxLength: 50,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 3) {
                            return 'El nombre debe tener al menos 3 caracteres.';
                          }
                          if (value != null && value.length > 30) {
                            return 'El nombre no puede exceder los 30 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: 'Crea una contraseña segura...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        obscureText: true,
                        maxLength: 64,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa una contraseña.';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres.';
                          }
                          if (value.length > 50) {
                            return 'La contraseña no puede exceder los 50 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          hintText: 'Vuelve a escribir tu contraseña...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                        ),
                        obscureText: true,
                        maxLength: 64,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirma tu contraseña.';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed:
                            _isLoading ? null : () => _handleSignUp(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Text('Registrarse'),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => context.go('/login'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('¿Ya tienes cuenta? Inicia Sesión'),
                      ),
                    ],
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
