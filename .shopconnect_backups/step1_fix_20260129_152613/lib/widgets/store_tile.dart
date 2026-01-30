import 'package:flutter/material.dart';
import '../models/store_model.dart';

class StoreTile extends StatelessWidget {
  final StoreModel store;
  final VoidCallback onTap;

  const StoreTile({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          store.logoAsset,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 44,
            height: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black12),
              child: Icon(Icons.store),
            ),
          ),
        ),
      ),
      title: Text(store.name),
      subtitle: Text(store.category),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: onTap,
    );
  }
}
