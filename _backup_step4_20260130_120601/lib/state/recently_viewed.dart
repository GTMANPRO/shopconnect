import 'package:flutter/foundation.dart';

class RecentlyViewed extends ChangeNotifier {
  final List<String> _storeIds = <String>[];

  List<String> get storeIds => List.unmodifiable(_storeIds);

  void add(String storeId) {
    // Move to front, dedupe
    _storeIds.remove(storeId);
    _storeIds.insert(0, storeId);

    // Keep small + fast
    if (_storeIds.length > 10) {
      _storeIds.removeRange(10, _storeIds.length);
    }
    notifyListeners();
  }

  void clear() {
    _storeIds.clear();
    notifyListeners();
  }
}
