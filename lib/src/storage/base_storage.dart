import 'package:shelf_rate_limiter/src/models.dart';

///Use this as base class to implement different storage backends.

abstract class BaseStorage {
  IpItem add(String key, Duration duration);

  void remove(String key);

  void updateCount(String key);

  IpItem? getItem(String key);

  void resetIp(String key, Duration duration);

  void resetAll(Duration duration);

  void removeAll();

  List<IpItem> getItems();
}
