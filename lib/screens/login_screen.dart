// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

/// LoginScreen is a StatefulWidget that allows the user to sign in to the app.
/// It provides text fields for the user to enter their email and password.
/// It also provides a button to sign in and a link to navigate to the registration screen.
/// 
/// 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// _LoginScreenState is the state of the LoginScreen.
/// 
/// 
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
          children: [
            const Spacer(),
            Text(
              'Sign in now',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color ?? AppColor.hBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              'Please sign in to continue our app',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.background,
                hintText: 'Email',
                hintStyle: TextStyle(color: theme.hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.background),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.background),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.background,
                hintText: 'Password',
                hintStyle: TextStyle(color: theme.hintColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.background),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.background),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                try {
                  await authProvider.login(
                    _usernameController.text,
                    _passwordController.text,
                  );

                  if (!context.mounted) return;

                  if (authProvider.user != null) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed')),
                    );
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Sign In', style: TextStyle(color: theme.colorScheme.onPrimary)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Text(
                'Don\'t have an account ? Sign up',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}