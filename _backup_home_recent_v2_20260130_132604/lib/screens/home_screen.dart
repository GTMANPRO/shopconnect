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

  // Local in-memory list of recently viewed store IDs.
  // We keep this here to avoid depending on a specific API surface
  // of RecentlyViewed (some versions don't expose an `items` getter).
  final List<String> _recentIds = <String>[];

  List<StoreModel> _resolveRecentStores() {
    // Deduplicate while preserving order.
    final seen = <String>{};
    final ordered = <String>[];
    for (final id in _recentIds) {
      if (seen.add(id)) ordered.add(id);
    }

    final byId = {for (final s in SeedData.stores) s.id: s};
    return ordered.map((id) => byId[id]).whereType<StoreModel>().toList();
  }

  void _recordRecent(StoreModel store) {
    // Put most-recent-first.
    setState(() {
      _recentIds.remove(store.id);
      _recentIds.insert(0, store.id);
      // Keep it small.
      if (_recentIds.length > 12) {
        _recentIds.removeRange(12, _recentIds.length);
      }
    });

    // Also record into the shared RecentlyViewed state (used by other screens),
    // but do not assume it exposes a readable list API.
    _recent.add(store.id);
  }

  @override
  Widget build(BuildContext context) {
    final featured = SeedData.stores.where((s) => s.isFeatured).toList();
    final recentStores = _resolveRecentStores();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------- Featured ----------------
          if (featured.isNotEmpty) ...[
            const Text(
              'Featured stores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _horizontalStores(featured),
            const SizedBox(height: 24),
          ],

          // ---------------- Recently viewed ----------------
          if (recentStores.isNotEmpty) ...[
            const Text(
              'Recently viewed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _horizontalStores(recentStores),
            const SizedBox(height: 24),
          ],

          // ---------------- Quick links ----------------
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Browse stores'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StoresScreen()),
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
                  builder: (_) => CategoriesScreen(recentlyViewed: _recent),
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
              _recordRecent(store);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoreDetailScreen(store: store)),
              );
            },
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(store.logoAsset, fit: BoxFit.contain),
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
