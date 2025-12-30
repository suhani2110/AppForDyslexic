import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../scan/camera_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // ---------- APP BAR ----------
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Dyslexia App",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _authButton("Login", Colors.blue),
                const SizedBox(width: 8),
                _authButton("Sign Up", Colors.purple),
              ],
            ),
          )
        ],
      ),

      // ---------- BODY ----------
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu_book_rounded,
                  size: 64,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  "My Notebook",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ),

      // ---------- FOOTER ----------
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF2F80ED),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CameraPage()),
              );
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 32,
                color: Color(0xFF2F80ED),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- AUTH BUTTON ----------
  Widget _authButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
