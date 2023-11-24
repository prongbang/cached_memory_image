import 'dart:io';
import 'dart:ui' as ui show Codec;

import 'package:cached_memory_image/cached_image.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CachedMemoryImageProvider
    extends ImageProvider<CachedMemoryImageProvider> {
  final String uniqueKey;
  final String? base64;
  final Uint8List? bytes;
  final double scale;
  final CachedImage cached;
  CachedImageManager? _cachedImageManager;

  CachedMemoryImageProvider(
    this.uniqueKey, {
    this.bytes,
    this.base64,
    this.scale = 1.0,
    this.cached = CachedImage.cacheAndRead,
  }) {
    _cachedImageManager = CachedImageBase64Manager.instance();
  }

  static Future<Uint8List> readAsBytes(File? file) async =>
      await file?.readAsBytes() ?? Uint8List.fromList([]);

  @override
  ImageStreamCompleter loadImage(
    CachedMemoryImageProvider key,
    ImageDecoderCallback decode,
  ) =>
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, decode),
        scale: key.scale,
        debugLabel: key.uniqueKey,
        informationCollector: () => <DiagnosticsNode>[
          ErrorDescription('Key: $uniqueKey'),
        ],
      );

  Future<ui.Codec> _loadAsync(
    CachedMemoryImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);

    File? file;

    if (cached == CachedImage.cacheAndRead) {
      if (base64 != null) {
        file = await _cachedImageManager?.cacheBase64(uniqueKey, base64!);
      } else if (bytes != null) {
        file = await _cachedImageManager?.cacheBytes(uniqueKey, bytes!);
      }
    } else if (cached == CachedImage.readOnly) {
      file = await _cachedImageManager?.cacheFile(uniqueKey);
    }

    final bytesImage = await compute(readAsBytes, file);

    if (bytesImage.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$uniqueKey is empty and cannot be loaded as an image.');
    }
    ImmutableBuffer buffer =
        await ImmutableBuffer.fromUint8List(bytes ?? bytesImage);
    return decode(buffer);
  }

  @override
  Future<CachedMemoryImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) =>
      SynchronousFuture<CachedMemoryImageProvider>(this);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CachedMemoryImageProvider &&
        other.uniqueKey == uniqueKey &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(uniqueKey, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CachedMemoryImageProvider')}("$uniqueKey", scale: $scale)';
}
