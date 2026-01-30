class StoreModel {
  final String id;
  final String name;
  final String logoUrl;
  final String category;
  final String affiliateUrl;

  StoreModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.category,
    required this.affiliateUrl,
  });

  factory StoreModel.fromMap(Map<String, dynamic> data, String id) {
    return StoreModel(
      id: id,
      name: (data['name'] ?? '') as String,
      logoUrl: (data['logoUrl'] ?? '') as String,
      category: (data['category'] ?? '') as String,
      affiliateUrl: (data['affiliateUrl'] ?? '') as String,
    );
  }
}
