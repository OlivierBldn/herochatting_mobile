// lib/screens/universe_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/universe_provider.dart';

class UniverseListScreen extends StatelessWidget {
  const UniverseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universes'),
      ),
      body: FutureBuilder(
        future: Provider.of<UniverseProvider>(context, listen: false).fetchUniverses(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<UniverseProvider>(
              builder: (ctx, universeProvider, child) {
                return ListView.builder(
                  itemCount: universeProvider.universes.length,
                  itemBuilder: (ctx, i) {
                    final universe = universeProvider.universes[i];
                    return ListTile(
                      title: Text(universe.name),
                      onTap: () {
                        Navigator.of(context).pushNamed('/universe_detail', arguments: universe);
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showCreateUniverseDialog(context);
        },
      ),
    );
  }

  void _showCreateUniverseDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Universe'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Universe Name'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Create'),
            onPressed: () async {
              final success = await Provider.of<UniverseProvider>(context, listen: false).createUniverse(nameController.text);
              if (success) {
                Navigator.of(ctx).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to create universe'),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}