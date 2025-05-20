import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../generated_code/api.swagger.dart';

class EditDeathsDialog extends StatefulWidget {
  final String lockeId;
  final EnrichedParticipantResponseDto participant;
  final Function() onSuccess;

  const EditDeathsDialog({
    Key? key,
    required this.lockeId,
    required this.participant,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<EditDeathsDialog> createState() => _EditDeathsDialogState();
}

class _EditDeathsDialogState extends State<EditDeathsDialog> {
  late TextEditingController _deathsController;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentDeaths = 0;

  @override
  void initState() {
    super.initState();
    _currentDeaths = widget.participant.deaths.toInt();
    _deathsController = TextEditingController(text: _currentDeaths.toString());
  }

  @override
  void dispose() {
    _deathsController.dispose();
    super.dispose();
  }

  void _incrementDeaths() {
    final newValue = _currentDeaths + 1;
    setState(() {
      _currentDeaths = newValue;
      _deathsController.text = newValue.toString();
    });
  }

  void _decrementDeaths() {
    if (_currentDeaths > 0) {
      final newValue = _currentDeaths - 1;
      setState(() {
        _currentDeaths = newValue;
        _deathsController.text = newValue.toString();
      });
    }
  }

  void _onTextChanged(String value) {
    final parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue >= 0) {
      setState(() {
        _currentDeaths = parsedValue;
      });
    }
  }

  Future<void> _updateDeaths() async {
    final deaths = int.tryParse(_deathsController.text);
    if (deaths == null) {
      setState(() {
        _errorMessage = 'Por favor ingresa un número válido';
      });
      return;
    }

    if (deaths < 0) {
      setState(() {
        _errorMessage = 'El número de muertes no puede ser negativo';
      });
      return;
    }

    final originalDeaths = widget.participant.deaths.toInt();
    if (deaths == originalDeaths) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ApiService();
      
      // Calcula la diferencia para agregar o restar muertes
      final difference = deaths - originalDeaths;
      
      await apiService.recordKill(
        widget.lockeId,
        difference,
        userId: widget.participant.userId,
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
      title: Text('Editar muertes de ${widget.participant.username}'),
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
          // Nueva fila con botones de incremento/decremento
          Row(
            children: [
              // Botón de decremento
              FilledButton.tonal(
                onPressed: _currentDeaths > 0 ? _decrementDeaths : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.remove),
              ),
              
              // Campo de texto
              Expanded(
                child: TextField(
                  controller: _deathsController,
                  decoration: const InputDecoration(
                    labelText: 'Muertes',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  enabled: !_isLoading,
                  onChanged: _onTextChanged,
                ),
              ),
              
              // Botón de incremento
              FilledButton.tonal(
                onPressed: _incrementDeaths,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          
          // Indicador visual
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: _currentDeaths > widget.participant.deaths.toInt()
                    ? Colors.red
                    : _currentDeaths < widget.participant.deaths.toInt()
                        ? Colors.green
                        : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                _currentDeaths > widget.participant.deaths.toInt()
                    ? '${_currentDeaths - widget.participant.deaths.toInt()} muertes más'
                    : _currentDeaths < widget.participant.deaths.toInt()
                        ? '${widget.participant.deaths.toInt() - _currentDeaths} muertes menos'
                        : 'Sin cambios',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _currentDeaths > widget.participant.deaths.toInt()
                      ? Colors.red
                      : _currentDeaths < widget.participant.deaths.toInt()
                          ? Colors.green
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading || _currentDeaths == widget.participant.deaths.toInt() 
              ? null 
              : _updateDeaths,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}