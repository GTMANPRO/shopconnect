import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'stores_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = const [
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
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoresScreen(category: c.name),
                  ),
                );
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        child: Text(c.icon, style: const TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        c.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'View stores',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
