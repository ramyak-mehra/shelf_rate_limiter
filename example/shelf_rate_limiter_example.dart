import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_rate_limiter/shelf_rate_limiter.dart';
import 'package:shelf_rate_limiter/src/storage/memory_storage.dart';

void main() async {
  final memoryStorage = MemStorage();
  final rateLimiter = ShelfRateLimiter(
      storage: memoryStorage, duration: Duration(seconds: 60), maxRequests: 10);

  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(rateLimiter.rateLimiter())
      .addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request request) =>
    Response.ok('Request for "${request.url}"');
