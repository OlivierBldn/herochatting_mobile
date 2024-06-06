// lib/screens/universe_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (universe.image.isNotEmpty)
              CachedNetworkImage(
                imageUrl: 'https://mds.sprw.dev/image_data/${universe.image}',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            const SizedBox(height: 20),
            Text(universe.description),
            const SizedBox(height: 20),
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
              onPressed: () {
                Navigator.of(context).pushNamed('/character_list', arguments: universe.id);
              },
              child: const Text('View Characters'),
            ),
          ],
        ),
      ),
    );
  }
}