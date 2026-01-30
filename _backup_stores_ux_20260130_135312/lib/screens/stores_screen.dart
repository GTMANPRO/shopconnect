import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/store_model.dart';
import '../widgets/store_tile.dart';
import 'store_detail_screen.dart';

class StoresScreen extends StatefulWidget {
  final String? category;

  const StoresScreen({super.key, this.category});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  bool _sortAZ = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final q = _controller.text.trim().toLowerCase();
      if (q != _query) {
        setState(() => _query = q);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<StoreModel> _filteredStores() {
    final List<StoreModel> all = SeedData.stores;
    final List<StoreModel> filtered = all.where((s) {
      final bool catOk =
          widget.category == null ? true : s.category == widget.category;
      final bool qOk = _query.isEmpty
          ? true
          : s.name.toLowerCase().contains(_query) ||
              s.description.toLowerCase().contains(_query);
      return catOk && qOk;
    }).toList();

    filtered.sort((a, b) => _sortAZ
        ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
        : b.name.toLowerCase().compareTo(a.name.toLowerCase()));

    return filtered;
  }

  void _clearSearch() {
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final stores = _filteredStores();
    final title = widget.category == null ? 'Stores' : 'Stores • ${widget.category}';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: _sortAZ ? 'Sort Z→A' : 'Sort A→Z',
            icon: Icon(_sortAZ ? Icons.sort_by_alpha : Icons.swap_vert),
            onPressed: () => setState(() => _sortAZ = !_sortAZ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search stores',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: stores.isEmpty
                  ? _EmptyState(
                      hasQuery: _query.isNotEmpty,
                      onClearSearch: _clearSearch,
                    )
                  : ListView.separated(
                      itemCount: stores.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final store = stores[i];
                        return StoreTile(
                          store: store,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoreDetailScreen(store: store),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasQuery;
  final VoidCallback onClearSearch;

  const _EmptyState({
    required this.hasQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 52, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              'No stores found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              hasQuery
                  ? 'Try a different search or clear your search.'
                  : 'There are no stores in this list yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            if (hasQuery)
              OutlinedButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.close),
                label: const Text('Clear search'),
              ),
          ],
        ),
      ),
    );
  }
}
