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

class LockeDetailsScreen extends StatefulWidget {
  final String lockeId;

  const LockeDetailsScreen({super.key, required this.lockeId});

  @override
  State<LockeDetailsScreen> createState() => _LockeDetailsScreenState();
}

class _LockeDetailsScreenState extends State<LockeDetailsScreen> {
  bool _isLoading = true;
  bool _isRefreshing = false;
  EnrichedLockeResponseDto? _locke;
  String? _error;
  String? _loadingParticipantId;
  TextEditingController _deathsController = TextEditingController();

  // Variables for dialog state
  bool _showEditDeathsDialog = false;
  EnrichedParticipantResponseDto? _selectedParticipant;

  @override
  void initState() {
    super.initState();
    _loadLockeDetails();
  }

  @override
  void dispose() {
    _deathsController.dispose();
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

    // Get max deaths for chart scaling
    final maxDeaths =
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
      body: RefreshIndicator(
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

                    /*
                    if (_locke!.description != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          _locke!.description!,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      */
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

                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Progreso',
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
                              color: colorScheme.surfaceVariant.withOpacity(
                                0.3,
                              ),
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
                              color: colorScheme.errorContainer.withOpacity(
                                0.3,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '$totalDeaths',
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

                    // Admin Actions
                    if (_isUserAdmin() && _locke!.isActive)
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
                                  builder: (context) => CompleteLockeDialog(
                                    lockeId: widget.lockeId,
                                    lockeName: _locke!.name ?? "Partida sin nombre",
                                    onSuccess: () {
                                      _loadLockeDetails();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('¡Nuzlocke completado con éxito!'),
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
                ),
              ),

              const SizedBox(height: 16),

              // Participants Deaths Chart
              Card(
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Muertes por participante',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    // Legend
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Otros participantes'),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('Tú'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _isUserAdmin()
                            ? 'Como administrador, puedes editar las muertes de todos los participantes.'
                            : 'Solo puedes editar tus propias muertes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    if (_locke!.participants == null ||
                        _locke!.participants!.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No hay participantes en esta partida.'),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children:
                              _locke!.participants!.map((participant) {
                                final isCurrentUser =
                                    participant.userId ==
                                    userService.currentUser?.id;
                                final deathCount =
                                    participant.deaths?.toInt() ?? 0;
                                final barWidth = (deathCount / maxDeaths) * 100;
                                final canEdit = isCurrentUser || _isUserAdmin();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    children: [
                                      // Participant name
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          participant.name ?? 'User',
                                          style: TextStyle(
                                            fontWeight:
                                                isCurrentUser
                                                    ? FontWeight.bold
                                                    : null,
                                            color:
                                                isCurrentUser
                                                    ? colorScheme.primary
                                                    : null,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      // Bar chart
                                      Expanded(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            final maxAvailableWidth =
                                                constraints.maxWidth;
                                            // Calcula un ancho mínimo razonable para barras con 0 muertes
                                            final minWidth = maxAvailableWidth *
                                                0.1; // 10% del ancho disponible

                                            // Calcula el ancho proporcional, con un mínimo para barras con valor 0
                                            final calculatedWidth = deathCount == 0
                                                ? minWidth
                                                : maxAvailableWidth *
                                                    (deathCount / maxDeaths);

                                            return Container(
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: colorScheme.surfaceVariant
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: calculatedWidth,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: isCurrentUser
                                                          ? colorScheme.primary
                                                          : colorScheme.error,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      '$deathCount',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      // Edit button
                                      if (canEdit)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                          ),
                                          child: IconButton(
                                            icon: _loadingParticipantId == participant.userId
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                  ),
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  colorScheme.primaryContainer,
                                            ),
                                            onPressed: _loadingParticipantId != null
                                                ? null
                                                : () {
                                                    // Aquí está el cambio - mostrar el diálogo directamente
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => EditDeathsDialog(
                                                        lockeId: widget.lockeId,
                                                        participant: participant,
                                                        onSuccess: _loadLockeDetails,
                                                      ),
                                                    );
                                                  },
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Edit deaths dialog
      floatingActionButton:
          _isUserAdmin()
              ? FloatingActionButton(
                heroTag: 'add_participant',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddParticipantDialog(
                      lockeId: widget.lockeId,
                      onSuccess: _loadLockeDetails,
                    ),
                  );
                },
                tooltip: 'Añadir participante',
                child: const Icon(Icons.person_add),
              )
              : null,
    );

    // Return the builder with the dialog
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
