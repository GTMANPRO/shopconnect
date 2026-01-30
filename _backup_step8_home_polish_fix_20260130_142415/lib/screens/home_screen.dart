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

  // In-memory recent list for fast UI updates (persistence handled in RecentlyViewed if implemented).
  final List<String> _recentIds = <String>[];

  @override
  Widget build(BuildContext context) {
    final featured = SeedData.stores.where((s) => s.isFeatured).toList();

    final recentStores = _recentIds
        .map((id) => SeedData.stores.where((s) => s.id == id).toList())
        .expand((e) => e)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopConnect'),
        actions: [
          IconButton(
            tooltip: 'Stores',
            icon: const Icon(Icons.storefront_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen()));
            },
          ),
          IconButton(
            tooltip: 'Categories',
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoriesScreen(recentlyViewed: _recent)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _heroCard(context),
          const SizedBox(height: 18),

          _sectionHeader(
            context,
            icon: Icons.star_rounded,
            title: 'Featured',
            subtitle: 'Top picks right now',
            trailing: TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen())),
              child: const Text('See all'),
            ),
          ),
          const SizedBox(height: 10),
          _storeRow(context, featured, onTap: _openStore),
          const SizedBox(height: 18),

          _sectionHeader(
            context,
            icon: Icons.history_rounded,
            title: 'Recently viewed',
            subtitle: 'Pick up where you left off',
            trailing: TextButton(
              onPressed: () {
                setState(() => _recentIds.clear());
                // Also clear persisted store if your RecentlyViewed supports it.
                try {
                  _recent.clear();
                } catch (_) {}
              },
              child: const Text('Clear'),
            ),
          ),
          const SizedBox(height: 10),
          if (recentStores.isEmpty)
            _emptyRecent(context)
          else
            _storeRow(context, recentStores, onTap: _openStore),
          const SizedBox(height: 18),

          _sectionHeader(
            context,
            icon: Icons.flash_on_rounded,
            title: 'Quick actions',
            subtitle: 'Browse faster',
          ),
          const SizedBox(height: 10),
          _quickActionCard(
            context,
            title: 'Stores',
            subtitle: 'Search + sort',
            icon: Icons.storefront_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen())),
          ),
          const SizedBox(height: 10),
          _quickActionCard(
            context,
            title: 'Categories',
            subtitle: 'Tap to filter',
            icon: Icons.grid_view_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CategoriesScreen(recentlyViewed: _recent)),
            ),
          ),
          const SizedBox(height: 10),

          // About / Disclosure CTA — no direct import to avoid breakage if file name differs.
          _aboutDisclosureCard(context),
        ],
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: const Icon(Icons.local_offer_outlined, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Find deals fast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text(
                  'Browse trusted stores and jump straight to their best offers.',
                  style: TextStyle(fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: null,
            child: Text('Explore'),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.55),
          ),
          child: Icon(icon, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _storeRow(BuildContext context, List<StoreModel> stores, {required void Function(StoreModel) onTap}) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _storeCard(context, stores[index], onTap: onTap),
      ),
    );
  }

  Widget _storeCard(BuildContext context, StoreModel store, {required void Function(StoreModel) onTap}) {
    final cs = Theme.of(context).colorScheme;

    return _Hoverable(
      onTap: () => onTap(store),
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.42),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 54,
              width: 54,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: cs.surface,
                border: Border.all(color: cs.primary.withOpacity(0.25), width: 1.2),
              ),
              child: Image.asset(store.logoAsset, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              store.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              store.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyRecent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.history_rounded, color: Theme.of(context).hintColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No recently viewed stores yet. Open a store to see it here.',
              style: TextStyle(fontSize: 12.5, color: Theme.of(context).hintColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return _Hoverable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.45)),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Icon(icon, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget _aboutDisclosureCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return _Hoverable(
      onTap: () async {
        // Try common named routes without importing a specific screen file.
        // This avoids breakage if your disclosure screen filename/class differs.
        const candidates = <String>['/about', '/disclosure', '/about-disclosure', '/aboutDisclosure'];
        bool pushed = false;

        for (final r in candidates) {
          try {
            await Navigator.of(context).pushNamed(r);
            pushed = true;
            break;
          } catch (_) {
            // ignore and try next
          }
        }

        if (!pushed && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('About / Disclosure route not found. If you renamed it, add a named route like /about.'),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.45)),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: const Icon(Icons.info_outline_rounded, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('About / Disclosure', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(width: 8),
                      _Pill(text: 'Required'),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text('Affiliate disclosure', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  void _openStore(StoreModel store) {
    // Keep local recent row updated immediately.
    setState(() {
      _recentIds.remove(store.id);
      _recentIds.insert(0, store.id);
      if (_recentIds.length > 10) _recentIds.removeLast();
    });

    // Also write to shared RecentlyViewed (may be persisted depending on implementation).
    try {
      _recent.add(store.id);
    } catch (_) {}

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StoreDetailScreen(store: store)),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: cs.primary,
        ),
      ),
    );
  }
}

class _Hoverable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Hoverable({required this.child, required this.onTap});

  @override
  State<_Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<_Hoverable> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scale = _hover ? 1.01 : 1.0;
    final translate = _hover ? -2.0 : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          transform: Matrix4.identity()
            ..translate(0.0, translate)
            ..scale(scale),
          child: widget.child,
        ),
      ),
    );
  }
}