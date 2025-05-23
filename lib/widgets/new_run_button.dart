import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewRunButton extends StatelessWidget {
  /// Optional callback to execute when button is pressed
  final VoidCallback? onPressed;
  
  /// Optional route to navigate to, defaults to '/lockes/new'
  final String route;

  const NewRunButton({
    super.key, 
    this.onPressed,
    this.route = '/lockes/new',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return FloatingActionButton(
      onPressed: onPressed ?? () => context.push(route),
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.catching_pokemon,
              size: 35,
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primaryContainer,
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.add, size: 10, color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}