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

  static final List<StoreModel> stores = <StoreModel>[
    // Electronics
    StoreModel(
      id: 'amazon',
      name: 'Amazon',
      category: 'Electronics',
      description: 'Everything from gadgets to home essentials.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.amazon.com/',
    ),

    // Fashion
    StoreModel(
      id: 'nike',
      name: 'Nike',
      category: 'Fashion',
      description: 'Shoes, apparel, and sportswear.',
      logoAsset: 'assets/logos/nike.png',
      outboundUrl: 'https://www.nike.com/',
    ),

    // Beauty
    StoreModel(
      id: 'sephora',
      name: 'Sephora',
      category: 'Beauty',
      description: 'Makeup, skincare, and beauty products.',
      logoAsset: 'assets/logos/sephora.png',
      outboundUrl: 'https://www.sephora.com/',
    ),

    // Sports
    StoreModel(
      id: 'espn',
      name: 'ESPN',
      category: 'Sports',
      description: 'Scores, highlights, and sports coverage.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.espn.com/',
    ),

    // Travel
    StoreModel(
      id: 'expedia',
      name: 'Expedia',
      category: 'Travel',
      description: 'Flights, hotels, and travel deals.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.expedia.com/',
    ),

    // Photography
    StoreModel(
      id: 'bhphoto',
      name: 'B&H Photo',
      category: 'Photography',
      description: 'Cameras, lenses, and photo gear.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.bhphotovideo.com/',
    ),

    // Entertainment
    StoreModel(
      id: 'netflix',
      name: 'Netflix',
      category: 'Entertainment',
      description: 'Movies and TV streaming.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.netflix.com/',
    ),

    // Gaming (✅ ensures count is not 0)
    StoreModel(
      id: 'playstation',
      name: 'PlayStation Store',
      category: 'Gaming',
      description: 'Games, DLC, subscriptions, and deals.',
      // Reuse an existing logo to avoid introducing new assets.
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://store.playstation.com/',
    ),
  ];
}
