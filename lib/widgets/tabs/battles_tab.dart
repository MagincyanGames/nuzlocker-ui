import 'package:flutter/material.dart';
import '../../generated_code/api.swagger.dart';
import '../../services/api_service.dart';
import 'package:intl/intl.dart';

class BattlesTab extends StatefulWidget {
  final String lockeId;
  final List<EnrichedParticipantResponseDto> participants;
  final bool isAdmin;

  const BattlesTab({
    Key? key,
    required this.lockeId,
    required this.participants,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<BattlesTab> createState() => _BattlesTabState();
}

class _BattlesTabState extends State<BattlesTab> {
  bool _isLoading = true;
  List<EnrichedBattleResponseDto>? _battles;
  String? _error;
  String? _updatingBattleId;
  bool _isGridView = true; // Default to grid view

  @override
  void initState() {
    super.initState();
    _loadBattles();
  }

  Future<void> _loadBattles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final apiService = ApiService();
      final battles = await apiService.getLockleBattles(widget.lockeId);

      if (mounted) {
        setState(() {
          _battles = battles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar batallas: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Find participant name by ID
  String _getParticipantName(String userId) {
    final participant = widget.participants.firstWhere(
      (p) => p.userId == userId,
      orElse:
          () => EnrichedParticipantResponseDto(
            userId: userId,
            username: 'Usuario desconocido',
            name: 'Desconocido',
            deaths: 0,
            points: 0,
            isAdmin: false,
            score: 0,
          ),
    );
    return participant.name ?? 'Desconocido';
  }

  // Update battle status
  Future<void> _updateBattleStatus(
    EnrichedBattleResponseDto battle,
    EnrichedBattleResponseDtoStatus newStatus,
  ) async {
    if (!widget.isAdmin) return;

    try {
      setState(() {
        _updatingBattleId = battle.id;
      });

      final apiService = ApiService();

      // Convert EnrichedBattleResponseDtoStatus to UpdateBattleDtoStatus
      final statusForUpdate =
          newStatus == EnrichedBattleResponseDtoStatus.completed
              ? UpdateBattleDtoStatus.completed
              : UpdateBattleDtoStatus.scheduled;

      // Call the API to update the battle status
      await apiService.updateBattle(battle.id!, status: statusForUpdate);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Estado de la batalla actualizado correctamente'),
          ),
        );
      }

      // Refresh battles
      await _loadBattles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el estado: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingBattleId = null;
        });
      }
    }
  }

  // Show dialog to edit participant scores
  void _showEditScoresDialog(EnrichedBattleResponseDto battle) {
    if (!widget.isAdmin) return;

    // Create a map of current scores for editing
    final Map<String, TextEditingController> controllers = {};
    for (final result in battle.results ?? []) {
      if (result.userId != null) {
        controllers[result.userId!] = TextEditingController(
          text: (result.score ?? 0).toInt().toString(),
        );
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Editar puntuaciones'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final result in battle.results ?? [])
                    if (result.userId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getParticipantName(result.userId!),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    final current =
                                        int.tryParse(
                                          controllers[result.userId!]!.text,
                                        ) ??
                                        0;
                                    if (current > 0) {
                                      controllers[result.userId!]!.text =
                                          (current - 1).toString();
                                    }
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controllers[result.userId!],
                                    decoration: const InputDecoration(
                                      labelText: 'Puntos',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    final current =
                                        int.tryParse(
                                          controllers[result.userId!]!.text,
                                        ) ??
                                        0;
                                    controllers[result.userId!]!.text =
                                        (current + 1).toString();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  // Collect the new scores
                  final Map<String, int> newScores = {};
                  for (final entry in controllers.entries) {
                    final score = int.tryParse(entry.value.text) ?? 0;
                    newScores[entry.key] = score;
                  }

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Update battle scores
                  await _updateBattleScores(battle, newScores);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }

  // Update battle participant scores
  Future<void> _updateBattleScores(
    EnrichedBattleResponseDto battle,
    Map<String, int> newScores,
  ) async {
    if (!widget.isAdmin) return;

    try {
      setState(() {
        _updatingBattleId = battle.id;
      });

      final apiService = ApiService();

      // Convert the Map<String, int> to List<ParticipantResultDto>
      final updatedResults =
          battle.results?.map((result) {
            if (result.userId != null && newScores.containsKey(result.userId)) {
              return ParticipantResultDto(
                userId: result.userId,
                score: newScores[result.userId]!.toDouble(),
              );
            }
            return ParticipantResultDto(
              userId: result.userId,
              score: result.score,
            );
          }).toList() ??
          [];

      // Call the API to update the scores
      await apiService.updateBattleScores(battle.id!, updatedResults);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Puntuaciones actualizadas correctamente'),
          ),
        );
      }

      // Refresh battles
      await _loadBattles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar puntuaciones: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingBattleId = null;
        });
      }
    }
  }

  // Show dialog to edit battle date
  Future<void> _showDatePickerDialog(EnrichedBattleResponseDto battle) async {
    if (!widget.isAdmin) return;

    // Use battle.date if it exists, otherwise use current datetime
    final DateTime initialDate = battle.date ?? DateTime.now();
    final DateTime firstDate = DateTime(2020);
    final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate == null) return;

    // Show time picker after date is selected
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

    // Combine date and time
    final DateTime newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Update battle date
    await _updateBattleDate(battle, newDateTime);
  }

  // Update battle date
  Future<void> _updateBattleDate(
    EnrichedBattleResponseDto battle,
    DateTime newDate,
  ) async {
    if (!widget.isAdmin) return;

    try {
      setState(() {
        _updatingBattleId = battle.id;
      });

      final apiService = ApiService();

      // Call the API to update the battle date
      await apiService.updateBattle(battle.id!, date: newDate);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fecha de la batalla actualizada correctamente'),
          ),
        );
      }

      // Refresh battles
      await _loadBattles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la fecha: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingBattleId = null;
        });
      }
    }
  }

  // Show dialog to edit battle notes
  Future<void> _showEditNotesDialog(EnrichedBattleResponseDto battle) async {
    if (!widget.isAdmin) return;

    final notesController = TextEditingController(text: battle.notes ?? '');

    final String? newNotes = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Editar título de la batalla'),
            content: TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(notesController.text);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );

    if (newNotes != null) {
      await _updateBattleNotes(battle, newNotes);
    }
  }

  // Update battle notes
  Future<void> _updateBattleNotes(
    EnrichedBattleResponseDto battle,
    String newNotes,
  ) async {
    if (!widget.isAdmin) return;

    try {
      setState(() {
        _updatingBattleId = battle.id;
      });

      final apiService = ApiService();
      await apiService.updateBattle(battle.id!, notes: newNotes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notas de la batalla actualizadas correctamente'),
          ),
        );
      }
      await _loadBattles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar las notas: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _updatingBattleId = null;
        });
      }
    }
  }

  // Show dialog to create a new battle
  Future<void> _showCreateBattleDialog() async {
    if (!widget.isAdmin) return;

    // Date picker controller
    final DateTime initialDate = DateTime.now();
    DateTime? selectedDate = initialDate;

    // For best of selection
    final bestOfController = TextEditingController(text: '3');
    // For notes
    final notesController = TextEditingController();

    // For participant selection
    final Map<String, bool> selectedParticipants = {};
    for (final participant in widget.participants) {
      selectedParticipants[participant.userId] =
          true; // Default all to selected
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Crear nueva batalla'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and time picker
                        ListTile(
                          title: const Text('Fecha y hora'),
                          subtitle: Text(
                            selectedDate != null
                                ? DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(selectedDate!)
                                : 'Sin fecha',
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? initialDate,
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 30),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );

                            if (pickedDate != null) {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      selectedDate ?? initialDate,
                                    ),
                                  );

                              if (pickedTime != null) {
                                setState(() {
                                  selectedDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Best of selector
                        TextField(
                          controller: bestOfController,
                          decoration: const InputDecoration(
                            labelText:
                                'Al mejor de (número de enfrentamientos)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),

                        // Notes field
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Título de la batalla',
                            hintText: 'Ej: Primera ronda, Semifinal, etc.',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 1,
                        ),

                        const SizedBox(height: 24),

                        // Participants selection
                        const Text(
                          'Seleccionar participantes:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        ...widget.participants
                            .map(
                              (participant) => CheckboxListTile(
                                title: Text(participant.name),
                                subtitle: Text(participant.username),
                                value:
                                    selectedParticipants[participant.userId] ??
                                    false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedParticipants[participant.userId] =
                                        value ?? false;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Crear'),
                    ),
                  ],
                ),
          ),
    );

    // If dialog was confirmed
    if (confirmed == true) {
      // Collect selected participant IDs
      final List<String> participantIds = [];
      selectedParticipants.forEach((userId, selected) {
        if (selected) participantIds.add(userId);
      });

      // Validate inputs
      if (participantIds.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes seleccionar al menos un participante'),
            ),
          );
        }
        return;
      }

      // Parse best of
      final int bestOf = int.tryParse(bestOfController.text) ?? 3;

      // Create battle
      await _createBattle(
        participantIds: participantIds,
        bestOf: bestOf,
        date: selectedDate,
        notes: notesController.text,
      );
    }
  }

  // Método para mostrar el diálogo de creación de todas las batallas
  Future<void> _showCreateAllBattlesDialog() async {
    if (!widget.isAdmin) return;

    // Date picker controller
    final DateTime initialDate = DateTime.now();
    DateTime? selectedDate = initialDate;

    // For best of selection
    final bestOfController = TextEditingController(text: '3');
    // For notes
    final notesController = TextEditingController();

    // For participant selection
    final Map<String, bool> selectedParticipants = {};
    for (final participant in widget.participants) {
      selectedParticipants[participant.userId] =
          true; // Default all to selected
    }

    // Confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Crear todas las batallas'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Se crearán batallas para todas las combinaciones posibles entre los participantes seleccionados.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 16),

                        // Date and time picker
                        ListTile(
                          title: const Text('Fecha y hora de inicio'),
                          subtitle: Text(
                            selectedDate != null
                                ? DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(selectedDate!)
                                : 'Sin fecha',
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? initialDate,
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 30),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );

                            if (pickedDate != null) {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      selectedDate ?? initialDate,
                                    ),
                                  );

                              if (pickedTime != null) {
                                setState(() {
                                  selectedDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Best of selector
                        TextField(
                          controller: bestOfController,
                          decoration: const InputDecoration(
                            labelText:
                                'Al mejor de (número de enfrentamientos)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),

                        // Notes field
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText:
                                'Título base (se añadirá el nombre de los participantes)',
                            hintText: 'Ej: Ronda clasificatoria',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 1,
                        ),

                        const SizedBox(height: 24),

                        // Participants selection
                        const Text(
                          'Seleccionar participantes:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        ...widget.participants
                            .map(
                              (participant) => CheckboxListTile(
                                title: Text(participant.name),
                                subtitle: Text(participant.username),
                                value:
                                    selectedParticipants[participant.userId] ??
                                    false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedParticipants[participant.userId] =
                                        value ?? false;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Crear batallas'),
                    ),
                  ],
                ),
          ),
    );

    // If dialog was confirmed
    if (confirmed == true) {
      // Collect selected participant IDs
      final List<String> participantIds = [];
      selectedParticipants.forEach((userId, selected) {
        if (selected) participantIds.add(userId);
      });

      // Validate inputs
      if (participantIds.length < 2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes seleccionar al menos 2 participantes'),
            ),
          );
        }
        return;
      }

      // Parse best of
      final int bestOf = int.tryParse(bestOfController.text) ?? 3;

      // Create all battles
      await _createAllBattles(
        participantIds: participantIds,
        bestOf: bestOf,
        date: selectedDate,
        notes: notesController.text,
      );
    }
  }

  // Create a new battle
  Future<void> _createBattle({
    required List<String> participantIds,
    required int bestOf,
    DateTime? date,
    String? notes,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final apiService = ApiService();

      // Create initial battle with minimal information
      final response = await apiService.api.apiLockesIdBattlesPost(
        id: widget.lockeId,
        body: CreateBattleDto(
          date: date,
          participantIds: participantIds,
          bestOf: bestOf.toDouble(),
          status: CreateBattleDtoStatus.scheduled,
          notes: notes ?? '',
          results:
              participantIds
                  .map(
                    (userId) => ParticipantResultDto(
                      userId: userId,
                      score: 0, // Initial score is 0
                    ),
                  )
                  .toList(),
        ),
      );

      if (response.isSuccessful && response.body != null) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Batalla creada correctamente')),
          );
        }

        // Refresh battles
        await _loadBattles();
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear la batalla: ${response.error}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la batalla: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Create all battles
  Future<void> _createAllBattles({
    required List<String> participantIds,
    required int bestOf,
    DateTime? date,
    String? notes,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final apiService = ApiService();

      // Create battles for all combinations of participants
      final List<CreateBattleDto> battlesToCreate = [];

      for (int i = 0; i < participantIds.length; i++) {
        for (int j = i + 1; j < participantIds.length; j++) {
          final participant1 = participantIds[i];
          final participant2 = participantIds[j];

          // Create battle for this pair
          battlesToCreate.add(
            CreateBattleDto(
              date: date,
              participantIds: [participant1, participant2],
              bestOf: bestOf.toDouble(),
              status: CreateBattleDtoStatus.scheduled,
              notes:
                  notes != null && notes.isNotEmpty
                      ? '$notes - ${_getParticipantName(participant1)} vs ${_getParticipantName(participant2)}'
                      : '${_getParticipantName(participant1)} vs ${_getParticipantName(participant2)}',
              results: [
                ParticipantResultDto(userId: participant1, score: 0),
                ParticipantResultDto(userId: participant2, score: 0),
              ],
            ),
          );
        }
      }

      // Send batch request to create all battles
      final responses = await Future.wait(
        battlesToCreate.map(
          (battleDto) => apiService.api.apiLockesIdBattlesPost(
            id: widget.lockeId,
            body: battleDto,
          ),
        ),
      );

      // Check responses
      for (final response in responses) {
        if (!response.isSuccessful) {
          throw Exception('Error al crear una batalla: ${response.error}');
        }
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Batallas creadas correctamente')),
        );
      }

      // Refresh battles
      await _loadBattles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear batallas: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading && _battles == null) {
      // Show loading only on initial load
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: colorScheme.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBattles,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_battles == null || _battles!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay batallas registradas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Las batallas aparecerán aquí una vez registradas',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            if (widget.isAdmin)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.icon(
                      onPressed: _showCreateBattleDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Crear batalla'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _showCreateAllBattlesDialog,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Crear todas las combinaciones'),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    // Sort battles by date (most recent first)
    _battles!.sort((a, b) {
      // Handle cases when either date is null
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1; // null dates go at the end
      if (b.date == null) return -1;
      // Normal comparison for non-null dates (newest first)
      return b.date!.compareTo(a.date!);
    });

    return RefreshIndicator(
      onRefresh: _loadBattles,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Historial de Batallas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  // View toggle button
                  IconButton(
                    icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                    tooltip:
                        _isGridView ? 'Ver como lista' : 'Ver como cuadrícula',
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                  if (widget.isAdmin)
                    PopupMenuButton<String>(
                      tooltip: 'Opciones de creación',
                      icon: const Icon(Icons.add_circle),
                      onSelected: (value) {
                        if (value == 'single') {
                          _showCreateBattleDialog();
                        } else if (value == 'all') {
                          _showCreateAllBattlesDialog();
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'single',
                              child: Text('Crear batalla individual'),
                            ),
                            const PopupMenuItem(
                              value: 'all',
                              child: Text('Crear todas las combinaciones'),
                            ),
                          ],
                    ),
                ],
              ),
            ),
            _isGridView
                ? _buildBattlesGrid(_battles!, colorScheme)
                : _buildBattlesList(_battles!, colorScheme),
          ],
        ),
      ),
    );
  }

  // New method to build grid view
  Widget _buildBattlesGrid(
    List<EnrichedBattleResponseDto> battles,
    ColorScheme colorScheme,
  ) {
    // Calculate grid columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // Default for small screens

    if (screenWidth > 1200) {
      crossAxisCount = 5; // Very wide screens
    } else if (screenWidth > 900) {
      crossAxisCount = 4; // Wide screens
    } else if (screenWidth > 600) {
      crossAxisCount = 3; // Medium screens
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5, // Increased from 1.5 to make items shorter
      ),
      itemCount: battles.length,
      itemBuilder: (context, index) {
        final battle = battles[index];
        return _buildBattleGridItem(battle, colorScheme);
      },
    );
  }

  // New grid item widget
  Widget _buildBattleGridItem(
    EnrichedBattleResponseDto battle,
    ColorScheme colorScheme,
  ) {
    final dateFormat = DateFormat('dd/MM');
    final formattedDate = battle.date != null ? dateFormat.format(battle.date!) : 'Sin fecha';

    // Determine battle status
    final bool isCompleted = battle.status == EnrichedBattleResponseDtoStatus.completed;
    final statusColor = isCompleted ? colorScheme.primary : colorScheme.tertiary;
    final statusText = isCompleted ? 'Completada' : 'En curso';
    
    // Find winner if battle is completed
    EnrichedResultDto? winner;
    if (isCompleted && battle.results != null && battle.results!.isNotEmpty) {
      winner = battle.results!.reduce((a, b) => (a.score ?? 0) > (b.score ?? 0) ? a : b);
    }

    final isUpdating = _updatingBattleId == battle.id;
    
    // Get screen width to adjust layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isVeryNarrow = screenWidth < 300; // Extremely small screens

    return Card(
      
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      margin: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isCompleted ? colorScheme.primary.withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showBattleDetailsDialog(battle),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status bar at top
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryNarrow ? 4 : 6,
                    vertical: 2,
                  ),
                  color: statusColor.withOpacity(0.15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.schedule,
                        size: 10,
                        color: statusColor,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.normal,
                            color: statusColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 9,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Battle content
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isVeryNarrow ? 4 : 8,
                    isVeryNarrow ? 4 : 6,
                    isVeryNarrow ? 4 : 8,
                    isVeryNarrow ? 2 : 4
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with ellipsis
                      Text(
                        battle.notes != null && battle.notes!.isNotEmpty
                            ? battle.notes!
                            : 'Batalla',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isVeryNarrow ? 11 : 12,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: isVeryNarrow ? 4 : 8),
                      
                      // Participants section
                      if (battle.results != null && battle.results!.length >= 2)
                        _buildParticipantsSection(battle, winner, colorScheme, isVeryNarrow),
                    ],
                  ),
                ),
              ],
            ),

            // Admin edit button - make it smaller on very narrow screens

            // Loading indicator
            if (isUpdating)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: SizedBox(
                      width: isVeryNarrow ? 16 : 20,
                      height: isVeryNarrow ? 16 : 20,
                      child: CircularProgressIndicator(strokeWidth: isVeryNarrow ? 1.5 : 2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build participants section with scores if available
  Widget _buildParticipantsSection(
    EnrichedBattleResponseDto battle, 
    EnrichedResultDto? winner, 
    ColorScheme colorScheme,
    bool isVeryNarrow
  ) {
    final bool isCompleted = battle.status == EnrichedBattleResponseDtoStatus.completed;
    
    return Column(
      children: battle.results!.take(2).map((result) {
        final bool isWinner = isCompleted && winner != null && result.userId == winner.userId;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isVeryNarrow ? 2 : 4, 
            horizontal: isVeryNarrow ? 3 : 6
          ),
          margin: EdgeInsets.only(bottom: isVeryNarrow ? 1 : 2),
          decoration: isWinner ? BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ) : null,
          child: Row(
            children: [
              if (isWinner && !isVeryNarrow)
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Icon(Icons.emoji_events, size: 10, color: Colors.amber),
                ),
                
              Expanded(
                child: Text(
                  _getParticipantName(result.userId ?? ''),
                  style: TextStyle(
                    fontSize: isVeryNarrow ? 10 : 12,
                    fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              if (isCompleted && result.score != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryNarrow ? 4 : 6, 
                    vertical: 1
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${result.score!.toInt()}',
                    style: TextStyle(
                      fontSize: isVeryNarrow ? 9 : 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Add this method to show battle details when tapping a card
  void _showBattleDetailsDialog(EnrichedBattleResponseDto battle) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate =
        battle.date != null ? dateFormat.format(battle.date!) : 'Sin fecha';
    final colorScheme = Theme.of(context).colorScheme;

    // Get status as string
    String statusText = '';
    if (battle.status != null) {
      switch (battle.status) {
        case EnrichedBattleResponseDtoStatus.scheduled:
          statusText = 'En curso';
          break;
        case EnrichedBattleResponseDtoStatus.completed:
          statusText = 'Completada';
          break;
        default:
          statusText = 'Desconocido';
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title:
                widget.isAdmin
                    ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            battle.notes != null && battle.notes!.isNotEmpty
                                ? battle.notes!
                                : 'Detalles de la batalla',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          tooltip: 'Editar título',
                          onPressed: () {
                            Navigator.of(context).pop(); // Close details dialog
                            _showEditNotesDialog(battle);
                          },
                        ),
                      ],
                    )
                    : Text(
                      battle.notes != null && battle.notes!.isNotEmpty
                          ? battle.notes!
                          : 'Detalles de la batalla',
                    ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date with edit option for admins
                if (widget.isAdmin)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(formattedDate),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.edit_calendar, size: 16),
                        label: const Text('Cambiar fecha'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close details dialog
                          _showDatePickerDialog(battle);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero, // Remove extra padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(formattedDate),
                    ],
                  ),
                const SizedBox(height: 12),

                // Status with edit option for admins
                if (widget.isAdmin)
                  Row(
                    children: [
                      Text(
                        'Estado: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton<EnrichedBattleResponseDtoStatus>(
                        initialValue: battle.status,
                        tooltip: 'Cambiar estado',
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value:
                                    EnrichedBattleResponseDtoStatus.scheduled,
                                child: Text('En curso'),
                              ),
                              const PopupMenuItem(
                                value:
                                    EnrichedBattleResponseDtoStatus.completed,
                                child: Text('Completada'),
                              ),
                            ],
                        onSelected: (newStatus) {
                          Navigator.of(context).pop(); // Close details dialog
                          _updateBattleStatus(battle, newStatus);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                battle.status ==
                                        EnrichedBattleResponseDtoStatus
                                            .completed
                                    ? colorScheme.primaryContainer
                                    : colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      battle.status ==
                                              EnrichedBattleResponseDtoStatus
                                                  .completed
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 14,
                                color:
                                    battle.status ==
                                            EnrichedBattleResponseDtoStatus
                                                .completed
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      const Text(
                        'Estado: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              battle.status ==
                                      EnrichedBattleResponseDtoStatus.completed
                                  ? colorScheme.primaryContainer
                                  : colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                battle.status ==
                                        EnrichedBattleResponseDtoStatus
                                            .completed
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Results
                const Text(
                  'Resultados:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (battle.results != null && battle.results!.isNotEmpty)
                  ...battle.results!
                      .map(
                        (result) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _getParticipantName(result.userId ?? ''),
                                ),
                              ),
                              Text(
                                '${(result.score ?? 0).toInt()} puntos',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()
                else
                  const Text('No hay resultados disponibles'),
              ],
            ),
            actions: [
              if (widget.isAdmin)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close details dialog
                    _showEditScoresDialog(battle);
                  },
                  child: const Text('Editar puntuaciones'),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  // ...existing code...
  // Rename existing list builder to avoid conflicts
  Widget _buildBattlesList(
    List<EnrichedBattleResponseDto> battles,
    ColorScheme colorScheme,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: battles.length,
      itemBuilder: (context, index) {
        final battle = battles[index];
        final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
        final formattedDate =
            battle.date != null ? dateFormat.format(battle.date!) : 'Sin fecha';

        // Get status as string
        String statusText = '';
        if (battle.status != null) {
          switch (battle.status) {
            case EnrichedBattleResponseDtoStatus.scheduled:
              statusText = 'En curso';
              break;
            case EnrichedBattleResponseDtoStatus.completed:
              statusText = 'Completada';
              break;
            default:
              statusText = 'Desconocido';
          }
        }

        final isUpdating = _updatingBattleId == battle.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sports_kabaddi, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        battle.notes != null && battle.notes!.isNotEmpty
                            ? battle.notes!
                            : 'Batalla ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (widget.isAdmin && !isUpdating)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        tooltip: 'Editar título',
                        onPressed: () => _showEditNotesDialog(battle),
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                    // Status chip follows here...
                    if (widget.isAdmin && !isUpdating)
                      PopupMenuButton<EnrichedBattleResponseDtoStatus>(
                        initialValue: battle.status,
                        tooltip: 'Cambiar estado',
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value:
                                    EnrichedBattleResponseDtoStatus.scheduled,
                                child: Text('En curso'),
                              ),
                              const PopupMenuItem(
                                value:
                                    EnrichedBattleResponseDtoStatus.completed,
                                child: Text('Completada'),
                              ),
                            ],
                        onSelected:
                            (status) => _updateBattleStatus(battle, status),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                battle.status ==
                                        EnrichedBattleResponseDtoStatus
                                            .completed
                                    ? colorScheme.primaryContainer
                                    : colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      battle.status ==
                                              EnrichedBattleResponseDtoStatus
                                                  .completed
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 14,
                                color:
                                    battle.status ==
                                            EnrichedBattleResponseDtoStatus
                                                .completed
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onTertiaryContainer,
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (isUpdating)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              battle.status ==
                                      EnrichedBattleResponseDtoStatus.completed
                                  ? colorScheme.primaryContainer
                                  : colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                battle.status ==
                                        EnrichedBattleResponseDtoStatus
                                            .completed
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                const Divider(),

                // Date of the battle
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: colorScheme.tertiary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fecha: $formattedDate',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (widget.isAdmin && !isUpdating)
                      IconButton(
                        icon: const Icon(Icons.edit_calendar, size: 16),
                        tooltip: 'Cambiar fecha',
                        onPressed: () => _showDatePickerDialog(battle),
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8), // Adjusted spacing
                // Participant results
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Resultados:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                    if (widget.isAdmin && !isUpdating)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Editar puntuaciones',
                        onPressed: () => _showEditScoresDialog(battle),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Results table
                if (isUpdating)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (battle.results != null && battle.results!.isNotEmpty)
                  _buildResultsTable(battle.results!, colorScheme)
                else
                  const Text('No hay resultados disponibles'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsTable(
    List<EnrichedResultDto> results,
    ColorScheme colorScheme,
  ) {
    // Find the participant with the highest score
    EnrichedResultDto? topWinner;
    if (results.isNotEmpty) {
      topWinner = results.reduce(
        (a, b) => (a.score ?? 0) > (b.score ?? 0) ? a : b,
      );
    }

    return Column(
      children:
          results.map((result) {
            final isTopWinner =
                topWinner != null &&
                result.userId == topWinner.userId &&
                (result.score ?? 0) > 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isTopWinner
                      ? colorScheme.primaryContainer.withOpacity(0.3)
                      : colorScheme.surfaceVariant.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: isTopWinner
                      ? Border.all(color: colorScheme.primary, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    if (isTopWinner)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    // Cambia aquí: usa Flexible y limita el texto
                    Flexible(
                      child: Text(
                        _getParticipantName(result.userId ?? ''),
                        style: TextStyle(
                          fontWeight: isTopWinner ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(result.score ?? 0).toInt()} puntos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
