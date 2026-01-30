import 'package:flutter/material.dart';
import '../models/store_model.dart';

class StoreTile extends StatelessWidget {
  final StoreModel store;
  final VoidCallback? onTap;

  const StoreTile({super.key, required this.store, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        store.logoAsset,
        width: 36,
        height: 36,
        errorBuilder: (context, error, stack) =>
            const Icon(Icons.storefront_outlined),
      ),
      title: Text(store.name),
      subtitle: Text(store.description, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
