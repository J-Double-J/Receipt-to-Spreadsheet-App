import 'dart:ui';

import 'package:flutter/services.dart';

class ImageDimensions {
  int width;
  int height;

  ImageDimensions({required this.width, required this.height});

  static Future<ImageDimensions> imageDimensionsFromAsset(String path) async {
    final byteData = await rootBundle.load(path);
    final bytes = byteData.buffer.asUint8List();
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ImageDescriptor.encoded(buffer);

    ImageDimensions imageDimensions =
        ImageDimensions(width: descriptor.width, height: descriptor.height);
    descriptor.dispose();
    buffer.dispose();

    return imageDimensions;
  }
}
