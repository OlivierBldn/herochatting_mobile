// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/universe_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/universe_list_screen.dart';
import 'screens/universe_detail_screen.dart';
import 'models/user.dart';
import 'models/universe.dart';

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
          }
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}