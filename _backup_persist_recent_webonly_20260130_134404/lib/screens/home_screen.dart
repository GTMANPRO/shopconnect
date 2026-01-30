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
  late Future<void> _loadRecentFuture;

  @override
  void initState() {
    super.initState();
    _loadRecentFuture = _recent.load();
  }

  List<StoreModel> _resolveRecentStores() {
    final ids = _recent.ids;

    final map = <String, StoreModel>{
      for (final s in SeedData.stores) s.id: s,
    };

    final resolved = <StoreModel>[];
    for (final id in ids) {
      final store = map[id];
      if (store != null) resolved.add(store);
    }
    return resolved;
  }

  @override
  Widget build(BuildContext context) {
    final featured = SeedData.stores.where((s) => s.isFeatured).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder<void>(
        future: _loadRecentFuture,
        builder: (context, snap) {
          final recentStores = _resolveRecentStores();

          return ListView(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recently viewed',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _recent.clear();
                        if (!mounted) return;
                        setState(() {});
                      },
                      child: const Text('Clear'),
                    ),
                  ],
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
          );
        },
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
            onTap: () async {
              await _recent.add(store.id);

              if (mounted) setState(() {});

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoreDetailScreen(store: store)),
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
