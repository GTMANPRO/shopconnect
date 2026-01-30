import 'package:flutter/material.dart';
import '../data/seed_data.dart';
import '../state/recently_viewed.dart';
import 'stores_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final RecentlyViewed? recentlyViewed;
  const CategoriesScreen({super.key, this.recentlyViewed});

  @override
  Widget build(BuildContext context) {
    final cats = SeedData.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: cats.length,
        itemBuilder: (context, i) {
          final c = cats[i];
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StoresScreen(category: c, recentlyViewed: recentlyViewed),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(c, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          );
        },
      ),
    );
  }
}
