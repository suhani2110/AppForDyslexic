import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ManualCropPage extends StatefulWidget {
  final File image;

  const ManualCropPage({super.key, required this.image});

  @override
  State<ManualCropPage> createState() => _ManualCropPageState();
}

class _ManualCropPageState extends State<ManualCropPage> {
  late ui.Image _uiImage;
  bool _loaded = false;

  Rect cropRect = const Rect.fromLTWH(60, 180, 260, 160);

  double scaleX = 1.0;
  double scaleY = 1.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final data = await widget.image.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();

    _uiImage = frame.image;
    setState(() => _loaded = true);
  }

  void _resize(Offset delta, Alignment alignment) {
    setState(() {
      switch (alignment) {
        case Alignment.topLeft:
          cropRect = Rect.fromLTRB(
            cropRect.left + delta.dx,
            cropRect.top + delta.dy,
            cropRect.right,
            cropRect.bottom,
          );
          break;
        case Alignment.topRight:
          cropRect = Rect.fromLTRB(
            cropRect.left,
            cropRect.top + delta.dy,
            cropRect.right + delta.dx,
            cropRect.bottom,
          );
          break;
        case Alignment.bottomLeft:
          cropRect = Rect.fromLTRB(
            cropRect.left + delta.dx,
            cropRect.top,
            cropRect.right,
            cropRect.bottom + delta.dy,
          );
          break;
        case Alignment.bottomRight:
          cropRect = Rect.fromLTRB(
            cropRect.left,
            cropRect.top,
            cropRect.right + delta.dx,
            cropRect.bottom + delta.dy,
          );
          break;
      }
    });
  }

  Future<File> _cropImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final scaled = Rect.fromLTWH(
      cropRect.left * scaleX,
      cropRect.top * scaleY,
      cropRect.width * scaleX,
      cropRect.height * scaleY,
    );

    canvas.drawImageRect(
      _uiImage,
      scaled,
      Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
      Paint(),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );

    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final file = File('${widget.image.path}_crop.png');
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    return file;
  }

  Widget _cornerHandle(Alignment a) {
    return Align(
      alignment: a,
      child: GestureDetector(
        onPanUpdate: (d) => _resize(d.delta, a),
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('MANUAL CROP (NEW)'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          scaleX = _uiImage.width / constraints.maxWidth;
          scaleY = _uiImage.height / constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.file(widget.image, fit: BoxFit.contain),
              ),

              // Crop box
              Positioned(
                left: cropRect.left,
                top: cropRect.top,
                child: GestureDetector(
                  onPanUpdate: (d) =>
                      setState(() => cropRect = cropRect.shift(d.delta)),
                  child: Container(
                    width: cropRect.width,
                    height: cropRect.height,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3),
                      color: Colors.green.withOpacity(0.15),
                    ),
                    child: Stack(
                      children: [
                        _cornerHandle(Alignment.topLeft),
                        _cornerHandle(Alignment.topRight),
                        _cornerHandle(Alignment.bottomLeft),
                        _cornerHandle(Alignment.bottomRight),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () async {
            final cropped = await _cropImage();
            if (!mounted) return;
            Navigator.pop(context, cropped);
          },
          child: const Text('Crop & Continue'),
        ),
      ),
    );
  }
}
