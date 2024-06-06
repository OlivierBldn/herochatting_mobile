// // lib/screens/universe_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/universe_provider.dart';

// class UniverseListScreen extends StatelessWidget {
//   const UniverseListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final nameController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Universes'),
//       ),
//       body: FutureBuilder(
//         future: Provider.of<UniverseProvider>(context, listen: false).fetchUniverses(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             return Consumer<UniverseProvider>(
//               builder: (ctx, universeProvider, child) {
//                 return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Create a new universe'),
//                           TextField(
//                             controller: nameController,
//                             decoration: const InputDecoration(labelText: 'Universe Name'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () async {
//                               final success = await universeProvider.createUniverse(
//                                 nameController.text,
//                               );
//                               if (success) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('Universe created')),
//                                 );
//                                 nameController.clear();
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('Failed to create universe')),
//                                 );
//                               }
//                             },
//                             child: const Text('Create'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: universeProvider.universes.length,
//                         itemBuilder: (ctx, i) {
//                           final universe = universeProvider.universes[i];
//                           return ListTile(
//                             leading: universe.image.isNotEmpty 
//                               ? Image.network('https://mds.sprw.dev/image_data/${universe.image}')
//                               : null,
//                             title: Text(universe.name),
//                             subtitle: Text(universe.description),
//                             onTap: () {
//                               Navigator.of(context).pushNamed('/universe_detail', arguments: universe);
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }





// lib/screens/universe_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/universe_provider.dart';

class UniverseListScreen extends StatelessWidget {
  const UniverseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Create a new universe'),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: 'Universe Name'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final success = await universeProvider.createUniverse(
                                nameController.text,
                              );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Universe created')),
                                );
                                nameController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to create universe')),
                                );
                              }
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: universeProvider.universes.length,
                        itemBuilder: (ctx, i) {
                          final universe = universeProvider.universes[i];
                          return ListTile(
                            leading: universe.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: 'https://mds.sprw.dev/image_data/${universe.image}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                : null,
                            title: Text(universe.name),
                            onTap: () {
                              Navigator.of(context).pushNamed('/universe_detail', arguments: universe);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
