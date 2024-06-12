// // lib/screens/chat_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:provider/provider.dart';
// import '../providers/chat_provider.dart';
// import '../models/character.dart';

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chats'),
//       ),
//       body: FutureBuilder(
//         future: Provider.of<ChatProvider>(context, listen: false).fetchChats(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Consumer<ChatProvider>(
//               builder: (ctx, chatProvider, child) {
//                 final chats = chatProvider.chats;
//                 return ListView.builder(
//                   itemCount: chats.length,
//                   itemBuilder: (ctx, i) {
//                     final chat = chats[i];
//                     return FutureBuilder<Character?>(
//                       future: chatProvider.fetchCharacterDetails(chat.characterId),
//                       builder: (ctx, charSnapshot) {
//                         if (charSnapshot.connectionState == ConnectionState.waiting) {
//                           return const ListTile(
//                             leading: CircularProgressIndicator(),
//                             title: Text('Loading...'),
//                           );
//                         } else if (charSnapshot.hasError) {
//                           return ListTile(
//                             title: Text('Error: ${charSnapshot.error}'),
//                           );
//                         } else {
//                           final character = charSnapshot.data;
//                           return ListTile(
//                             leading: character != null && character.image.isNotEmpty
//                                 ? CachedNetworkImage(
//                                     imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) => const CircularProgressIndicator(),
//                                     errorWidget: (context, url, error) => const Icon(Icons.error),
//                                   )
//                                 : null,
//                             title: Text(character?.name ?? 'Unknown Character'),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.close),
//                               onPressed: () async {
//                                 final success = await chatProvider.deleteChat(chat.id);
//                                 if (!context.mounted) return;
//                                 if (success) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text('Chat deleted')),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text('Failed to delete chat')),
//                                   );
//                                 }
//                               },
//                             ),
//                             onTap: () {
//                               Navigator.of(context).pushNamed('/chat_detail', arguments: chat.id);
//                             },
//                           );
//                         }
//                       },
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }



// // lib/screens/chat_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:provider/provider.dart';
// import '../providers/chat_provider.dart';
// import '../models/character.dart';
// import '../constants/colors.dart';

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         centerTitle: true,
//         title: Row(
//           children: [
//             InkWell(
//               onTap: () => Navigator.of(context).pop(),
//               borderRadius: BorderRadius.circular(30),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: const BoxDecoration(
//                   color: AppColor.hGreyLight,
//                   shape: BoxShape.circle,
//                 ),
//                 child: SvgPicture.asset(
//                   'assets/icons/chevron-left.svg',
//                   width: 24,
//                   height: 24,
//                   colorFilter: const ColorFilter.mode(AppColor.hGreyDark, BlendMode.srcIn),
//                 ),
//               ),
//             ),
//             const Spacer(),
//             const Text(
//               'Chats',
//               style: TextStyle(
//                 color: AppColor.hBlack,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const Spacer(),
//             const SizedBox(width: 48),
//           ],
//         ),
//       ),
//       body: FutureBuilder(
//         future: Provider.of<ChatProvider>(context, listen: false).fetchChats(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Consumer<ChatProvider>(
//               builder: (ctx, chatProvider, child) {
//                 final chats = chatProvider.chats;
//                 return ListView.builder(
//                   itemCount: chats.length,
//                   itemBuilder: (ctx, i) {
//                     final chat = chats[i];
//                     return FutureBuilder<Character?>(
//                       future: chatProvider.fetchCharacterDetails(chat.characterId),
//                       builder: (ctx, charSnapshot) {
//                         if (charSnapshot.connectionState == ConnectionState.waiting) {
//                           return const ListTile(
//                             leading: CircularProgressIndicator(),
//                             title: Text('Loading...'),
//                           );
//                         } else if (charSnapshot.hasError) {
//                           return ListTile(
//                             title: Text('Error: ${charSnapshot.error}'),
//                           );
//                         } else {
//                           final character = charSnapshot.data;
//                           return ListTile(
//                             leading: character != null && character.image.isNotEmpty
//                                 ? ClipOval(
//                                     child: CachedNetworkImage(
//                                       imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                       placeholder: (context, url) => const CircularProgressIndicator(),
//                                       errorWidget: (context, url, error) => const Icon(Icons.error),
//                                     ),
//                                   )
//                                 : ClipOval(
//                                     child: Container(
//                                       width: 50,
//                                       height: 50,
//                                       color: Colors.grey.shade300,
//                                       child: Icon(Icons.person, color: Colors.grey.shade800),
//                                     ),
//                                   ),
//                             title: Text(character?.name ?? 'Unknown Character'),
//                             trailing: IconButton(
//                               icon: SvgPicture.asset(
//                                 'assets/icons/cross.svg',
//                                 width: 24,
//                                 height: 24,
//                                 colorFilter: const ColorFilter.mode(AppColor.hGreyDark, BlendMode.srcIn),
//                               ),
//                               onPressed: () async {
//                                 final success = await chatProvider.deleteChat(chat.id);
//                                 if (!context.mounted) return;
//                                 if (success) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text('Chat deleted')),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(content: Text('Failed to delete chat')),
//                                   );
//                                 }
//                               },
//                             ),
//                             onTap: () {
//                               Navigator.of(context).pushNamed('/chat_detail', arguments: chat.id);
//                             },
//                           );
//                         }
//                       },
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }



// lib/screens/chat_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/character.dart';
import '../constants/colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.hWhite,
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(left: 6),
                decoration: const BoxDecoration(
                  color: AppColor.hWhite,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  width: 32,
                  height: 32,
                  colorFilter: const ColorFilter.mode(AppColor.hGreyDark, BlendMode.srcIn),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Chats',
              style: TextStyle(
                color: AppColor.hBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: FutureBuilder(
        future: Provider.of<ChatProvider>(context, listen: false).fetchChats(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<ChatProvider>(
              builder: (ctx, chatProvider, child) {
                final chats = chatProvider.chats;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (ctx, i) {
                    final chat = chats[i];
                    return FutureBuilder<Character?>(
                      future: chatProvider.fetchCharacterDetails(chat.characterId),
                      builder: (ctx, charSnapshot) {
                        if (charSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Loading...'),
                          );
                        } else if (charSnapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${charSnapshot.error}'),
                          );
                        } else {
                          final character = charSnapshot.data;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/chat_detail', arguments: chat.id);
                              },
                              splashColor: AppColor.hBlueLight,
                              highlightColor: AppColor.hBlueLight,
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: character != null && character.image.isNotEmpty
                                          ? ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://mds.sprw.dev/image_data/${character.image}',
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            )
                                          : ClipOval(
                                              child: Container(
                                                width: 75,
                                                height: 75,
                                                color: Colors.grey.shade300,
                                                child: Icon(Icons.person, color: Colors.grey.shade800),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          character?.name ?? 'Unknown Character',
                                          style: const TextStyle(color: AppColor.hGreyDark, fontSize: 24, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/icons/cross.svg',
                                        width: 32,
                                        height: 32,
                                        colorFilter: const ColorFilter.mode(AppColor.hGreyDark, BlendMode.srcIn),
                                      ),
                                      onPressed: () async {
                                        final success = await chatProvider.deleteChat(chat.id);
                                        if (!context.mounted) return;
                                        if (success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Chat deleted')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to delete chat')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
