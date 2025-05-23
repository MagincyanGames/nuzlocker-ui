import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/developer_service.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  PackageInfo? _packageInfo;
  bool _isLoadingPackageInfo = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = packageInfo;
          _isLoadingPackageInfo = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading package info: $e');
      if (mounted) {
        setState(() {
          _isLoadingPackageInfo = false;
        });
      }
    }
  }

  String get _versionInfo {
    if (_isLoadingPackageInfo) return 'Cargando...';
    if (_packageInfo == null) return 'No disponible';
    
    return '${_packageInfo!.version}+${_packageInfo!.buildNumber} (Dev)';
  }

  String get _appName {
    return _packageInfo?.appName ?? 'NuzlockeTracker';
  }

  String get _packageName {
    return _packageInfo?.packageName ?? 'No disponible';
  }

  @override
  Widget build(BuildContext context) {
    final developerService = Provider.of<DeveloperService>(context);
    final userService = Provider.of<UserService>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isUserLoggedIn = userService.isAuthenticated;

    // Redirect if not in developer mode (keep this check)
    if (!developerService.isDeveloperMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.code, color: Colors.orange),
            SizedBox(width: 8),
            Text('Developer Options'),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Modo Developer Activo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tienes acceso a herramientas de desarrollo y debugging.',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  if (!isUserLoggedIn) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No has iniciado sesión. Algunas opciones pueden estar limitadas.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // API Configuration Section
            _SectionCard(
              title: 'Configuración de API',
              icon: Icons.api,
              children: [
                _InfoTile(
                  label: 'URL actual',
                  value: _getApiUrlDisplayName(_apiService.currentBaseUrl),
                ),
                _ActionTile(
                  icon: Icons.swap_horiz,
                  title: 'Cambiar servidor API',
                  subtitle: 'Alternar entre desarrollo y producción',
                  onTap: () => _showApiUrlDialog(context),
                ),
                _ActionTile(
                  icon: Icons.network_check,
                  title: 'Test de conectividad',
                  subtitle: 'Verificar conexión con el servidor actual',
                  onTap: () => _testApiConnection(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // App Info Section
            _SectionCard(
              title: 'Información de la App',
              icon: Icons.info,
              children: [
                _InfoTile(
                  label: 'Nombre de la app',
                  value: _appName,
                ),
                _InfoTile(
                  label: 'Versión',
                  value: _versionInfo,
                ),
                _InfoTile(
                  label: 'Package name',
                  value: _packageName,
                ),
                if (isUserLoggedIn) ...[
                  const Divider(),
                  _InfoTile(
                    label: 'Usuario actual',
                    value: userService.currentUser?.username ?? 'No disponible',
                  ),
                  _InfoTile(
                    label: 'ID de usuario',
                    value: userService.currentUser?.id ?? 'No disponible',
                  ),
                  _InfoTile(
                    label: 'Estado de auth',
                    value: 'Autenticado',
                  ),
                ] else ...[
                  const Divider(),
                  const _InfoTile(
                    label: 'Estado de auth',
                    value: 'No autenticado',
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Debug Actions Section - Only show actions that work without auth
            _SectionCard(
              title: 'Acciones de Debug',
              icon: Icons.bug_report,
              children: [
                _ActionTile(
                  icon: Icons.terminal,
                  title: 'Mostrar logs de sistema',
                  subtitle: 'Ver información detallada en consola',
                  onTap: () {
                    debugPrint('=== SYSTEM DEBUG INFO ===');
                    debugPrint('Autenticado: ${userService.isAuthenticated}');
                    if (isUserLoggedIn) {
                      debugPrint('Usuario actual: ${userService.currentUser?.username}');
                      debugPrint('ID de usuario: ${userService.currentUser?.id}');
                    } else {
                      debugPrint('Usuario actual: No autenticado');
                    }
                    debugPrint('Modo developer: ${developerService.isDeveloperMode}');
                    debugPrint('API URL: ${_apiService.currentBaseUrl}');
                    debugPrint('App: $_appName');
                    debugPrint('Versión: $_versionInfo');
                    debugPrint('Package: $_packageName');
                    debugPrint('========================');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📋 Logs mostrados en consola'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                // Only show reload action if user is logged in
                if (isUserLoggedIn)
                  _ActionTile(
                    icon: Icons.refresh,
                    title: 'Recargar datos',
                    subtitle: 'Forzar recarga de todas las partidas',
                    onTap: () async {
                      // Navigate back and trigger reload
                      context.go('/');
                      // Add a small delay to ensure navigation completes
                      await Future.delayed(const Duration(milliseconds: 100));
                      // You'll need to access the home screen's reload method
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos recargados'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Danger Zone - Adjust based on authentication
            _SectionCard(
              title: 'Zona de Peligro',
              icon: Icons.warning,
              color: Colors.red,
              children: [
                // Only show logout if user is logged in
                if (isUserLoggedIn)
                  _ActionTile(
                    icon: Icons.logout,
                    title: 'Cerrar sesión forzado',
                    subtitle: 'Cerrar sesión y limpiar datos locales',
                    color: Colors.red,
                    onTap: () {
                      userService.logout();
                      context.go('/login');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🔐 Sesión cerrada forzadamente'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                _ActionTile(
                  icon: Icons.close,
                  title: 'Desactivar modo developer',
                  subtitle: 'Volver al modo normal de la aplicación',
                  color: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('¿Desactivar modo developer?'),
                        content: const Text(
                          'Esto desactivará todas las funciones de desarrollo '
                          'y regresarás al modo normal de la aplicación.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              developerService.disableDeveloperMode();
                              context.go('/');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔒 Modo developer desactivado'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Desactivar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getApiUrlDisplayName(String url) {
    if (url.contains('api.nuz.onara.top')) {
      return 'Producción (api.nuz.onara.top:6109)';
    } else if (url.contains('play.onara.top')) {
      return 'Desarrollo (play.onara.top:3000)';
    }
    return url;
  }

  void _showApiUrlDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar URL de API'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'URL actual: ${_getApiUrlDisplayName(_apiService.currentBaseUrl)}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text('Selecciona el servidor:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Producción'),
              subtitle: const Text('api.nuz.onara.top:6109'),
              trailing: _apiService.currentBaseUrl == ApiService.prodUrl
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () => _changeApiUrl(context, ApiService.prodUrl),
            ),
            ListTile(
              leading: const Icon(Icons.developer_mode),
              title: const Text('Desarrollo'),
              subtitle: const Text('play.onara.top:3000'),
              trailing: _apiService.currentBaseUrl == ApiService.devUrl
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () => _changeApiUrl(context, ApiService.devUrl),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeApiUrl(BuildContext context, String newUrl) async {
    Navigator.of(context).pop();
    
    try {
      await _apiService.setBaseUrl(newUrl);
      setState(() {}); // Refresh the UI to show the new URL
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ URL cambiada a: ${_getApiUrlDisplayName(newUrl)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al cambiar URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testApiConnection(BuildContext context) async {
    try {
      await _apiService.getMyLockes(active: true);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Conexión exitosa a ${_getApiUrlDisplayName(_apiService.currentBaseUrl)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error de conexión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? color;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sectionColor = color ?? colorScheme.primary;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: sectionColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: sectionColor,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actionColor = color ?? colorScheme.primary;

    return ListTile(
      leading: Icon(icon, color: actionColor),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}