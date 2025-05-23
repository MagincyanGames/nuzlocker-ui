import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';
import '../generated_code/api.swagger.dart';
import 'package:dots_indicator/dots_indicator.dart'; // Añadir esta dependencia para los indicadores de página

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _apiService = ApiService();
  bool _isLoading = true;
  UserStatisticsDto? _myStats;
  List<UserStatisticsDto>? _rankings;
  String? _error;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Definir los atributos y sus detalles de visualización
  final List<Map<String, dynamic>> _rankingAttributes = [
    {
      'key': 'totalDeaths',
      'title': 'Total de Muertes',
      'icon': FontAwesomeIcons.skull,
      'color': Colors.red,
      'inverseRanking': false, // Menor es mejor
    },
    {
      'key': 'averageDeathsPerLocke',
      'title': 'Promedio de Muertes',
      'icon': FontAwesomeIcons.chartLine,
      'color': Colors.orange,
      'inverseRanking': false,
    },
    {
      'key': 'totalBattlesWon',
      'title': 'Batallas Ganadas',
      'icon': FontAwesomeIcons.trophy,
      'color': Colors.green,
      'inverseRanking': true, // Mayor es mejor
    },
    {
      'key': 'totalBattlePoints',
      'title': 'Puntos de Batalla',
      'icon': FontAwesomeIcons.star,
      'color': Colors.amber,
      'inverseRanking': true,
    },
    {
      'key': 'performanceScore',
      'title': 'Puntuación Global',
      'icon': FontAwesomeIcons.medal,
      'color': Colors.blue,
      'inverseRanking': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Escuchar cambios de página
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (_currentPage != newPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Cargar datos en paralelo
      final myStats = await _apiService.getMyStatistics();
      final rankings = await _apiService.getGlobalRankings();

      setState(() {
        _myStats = myStats;
        _rankings = rankings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar las estadísticas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Estadísticas'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorScheme.error),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.tonal(
                            onPressed: _loadData,
                            child: const Text('Intentar de nuevo'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sección de estadísticas personales
                        _buildPersonalStats(colorScheme),
                        
                        const SizedBox(height: 24),
                        
                        // Sección de rankings por categoría
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                          child: Text(
                            'Rankings Globales',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        
                        // Carrusel de rankings (PageView horizontal)
                        SizedBox(
                          height: 280, // Altura fija para el PageView
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _rankingAttributes.length,
                            itemBuilder: (context, index) {
                              final attr = _rankingAttributes[index];
                              return _buildRankingCard(
                                attr['key'],
                                attr['title'],
                                attr['icon'],
                                Color(attr['color'].value),
                                attr['inverseRanking'],
                                colorScheme,
                              );
                            },
                          ),
                        ),
                        
                        // Indicadores de página (dots)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Center(
                            child: DotsIndicator(
                              dotsCount: _rankingAttributes.length,
                              position: _currentPage.toDouble(),
                              decorator: DotsDecorator(
                                color: colorScheme.surfaceVariant,
                                activeColor: Color(_rankingAttributes[_currentPage]['color'].value),
                                size: const Size.square(8.0),
                                activeSize: const Size(24.0, 8.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onTap: (position) {
                                _pageController.animateToPage(
                                  position,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        ),
                        
                        // Controles de navegación
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Botón anterior
                              IconButton(
                                onPressed: _currentPage > 0
                                    ? () {
                                        _pageController.previousPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_back),
                                color: _currentPage > 0
                                    ? Color(_rankingAttributes[_currentPage]['color'].value)
                                    : colorScheme.surfaceVariant,
                              ),
                              
                              // Título del ranking actual
                              Expanded(
                                child: Center(
                                  child: Text(
                                    _rankingAttributes[_currentPage]['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(_rankingAttributes[_currentPage]['color'].value),
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Botón siguiente
                              IconButton(
                                onPressed: _currentPage < _rankingAttributes.length - 1
                                    ? () {
                                        _pageController.nextPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.arrow_forward),
                                color: _currentPage < _rankingAttributes.length - 1
                                    ? Color(_rankingAttributes[_currentPage]['color'].value)
                                    : colorScheme.surfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildPersonalStats(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Mis Estadísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_myStats != null) ..._buildStatsItems(colorScheme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStatsItems(ColorScheme colorScheme) {
    final List<Widget> widgets = [];
    
    if (_myStats != null) {
      // Primero mostrar las estadísticas específicas que queremos rankear
      for (final attr in _rankingAttributes) {
        final String key = attr['key'];
        final dynamic value = _getPropertyValue(_myStats!, key);
        
        if (value != null) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        attr['icon'],
                        size: 16,
                        color: Color(attr['color'].value).withOpacity(0.8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        attr['title'],
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatValue(value),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(attr['color'].value),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    } else {
      widgets.add(
        Text(
          'No hay estadísticas disponibles',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildRankingCard(String attribute, String title, IconData icon, Color color, bool inverseRanking, ColorScheme colorScheme) {
    // Crear una lista ordenada específicamente para este atributo
    final List<UserStatisticsDto> sortedRankings = _rankings != null 
        ? List.from(_rankings!) 
        : [];
    
    if (sortedRankings.isNotEmpty) {
      sortedRankings.sort((a, b) {
        final valA = _getPropertyValue(a, attribute);
        final valB = _getPropertyValue(b, attribute);
        
        if (valA == null) return inverseRanking ? 1 : -1;
        if (valB == null) return inverseRanking ? -1 : 1;
        
        return inverseRanking 
            ? valB.compareTo(valA) // Mayor a menor para puntuaciones
            : valA.compareTo(valB); // Menor a mayor para muertes
      });
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Lista de rankings para este atributo
            if (sortedRankings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedRankings.length > 5 ? 5 : sortedRankings.length,
                  itemBuilder: (context, index) {
                    final ranking = sortedRankings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          _buildRankBadge(index + 1, colorScheme, color),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ranking.username ?? 'Usuario',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatValue(_getPropertyValue(ranking, attribute)),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
            // Botón para ver ranking completo
            if (sortedRankings.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      _showFullRankingDialog(attribute, title, sortedRankings, color);
                    },
                    icon: Icon(Icons.list, color: color),
                    label: Text(
                      'Ver ranking completo',
                      style: TextStyle(color: color),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void _showFullRankingDialog(String attribute, String title, List<UserStatisticsDto> rankingData, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        
        return AlertDialog(
          title: Text('Ranking: $title'),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rankingData.length,
              itemBuilder: (context, index) {
                final ranking = rankingData[index];
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      _buildRankBadge(index + 1, colorScheme, color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ranking.username ?? 'Usuario',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        _formatValue(_getPropertyValue(ranking, attribute)),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildRankBadge(int position, ColorScheme colorScheme, Color rankingColor) {
    Color badgeColor;
    IconData? icon;
    
    switch (position) {
      case 1:
        badgeColor = const Color(0xFFFFD700); // Gold
        icon = FontAwesomeIcons.trophy;
        break;
      case 2:
        badgeColor = const Color(0xFFC0C0C0); // Silver
        icon = FontAwesomeIcons.medal;
        break;
      case 3:
        badgeColor = const Color(0xFFCD7F32); // Bronze
        icon = FontAwesomeIcons.medal;
        break;
      default:
        badgeColor = rankingColor.withOpacity(0.7);
        icon = null;
    }
    
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon != null
            ? FaIcon(
                icon,
                size: 14,
                color: Colors.white,
              )
            : Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }
  
  // Método auxiliar para obtener el valor de una propiedad por nombre
  dynamic _getPropertyValue(UserStatisticsDto statistics, String property) {
    switch (property) {
      case 'totalDeaths':
        return statistics.totalDeaths;
      case 'averageDeathsPerLocke':
        return statistics.averageDeathsPerLocke;
      case 'totalBattlesWon':
        return statistics.totalBattlesWon;
      case 'totalBattlePoints':
        return statistics.totalBattlePoints;
      case 'performanceScore':
        return statistics.performanceScore;
      default:
        return null;
    }
  }
  
  String _formatValue(dynamic value) {
    if (value == null) return '-';
    
    if (value is double) {
      // Formatear a 2 decimales si es un número decimal
      return value.toStringAsFixed(2);
    }
    
    return value.toString();
  }
}