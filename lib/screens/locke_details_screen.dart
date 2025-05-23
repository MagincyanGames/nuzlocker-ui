import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../services/api_service.dart';
import '../generated_code/api.swagger.dart';
import '../widgets/back_app_bar.dart';
import '../widgets/edit_deaths_dialog.dart';
import '../widgets/add_participant_dialog.dart';
import '../widgets/complete_locke_dialog.dart';
import '../widgets/tabs/battles_tab.dart';
import '../widgets/tabs/progress_tab.dart';

class LockeDetailsScreen extends StatefulWidget {
  final String lockeId;

  const LockeDetailsScreen({super.key, required this.lockeId});

  @override
  State<LockeDetailsScreen> createState() => _LockeDetailsScreenState();
}

class _LockeDetailsScreenState extends State<LockeDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isRefreshing = false;
  EnrichedLockeResponseDto? _locke;
  String? _error;
  String? _loadingParticipantId;
  TextEditingController _deathsController = TextEditingController();

  // Tab controller
  late TabController _tabController;

  // Variables for dialog state
  bool _showEditDeathsDialog = false;
  EnrichedParticipantResponseDto? _selectedParticipant;

  // Variables for user management
  String? _loadingAdminId;
  String? _removingUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    ); // Changed length to 4
    _loadLockeDetails();
  }

  @override
  void dispose() {
    _deathsController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLockeDetails({bool isRefreshing = false}) async {
    if (!isRefreshing) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final apiService = ApiService();
      final locke = await apiService.getLockeById(widget.lockeId);

      if (mounted) {
        setState(() {
          _locke = locke;
          _error = null;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar los detalles de la partida: $e';
          _isLoading = false;
          _isRefreshing = false;
        });
      }
      debugPrint('Error loading locke details: $e');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadLockeDetails(isRefreshing: true);
  }

  Future<void> _updateDeathCount(String participantId, int newCount) async {
    try {
      setState(() {
        _loadingParticipantId = participantId;
      });

      final apiService = ApiService();
      await apiService.recordKill(
        widget.lockeId,
        newCount - (_getCurrentDeathCount(participantId) ?? 0),
      );
      await _loadLockeDetails(isRefreshing: true);

      // Close the dialog
      setState(() {
        _showEditDeathsDialog = false;
        _selectedParticipant = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar muertes: $e')),
      );
      debugPrint('Error updating death count: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingParticipantId = null;
        });
      }
    }
  }

  // User Management Methods
  Future<void> _toggleAdminStatus(String userId, bool makeAdmin) async {
    if (!_isUserAdmin()) return;

    try {
      setState(() {
        _loadingAdminId = userId;
      });

      final apiService = ApiService();
      final adminIds = [..._locke!.adminIds];

      if (makeAdmin && !adminIds.contains(userId)) {
        adminIds.add(userId);
      } else if (!makeAdmin && adminIds.contains(userId)) {
        adminIds.remove(userId);
      }

      await apiService.updateLocke(widget.lockeId, adminIds: adminIds);

      await _loadLockeDetails(isRefreshing: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar estado de administrador: $e'),
        ),
      );
      debugPrint('Error updating admin status: $e');
    } finally {
      setState(() {
        _loadingAdminId = null;
      });
    }
  }

  Future<void> _removeParticipant(String userId) async {
    if (!_isUserAdmin()) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar a este participante? Se perderán todos sus datos en esta partida.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    try {
      setState(() {
        _removingUserId = userId;
      });

      // This would require a new API endpoint - for now we'd update the locke with
      // a new participants list excluding this user
      // await apiService.removeParticipant(widget.lockeId, userId);

      // Since we don't have a direct API for removal, we'd need this on the backend
      // For now, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La eliminación de participantes no está implementada en la API actual',
          ),
        ),
      );

      // await _loadLockeDetails(isRefreshing: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar participante: $e')),
      );
    } finally {
      setState(() {
        _removingUserId = null;
      });
    }
  }

  int? _getCurrentDeathCount(String participantId) {
    if (_locke?.participants == null) return null;

    final participant = _locke!.participants!.firstWhere(
      (p) => p.userId == participantId,
    );

    return participant.deaths?.toInt();
  }

  bool _isUserAdmin() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (!userService.isAuthenticated ||
        userService.currentUser == null ||
        _locke?.adminIds == null) {
      return false;
    }

    return _locke!.adminIds!.contains(userService.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalles de la partida')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: TextStyle(color: colorScheme.error)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _loadLockeDetails(),
                child: const Text('Reintentar'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    if (_locke == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Partida no encontrada')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No se encontró la partida',
                style: TextStyle(color: colorScheme.error),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    // Format dates
    final String createdDate =
        _locke!.createdAt != null
            ? '${_locke!.createdAt!.day}/${_locke!.createdAt!.month}/${_locke!.createdAt!.year}'
            : 'Desconocida';

    final String updatedDate =
        _locke!.updatedAt != null
            ? '${_locke!.updatedAt!.day}/${_locke!.updatedAt!.month}/${_locke!.updatedAt!.year}'
            : 'Desconocida';

    // Calculate total deaths
    final totalDeaths =
        _locke!.participants?.fold<int>(
          0,
          (sum, participant) => sum + (participant.deaths?.toInt() ?? 0),
        ) ??
        0;

    // Get max deaths for chart scaling (used in Progress Tab for deaths chart)
    final maxDeathsForChart = // Renamed to avoid conflict if another maxDeaths is needed elsewhere
        _locke!.participants?.fold<int>(
          1, // Min 1 to avoid division by zero
          (max, participant) =>
              (participant.deaths?.toInt() ?? 0) > max
                  ? (participant.deaths?.toInt() ?? 0)
                  : max,
        ) ??
        1;

    return Scaffold(
      appBar: BackAppBar(
        title: _locke!.name ?? 'Detalles de la partida',
        fallbackRoute: '/lockes', // Go to lockes list if can't pop
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _handleRefresh,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: General
          _buildGeneralTab(
            colorScheme,
            userService,
            createdDate,
            updatedDate,
            totalDeaths, // Added totalDeaths
          ),

          // Tab 2: Progress
          _buildProgressTab(
            colorScheme,
            userService,
            // totalDeaths, // Removed totalDeaths
            maxDeathsForChart,
          ),

          // Tab 3: Battles
          _buildBattlesTab(),

          // Tab 4: User Management
          _buildUserManagementTab(colorScheme, userService),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(icon: Icon(Icons.info_outline), text: 'General'), // Changed
          Tab(icon: Icon(Icons.bar_chart), text: 'Progreso'), // New Tab
          Tab(icon: Icon(Icons.emoji_events), text: 'Batallas'),
          Tab(icon: Icon(Icons.people), text: 'Participantes'),
        ],
      ),
    );
  }

  // Tab content widgets
  Widget _buildGeneralTab(
    // Renamed from _buildStatisticsTab
    ColorScheme colorScheme,
    UserService userService,
    String createdDate,
    String updatedDate,
    int totalDeaths, // Added totalDeaths
  ) {
    EnrichedParticipantResponseDto? currentUserParticipant;
    if (_locke?.participants != null && userService.currentUser != null) {
      try {
        currentUserParticipant = _locke!.participants!.firstWhere(
          (p) => p.userId == userService.currentUser!.id,
        );
      } catch (e) {
        // Si firstWhere lanza una excepción (ej. StateError si no se encuentra el elemento),
        // currentUserParticipant permanecerá como null, que es el comportamiento deseado.
        // Opcionalmente, se puede añadir un debugPrint para registrar esta situación:
        // debugPrint('El usuario actual no es un participante en esta partida.');
      }
    }

    final currentUserDeaths = currentUserParticipant?.deaths?.toInt() ?? 0;
    final currentUserPoints = currentUserParticipant?.points?.toInt() ?? 0;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Info Card
            Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.videogame_asset),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _locke!.name ?? 'Sin nombre',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            _locke!.isActive ? 'Activa' : 'Completada',
                            style: TextStyle(
                              color:
                                  _locke!.isActive
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSecondaryContainer,
                            ),
                          ),
                          backgroundColor:
                              _locke!.isActive
                                  ? colorScheme.primaryContainer
                                  : colorScheme.secondaryContainer,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha inicio: $createdDate'),
                        const SizedBox(height: 4),
                        Text('Última actualización: $updatedDate'),
                      ],
                    ),
                  ),
                  // Admin Actions for completing locke
                  if (_isUserAdmin() && _locke!.isActive) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () {
                              // Mostrar el diálogo para marcar como completado
                              showDialog(
                                context: context,
                                builder:
                                    (context) => CompleteLockeDialog(
                                      lockeId: widget.lockeId,
                                      lockeName:
                                          _locke!.name ?? "Partida sin nombre",
                                      onSuccess: () {
                                        _loadLockeDetails();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              '¡Nuzlocke completado con éxito!',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                              );
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Marcar como completada'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16), // Added spacing
            // Current User Stats Card (MOVED HERE)
            if (userService.isAuthenticated &&
                currentUserParticipant != null &&
                currentUserParticipant
                    .userId
                    .isNotEmpty) // Added check for userId to ensure participant was found
              Card(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tu Progreso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: colorScheme.errorContainer.withOpacity(
                                0.6,
                              ), // Changed for better contrast
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '$currentUserDeaths',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            colorScheme
                                                .onErrorContainer, // Adjusted to onErrorContainer
                                      ),
                                    ),
                                    Text(
                                      'Tus Muertes',
                                      style: TextStyle(
                                        color: colorScheme.onErrorContainer,
                                      ), // Adjusted to onErrorContainer
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Card(
                              color: colorScheme.primaryContainer.withOpacity(
                                0.6,
                              ), // Changed for better contrast
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '$currentUserPoints',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            colorScheme
                                                .onPrimaryContainer, // Adjusted to onPrimaryContainer
                                      ),
                                    ),
                                    Text(
                                      'Tus Victorias', // Changed from "Tus Puntos"
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                      ), // Adjusted to onPrimaryContainer
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (userService.isAuthenticated &&
                currentUserParticipant != null &&
                currentUserParticipant
                    .userId
                    .isNotEmpty) // Added check for userId
              const SizedBox(
                height: 16,
              ), // Spacing after "Tu Progreso" if it's shown
            // Progress Summary Card
            Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Progreso general',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: colorScheme.surfaceVariant.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${_locke!.participants?.length ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Participantes'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Card(
                            color: colorScheme.errorContainer.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$totalDeaths', // Uses totalDeaths parameter
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Muertes totales'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Add some spacing at the end
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab(
    ColorScheme colorScheme,
    UserService userService,
    int maxKillsForChart,
  ) {
    return ProgressTab(
      locke: _locke!,
      onRefresh: _handleRefresh,
      lockeId: widget.lockeId,
      isAdmin: _isUserAdmin(),
      loadingParticipantId: _loadingParticipantId,
      onLoadLockeDetails: _loadLockeDetails,
      userService: userService,
    );
  }

  Widget _buildBattlesTab() {
    if (_locke == null) {
      return const Center(
        child: Text('No se ha cargado la información de la partida'),
      );
    }

    return BattlesTab(
      lockeId: widget.lockeId,
      participants: _locke!.participants!,
      isAdmin: _isUserAdmin(), // Pass the admin status
    );
  }

  Widget _buildUserManagementTab(
    ColorScheme colorScheme,
    UserService userService,
  ) {
    final isAdmin = _isUserAdmin();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Participantes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        if (isAdmin)
                          FilledButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AddParticipantDialog(
                                      lockeId: widget.lockeId,
                                      onSuccess: _loadLockeDetails,
                                    ),
                              );
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text('Añadir'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isAdmin
                          ? 'Como administrador, puedes gestionar los participantes y sus permisos.'
                          : 'Participantes en esta partida:',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_locke!.participants == null ||
                        _locke!.participants!.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text('No hay participantes en esta partida'),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _locke!.participants!.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final participant = _locke!.participants![index];
                          final isCurrentUser =
                              participant.userId == userService.currentUser?.id;
                          final isParticipantAdmin = _locke!.adminIds.contains(
                            participant.userId,
                          );

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isCurrentUser
                                      ? colorScheme.primaryContainer
                                      : colorScheme.surfaceVariant,
                              child: Text(
                                participant.name.isNotEmpty
                                    ? participant.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color:
                                      isCurrentUser
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  participant.name,
                                  style: TextStyle(
                                    fontWeight:
                                        isCurrentUser ? FontWeight.bold : null,
                                  ),
                                ),
                                if (isParticipantAdmin)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Tooltip(
                                      message: 'Administrador',
                                      child: Icon(
                                        Icons.admin_panel_settings,
                                        size: 16,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                if (isCurrentUser)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Tooltip(
                                      message: 'Tú',
                                      child: Icon(
                                        Icons.person,
                                        size: 16,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Text(
                              '@${participant.username} • ${participant.deaths?.toInt() ?? 0} muertes',
                            ),
                            trailing:
                                isAdmin && !isCurrentUser
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Toggle admin status
                                        IconButton(
                                          icon:
                                              _loadingAdminId ==
                                                      participant.userId
                                                  ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                  : Icon(
                                                    isParticipantAdmin
                                                        ? Icons
                                                            .admin_panel_settings
                                                        : Icons
                                                            .admin_panel_settings_outlined,
                                                  ),
                                          tooltip:
                                              isParticipantAdmin
                                                  ? 'Quitar permisos de administrador'
                                                  : 'Hacer administrador',
                                          onPressed:
                                              _loadingAdminId != null
                                                  ? null
                                                  : () => _toggleAdminStatus(
                                                    participant.userId!,
                                                    !isParticipantAdmin,
                                                  ),
                                        ),

                                        // Remove user
                                        IconButton(
                                          icon:
                                              _removingUserId ==
                                                      participant.userId
                                                  ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                  : Icon(
                                                    Icons.person_remove,
                                                    color: colorScheme.error,
                                                  ),
                                          tooltip: 'Eliminar participante',
                                          onPressed:
                                              _removingUserId != null
                                                  ? null
                                                  : () => _removeParticipant(
                                                    participant.userId!,
                                                  ),
                                        ),
                                      ],
                                    )
                                    : null,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditDeathsDialog() {
    return AlertDialog(
      title: const Text('Editar muertes'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Participante: ${_selectedParticipant?.name ?? 'Usuario'}'),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  final current = int.tryParse(_deathsController.text) ?? 0;
                  if (current > 0) {
                    setState(() {
                      _deathsController.text = (current - 1).toString();
                    });
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: _deathsController,
                  decoration: const InputDecoration(
                    labelText: 'Muertes',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final current = int.tryParse(_deathsController.text) ?? 0;
                  setState(() {
                    _deathsController.text = (current + 1).toString();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showEditDeathsDialog = false;
            });
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final newCount = int.tryParse(_deathsController.text) ?? 0;
            _updateDeathCount(_selectedParticipant!.userId!, newCount);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
