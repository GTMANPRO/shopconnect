import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../services/affiliate_service.dart';
import '../services/firestore_service.dart';

class StoreDetailScreen extends StatelessWidget {
  final StoreModel store;

  const StoreDetailScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                store.logoUrl,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 110,
                  width: 110,
                  child: Icon(Icons.store, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(store.category, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await service.logClick(store.id);
                  await AffiliateService.openAffiliateLink(store.affiliateUrl);
                },
                child: const Text('Shop Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
