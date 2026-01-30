class StoreModel {
  final String id;
  final String name;
  final String logoAsset; // local asset path, e.g. assets/logos/amazon.png
  final String category;
  final String affiliateUrl;

  const StoreModel({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.category,
    required this.affiliateUrl,
  });
}
