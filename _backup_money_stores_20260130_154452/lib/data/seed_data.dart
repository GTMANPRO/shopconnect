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

  // --- Added core affiliate stores (Money Stores Pack) ---
    StoreModel(
      id: 'walmart',
      name: 'Walmart',
      category: 'Electronics',
      description: 'Everyday low prices across electronics, home, and more.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.walmart.com/',
      isFeatured: true,
    ),

    StoreModel(
      id: 'target',
      name: 'Target',
      category: 'Fashion',
      description: 'Style, home, and essentials with frequent promos.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.target.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'ebay',
      name: 'eBay',
      category: 'Electronics',
      description: 'New and used goods—great for deals and unique finds.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.ebay.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'etsy',
      name: 'Etsy',
      category: 'Beauty',
      description: 'Handmade and unique goods from independent sellers.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.etsy.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'temu',
      name: 'Temu',
      category: 'Fashion',
      description: 'Trend-driven low-cost items—strong for viral/social traffic.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.temu.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'shein',
      name: 'SHEIN',
      category: 'Fashion',
      description: 'Fast fashion with frequent drops—viral/social friendly.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.shein.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'aliexpress',
      name: 'AliExpress',
      category: 'Electronics',
      description: 'Marketplace for budget gadgets and deals.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.aliexpress.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'bestbuy',
      name: 'Best Buy',
      category: 'Electronics',
      description: 'High-ticket electronics—good for larger commission dollars.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.bestbuy.com/',
      isFeatured: true,
    ),

    StoreModel(
      id: 'newegg',
      name: 'Newegg',
      category: 'Electronics',
      description: 'PC parts, gaming, and tech—strong for high-intent shoppers.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.newegg.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'apple',
      name: 'Apple',
      category: 'Electronics',
      description: 'Premium devices and accessories—high-ticket intent.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.apple.com/',
      isFeatured: false,
    ),

    StoreModel(
      id: 'booking',
      name: 'Booking.com',
      category: 'Travel',
      description: 'Hotels and travel deals—payouts depend on country/season.',
      logoAsset: 'assets/logos/amazon.png',
      outboundUrl: 'https://www.booking.com/',
      isFeatured: true,
    ),

    StoreModel(
      id: 'adidas',
      name: 'Adidas',
      category: 'Sports',
      description: 'Sportswear and sneakers—strong brand conversion.',
      logoAsset: 'assets/logos/nike.png',
      outboundUrl: 'https://www.adidas.com/',
      isFeatured: false,
    ),


  ];
}
