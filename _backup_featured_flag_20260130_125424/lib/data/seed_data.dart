import '../models/store_model.dart';

class SeedData {
  static const List<String> categories = [
    'Electronics',
    'Fashion',
    'Beauty',
    'Sports',
    'Travel',
    'Photography',
    'Entertainment',
    'Gaming',
  ];

  /// Single source of truth for all stores.
  static final List<StoreModel> stores = <StoreModel>[
    StoreModel(
      id: 'amazon',
      name: 'Amazon',
      category: 'Electronics',
      description: 'Everyday essentials, tech, and deals.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.amazon.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'nike',
      name: 'Nike',
      category: 'Fashion',
      description: 'Shoes, apparel, and gear.',
      logoAsset: 'assets/logos/nike.png',
      outboundUrl: 'https://www.nike.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'sephora',
      name: 'Sephora',
      category: 'Beauty',
      description: 'Beauty, skincare, and fragrances.',
      logoAsset: 'assets/logos/sephora.png',
      outboundUrl: 'https://www.sephora.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'espn',
      name: 'ESPN',
      category: 'Sports',
      description: 'Sports coverage, streaming, and gear links.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.espn.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'expedia',
      name: 'Expedia',
      category: 'Travel',
      description: 'Flights, hotels, and travel bundles.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.expedia.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'bhphoto',
      name: 'B&H Photo',
      category: 'Photography',
      description: 'Cameras, lenses, and accessories.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.bhphotovideo.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'netflix',
      name: 'Netflix',
      category: 'Entertainment',
      description: 'Streaming entertainment and subscriptions.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.netflix.com/',
      isFeatured: true,
    ),
    StoreModel(
      id: 'playstation',
      name: 'PlayStation Store',
      category: 'Gaming',
      description: 'Games, DLC, subscriptions, and deals.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://store.playstation.com/',
      isFeatured: true,
    ),
  ];
}
