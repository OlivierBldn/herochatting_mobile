import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final firstnameController = TextEditingController(text: user.firstname);
    final lastnameController = TextEditingController(text: user.lastname);

    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: firstnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final success = await userProvider.updateUser(
                  user.id,
                  usernameController.text,
                  emailController.text,
                  firstnameController.text,
                  lastnameController.text,
                );
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update user')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}