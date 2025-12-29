import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';

class CanvasToImage {
  static Future<Uint8List> capture(GlobalKey key) async {
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
