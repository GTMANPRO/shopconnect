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

  List<StoreModel> _recentStores() {
    final ids = _recent.items;

    return ids
        .map(
          (id) => SeedData.stores.where((s) => s.id == id).cast<StoreModel?>(),
        )
        .expand((e) => e)
        .whereType<StoreModel>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final featured =
        SeedData.stores.where((s) => s.isFeatured).toList();

    final recentStores = _recentStores();

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _horizontalStores(featured),
            const SizedBox(height: 24),
          ],

          if (recentStores.isNotEmpty) ...[
            const Text(
              'Recently viewed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _horizontalStores(recentStores),
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

  Widget _horizontalStores(List<StoreModel> stores) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final store = stores[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _recent.add(store.id);

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
    );
  }
}
