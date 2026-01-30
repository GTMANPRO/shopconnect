import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../services/firestore_service.dart';
import '../widgets/store_tile.dart';
import 'store_detail_screen.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Stores')),
      body: StreamBuilder<List<StoreModel>>(
        stream: service.getStores(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stores = snapshot.data!;
          if (stores.isEmpty) {
            return const Center(child: Text('No stores found.'));
          }

          return ListView.separated(
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
          );
        },
      ),
    );
  }
}
