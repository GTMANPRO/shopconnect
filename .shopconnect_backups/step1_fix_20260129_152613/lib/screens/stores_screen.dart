import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../widgets/store_tile.dart';
import 'store_detail_screen.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  /// Replace affiliateUrl values with your real affiliate links.
  static const stores = <StoreModel>[
    StoreModel(
      id: 'amazon',
      name: 'Amazon',
      logoAsset: 'assets/logos/amazon.png',
      category: 'Electronics',
      affiliateUrl: 'https://www.amazon.com',
    ),
    StoreModel(
      id: 'nike',
      name: 'Nike',
      logoAsset: 'assets/logos/nike.png',
      category: 'Sports',
      affiliateUrl: 'https://www.nike.com',
    ),
    StoreModel(
      id: 'sephora',
      name: 'Sephora',
      logoAsset: 'assets/logos/sephora.png',
      category: 'Beauty',
      affiliateUrl: 'https://www.sephora.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stores")),
      body: ListView.separated(
        itemCount: stores.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
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
