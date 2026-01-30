import '../models/store_model.dart';

class SeedData {
  static const List<String> categories = <String>[
    'Electronics',
    'Fashion',
    'Beauty',
    'Sports',
    'Travel',
    'Photography',
    'Entertainment',
  ];

  // Keep ids stable so recently-viewed can be deduped.
  static final List<StoreModel> stores = <StoreModel>[
    const StoreModel(
      id: 'amazon',
      name: 'Amazon',
      category: 'Electronics',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.amazon.com',
      description: 'Everyday essentials, tech, and more.',
    ),
    const StoreModel(
      id: 'nike',
      name: 'Nike',
      category: 'Sports',
      logoAsset: 'assets/logos/nike.png',
      outboundUrl: 'https://www.nike.com',
      description: 'Shoes, apparel, and training gear.',
    ),
    const StoreModel(
      id: 'sephora',
      name: 'Sephora',
      category: 'Beauty',
      logoAsset: 'assets/logos/sephora.png',
      outboundUrl: 'https://www.sephora.com',
      description: 'Makeup, skincare, and fragrance.',
    ),
    const StoreModel(
      id: 'bhphoto',
      name: 'B&H Photo',
      category: 'Photography',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.bhphotovideo.com',
      description: 'Cameras, lenses, and creator gear.',
    ),
    const StoreModel(
      id: 'expedia',
      name: 'Expedia',
      category: 'Travel',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.expedia.com',
      description: 'Flights, hotels, and packages.',
    ),
    const StoreModel(
      id: 'ticketmaster',
      name: 'Ticketmaster',
      category: 'Entertainment',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.ticketmaster.com',
      description: 'Concerts, sports tickets, events.',
    ),
    const StoreModel(
      id: 'asos',
      name: 'ASOS',
      category: 'Fashion',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.asos.com',
      description: 'Style, clothing, and accessories.',
    ),
  ];

  static StoreModel? byId(String id) {
    try {
      return stores.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
