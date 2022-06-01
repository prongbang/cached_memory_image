import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CachedMemoryImageProvider
    extends ImageProvider<CachedMemoryImageProvider> {
  final String uniqueKey;
  final String? base64;
  final Uint8List? bytes;
  final double scale;
  CachedImageManager? _cachedImageManager;

  CachedMemoryImageProvider(
    this.uniqueKey, {
    this.bytes,
    this.base64,
    this.scale = 1.0,
  }) {
    _cachedImageManager = CachedImageBase64Manager.instance();
  }

  static Future<Uint8List> readAsBytes(File? file) async =>
      await file?.readAsBytes() ?? Uint8List.fromList([]);

  @override
  ImageStreamCompleter load(
    CachedMemoryImageProvider key,
    DecoderCallback decode,
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
    DecoderCallback decode,
  ) async {
    assert(key == this);

    File? file;

    if (base64 != null) {
      file = await _cachedImageManager?.cacheBase64(uniqueKey, base64!);
    } else if (bytes != null) {
      file = await _cachedImageManager?.cacheBytes(uniqueKey, bytes!);
    }

    final bytesImage = await compute(readAsBytes, file);

    if (bytesImage.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance?.imageCache?.evict(key);
      throw StateError('$uniqueKey is empty and cannot be loaded as an image.');
    }

    return decode(bytesImage);
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
