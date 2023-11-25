import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_memory_image_example/card_image_widget.dart';
import 'package:cached_memory_image_example/image_data.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cached Memory Image'),
        ),
        body: ListView(
          children: [
            CardImageWidget(
              title: 'With Base64',
              child: CachedMemoryImage(
                uniqueKey: 'app://image/1',
                errorWidget: const Text('Error'),
                base64: ImageData.base64,
                placeholder: const CircularProgressIndicator(),
              ),
            ),
            CardImageWidget(
              title: 'With Bytes',
              child: CachedMemoryImage(
                uniqueKey: 'app://image/4',
                errorWidget: const Text('Error'),
                bytes: ImageData.bytes,
                placeholder: const CircularProgressIndicator(),
              ),
            ),
            CardImageWidget(
              title: 'With Bytes Provider',
              child: FadeInImage(
                placeholder: CachedMemoryImagePlaceholderProvider(
                  bytes: kTransparentImage,
                ),
                image: CachedMemoryImageProvider(
                  'app://image/5',
                  bytes: ImageData.bytes,
                ),
              ),
            ),
            CardImageWidget(
              title: 'With Base64 Provider',
              child: FadeInImage(
                placeholder: CachedMemoryImagePlaceholderProvider(
                  bytes: kTransparentImage,
                ),
                image: CachedMemoryImageProvider(
                  'app://image/6',
                  base64: ImageData.base64,
                ),
              ),
            ),
            CardImageWidget(
              title: 'With Cache Provider',
              child: FadeInImage(
                placeholder: CachedMemoryImagePlaceholderProvider(
                  bytes: kTransparentImage,
                ),
                image: CachedMemoryImageProvider(
                  'app://image/6',
                  cached: CachedImage.readOnly,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
