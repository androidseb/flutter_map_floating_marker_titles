import 'package:flutter_floating_map_marker_titles_core/utils/rotating_cache.dart';

abstract class CachedCalculator<K, V> {
  final RotatingCache<K, V> _cache;

  static int _computeSaneHalfCacheSize(final int cacheMaxSize) {
    if (cacheMaxSize < 2) {
      return 1;
    } else {
      return (cacheMaxSize / 2).floor();
    }
  }

  CachedCalculator(final int cacheMaxSize) : _cache = RotatingCache<K, V>(_computeSaneHalfCacheSize(cacheMaxSize));

  V getValue(final K key) {
    final V existingCacheEntry = _cache.getValue(key);
    if (existingCacheEntry != null) {
      return existingCacheEntry;
    }
    final V createdCacheEntry = calculateValue(key);
    _cache.putValue(key, createdCacheEntry);
    return createdCacheEntry;
  }

  V calculateValue(final K key);
}
