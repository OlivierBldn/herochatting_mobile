// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: SvgPicture.asset('assets/icons/user.svg', width: 24, height: 24),
              label: const Text('Users'),
              onPressed: () {
                Navigator.pushNamed(context, '/user_list');
              },
            ),
            ElevatedButton.icon(
              icon: SvgPicture.asset('assets/icons/universe.svg', width: 24, height: 24),
              label: const Text('Universes'),
              onPressed: () {
                Navigator.pushNamed(context, '/universe_list');
              },
            ),
            ElevatedButton.icon(
              icon: SvgPicture.asset('assets/icons/chat.svg', width: 24, height: 24),
              label: const Text('Chats'),
              onPressed: () {
                Navigator.pushNamed(context, '/chat_list');
              },
            ),
            ElevatedButton.icon(
              icon: SvgPicture.asset('assets/icons/logout.svg', width: 24, height: 24),
              label: const Text('Sign out'),
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}