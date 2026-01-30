import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/store_model.dart';
import '../state/recently_viewed.dart';
import 'about_disclosure_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final featured = SeedData.stores.where((s) => s.isFeatured).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopConnect'),
        actions: [
          IconButton(
            tooltip: 'Stores',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StoresScreen()),
              );
            },
            icon: const Icon(Icons.storefront_outlined),
          ),
          IconButton(
            tooltip: 'Categories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriesScreen(recentlyViewed: _recent),
                ),
              );
            },
            icon: const Icon(Icons.grid_view_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _heroCard(context),
          const SizedBox(height: 18),

          _sectionHeader(
            context,
            icon: Icons.auto_awesome_rounded,
            title: 'Featured',
            subtitle: 'Top picks right now',
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
          if (featured.isEmpty)
            _emptyCard(
              context,
              title: 'No featured stores yet',
              subtitle: 'Mark stores with isFeatured: true in SeedData.',
            )
          else
            _storeRow(context, featured),
          const SizedBox(height: 18),

          _sectionHeader(
            context,
            icon: Icons.history_rounded,
            title: 'Recently viewed',
            subtitle: 'Pick up where you left off',
            trailing: TextButton(
              onPressed: () async {
                await _recent.clear();
                setState(() {
                  _loadRecentFuture = _recent.load();
                });
              },
              child: const Text('Clear'),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<void>(
            future: _loadRecentFuture,
            builder: (context, snapshot) {
              final ids = _recent.ids;
              final recentStores = ids
                  .map((id) => SeedData.stores.where((s) => s.id == id))
                  .expand((e) => e)
                  .toList();

              if (snapshot.connectionState == ConnectionState.waiting &&
                  recentStores.isEmpty) {
                return _skeletonRow(context);
              }

              if (recentStores.isEmpty) {
                return _emptyCard(
                  context,
                  title: 'Nothing yet',
                  subtitle: 'Open a store to see it here.',
                );
              }

              return _storeRow(context, recentStores);
            },
          ),
          const SizedBox(height: 18),

          _sectionHeader(
            context,
            icon: Icons.flash_on_rounded,
            title: 'Quick actions',
            subtitle: 'Browse faster',
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _actionCard(
                  context,
                  icon: Icons.store_mall_directory_rounded,
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
                child: _actionCard(
                  context,
                  icon: Icons.category_rounded,
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

          // About/Disclosure — make it feel less like a "dead" row and more like a CTA.
          _aboutCard(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer.withOpacity(0.55),
            cs.secondaryContainer.withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: cs.surface.withOpacity(0.70),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_offer_rounded, color: cs.onSurface),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find deals fast',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(
                  'Browse trusted stores and jump straight to their best offers.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: null,
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(0.55),
            borderRadius: BorderRadius.circular(10),
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _storeRow(BuildContext context, List<StoreModel> stores) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final store = stores[index];
          return _StoreCard(
            store: store,
            onOpen: () async {
              await _recent.add(store.id);
              if (mounted) {
                setState(() {}); // refresh recent row
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoreDetailScreen(store: store)),
              );
            },
          );
        },
      ),
    );
  }

  Widget _emptyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _skeletonRow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Container(
          width: 160,
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(0.35),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return _HoverCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: cs.surface.withOpacity(0.70),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  Widget _aboutCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _HoverCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutDisclosureScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: cs.surface.withOpacity(0.70),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.info_outline_rounded, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About / Disclosure',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'How ShopConnect earns (affiliate disclosure)',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.55),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Required',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}

class _StoreCard extends StatefulWidget {
  final StoreModel store;
  final VoidCallback onOpen;

  const _StoreCard({
    required this.store,
    required this.onOpen,
  });

  @override
  State<_StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<_StoreCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Brand-ish ring: subtle gradient, still safe and neutral.
    final ring = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          cs.primary.withOpacity(0.25),
          cs.secondary.withOpacity(0.18),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onOpen,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceVariant.withOpacity(_hover ? 0.45 : 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(_hover ? 0.55 : 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.10 : 0.05),
                blurRadius: _hover ? 18 : 10,
                offset: Offset(0, _hover ? 10 : 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: ring,
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    widget.store.logoAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.store.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  letterSpacing: 0.1,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.store.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverCard({required this.child, required this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _hover ? 1.01 : 1.0,
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
