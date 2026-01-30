import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../widgets/store_tile.dart';
import 'store_detail_screen.dart';

class StoresScreen extends StatelessWidget {
  final String? category; // optional filter

  const StoresScreen({super.key, this.category});

  static const _allStores = <StoreModel>[
    StoreModel(
      id: 'amazon',
      name: 'Amazon',
      logoAsset: 'assets/logos/amazon.png',
      category: 'Electronics',
      affiliateUrl: 'https://www.amazon.com/',
    ),
    StoreModel(
      id: 'nike',
      name: 'Nike',
      logoAsset: 'assets/logos/nike.png',
      category: 'Sports',
      affiliateUrl: 'https://www.nike.com/',
    ),
    StoreModel(
      id: 'sephora',
      name: 'Sephora',
      logoAsset: 'assets/logos/sephora.png',
      category: 'Beauty',
      affiliateUrl: 'https://www.sephora.com/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final stores = (category == null)
        ? _allStores
        : _allStores.where((s) => s.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'Stores' : 'Stores • $category'),
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, i) {
          return StoreTile(
            store: stores[i],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoreDetailScreen(store: stores[i]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
