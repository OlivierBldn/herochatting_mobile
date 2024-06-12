// lib/screens/universe_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/universe_provider.dart';
import '../constants/colors.dart';

class UniverseListScreen extends StatelessWidget {
  const UniverseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    Future<void> createUniverse(UniverseProvider universeProvider) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final success = await universeProvider.createUniverse(nameController.text);
      if (!context.mounted) return;
      Navigator.of(context).pop();


      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Universe created')),
        );
        nameController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create universe')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.hWhite,
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColor.hGreyLight,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(AppColor.hGreyDark, BlendMode.srcIn),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Universes',
              style: TextStyle(
                color: AppColor.hBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: FutureBuilder(
        future: Provider.of<UniverseProvider>(context, listen: false).fetchUniverses(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<UniverseProvider>(
              builder: (ctx, universeProvider, child) {
                final sortedUniverses = universeProvider.universes..sort((a, b) => a.name.compareTo(b.name));

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.hGreyLight,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/universe.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(AppColor.hGrey, BlendMode.srcIn),
                                  ),
                                ),
                                hintText: 'Universe name',
                                hintStyle: const TextStyle(color: AppColor.hGrey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: AppColor.hGreyLight),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: AppColor.hGreyLight),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: AppColor.hGrey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => createUniverse(universeProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.hBlueLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              textStyle: const TextStyle(
                                color: AppColor.hBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Create', style: TextStyle(color: AppColor.hBlue)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: sortedUniverses.length,
                        itemBuilder: (ctx, i) {
                          final universe = sortedUniverses[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/universe_detail', arguments: universe);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: AppColor.hGreyLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://mds.sprw.dev/image_data/${universe.image}',
                                        height: 150,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => SvgPicture.asset(
                                          'assets/icons/placeholder.svg',
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                          child: Text(
                                            universe.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}