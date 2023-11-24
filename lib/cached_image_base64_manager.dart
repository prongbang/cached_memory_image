import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImageBase64Manager implements CachedImageManager {
  final CacheManager _cacheManager;

  CachedImageBase64Manager(this._cacheManager);

  factory CachedImageBase64Manager.instance() =>
      CachedImageBase64Manager(DefaultCacheManager());

  static Future<Uint8List> _convertBase64ToBytes(String base64) async {
    const converter = Base64Decoder();
    final imageBytes = converter.convert(base64);
    return imageBytes;
  }

  @override
  Future<File> cacheBase64(
    String key,
    String base64, {
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'jpg',
  }) async {
    // Check if the image file is not in the cache
    final fileInfo = await _cacheManager.getFileFromCache(key);
    final file = fileInfo?.file;
    if (file == null) {
      // Convert Base64 to Bytes of array
      final imageBytes = await compute(_convertBase64ToBytes, base64);

      // Put the image file in the cache
      final files = await _cacheManager.putFile(
        key,
        imageBytes,
        maxAge: maxAge,
        fileExtension: fileExtension,
      );
      return files;
    }
    return file;
  }

  @override
  Future<File> cacheBytes(
    String key,
    Uint8List bytes, {
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'jpg',
  }) async {
    // Check if the image file is not in the cache
    final fileInfo = await _cacheManager.getFileFromCache(key);
    final file = fileInfo?.file;
    if (file == null) {
      // Put the image file in the cache
      final files = await _cacheManager.putFile(
        key,
        bytes,
        maxAge: maxAge,
        fileExtension: fileExtension,
      );
      return files;
    }
    return file;
  }

  @override
  Future<bool> isExists(String key) async {
    final fileInfo = await _cacheManager.getFileFromCache(key);
    return fileInfo?.file != null;
  }

  @override
  Future<void> clearCache() => _cacheManager.emptyCache();

  @override
  Future<void> dispose() => _cacheManager.dispose();

  @override
  Future<bool> removeFile(String key) async {
    await _cacheManager.removeFile(key);
    return true;
  }

  @override
  Future<File?> cacheFile(String key) async {
    // Check if the image file is not in the cache
    final fileInfo = await _cacheManager.getFileFromCache(key);
    return fileInfo?.file;
  }
}
