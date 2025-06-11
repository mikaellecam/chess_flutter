import 'package:flutter/material.dart';

class PlayerInputCard extends StatelessWidget {
  final TextEditingController player1Controller;
  final TextEditingController player2Controller;

  const PlayerInputCard({
    super.key,
    required this.player1Controller,
    required this.player2Controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Players', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            TextFormField(
              controller: player1Controller,
              decoration: const InputDecoration(
                labelText: 'Player 1 (White)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter Player 1 name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: player2Controller,
              decoration: const InputDecoration(
                labelText: 'Player 2 (Black)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter Player 2 name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
