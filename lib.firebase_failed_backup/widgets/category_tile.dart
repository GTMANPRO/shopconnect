import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(category.icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
