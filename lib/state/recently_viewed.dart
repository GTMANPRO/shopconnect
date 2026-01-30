import 'package:flutter/foundation.dart';
import 'recent_storage_stub.dart'
    if (dart.library.html) 'recent_storage_web.dart' as storage;

/// Persists a list of store IDs.
/// - Web: uses window.localStorage (no extra deps)
/// - Other platforms: in-memory only
class RecentlyViewed {
  static const String _storageKey = 'shopconnect_recently_viewed_ids';
  static const int _maxItems = 10;

  final List<String> _ids = <String>[];

  Future<void> load() async {
    _ids.clear();
    if (!kIsWeb) return;

    final raw = storage.getString(_storageKey);
    if (raw == null || raw.trim().isEmpty) return;

    final parts = raw
        .split('|')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .take(_maxItems);

    _ids.addAll(parts);
  }

  List<String> get ids => List<String>.unmodifiable(_ids);

  Future<void> add(String id) async {
    final clean = id.trim();
    if (clean.isEmpty) return;

    _ids.remove(clean);
    _ids.insert(0, clean);

    if (_ids.length > _maxItems) {
      _ids.removeRange(_maxItems, _ids.length);
    }

    await _save();
  }

  Future<void> clear() async {
    _ids.clear();
    await _save();
  }

  Future<void> _save() async {
    if (!kIsWeb) return;
    storage.setString(_storageKey, _ids.join('|'));
  }
}
