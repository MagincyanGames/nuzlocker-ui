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

class _LockesScreenState extends State<LockesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<EnrichedLockeResponseDto> _lockes = [];
  String _filterMode = 'my'; // 'my' or 'all'
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLockes();
    });
  }

  Future<void> _fetchLockes() async {
    final userService = Provider.of<UserService>(context, listen: false);
    // Check if we're viewing personal lockes but user isn't authenticated
    final isAuthenticated = userService.isAuthenticated;
    if (_filterMode == 'my' && !isAuthenticated) {
      setState(() {
        _filterMode = 'all'; // Switch to "all" mode if not authenticated
      });
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<EnrichedLockeResponseDto> fetchedLockes;

      if (_filterMode == 'my') {
        fetchedLockes = await _apiService.getMyLockes(
          includeParticipating: true,
        );
      } else {
        // Implement when you have an API endpoint for all lockes
        // For now, just use getMyLockes as placeholder
        fetchedLockes = await _apiService.getAllLockes();
        // TODO: Replace with actual "get all lockes" endpoint when available
      }

      setState(() {
        _lockes = fetchedLockes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to fetch lockes: $e');
      setState(() {
        _errorMessage = 'Failed to load lockes: ${e.toString()}';
        _isLoading = false;

        // Optional: Add mock data for development
        if (const bool.fromEnvironment('dart.vm.product') == false) {
          debugPrint('Using mock data in development mode');
          _lockes = []; // Clear real data
          // Add mock data if needed
        }
      });
    }
  }

  void _setFilterMode(String mode) {
    if (_filterMode != mode) {
      setState(() {
        _filterMode = mode;
      });
      _fetchLockes();
    }
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

    return Scaffold(
      appBar: BackAppBar(
        title: 'Nuzlocke Runs',
        fallbackRoute: '/', // Go to home if can't pop
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLockes,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(theme, isAuthenticated),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          GoRouter.of(context).go('/lockes/new');
        },
        label: const Text('New Locke'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isAuthenticated) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Filter Options
          _buildFilterOptions(theme, isAuthenticated),

          // Error message if any
          if (_errorMessage != null) _buildErrorBanner(theme),

          // Lockes list or empty state
          Expanded(
            child:
                _lockes.isEmpty ? _buildEmptyState(theme) : _buildLockesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(ThemeData theme, bool isAuthenticated) {
    if (!isAuthenticated) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment<String>(
            value: 'my',
            label: Text('My Lockes'),
            icon: Icon(Icons.person),
          ),
          ButtonSegment<String>(
            value: 'all',
            label: Text('All Lockes'),
            icon: Icon(Icons.list),
          ),
        ],
        selected: {_filterMode},
        onSelectionChanged: (Set<String> selection) {
          _setFilterMode(selection.first);
        },
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

  Widget _buildLockesList() {
    return ListView.builder(
      itemCount: _lockes.length,
      itemBuilder: (context, index) {
        final locke = _lockes[index];

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
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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
}
