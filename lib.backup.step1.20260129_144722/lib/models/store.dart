class Store {
  final String name;
  final String category;
  final String logoUrl;      // can be asset path or network url later
  final String affiliateUrl;

  const Store({
    required this.name,
    required this.category,
    required this.logoUrl,
    required this.affiliateUrl,
  });
}
