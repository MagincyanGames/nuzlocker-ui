import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../generated_code/api.swagger.dart';

class AddParticipantDialog extends StatefulWidget {
  final String lockeId;
  final Function() onSuccess;

  const AddParticipantDialog({
    Key? key,
    required this.lockeId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<AddParticipantDialog> createState() => _AddParticipantDialogState();
}

class _AddParticipantDialogState extends State<AddParticipantDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final List<UserResponseDto> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  Timer? _debounce;
  UserResponseDto? _selectedUser;

  @override
  void dispose() {
    _usernameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 3) {
        _searchUsers(query);
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    });
  }

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final apiService = ApiService();
      final results = await apiService.api.apiUsersSearchGet(query: query);

      if (mounted) {
        setState(() {
          _searchResults.clear();
          if (results.isSuccessful && results.body != null) {
            _searchResults.addAll(results.body!);
          }
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al buscar usuarios: ${e.toString()}';
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _addParticipant() async {
    if (_selectedUser == null) {
      setState(() {
        _errorMessage = 'Por favor selecciona un usuario';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ApiService();
      await apiService.api.apiLockesIdParticipantsPost(
        id: widget.lockeId,
        body: AddParticipantDto(userId: _selectedUser!.id),
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al agregar participante: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Agregar Participante'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Buscar usuario',
                hintText: 'Mínimo 3 caracteres',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            if (_searchResults.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    final isSelected = _selectedUser?.id == user.id;
                    
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.name ?? ''),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          user.username[0].toUpperCase(),
                          style: TextStyle(color: theme.colorScheme.onPrimary),
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      onTap: () {
                        setState(() {
                          _selectedUser = isSelected ? null : user;
                        });
                      },
                    );
                  },
                ),
              )
            else if (_usernameController.text.length >= 3 && !_isSearching)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No se encontraron usuarios'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading || _selectedUser == null ? null : _addParticipant,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Agregar'),
        ),
      ],
    );
  }
}