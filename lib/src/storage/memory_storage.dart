import 'package:shelf_rate_limiter/src/models.dart';
import 'package:shelf_rate_limiter/src/storage/base_storage.dart';

/// A [BaseStorage] implementation that stores the rate limit data in memory.

class MemStorage implements BaseStorage {
  final Map<String, IpItem> items;
  MemStorage() : items = {};

  @override
  IpItem add(String key, Duration duration) {
    if (items.containsKey(key)) {
      updateCount(key);
      return items[key]!;
    }
    final ipItem = IpItem(key: key, duration: duration);
    items[key] = ipItem;
    return ipItem;
  }

  @override
  void remove(String key) {
    items.remove(key);
  }

  @override
  void updateCount(String key) {
    items[key]!.updateAccessCount();
  }

  @override
  IpItem? getItem(String key) {
    return items[key];
  }

  @override
  List<IpItem> getItems() {
    return items.values.toList();
  }

  @override
  void resetAll(Duration duration) {
    for (final item in items.values) {
      item.resetIp(duration);
    }
  }

  @override
  void removeAll() {
    items.clear();
  }

  @override
  void resetIp(String key, Duration duration) {
    items[key]!.resetIp(duration);
  }
}
