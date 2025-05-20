import 'package:flutter/material.dart';

class NewRunScreen extends StatelessWidget {
  const NewRunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Partida Nuzlocke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear Nueva Partida',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre de la partida',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Juego',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'red', child: Text('Rojo')),
                DropdownMenuItem(value: 'blue', child: Text('Azul')),
                DropdownMenuItem(value: 'yellow', child: Text('Amarillo')),
                // Más juegos
              ],
              onChanged: (value) {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text('Comenzar Partida'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}