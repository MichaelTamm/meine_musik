import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const bool CI = bool.fromEnvironment('CI');

class RecordPlaybackHttpClient implements http.Client {
  final http.Client _httpClient = http.Client();

  @override
  void close() {
    // TODO: implement close
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final dir = Directory('test/.http-recordings/${url.host}');
    final query = url.query;
    final file = File('${dir.path}/GET${url.path.replaceAll('/', '_')}${query.isEmpty ? '' : '_$query'}.json');
    if (file.existsSync()) {
      final response = _deserializeResponse(http.Request('GET', url), file);
      return response;
    } else {
      if (CI) {
        throw StateError('No http recording for GET $url -- will not record HTTP requests in CI environment.');
      }
      final response = await _httpClient.get(url, headers: headers);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      _serializeResponse(file, response);
      return response;
    }
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    // TODO: implement head
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    // TODO: implement readBytes
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }

  void _serializeResponse(File file, http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    dynamic body;
    if (contentType.startsWith('application/json')) {
      body = jsonDecode(response.body);
    } else {
      body = base64.encode(response.bodyBytes);
    }
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ', ).convert({
        'statusCode': response.statusCode,
        'headers': response.headers,
        'body': body,
      })
    );
  }

  http.Response _deserializeResponse(http.Request request, File file) {
    final data = jsonDecode(file.readAsStringSync());
    final statusCode = data['statusCode'] as int;
    final headers = (data['headers'] as Map<String, dynamic>).cast<String, String>();
    final contentType = headers['content-type'] ?? '';
    if (contentType.startsWith('application/json')) {
      final body = JsonEncoder.withIndent('  ').convert(data['body']);
      return http.Response(body, statusCode, request: request, headers: headers);
    } else {
      final body = base64.decode(data['body'] as String);
      return http.Response.bytes(body, statusCode, request: request, headers: headers);
    }
  }
}