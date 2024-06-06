// lib/screens/universe_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/universe.dart';
import '../providers/universe_provider.dart';

class UniverseDetailScreen extends StatelessWidget {
  final Universe universe;

  const UniverseDetailScreen({super.key, required this.universe});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: universe.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(universe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Universe Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final universeProvider = Provider.of<UniverseProvider>(context, listen: false);
                final success = await universeProvider.updateUniverse(
                  universe.id,
                  nameController.text,
                );
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update universe')),
                  );
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final universeProvider = Provider.of<UniverseProvider>(context, listen: false);
                final success = await universeProvider.deleteUniverse(universe.id);
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete universe')),
                  );
                }
              },
              child: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}