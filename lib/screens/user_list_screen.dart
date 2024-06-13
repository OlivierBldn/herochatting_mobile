// lib/screens/user_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  UserListScreenState createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();

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
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                      theme.iconTheme.color ?? AppColor.hGreyDark,
                      BlendMode.srcIn),
                ),
              ),
            ),
            const Text(
              'Users',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: () {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Users',
                filled: true,
                fillColor: theme.colorScheme.background,
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
              onChanged: (value) {
                Provider.of<UserProvider>(context, listen: false)
                    .filterUsers(value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<UserProvider>(context, listen: false)
                  .fetchUsers(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Consumer<UserProvider>(
                    builder: (ctx, userProvider, child) {
                      return ListView.builder(
                        itemCount: userProvider.users.length,
                        itemBuilder: (ctx, i) {
                          final user = userProvider.filteredUsers.isNotEmpty
                              ? userProvider.filteredUsers[i]
                              : userProvider.users[i];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage('assets/logo/logo.png'),
                            ),
                            title: Text(
                              user.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            subtitle: Text(
                              user.email,
                              style: TextStyle(
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/user_detail',
                                arguments: user,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}