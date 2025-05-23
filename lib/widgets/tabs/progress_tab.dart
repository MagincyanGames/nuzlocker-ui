import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../generated_code/api.swagger.dart';
import '../../services/user_service.dart';
import '../edit_deaths_dialog.dart';
import '../chart_bar.dart';

class ProgressTab extends StatefulWidget {
  final EnrichedLockeResponseDto locke;
  final Future<void> Function() onRefresh;
  final String lockeId;
  final bool isAdmin;
  final String? loadingParticipantId;
  final Future<void> Function() onLoadLockeDetails;
  final UserService userService;

  const ProgressTab({
    Key? key,
    required this.locke,
    required this.onRefresh,
    required this.lockeId,
    required this.isAdmin,
    required this.loadingParticipantId,
    required this.onLoadLockeDetails,
    required this.userService,
  }) : super(key: key);

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  final PageController _scorePageController = PageController();
  final ValueNotifier<int> _currentScorePageNotifier = ValueNotifier(0);
  
  @override
  void dispose() {
    _scorePageController.dispose();
    _currentScorePageNotifier.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Get max deaths for chart scaling
    final maxKillsForChart =
        widget.locke.participants?.fold<int>(
          1, // Min 1 to avoid division by zero
          (max, participant) =>
              (participant.deaths?.toInt() ?? 0) > max
                  ? (participant.deaths?.toInt() ?? 0)
                  : max,
        ) ??
        1;

    // Add a helper to create section headers
    Widget buildSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kills Chart
            Card(
              elevation: 2,
              shadowColor: colorScheme.shadow.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionHeader('Muertes por participante'),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.isAdmin
                          ? 'Como administrador, puedes editar las muertes de todos los participantes.'
                          : 'Solo puedes editar tus propias muertes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  if (widget.locke.participants == null || widget.locke.participants!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No hay participantes en esta partida.'),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children:
                            widget.locke.participants!.map((participant) {
                              final isCurrentUser =
                                  participant.userId ==
                                  widget.userService.currentUser?.id;
                              final killsCount =
                                  participant.deaths?.toInt() ?? 0;
                              final canEdit = isCurrentUser || widget.isAdmin;

                              return Row(
                                children: [
                                  Expanded(
                                    child: ChartBar(
                                      value: killsCount.toDouble(),
                                      maxValue: maxKillsForChart.toDouble(),
                                      label: participant.name ?? 'User',
                                      isCurrentUser: isCurrentUser,
                                      primaryColor: colorScheme.primary,
                                      secondaryColor: colorScheme.tertiary,
                                      showEditButton: canEdit, // Nueva propiedad
                                      isLoading: widget.loadingParticipantId == participant.userId, // Nueva propiedad
                                      onEdit: () { // Nueva propiedad
                                        showDialog(
                                          context: context,
                                          builder: (context) => EditDeathsDialog(
                                            lockeId: widget.lockeId,
                                            participant: participant,
                                            onSuccess: widget.onLoadLockeDetails,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Points Chart (Victorias)
            Card(
              elevation: 2,
              shadowColor: colorScheme.shadow.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionHeader('Victorias por participante'),

                  const SizedBox(height: 8),

                  if (widget.locke.participants == null || widget.locke.participants!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No hay participantes en esta partida.'),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children:
                            widget.locke.participants!.map((participant) {
                              final isCurrentUser =
                                  participant.userId ==
                                  widget.userService.currentUser?.id;
                              final pointsCount =
                                  participant.points?.toInt() ?? 0;

                              // Calculate max points for chart scaling
                              final maxPoints =
                                  widget.locke.participants?.fold<int>(
                                    1, // Min 1 to avoid division by zero
                                    (max, p) =>
                                        (p.points?.toInt() ?? 0) > max
                                            ? (p.points?.toInt() ?? 0)
                                            : max,
                                  ) ??
                                  1;

                              return ChartBar(
                                value: pointsCount.toDouble(),
                                maxValue: maxPoints.toDouble(),
                                label: participant.name ?? 'User',
                                isCurrentUser: isCurrentUser,
                                primaryColor: colorScheme.primary,
                                secondaryColor: colorScheme.tertiary,
                              );
                            }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
  
            // Score Charts (MCM, WCM, Average) en formato carrusel
            Card(
              elevation: 2,
              shadowColor: colorScheme.shadow.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título dinámico que cambia según la página actual
                  ValueListenableBuilder<int>(
                    valueListenable: _currentScorePageNotifier,
                    builder: (context, currentPage, _) {
                      final titles = [
                        'Score Medio por participante',
                        'Score MCM por participante',
                        'Score WCM por participante'
                      ];
                      return buildSectionHeader(titles[currentPage]);
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  if (widget.locke.participants == null || widget.locke.participants!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No hay participantes en esta partida.'),
                    )
                  else
                    Column(
                      children: [
                        // PageView para deslizar entre las tres gráficas
                        SizedBox(
                          height: widget.locke.participants != null 
                              ? widget.locke.participants!.length * 44.0 + 32.0 // Altura por participante + padding
                              : 220.0, // Altura predeterminada
                          child: PageView(
                            controller: _scorePageController,
                            onPageChanged: (index) {
                              _currentScorePageNotifier.value = index;
                            },
                            children: [
                              // Página 1: Score Medio
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: widget.locke.participants!.map((participant) {
                                    final isCurrentUser = participant.userId == widget.userService.currentUser?.id;
                                    final averageScore = ((participant.score.mcm + participant.score.wcm) / 2 * 100).toInt();
                                    final maxScore = widget.locke.participants!.fold<int>(
                                      1,
                                      (max, p) {
                                        final avgScore = ((p.score.mcm + p.score.wcm) / 2 * 100).toInt();
                                        return avgScore > max ? avgScore : max;
                                      },
                                    );
                                    return ChartBar(
                                      value: averageScore.toDouble(),
                                      maxValue: maxScore.toDouble(),
                                      label: participant.name ?? 'User',
                                      isCurrentUser: isCurrentUser,
                                      primaryColor: colorScheme.primary,
                                      secondaryColor: colorScheme.tertiary,
                                    );
                                  }).toList(),
                                ),
                              ),
                              
                              // Página 2: Score MCM
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: widget.locke.participants!.map((participant) {
                                    final isCurrentUser = participant.userId == widget.userService.currentUser?.id;
                                    final scoreCount = (participant.score.mcm * 100).toInt();
                                    final maxScore = widget.locke.participants!.fold<int>(
                                      1,
                                      (max, p) => (p.score.mcm * 100).toInt() > max
                                          ? (p.score.mcm * 100).toInt()
                                          : max,
                                    );
                                    return ChartBar(
                                      value: scoreCount.toDouble(),
                                      maxValue: maxScore.toDouble(),
                                      label: participant.name ?? 'User',
                                      isCurrentUser: isCurrentUser,
                                      primaryColor: colorScheme.primary,
                                      secondaryColor: colorScheme.tertiary,
                                    );
                                  }).toList(),
                                ),
                              ),
                              
                              // Página 3: Score WCM
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: widget.locke.participants!.map((participant) {
                                    final isCurrentUser = participant.userId == widget.userService.currentUser?.id;
                                    final scoreCount = (participant.score.wcm * 100).toInt();
                                    final maxScore = widget.locke.participants!.fold<int>(
                                      1,
                                      (max, p) => (p.score.wcm * 100).toInt() > max
                                          ? (p.score.wcm * 100).toInt()
                                          : max,
                                    );
                                    return ChartBar(
                                      value: scoreCount.toDouble(),
                                      maxValue: maxScore.toDouble(),
                                      label: participant.name ?? 'User',
                                      isCurrentUser: isCurrentUser,
                                      primaryColor: colorScheme.primary,
                                      secondaryColor: colorScheme.tertiary,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Indicadores de página (dots)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _currentScorePageNotifier,
                            builder: (context, currentPage, _) {
                              return DotsIndicator(
                                dotsCount: 3,
                                position: currentPage.toDouble(),
                                decorator: DotsDecorator(
                                  color: colorScheme.surfaceVariant,
                                  activeColor: colorScheme.primary,
                                  size: const Size.square(8.0),
                                  activeSize: const Size(24.0, 8.0),
                                  activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onTap: (position) {
                                  _scorePageController.animateToPage(
                                    position.toInt(),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        
                        // Controles de navegación
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _currentScorePageNotifier,
                            builder: (context, currentPage, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Botón anterior
                                  IconButton(
                                    onPressed: currentPage > 0
                                        ? () {
                                            _scorePageController.previousPage(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        : null,
                                    icon: const Icon(Icons.arrow_back),
                                    color: currentPage > 0
                                        ? colorScheme.primary
                                        : colorScheme.surfaceVariant,
                                  ),
                                  
                                  // Espacio entre botones
                                  const SizedBox(width: 24),
                                  
                                  // Botón siguiente
                                  IconButton(
                                    onPressed: currentPage < 2
                                        ? () {
                                            _scorePageController.nextPage(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        : null,
                                    icon: const Icon(Icons.arrow_forward),
                                    color: currentPage < 2
                                        ? colorScheme.primary
                                        : colorScheme.surfaceVariant,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
