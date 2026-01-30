import 'package:flutter/material.dart';
import '../data/seed_data.dart';
import '../models/store_model.dart';
import '../state/recently_viewed.dart';
import 'categories_screen.dart';
import 'stores_screen.dart';
import 'store_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecentlyViewed _recent = RecentlyViewed();

  @override
  Widget build(BuildContext context) {
    // NOTE: Your current StoreModel does not expose `isFeatured`.
    // To keep this drop-in compatible, we feature the first few stores from SeedData.
    final List<StoreModel> featured = SeedData.stores.take(8).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (featured.isNotEmpty) ...[
            const Text(
              'Featured stores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final store = featured[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Your RecentlyViewed.add(...) currently accepts a String.
                      // We record the store id (fallback to name if needed).
                      final String key = (store.id.isNotEmpty) ? store.id : store.name;
                      _recent.add(key);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StoreDetailScreen(store: store),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              store.logoAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            store.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Browse stores'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StoresScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Browse categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriesScreen(
                    recentlyViewed: _recent,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
