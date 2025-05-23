import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../generated_code/api.swagger.dart';
import 'package:intl/intl.dart';
import '../widgets/back_app_bar.dart';

class LockesScreen extends StatefulWidget {
  const LockesScreen({Key? key}) : super(key: key);

  @override
  State<LockesScreen> createState() => _LockesScreenState();
}

class _LockesScreenState extends State<LockesScreen>
    with SingleTickerProviderStateMixin {
  // Maintain separate loading states and data for each tab
  bool _isLoadingMy = true;
  bool _isLoadingAll = true;
  String? _errorMessage;
  List<EnrichedLockeResponseDto> _myLockes = [];
  List<EnrichedLockeResponseDto> _allLockes = [];
  String _filterMode = 'my'; // 'my' or 'all'
  final ApiService _apiService = ApiService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    final userService = Provider.of<UserService>(context, listen: false);
    if (_filterMode == 'my' && !userService.isAuthenticated) {
      _filterMode = 'all';
    }

    _tabController = TabController(
      length: 2, // 0: my, 1: all
      vsync: this,
      initialIndex: _filterMode == 'my' ? 0 : 1,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Wait for any tab animation to finish before acting
        return;
      }

      final newMode = _tabController.index == 0 ? 'my' : 'all';

      if (newMode != _filterMode) {
        setState(() {
          _filterMode = newMode;
          
          // Importante: resetear el estado de carga cuando cambiamos de pestaña
          // para evitar que aparezca el indicador de carga al volver
          if (newMode == 'my' && _myLockes.isNotEmpty) {
            _isLoadingMy = false;
          } else if (newMode == 'all' && _allLockes.isNotEmpty) {
            _isLoadingAll = false;
          }
        });
        
        // Fetch data for the new tab if it's empty or hasn't been loaded yet
        if ((newMode == 'my' && _myLockes.isEmpty) || 
            (newMode == 'all' && _allLockes.isEmpty)) {
          _fetchLockes(isInitialLoad: false);
        }
      }
    });

    // Fetch initial data for the active tab
    _fetchLockes(isInitialLoad: true);
    
    // Pre-fetch data for the other tab after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _fetchOtherTabData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch data for the tab that is NOT currently active
  void _fetchOtherTabData() {
    if (!mounted) return;
    
    final otherMode = _filterMode == 'my' ? 'all' : 'my';
    _fetchLockesByMode(otherMode, isInitialLoad: false);
  }

  // Fetch data for the specific mode
  Future<void> _fetchLockesByMode(String mode, {bool isInitialLoad = false}) async {
    if (!mounted) return;

    final bool isCurrentTab = mode == _filterMode;
    final bool isEmpty = mode == 'my' ? _myLockes.isEmpty : _allLockes.isEmpty;
    
    // Solo mostrar loader si:
    // 1. Es la pestaña actual
    // 2. No hay datos existentes
    // 3. No estamos en medio de un cambio de pestaña
    final bool shouldShowLoader = isEmpty && isCurrentTab && !_tabController.indexIsChanging;
    
    setState(() {
      if (shouldShowLoader) {
        if (mode == 'my') {
          _isLoadingMy = true;
        } else {
          _isLoadingAll = true;
        }
      }
      if (isCurrentTab) {
        _errorMessage = null; // Clear error only for current tab
      }
    });

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      List<EnrichedLockeResponseDto> fetchedLockes = [];
      
      if (mode == 'my') {
        if (!userService.isAuthenticated) {
          // For "my" mode, clear list if not authenticated
          if (mounted) {
            setState(() {
              _myLockes = [];
              _isLoadingMy = false;
            });
          }
          return;
        }
        fetchedLockes = await _apiService.getMyLockes(includeParticipating: true);
      } else {
        // For "all" mode
        fetchedLockes = await _apiService.getAllLockes();
      }

      // Sort lockes (active first, then by updated date)
      fetchedLockes.sort((a, b) {
        if (a.isActive != b.isActive) {
          return a.isActive ? -1 : 1; // Active items first
        }
        return b.updatedAt.compareTo(a.updatedAt); // Most recent first
      });

      if (mounted) {
        setState(() {
          if (mode == 'my') {
            _myLockes = fetchedLockes;
            _isLoadingMy = false;
          } else {
            _allLockes = fetchedLockes;
            _isLoadingAll = false;
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch lockes for mode $mode: $e');
      if (mounted && mode == _filterMode) { // Only show error for current tab
        setState(() {
          _errorMessage = 'Failed to load lockes: ${e.toString()}';
          if (mode == 'my') {
            _isLoadingMy = false;
            // Keep existing data unless it was initial load
            if (isEmpty) _myLockes = [];
          } else {
            _isLoadingAll = false;
            // Keep existing data unless it was initial load
            if (isEmpty) _allLockes = [];
          }
        });
      }
    }
  }

  // Main method to fetch lockes for current active tab
  Future<void> _fetchLockes({bool isInitialLoad = false}) async {
    _fetchLockesByMode(_filterMode, isInitialLoad: isInitialLoad);
  }

  // Main method to refresh both tabs
  Future<void> _refreshAll() async {
    await _fetchLockesByMode('my', isInitialLoad: false);
    await _fetchLockesByMode('all', isInitialLoad: false);
  }

  Color _getStatusColor(bool isActive) {
    final theme = Theme.of(context);
    return isActive ? theme.colorScheme.primary : theme.colorScheme.tertiary;
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final isAuthenticated = userService.isAuthenticated;
    final theme = Theme.of(context);
    
    // Ya no necesitamos esta variable pues no mostraremos el indicador de carga a pantalla completa
    // final bool isCurrentTabLoading = _filterMode == 'my' ? _isLoadingMy : _isLoadingAll;

    return Scaffold(
      appBar: BackAppBar(
        title: 'Nuzlocke Runs',
        fallbackRoute: '/',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAll,
            tooltip: 'Refresh',
          ),
        ],
      ),
      // Siempre mostrar el TabBarView, eliminando la condición que mostraba el CircularProgressIndicator
      body: TabBarView(
        controller: _tabController,
        // Desactivar el deslizamiento para controlar mejor las transiciones
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // "My Lockes" page - con indicador interno si está cargando
          _buildTabContentWithLoading(theme, isAuthenticated, _myLockes, _isLoadingMy),
          // "All Lockes" page - con indicador interno si está cargando
          _buildTabContentWithLoading(theme, isAuthenticated, _allLockes, _isLoadingAll),
        ],
      ),
      bottomNavigationBar: isAuthenticated
          ? TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'My Lockes'),
                Tab(icon: Icon(Icons.list), text: 'All Lockes'),
              ],
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          GoRouter.of(context).go('/lockes/new');
        },
        label: const Text('New Locke'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // Nuevo método que maneja el estado de carga dentro de cada pestaña sin bloquear la UI
  Widget _buildTabContentWithLoading(ThemeData theme, bool isAuthenticated, 
      List<EnrichedLockeResponseDto> lockes, bool isLoading) {
    
    // Solo mostrar indicador de carga si:
    // 1. La lista está vacía
    // 2. Es una carga inicial (isLoading es true)
    // 3. No estamos en medio de un cambio de pestaña
    if (isLoading && lockes.isEmpty && !_tabController.indexIsChanging) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mantener el banner de autenticación si corresponde
            if (!isAuthenticated && _filterMode == 'my')
              _buildAuthenticationBanner(theme),
              
            // Indicador de carga discreto
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Siempre mostrar el contenido normal si hay datos, incluso si está cargando en segundo plano
    return _buildTabContent(theme, isAuthenticated, lockes);
  }

  // Updated to accept the specific list
  Widget _buildTabContent(ThemeData theme, bool isAuthenticated, List<EnrichedLockeResponseDto> lockes) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Show authentication banner for non-authenticated users
          if (!isAuthenticated && _filterMode == 'my')
            _buildAuthenticationBanner(theme),

          // Error message if any
          if (_errorMessage != null) _buildErrorBanner(theme),

          // Lockes content - either empty state or list
          Expanded(
            child: lockes.isEmpty ? _buildEmptyState(theme) : _buildLockesList(lockes),
          ),
        ],
      ),
    );
  }

  // Update to accept the specific list
  Widget _buildLockesList(List<EnrichedLockeResponseDto> lockes) {
    return ListView.builder(
      itemCount: lockes.length,
      itemBuilder: (context, index) {
        final locke = lockes[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: InkWell(
            onTap: () {
              GoRouter.of(context).go('/locke/${locke.id}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    child: Text(
                      locke.name.isNotEmpty ? locke.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: _getStatusColor(locke.isActive),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(locke.name),
                  subtitle: Text('Participants: ${locke.participants.length}'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(locke.isActive),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            locke.isActive ? 'Active' : 'Completed',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              '🕒 Last updated: ',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              _formatDate(locke.updatedAt),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // New method for the authentication banner
  Widget _buildAuthenticationBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sign in to view your personal lockes',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/login');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
          TextButton.icon(
            onPressed: _fetchLockes,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _filterMode == 'my'
                      ? 'No personal lockes yet'
                      : 'No lockes available',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _filterMode == 'my'
                      ? 'Create a new Nuzlocke run to get started!'
                      : 'Be the first to create a Nuzlocke run!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    GoRouter.of(context).go('/lockes/new');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Locke'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
