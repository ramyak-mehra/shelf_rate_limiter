# Shelf Rate Limiter
It limits the number of requests made to your backend in a fixed time frame.

## Usage


```dart
  final memoryStorage = MemStorage();
    final rateLimiter = ShelfRateLimiter(
      storage: memoryStorage, duration: Duration(seconds: 60), maxRequests: 10);
```
The default values for duration is 60 seconds and maxRequests is 5.

Add it as a middleware inside the handler or any route.
```dart
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(rateLimiter.rateLimiter())
      .addHandler(_echoRequest);

```
