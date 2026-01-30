class StoreModel {
  final String id;
  final String name;
  final String category; // one of SeedData.categories
  final String logoAsset; // e.g. assets/logos/amazon.png
  final String outboundUrl; // affiliate / outbound
  final String description;

  const StoreModel({
    required this.id,
    required this.name,
    required this.category,
    required this.logoAsset,
    required this.outboundUrl,
    required this.description,
  });
}
