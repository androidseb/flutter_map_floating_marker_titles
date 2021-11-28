class RotatingCache<K, V> {
  final int halfCacheMaxSize;

  Map<K, V> _primaryCache = {};
  Map<K, V> _secondaryCache = {};

  RotatingCache(this.halfCacheMaxSize);

  void _swapCaches() {
    final Map<K, V> tmp = _primaryCache;
    _primaryCache = _secondaryCache;
    _secondaryCache = tmp;
  }

  V? getValue(final K key) {
    V? cachedValue = _primaryCache[key];
    if (cachedValue != null) {
      return cachedValue;
    }
    cachedValue = _secondaryCache[key];
    if (cachedValue == null) {
      return null;
    }

    putValue(key, cachedValue);
    return cachedValue;
  }

  void putValue(final K key, final V value) {
    if (_primaryCache.length >= halfCacheMaxSize) {
      _secondaryCache.clear();
      _swapCaches();
    }
    _primaryCache[key] = value;
  }
}
