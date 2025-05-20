import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';
import '../generated_code/api.swagger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  List<EnrichedLockeResponseDto> _lockes = [];
  String? _error;
  String? _loadingLockeId; // Add this to track which locke is being updated

  @override
  void initState() {
    super.initState();
    _loadLockes();
  }

  Future<void> _loadLockes({bool isRefreshing = false}) async {
    if (!isRefreshing) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final apiService = ApiService();
      final lockes = await apiService.getMyLockes(active: true);

      if (mounted) {
        setState(() {
          _lockes = lockes;
          _error = null;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar las partidas: $e';
          _isLoading = false;
          _isRefreshing = false;
        });
      }
      debugPrint('Error loading lockes: $e');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadLockes(isRefreshing: true);
  }

  // Add this method to provide a public way to reload data
  Future<void> reloadData() async {
    debugPrint('HomeScreen: reloadData() called - refreshing data');

    // Show a loading indicator if needed
    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });
    }

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recargando datos...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Use the existing load method
    await _loadLockes(isRefreshing: true);

    debugPrint('HomeScreen: reloadData completed');
  }

  Future<void> _incrementDeathCount(String lockeId) async {
    try {
      // Set the loading state for this specific locke
      setState(() {
        _loadingLockeId = lockeId;
      });

      final apiService = ApiService();
      await apiService.recordKill(lockeId, 1);
      await _loadLockes(isRefreshing: true);
    } catch (e) {
      setState(() {
        _error = 'Error al actualizar las muertes: $e';
      });
      debugPrint('Error incrementing death count: $e');
    } finally {
      // Clear the loading state
      if (mounted) {
        setState(() {
          _loadingLockeId = null;
        });
      }
    }
  }

  num _getUserDeathCount(EnrichedLockeResponseDto locke) {
    final userService = Provider.of<UserService>(context, listen: false);
    if (!userService.isAuthenticated || userService.currentUser == null) {
      return 0;
    }
    
    // Check if participants list exists and if user is a participant
    if (locke.participants == null || locke.participants!.isEmpty) {
      return 0;
    }
    
    // Find the current user in participants list
    final userParticipant = locke.participants!.where(
      (p) => p.userId == userService.currentUser!.id
    ).toList();
    
    // If user is not a participant, return 0
    if (userParticipant.isEmpty) {
      return 0;
    }
    
    // Return death count if user is a participant
    return userParticipant.first.deaths ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Pantalla de carga
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('NuzlockeTracker'),
          centerTitle: true,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.catching_pokemon,
                size: 60,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              CircularProgressIndicator(color: colorScheme.secondary),
              const SizedBox(height: 16),
              Text(
                'Cargando partidas...',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Pantalla sin autenticación
    if (!userService.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('NuzlockeTracker'),
          centerTitle: true,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
        body: Center(
          child: Card(
            elevation: 0,
            color: colorScheme.surfaceVariant,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.catching_pokemon,
                    size: 64,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenido a NuzlockeTracker',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Inicia sesión para ver tus partidas',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push('/login'),
                    icon: const Icon(Icons.login),
                    label: const Text('Iniciar sesión'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(200, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Pantalla principal con partidas
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.catching_pokemon, color: colorScheme.onPrimaryContainer),
            const SizedBox(width: 8),
            const Text('NuzlockeTracker'),
          ],
        ),
        centerTitle: false,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Ver todas las partidas',
            onPressed: () {
              context.push('/lockes');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              userService.logout();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/lockes/new'),
        label: const Text('Nueva partida'),
        icon: const Icon(Icons.add),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mensaje de bienvenida
              Card(
                elevation: 0,
                color: colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            radius: 24,
                            child: Icon(
                              Icons.person,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenido,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  userService.currentUser?.username ??
                                      'Entrenador',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => context.push('/lockes'),
                            icon: const Icon(Icons.list),
                            label: const Text('Ver todas las partidas'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Mensaje de error si existe
              if (_error != null)
                Card(
                  elevation: 0,
                  color: colorScheme.errorContainer,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _loadLockes,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Encabezado de sección
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the heading
                  children: [
                    Icon(
                      Icons.sports_esports,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Partidas activas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Lista de partidas o estado vacío
              if (_lockes.isEmpty)
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.catching_pokemon,
                          size: 48,
                          color: colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay partidas activas',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonalIcon(
                          onPressed: () => context.push('/nueva-partida'),
                          icon: const Icon(Icons.add),
                          label: const Text('Crear primera partida'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(220, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Lista de partidas
                ...List.generate(_lockes.length, (index) {
                  final locke = _lockes[index];
                  final userDeaths = _getUserDeathCount(locke);
                  final totalParticipants = locke.participants?.length ?? 0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
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
                        // Encabezado de la tarjeta
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.catching_pokemon,
                                color: colorScheme.secondary,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  locke.name ?? 'Sin nombre',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Estadísticas
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(
                                icon: FontAwesomeIcons.skull,
                                label: 'Tus muertes',
                                value:
                                    userDeaths
                                        .toInt()
                                        .toString(), // Convert to integer first
                                color: colorScheme.secondary,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: colorScheme.outline.withOpacity(0.2),
                              ),
                              _StatItem(
                                icon: Icons.group,
                                label: 'Participantes',
                                value: totalParticipants.toString(),
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),

                        // Acciones rápidas
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed:
                                      _loadingLockeId == locke.id
                                          ? null // Disable the button while loading
                                          : () => _incrementDeathCount(
                                            locke.id ?? '',
                                          ),
                                  icon:
                                      _loadingLockeId == locke.id
                                          ? SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color:
                                                  colorScheme.onErrorContainer,
                                            ),
                                          )
                                          : const FaIcon(
                                            FontAwesomeIcons.skull,
                                            size: 16,
                                          ),
                                  label: Text(
                                    _loadingLockeId == locke.id
                                        ? 'Añadiendo...'
                                        : 'Añadir muerte',
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: colorScheme.errorContainer,
                                    foregroundColor:
                                        colorScheme.onErrorContainer,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ), // Increased spacing between buttons
                              SizedBox(
                                width: 120, // Set a fixed minimum width
                                child: FilledButton.tonalIcon(
                                  onPressed:
                                      () => context.push('/locke/${locke.id}'),
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('Detalles'),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ), // Add horizontal padding
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
