import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TheAudioDB {
  TheAudioDB(this._httpClient);

  final http.Client _httpClient;
  final Map<String, Future<Uint8List?>> _cache = {};

  Future<Uint8List?> getArtistThumbnail(String artistMbid) async {
    var cached = true;
    try {
      final future = _cache.putIfAbsent(artistMbid, () {
        cached = false;
        return _getArtistThumbnail(artistMbid);
      });
      final result = await future;
      return result;
    } catch (error, stack) {
      if (!cached) {
        debugPrintStack(label: 'Failed to get thumbnail for artist $artistMbid -- $error', stackTrace: stack);
      }
      return null;
    }
  }

  Future<Uint8List?> _getArtistThumbnail(String artistMbid) async {
    final uri1 = Uri.https('www.theaudiodb.com', '/api/v1/json/123/artist-mb.php', {'i': artistMbid});
    final response1 = await _httpClient.get(uri1);
    if (response1.statusCode != 200) {
      throw Exception('HTTP GET $uri1 => HTTP Status code: ${response1.statusCode}\n${response1.body}');
    }
    final data = jsonDecode(utf8.decode(response1.bodyBytes)) as Map<String, dynamic>;
    final artists = data['artists'] as List<dynamic>?;
    if (artists != null && artists.isNotEmpty) {
      final thumbUrl = (artists[0] as Map<String, dynamic>)['strArtistThumb'] as String?;
      if (thumbUrl != null && thumbUrl.isNotEmpty) {
        final response2 = await _httpClient.get(Uri.parse(thumbUrl));
        if (response2.statusCode != 200) {
          throw Exception('HTTP GET $thumbUrl => HTTP Status code: ${response2.statusCode}\n${response2.body}');
        }
        return response2.bodyBytes;
      }
    }
    return null;
  }
}
