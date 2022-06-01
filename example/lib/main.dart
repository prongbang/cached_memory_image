import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_memory_image/provider/cached_memory_image_placeholder_provider.dart';
import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
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
  final CachedImageManager _cachedImageManager =
      CachedImageBase64Manager.instance();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cached Memory Image'),
        ),
        body: ListView(
          children: [
            Card(
              child: Column(
                children: [
                  const Text('With Base64'),
                  CachedMemoryImage(
                    uniqueKey: 'app://image/1',
                    errorWidget: const Text('Error'),
                    base64: ImageData.base64,
                    placeholder: const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('With Bytes'),
                  CachedMemoryImage(
                    uniqueKey: 'app://image/4',
                    errorWidget: const Text('Error'),
                    bytes: ImageData.bytes,
                    placeholder: const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('With Bytes Provider'),
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      children: <Widget>[
                        const Center(child: CircularProgressIndicator()),
                        Center(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('With Base64 Provider'),
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      children: <Widget>[
                        const Center(child: CircularProgressIndicator()),
                        Center(
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
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
