import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/ocr_service.dart';
import 'scan_result_page.dart';
import 'manual_crop_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isProcessing = false;

  Future<void> _captureImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _onNextPressed() async {
    if (_image == null) return;

    // 🔹 Step 1: Go to manual crop page
    final File? cropped = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (_) => ManualCropPage(image: _image!),
      ),
    );

    if (cropped == null) return;

    // 🔹 Step 2: OCR
    setState(() => _isProcessing = true);

    final ocrService = OcrService();
    final extractedText = await ocrService.extractText(cropped);

    setState(() => _isProcessing = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScanResultPage(text: extractedText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Page")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _image == null
                  ? const Text("Capture or upload a text image")
                  : Image.file(_image!),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _captureImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
              ),
              ElevatedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text("Gallery"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed:
                (_image == null || _isProcessing) ? null : _onNextPressed,
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Next"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
