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
    final featured = SeedData.stores.take(5).toList();
    final categories = SeedData.categories.take(6).toList();

    final recentStores = _recent.storeIds
        .map(SeedData.byId)
        .whereType<StoreModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('ShopConnect')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Featured Stores', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final s = featured[i];
                return SizedBox(
                  width: 180,
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StoreDetailScreen(store: s, recentlyViewed: _recent),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.asset(s.logoAsset, width: 40, height: 40,
                              errorBuilder: (c,e,st)=>const Icon(Icons.storefront_outlined)),
                            const SizedBox(width: 10),
                            Expanded(child: Text(s.name, style: Theme.of(context).textTheme.titleMedium)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Categories', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CategoriesScreen(recentlyViewed: _recent)),
                  );
                },
                child: const Text('See all'),
              )
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories.map((c) {
              return ActionChip(
                label: Text(c),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => StoresScreen(category: c, recentlyViewed: _recent)),
                  );
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recently Opened', style: Theme.of(context).textTheme.titleLarge),
              TextButton(onPressed: _recent.clear, child: const Text('Clear')),
            ],
          ),
          const SizedBox(height: 12),
          if (recentStores.isEmpty)
            const Text('No stores opened yet. Tap a featured store to start.'),
          if (recentStores.isNotEmpty)
            ...recentStores.map((s) => Card(
              child: ListTile(
                leading: Image.asset(s.logoAsset, width: 36, height: 36,
                  errorBuilder: (c,e,st)=>const Icon(Icons.storefront_outlined)),
                title: Text(s.name),
                subtitle: Text(s.category),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => StoreDetailScreen(store: s, recentlyViewed: _recent)),
                  );
                },
              ),
            )),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => StoresScreen(recentlyViewed: _recent)),
              );
            },
            icon: const Icon(Icons.store_outlined),
            label: const Text('Browse all stores'),
          ),
        ],
      ),
    );
  }
}
