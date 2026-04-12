import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    debugPrint('HTTP ${request.method} ${request.url} ...');
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}
