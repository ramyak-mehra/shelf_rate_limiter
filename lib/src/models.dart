///Basic model that stores the details of a single ip.
///Takes in a key(Unique to each ip) and a window duration
class IpItem {
  IpItem({required String key, required Duration duration, int? accessCount})
      : _key = key,
        _accessCount = accessCount ?? 1,
        _resetAt = DateTime.now().add(duration);

  ///Unique string to identify a request. Currently uses the users ip.
  final String _key;

  ///Time at which the window will be reset at.
  DateTime _resetAt;

  ///The number of times the user has accessed the site.
  int _accessCount;

  String get key => _key;
  DateTime get resetAt => _resetAt;
  int get accessCount => _accessCount;

  ///Reset the data for the ip. This is called when the window has been reset.
  void resetIp(Duration duration) {
    _accessCount = 1;
    _resetAt = DateTime.now().add(duration);
  }

  ///Increments the access count.
  void updateAccessCount() {
    _accessCount++;
  }
}
