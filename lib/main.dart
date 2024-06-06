// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/universe_provider.dart';
import 'providers/character_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/universe_list_screen.dart';
import 'screens/universe_detail_screen.dart';
import 'screens/character_list_screen.dart';
import 'screens/character_detail_screen.dart';
import 'screens/chat_detail_screen.dart';
import 'screens/chat_list_screen.dart';
import 'models/user.dart';
import 'models/universe.dart';
import 'models/character.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UniverseProvider()),
        ChangeNotifierProvider(create: (context) => CharacterProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Herochatting',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/register': (context) => const RegisterScreen(),
          '/user_list': (context) => const UserListScreen(),
          '/universe_list': (context) => const UniverseListScreen(),
          '/chat_list': (context) => const ChatListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/user_detail') {
            final user = settings.arguments as User;
            return MaterialPageRoute(
              builder: (context) {
                return UserDetailScreen(user: user);
              },
            );
          } else if (settings.name == '/universe_detail') {
            final universe = settings.arguments as Universe;
            return MaterialPageRoute(
              builder: (context) {
                return UniverseDetailScreen(universe: universe);
              },
            );
          } else if (settings.name == '/character_list') {
            final universeId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) {
                return CharacterListScreen(universeId: universeId);
              },
            );
          } else if (settings.name == '/character_detail') {
            final character = settings.arguments as Character;
            return MaterialPageRoute(
              builder: (context) {
                return CharacterDetailScreen(character: character);
              },
            );
          } else if (settings.name == '/chat_list') {
            return MaterialPageRoute(
              builder: (context) {
                return const ChatListScreen();
              },
            );
          } else if (settings.name == '/chat_detail') {
            final chatId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) {
                return ChatDetailScreen(chatId: chatId);
              },
            );
          }
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}
