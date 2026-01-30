import 'package:flutter/material.dart';
import '../models/store_model.dart';

class StoreTile extends StatelessWidget {
  final StoreModel store;
  final VoidCallback onTap;

  const StoreTile({
    super.key,
    required this.store,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          store.logoUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.store),
          ),
        ),
      ),
      title: Text(store.name),
      subtitle: Text(store.category),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
