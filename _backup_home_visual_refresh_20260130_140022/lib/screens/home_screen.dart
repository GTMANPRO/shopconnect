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

  // In-memory recent list (kept simple + safe). If you later wire persistence,
  // you can replace this with stored ids.
  final List<String> _recentIds = <String>[];

  void _touchRecent(String id) {
    // keep unique + most-recent-first
    _recentIds.remove(id);
    _recentIds.insert(0, id);
    if (_recentIds.length > 10) _recentIds.removeRange(10, _recentIds.length);
  }

  List<StoreModel> _resolveRecentStores() {
    final byId = {for (final s in SeedData.stores) s.id: s};
    final stores = <StoreModel>[];
    for (final id in _recentIds) {
      final s = byId[id];
      if (s != null) stores.add(s);
    }
    return stores;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final featured = SeedData.stores.where((s) => s.isFeatured).toList();
    final recentStores = _resolveRecentStores();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            centerTitle: false,
            title: const Text('ShopConnect'),
            actions: [
              IconButton(
                tooltip: 'Browse stores',
                icon: const Icon(Icons.storefront_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StoresScreen()),
                  );
                },
              ),
              IconButton(
                tooltip: 'Browse categories',
                icon: const Icon(Icons.category_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoriesScreen(recentlyViewed: _recent),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HERO CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primaryContainer.withOpacity(0.55),
                          scheme.secondaryContainer.withOpacity(0.45),
                        ],
                      ),
                      border: Border.all(
                        color: scheme.outlineVariant.withOpacity(0.35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: scheme.surface.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: scheme.outlineVariant.withOpacity(0.35),
                            ),
                          ),
                          child: const Icon(Icons.local_offer_outlined),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Find deals fast',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Browse trusted stores and jump straight to their best offers.',
                                style: TextStyle(height: 1.2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: null,
                          child: Text('Explore'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // FEATURED
                  _SectionHeader(
                    title: 'Featured',
                    subtitle: 'Top picks right now',
                    icon: Icons.star_outline,
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StoresScreen()),
                        );
                      },
                      child: const Text('See all'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _StoreCardRow(
                    stores: featured,
                    onTap: (store) {
                      _recent.add(store.id);
                      _touchRecent(store.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StoreDetailScreen(store: store),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),

                  // RECENTLY VIEWED
                  if (recentStores.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Recently viewed',
                      subtitle: 'Pick up where you left off',
                      icon: Icons.history,
                      trailing: TextButton(
                        onPressed: () {
                          setState(() => _recentIds.clear());
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _StoreCardRow(
                      stores: recentStores,
                      onTap: (store) {
                        _recent.add(store.id);
                        _touchRecent(store.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreDetailScreen(store: store),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  // QUICK ACTIONS
                  _SectionHeader(
                    title: 'Quick actions',
                    subtitle: 'Browse faster',
                    icon: Icons.flash_on_outlined,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.storefront_outlined,
                          title: 'Stores',
                          subtitle: 'Search + sort',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const StoresScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.grid_view_outlined,
                          title: 'Categories',
                          subtitle: 'Tap to filter',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoriesScreen(recentlyViewed: _recent),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _QuickActionCard(
                    icon: Icons.info_outline,
                    title: 'About / Disclosure',
                    subtitle: 'Affiliate disclosure',
                    onTap: () {
                      // If you have a dedicated route/screen, wire it here.
                      // Leaving as a no-op to avoid breaking navigation.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Disclosure page is available in the app menu.')),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: scheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.35)),
          ),
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _StoreCardRow extends StatelessWidget {
  final List<StoreModel> stores;
  final void Function(StoreModel store) onTap;

  const _StoreCardRow({required this.stores, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (stores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.35)),
        ),
        child: const Text('No stores yet.'),
      );
    }

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final store = stores[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(store),
            child: Container(
              width: 168,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceVariant.withOpacity(0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant.withOpacity(0.35)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: scheme.surface.withOpacity(0.55),
                          child: Image.asset(
                            store.logoAsset,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    store.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: scheme.surface.withOpacity(0.65),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scheme.outlineVariant.withOpacity(0.35)),
              ),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
