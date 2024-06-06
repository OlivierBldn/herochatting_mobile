// lib/screens/user_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).fetchUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<UserProvider>(
              builder: (ctx, userProvider, child) {
                return ListView.builder(
                  itemCount: userProvider.users.length,
                  itemBuilder: (ctx, i) {
                    final user = userProvider.users[i];
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.of(context).pushNamed('/user_detail', arguments: user);
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