# cached_memory_image

[![pub package](https://img.shields.io/pub/v/cached_memory_image.svg)](https://pub.dartlang.org/packages/cached_memory_image)

A Flutter library to show images from the Base64, Uint8List and keep them in the cache directory.

## Features

#### Check file is exists

```dart
final cachedImageManager = CachedImageBase64Manager.instance();

await cachedImageManager?.isExists('app://image/1');
await cachedImageManager?.removeFile('app://image/1');
```

#### Cached Image from Base64

- Widget

```dart
CachedMemoryImage(
  uniqueKey: 'app://image/1',
  base64: 'iVBORw0KGgoAAAANSUhEUgAAAk0AAAFwCAYAAACl9k...',
),
```

- Image Provider

```dart
CachedMemoryImageProvider(
  'app://image/6',
  base64: 'iVBORw0KGgoAAAANSUhEUgAAAk0AAAFwCAYAAACl9k...',
)
```

#### Cached Image from Uint8List

- Widget

```dart
CachedMemoryImage(
  uniqueKey: 'app://image/1',
  bytes: Uint8List.fromList([1,2,3,4,5]),
)
```

- Image Provider

```dart
CachedMemoryImageProvider(
  'app://image/5',
  bytes: Uint8List.fromList([1,2,3,4,5]),
)
```

## Getting started

It is really easy to use! You should ensure that you add the `cached_memory_image` as a dependency in your flutter project.

```yaml
cached_memory_image: ^1.5.0
```

## Usage

- Cached image from Base64 and Display

```dart
Padding(
  padding: const EdgeInsets.all(8.0),
  child: CachedMemoryImage(
    uniqueKey: 'app://image/1',
    base64: 'iVBORw0KGgoAAAANSUhEUgAAAk0AAAFwCAYAAACl9k...',
  ),
)
```

- Cached image from Uint8List and Display

```dart
Padding(
  padding: const EdgeInsets.all(8.0),
  child: CachedMemoryImage(
    uniqueKey: 'app://image/1',
    bytes: Uint8List.fromList([1,2,3,4,5]),
  ),
)
```

## How it works

The cached memory images stores and retrieves files using the [flutter_cache_manager](https://pub.dartlang.org/packages/flutter_cache_manager).
