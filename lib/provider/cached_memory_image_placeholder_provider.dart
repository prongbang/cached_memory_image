import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      ImageDecoderCallback decode,
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
      ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }
}
