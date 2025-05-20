import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../generated_code/api.swagger.dart';

class NewLockeScreen extends StatefulWidget {
  const NewLockeScreen({Key? key}) : super(key: key);

  @override
  State<NewLockeScreen> createState() => _NewLockeScreenState();
}

class _NewLockeScreenState extends State<NewLockeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createLocke() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    try {
      final newLocke = await _apiService.createLocke(
        name,
        description: description.isNotEmpty ? description : null,
        isActive: _isActive,
      );

      if (newLocke != null) {
        if (mounted) {
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nuzlocke run created successfully!')),
          );
          // Navigate to the new locke details page
          context.push('/locke/${newLocke.id}');
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to create Nuzlocke run. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error creating locke: $e');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final isAuthenticated = userService.isAuthenticated;
    final theme = Theme.of(context);

    // Redirect to login if not authenticated
    if (!isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You need to login to create a Nuzlocke run')),
        );
        context.push('/login');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Nuzlocke Run'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Create Run',
              onPressed: _createLocke,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error message if any
                    if (_errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),

                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter a name for your Nuzlocke run',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Enter a description for your Nuzlocke run',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Active status switch
                    SwitchListTile(
                      title: const Text('Active'),
                      subtitle: const Text(
                          'Turn off if this is a completed Nuzlocke run'),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _createLocke,
                        icon: const Icon(Icons.add),
                        label: const Text('Create Nuzlocke Run'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => context.push('/lockes'),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}