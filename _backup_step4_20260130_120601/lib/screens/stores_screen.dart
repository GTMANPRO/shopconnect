import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/store_model.dart';
import '../widgets/store_tile.dart';
import '../state/recently_viewed.dart';
import 'store_detail_screen.dart';

class StoresScreen extends StatefulWidget {
  final String? category; // optional filter
  final RecentlyViewed? recentlyViewed;

  const StoresScreen({super.key, this.category, this.recentlyViewed});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<StoreModel> all = SeedData.stores;

    final filtered = all.where((s) {
      final matchesCategory = widget.category == null ? true : s.category == widget.category;
      final q = _query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ? true : s.name.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Stores' : 'Stores • ${widget.category}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search stores',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final store = filtered[i];
                return StoreTile(
                  store: store,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StoreDetailScreen(
                          store: store,
                          recentlyViewed: widget.recentlyViewed,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
