import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../widgets/category_tile.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = <CategoryModel>[
      CategoryModel(name: 'Electronics', icon: '📱'),
      CategoryModel(name: 'Fashion', icon: '👗'),
      CategoryModel(name: 'Beauty', icon: '💄'),
      CategoryModel(name: 'Home', icon: '🏠'),
      CategoryModel(name: 'Sports', icon: '🏀'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: categories.map((c) {
            return CategoryTile(
              category: c,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Coming soon: ${c.name}')),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
