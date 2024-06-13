// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/universe_provider.dart';
import 'providers/character_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'constants/themes.dart';
import 'screens/initial_screen.dart';
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

/// The [build] method builds the widget tree of the app.
/// It returns a [MaterialApp] widget that provides the app's theme and routes.
/// The app uses the [MultiProvider] widget to provide multiple providers to its descendants.
/// 
/// The [MaterialApp] widget has the following properties:
/// - [title] is set to 'Herochatting'.
/// - [theme] is set to [lightTheme].
/// - [darkTheme] is set to [darkTheme].
/// - [themeMode] is set to the value of [ThemeProvider.themeMode].
/// - [initialRoute] is set to '/'.
/// - [routes] is a map of routes that maps route names to builder functions.
/// - [onGenerateRoute] is a function that generates routes based on the route settings.
/// 
/// The app has the following routes:
/// - '/' navigates to the [InitialScreen].
/// - '/login' navigates to the [LoginScreen].
/// - '/home' navigates to the [HomeScreen].
/// - '/register' navigates to the [RegisterScreen].
/// - '/user_list' navigates to the [UserListScreen].
/// - '/universe_list' navigates to the [UniverseListScreen].
/// - '/chat_list' navigates to the [ChatListScreen].
/// 
/// The app also has dynamic routes that are generated using the [onGenerateRoute] function:
/// - '/user_detail' navigates to the [UserDetailScreen] and passes a [User] object as an argument.
/// - '/universe_detail' navigates to the [UniverseDetailScreen] and passes a [Universe] object as an argument.
/// - '/character_list' navigates to the [CharacterListScreen] and passes a universe ID as an argument.
/// - '/character_detail' navigates to the [CharacterDetailScreen] and passes a [Character] object as an argument.
/// - '/chat_detail' navigates to the [ChatDetailScreen] and passes a chat ID as an argument.
/// 
/// The app uses the [Consumer] widget to listen to changes in the [ThemeProvider] and rebuild the app when the theme changes.
/// 
/// The app uses the [ChangeNotifierProvider] widget to provide the following providers to its descendants:
/// - [AuthProvider]
/// - [UserProvider]
/// - [UniverseProvider]
/// - [CharacterProvider]
/// - [ChatProvider]
/// - [ThemeProvider]
/// 
/// The [ThemeProvider] provider is initialized with the [isDarkMode] property set to false.
/// 
/// The [MaterialApp] widget is wrapped in a [MultiProvider] widget that provides the above providers to its descendants.
/// 
/// The [MyApp] widget is a StatelessWidget that returns the [MaterialApp] widget.
/// 
/// The [MyApp] widget is the root widget of the app and is passed to the [runApp] function to start the app.
/// 
/// 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UniverseProvider()),
        ChangeNotifierProvider(create: (context) => CharacterProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode: false)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Herochatting',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const InitialScreen(),
              '/login': (context) => const LoginScreen(),
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
          );
        },
      ),
    );
  }
}