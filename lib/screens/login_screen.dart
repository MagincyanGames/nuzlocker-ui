import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final userService = Provider.of<UserService>(context, listen: false);
        final response = await userService.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (response) {
          if (mounted) {
            context.go('/'); // Cambiado de push a go para reemplazar la pantalla actual
          }
        } else {
          setState(() {
            _errorMessage = 'Credenciales inválidas. Por favor intenta nuevamente.';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          
          // Mejorar el diagnóstico de errores
          if (e.toString().contains('SocketException') || 
              e.toString().contains('Connection refused')) {
            _errorMessage = 'Error de conexión: No se pudo conectar al servidor. El servidor puede estar caído o tu dispositivo no tiene conexión a internet.\n\nDetalles técnicos: ${e.toString()}';
          } 
          else if (e.toString().contains('HandshakeException') || 
                  e.toString().contains('WRONG_VERSION_NUMBER')) {
            _errorMessage = 'Error de conexión segura: No se puede establecer una conexión segura con el servidor. Esto puede deberse a problemas con certificados SSL o configuraciones de red.\n\nDetalles técnicos: ${e.toString()}';
          }
          else if (e.toString().contains('TimeoutException')) {
            _errorMessage = 'Error de tiempo de espera: La conexión al servidor tomó demasiado tiempo. Intenta nuevamente o verifica tu conexión a internet.\n\nDetalles técnicos: ${e.toString()}';
          }
          else if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
            _errorMessage = 'Error de autenticación: Credenciales inválidas o token expirado.\n\nDetalles técnicos: ${e.toString()}';
          }
          else if (e.toString().contains('500')) {
            _errorMessage = 'Error del servidor: El servidor encontró un problema interno. Por favor contacta al administrador.\n\nDetalles técnicos: ${e.toString()}';
          }
          else {
            _errorMessage = 'Error inesperado: Se produjo un problema al intentar iniciar sesión.\n\nDetalles técnicos: ${e.toString()}';
          }
        });
        debugPrint('Login error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Heading
                Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "We're excited to have you back. Please log in to continue.",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Error de inicio de sesión',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // Copiar el error al portapapeles para diagnóstico
                                final details = _errorMessage!.split('Detalles técnicos:').last.trim();
                                Clipboard.setData(ClipboardData(text: details));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Información de error copiada al portapapeles'))
                                );
                              },
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Copiar detalles'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username field
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        ),
                        maxLength: 64,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username.';
                          }
                          if (value.length < 3) {
                            return 'Too short! Username must be at least 3 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                        ),
                        obscureText: true,
                        maxLength: 64,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      FilledButton(
                        onPressed: _isLoading ? null : () => _handleLogin(context),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Login'),
                      ),
                      const SizedBox(height: 16),

                      // Sign up button
                      FilledButton.tonal(
                        onPressed: () => context.push('/signup'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('New here?'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Return to main menu button
                      OutlinedButton(
                        onPressed: () => context.push('/'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Return to Main Menu'),
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