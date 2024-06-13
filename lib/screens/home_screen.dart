// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

/// HomeScreen is a StatelessWidget that displays the home screen of the app.
/// It provides a list of menu items that allow the user to navigate to different screens.
/// 
/// The screen also has a toggle button to switch between light and dark themes.
/// 
/// 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            const Spacer(),
            IconButton(
              icon: Icon(theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logo/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to herochatting',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color ?? Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enjoy your journey with us !',
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  HomeMenuItem(
                    icon: 'assets/icons/user.svg',
                    text: 'Users',
                    onTap: () {
                      Navigator.pushNamed(context, '/user_list');
                    },
                  ),
                  HomeMenuItem(
                    icon: 'assets/icons/universe.svg',
                    text: 'Universes',
                    onTap: () {
                      Navigator.pushNamed(context, '/universe_list');
                    },
                  ),
                  HomeMenuItem(
                    icon: 'assets/icons/chat.svg',
                    text: 'Chats',
                    onTap: () {
                      Navigator.pushNamed(context, '/chat_list');
                    },
                  ),
                  HomeMenuItem(
                    icon: 'assets/icons/logout.svg',
                    text: 'Sign out',
                    onTap: () {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      authProvider.logout();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HomeMenuItem is a StatelessWidget that displays a menu item on the home screen.
/// It provides an icon, text, and an onTap callback.
/// 
/// 
class HomeMenuItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const HomeMenuItem({super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(theme.iconTheme.color ?? Colors.grey, BlendMode.srcIn),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.iconTheme.color ?? Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}