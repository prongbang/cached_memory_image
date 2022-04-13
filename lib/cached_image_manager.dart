import 'dart:io';
import 'dart:typed_data';

abstract class CachedImageManager {
  Future<bool> isExists(String key);

  Future<bool> removeFile(String key);

  Future<void> clearCache();

  Future<void> dispose();

  Future<File> cacheBase64(
    String key,
    String base64, {
    Duration maxAge,
    String fileExtension,
  });

  Future<File> cacheBytes(
    String key,
    Uint8List bytes, {
    Duration maxAge,
    String fileExtension,
  });
}
