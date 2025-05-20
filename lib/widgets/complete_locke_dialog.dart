import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../generated_code/api.swagger.dart';

class CompleteLockeDialog extends StatefulWidget {
  final String lockeId;
  final String lockeName;
  final Function() onSuccess;

  const CompleteLockeDialog({
    Key? key,
    required this.lockeId,
    required this.lockeName,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<CompleteLockeDialog> createState() => _CompleteLockeDialogState();
}

class _CompleteLockeDialogState extends State<CompleteLockeDialog> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _completeLocke() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ApiService();
      await apiService.updateLocke(
        widget.lockeId,
        isActive: false,
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: const Text('Completar Nuzlocke'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          Text(
            '¿Estás seguro que deseas marcar "${widget.lockeName}" como completado?',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          const Text(
            'Esta acción archivará la partida y ya no aparecerá en la lista de partidas activas.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
          ),
          onPressed: _isLoading ? null : _completeLocke,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Completar Nuzlocke'),
        ),
      ],
    );
  }
}