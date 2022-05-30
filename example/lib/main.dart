import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:cached_memory_image_example/image_data.dart';
import 'package:flutter/material.dart';

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
              child: CachedMemoryImage(
                uniqueKey: 'app://image/1',
                errorWidget: const Text('Error'),
                base64: ImageData.base64,
                placeholder: const CircularProgressIndicator(),
              ),
            ),
            Card(
              child: CachedMemoryImage(
                uniqueKey: 'app://image/4',
                errorWidget: const Text('Error'),
                bytes: ImageData.bytes,
                placeholder: const CircularProgressIndicator(),
              ),
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedMemoryImageProvider(
                        'app://image/5',
                        bytes: ImageData.bytes,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedMemoryImageProvider(
                        'app://image/6',
                        base64: ImageData.base64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
