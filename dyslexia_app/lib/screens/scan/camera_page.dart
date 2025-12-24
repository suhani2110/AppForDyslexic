import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/ocr_service.dart';
import 'scan_result_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isProcessing = false;

  // ---------- Capture from camera ----------
  Future<void> _captureImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  // ---------- Pick from gallery ----------
  Future<void> _pickFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  // ---------- OCR + safe navigation ----------
  Future<void> _onNextPressed() async {
    if (_image == null) return;

    setState(() {
      _isProcessing = true;
    });

    final ocrService = OcrService();
    final extractedText = await ocrService.extractText(_image!);

    setState(() {
      _isProcessing = false;
    });

    // ✅ SAFE navigation after frame layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ScanResultPage(text: extractedText),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Page"),
      ),
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

          // ---------- Buttons ----------
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
