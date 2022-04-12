import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cached Memory Image'),
        ),
        body: Row(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedMemoryImage(
                    uniqueKey: 'app://image/1',
                    base64: ImageData.base64,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedMemoryImage(
                    uniqueKey: 'app://image/2',
                    bytes: Uint8List.fromList([1, 2, 3, 4, 5]),
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
