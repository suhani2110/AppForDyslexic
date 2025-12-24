import 'package:flutter/material.dart';
import '../scan/camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App For Dyslexic'),
        actions: [
          TextButton(
            onPressed: () {
              // Login / Signup later
            },
            child: const Text(
              'Login / Signup',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'My Notebook',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 40),
          IconButton(
            iconSize: 72,
            icon: const Icon(Icons.camera_alt),
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CameraPage()),
  );
},
          ),
        ],
      ),
    );
  }
}

