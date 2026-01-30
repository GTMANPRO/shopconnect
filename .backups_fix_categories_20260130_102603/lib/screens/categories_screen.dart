import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<String> _categories = <String>[
    'Electronics',
    'Fashion',
    'Sports',
    'Beauty',
    'Home',
  ];

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Keep this screen self-contained. It only displays the category
    // grid for the MVP.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive columns (2 on small, 3 on wide).
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 900 ? 3 : 2;

          return GridView.builder(
            itemCount: _categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final label = _categories[index];
              return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
