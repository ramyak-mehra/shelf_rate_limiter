import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf_rate_limiter/src/models.dart';
import 'package:shelf_rate_limiter/src/storage/base_storage.dart';

///Actual implementation of rate limiter.
///Default value for [maxRequests] is 5 and duration is 1 minute.
class ShelfRateLimiter {
  final BaseStorage _storage;
  final Duration _duration;
  final int _maxRequests;
  final int _statusCode;
  final String _message;

  ShelfRateLimiter(
      {required BaseStorage storage, Duration? duration, int? maxRequests})
      : _storage = storage,
        _duration = duration ?? Duration(seconds: 60),
        _maxRequests = maxRequests ?? 5,
        _message = "Too many requests, please try again later.",
        _statusCode = 429;

  BaseStorage get storage => _storage;
  Duration get duration => _duration;
  int get maxResults => _maxRequests;

  Middleware rateLimiter() {
    IpItem? ipItem;

    Response? _handleRateLimitRequest(Request request) {
      final key = _keyGenerator(request);
      final result = _forwardRequests(key);
      if (result[0]) {
        ipItem = result[1];
        return null;
      } else {
        return Response(_statusCode, body: _message);
      }
    }

    Response _handleRateLimiterResponse(Response response) {
      if (response.statusCode < 400) {
        return response.change(headers: {
          'X-RateLimit-Limit': _maxRequests.toString(),
          'X-RateLimit-Remaining':
              max(_maxRequests - ipItem!.accessCount, 0).toString(),
          'X-RateLimit-Reset':
              (ipItem!.resetAt.millisecondsSinceEpoch / 1000).ceil().toString()
        });
      }
      return response;
    }

    return createMiddleware(
        responseHandler: _handleRateLimiterResponse,
        requestHandler: _handleRateLimitRequest);
  }

  List _forwardRequests(String key) {
    var item = _storage.getItem(key);
    if (item != null) {
      var result = item.resetAt.compareTo(DateTime.now());
      if (result > 0 && item.accessCount < maxResults) {
        _storage.updateCount(key);
        return [true, item];
      } else if (result > 0 && item.accessCount >= maxResults) {
        return [false];
      } else {
        _storage.resetIp(key, duration);
        return [true, item];
      }
    } else {
      final newIpItem = _storage.add(key, duration);
      return [true, newIpItem];
    }
  }

  ///Generates key for storage.
  ///Currently uses the ip address.
  String _keyGenerator(Request request) {
    return request.headers['X-Forwarded-For'] ??
        (request.context['shelf.io.connection_info'] as HttpConnectionInfo)
            .remoteAddress
            .address;
  }
}
