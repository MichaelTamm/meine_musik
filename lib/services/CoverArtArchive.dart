import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoverArtArchive {
  CoverArtArchive(this._httpClient);

  final http.Client _httpClient;
  final Map<String, Future<Uint8List?>> _cache = {};

  Future<Uint8List?> getAlbumCoverThumbnail(String releaseMbid) async {
    var cached = true;
    try {
      final future = _cache.putIfAbsent(releaseMbid, () {
        cached = false;
        return _getAlbumCoverThumbnail(releaseMbid);
      });
      final result = await future;
      return result;
    } catch (error, stack) {
      if (!cached) {
        debugPrintStack(label: 'Failed to get thumbnail for release: $releaseMbid -- $error', stackTrace: stack);
      }
      return null;
    }
  }

  Future<Uint8List?> _getAlbumCoverThumbnail(String releaseMbid) async {
    final uri1 = Uri.https('coverartarchive.org', '/release/$releaseMbid');
    final response1 = await _httpClient.get(uri1);
    if (response1.statusCode != 200) {
      throw Exception('HTTP GET $uri1 => HTTP Status code: ${response1.statusCode}\n${response1.body}');
    }
    final data = jsonDecode(utf8.decode(response1.bodyBytes)) as Map<String, dynamic>;
    final images = data['images'] as List<dynamic>?;
    if (images != null) {
      for (final imageData in images) {
        if (imageData['front'] == true) {
          final thumbnails = imageData['thumbnails'] as Map<String, dynamic>?;
          final uri2 = (thumbnails?['large'] ?? thumbnails?['500'] ?? imageData['image']) as String?;
          if (uri2 != null) {
            final response2 = await _httpClient.get(Uri.parse(uri2));
            if (response2.statusCode != 200) {
              throw Exception('HTTP GET $uri2 => HTTP Status code: ${response2.statusCode}\n${response2.body}');
            }
            return response2.bodyBytes;
          }
        }
      }
    }
    return null;
  }
}
