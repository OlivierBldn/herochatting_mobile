// // lib/screens/universe_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/universe.dart';
import '../providers/universe_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/colors.dart';

/// UniverseDetailScreen is a StatefulWidget that displays the details of a universe.
/// It allows the user to update the name of the universe and view the characters in the universe.
/// 
/// 
class UniverseDetailScreen extends StatefulWidget {
  final Universe universe;

  const UniverseDetailScreen({super.key, required this.universe});

  @override
  UniverseDetailScreenState createState() => UniverseDetailScreenState();
}

/// UniverseDetailScreenState is the state of the UniverseDetailScreen.
/// 
/// 
class UniverseDetailScreenState extends State<UniverseDetailScreen> {
  late TextEditingController _nameController;
  late String _universeName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.universe.name);
    _universeName = widget.universe.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateUniverseName() async {
    final universeProvider = Provider.of<UniverseProvider>(context, listen: false);
    final success = await universeProvider.updateUniverse(
      widget.universe.id,
      _nameController.text,
    );
    if (!context.mounted) return;
    if (success) {
      setState(() {
        _universeName = _nameController.text;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Universe updated successfully')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update universe')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor ?? AppColor.hWhite,
        elevation: 1,
        centerTitle: true,
        title: Row(
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
                  colorFilter: ColorFilter.mode(theme.iconTheme.color ?? AppColor.hGreyDark, BlendMode.srcIn),
                ),
              ),
            ),
            const Spacer(),
            Text(
              _universeName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.titleLarge?.color ?? AppColor.hBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.universe.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: 'https://mds.sprw.dev/image_data/${widget.universe.image}',
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Universe Name',
                filled: true,
                fillColor: theme.colorScheme.background,
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
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUniverseName,
              style: ElevatedButton.styleFrom(
                foregroundColor: isDarkMode ? AppColor.hBlack : theme.colorScheme.onSecondary, backgroundColor: isDarkMode ? AppColor.hWhite : theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, color: isDarkMode ? AppColor.hBlack : AppColor.hBlack),
                  const SizedBox(width: 10),
                  Text(
                    'Save new name',
                    style: TextStyle(
                      color: isDarkMode ? AppColor.hBlack : AppColor.hBlack,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/character_list', arguments: widget.universe.id);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: isDarkMode ? AppColor.hBlack : theme.colorScheme.onSecondary, backgroundColor: isDarkMode ? AppColor.hWhite : theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group, color: isDarkMode ? AppColor.hBlack : AppColor.hBlack),
                  const SizedBox(width: 10),
                  Text(
                    'View Characters',
                    style: TextStyle(
                      color: isDarkMode ? AppColor.hBlack : AppColor.hBlack,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.universe.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}