// // lib/screens/character_detail_screen.dart

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/character.dart';

// class CharacterDetailScreen extends StatelessWidget {
//   final Character character;

//   const CharacterDetailScreen({super.key, required this.character});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(character.name),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (character.image.isNotEmpty)
//               CachedNetworkImage(
//                 imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
//                 placeholder: (context, url) => const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             const SizedBox(height: 20),
//             Text(
//               character.name,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(character.description),
//           ],
//         ),
//       ),
//     );
//   }
// }



// // lib/screens/character_detail_screen.dart

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/character.dart';
// import '../providers/chat_provider.dart';
// import 'package:provider/provider.dart';

// class CharacterDetailScreen extends StatelessWidget {
//   final Character character;

//   const CharacterDetailScreen({super.key, required this.character});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(character.name),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (character.image.isNotEmpty)
//               CachedNetworkImage(
//                 imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
//                 placeholder: (context, url) => const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             const SizedBox(height: 20),
//             Text(
//               character.name,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(character.description),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed('/chat_list', arguments: character.id);
//               },
//               child: const Text('View Chats'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//                 final success = await chatProvider.createChat(character.id);
//                 if (success) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Chat created')),
//                   );
//                   Navigator.of(context).pushNamed('/chat_list', arguments: character.id);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Failed to create chat')),
//                   );
//                 }
//               },
//               child: const Text('Create Chat'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// lib/screens/character_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/character.dart';
import '../providers/chat_provider.dart';
import 'package:provider/provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (character.image.isNotEmpty)
              CachedNetworkImage(
                imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            const SizedBox(height: 20),
            Text(
              character.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(character.description),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/chat_list', arguments: character.id);
              },
              child: const Text('View Chats'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                final success = await chatProvider.createChat(character.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat created')),
                  );
                  Navigator.of(context).pushNamed('/chat_list', arguments: character.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create chat')),
                  );
                }
              },
              child: const Text('Create Chat'),
            ),
          ],
        ),
      ),
    );
  }
}