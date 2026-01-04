import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropPage extends StatelessWidget {
  final File image;

  const ImageCropPage({super.key, required this.image});

  Future<void> _crop(BuildContext context) async {
    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: image.path,

      // 🔴 THESE SETTINGS ARE CRITICAL
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: false,
          showCropGrid: true,
          initAspectRatio: CropAspectRatioPreset.original,
          cropFrameColor: Colors.white,
          cropGridColor: Colors.white,
        ),
      ],
    );

    // 🚨 USER PRESSED BACK / CROP FAILED
    if (cropped == null) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context, File(cropped.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crop Image")),
      body: Column(
        children: [
          Expanded(
            child: Image.file(image, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _crop(context),
              child: const Text("Crop & Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
