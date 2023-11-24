import 'dart:io';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_image.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:flutter/material.dart';

export 'provider/cached_memory_image_placeholder_provider.dart';
export 'provider/cached_memory_image_provider.dart';
export 'cached_image.dart';
export 'cached_image_manager.dart';
export 'cached_image_base64_manager.dart';

class CachedMemoryImage extends StatefulWidget {
  /// Example
  /// uniqueKey: 'app://content/image/1'
  final String uniqueKey;

  /// Example
  /// base64: 'iVBORw0KGgoAAAANSUhEUgAAAk0AAAFwCAYAAACl9k...'
  final String? base64;
  final Uint8List? bytes;
  final Widget? placeholder;
  final Widget? errorWidget;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final double scale;
  final int? cacheWidth;
  final int? cacheHeight;
  final CachedImage cached;

  final FilterQuality filterQuality;

  const CachedMemoryImage({
    Key? key,
    required this.uniqueKey,
    this.base64,
    this.bytes,
    this.scale = 1.0,
    this.placeholder,
    this.frameBuilder,
    this.errorBuilder,
    this.errorWidget,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.cached = CachedImage.cacheAndRead,
  }) : super(key: key);

  @override
  State<CachedMemoryImage> createState() => _CachedMemoryImageState();
}

class _CachedMemoryImageState extends State<CachedMemoryImage> {
  late final CachedImageManager? _cachedImageManager;

  @override
  void initState() {
    _cachedImageManager = CachedImageBase64Manager.instance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _cachedImage(),
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (snapshot.hasData && file != null) {
          return Image.file(
            file,
            key: widget.key,
            scale: widget.scale,
            frameBuilder: widget.frameBuilder,
            errorBuilder: _errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            width: widget.width,
            height: widget.height,
            color: widget.color,
            fit: widget.fit,
            opacity: widget.opacity,
            alignment: widget.alignment,
            colorBlendMode: widget.colorBlendMode,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            isAntiAlias: widget.isAntiAlias,
            filterQuality: widget.filterQuality,
            cacheWidth: widget.cacheWidth,
            cacheHeight: widget.cacheHeight,
          );
        }
        return widget.placeholder ?? const SizedBox();
      },
    );
  }

  Widget _errorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    // Remove invalid file from cache and display error widget.
    return FutureBuilder<bool>(
      future: _cachedImageManager?.removeFile(widget.uniqueKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (widget.errorWidget != null) {
            return widget.errorWidget!;
          } else if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, error, stackTrace);
          }
        }
        return const SizedBox();
      },
    );
  }

  Future<File?> _cachedImage() async {
    if (widget.cached == CachedImage.cacheAndRead) {
      if (widget.base64 != null) {
        return _cachedImageManager?.cacheBase64(
          widget.uniqueKey,
          widget.base64!,
        );
      } else if (widget.bytes != null) {
        return _cachedImageManager?.cacheBytes(
          widget.uniqueKey,
          widget.bytes!,
        );
      }
    } else if (widget.cached == CachedImage.readOnly) {
      return _cachedImageManager?.cacheFile(widget.uniqueKey);
    }
    return null;
  }
}
