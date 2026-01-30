import 'package:flutter/foundation.dart';

@immutable
class StoreModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String logoAsset;
  final String outboundUrl;

  /// Controls whether the store should appear in the Home "Featured stores" row.
  /// Defaults to false so existing code/data stays compatible.
  final bool isFeatured;

  const StoreModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.logoAsset,
    required this.outboundUrl,
    this.isFeatured = false,
  });
}
