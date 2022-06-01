import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CachedMemoryImagePlaceholderProvider
    extends ImageProvider<CachedMemoryImagePlaceholderProvider> {
  final Uint8List bytes;
  final double scale;

  CachedMemoryImagePlaceholderProvider({
    required this.bytes,
    this.scale = 1.0,
  });

  @override
  ImageStreamCompleter load(
    CachedMemoryImagePlaceholderProvider key,
    DecoderCallback decode,
  ) =>
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, decode),
        scale: key.scale,
        informationCollector: () => <DiagnosticsNode>[
          ErrorDescription('Key: $key'),
        ],
      );

  @override
  Future<CachedMemoryImagePlaceholderProvider> obtainKey(
    ImageConfiguration configuration,
  ) =>
      SynchronousFuture<CachedMemoryImagePlaceholderProvider>(this);

  Future<ui.Codec> _loadAsync(
    CachedMemoryImagePlaceholderProvider key,
    DecoderCallback decode,
  ) async {
    assert(key == this);
    return decode(bytes);
  }
}
