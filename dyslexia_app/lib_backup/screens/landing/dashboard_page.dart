import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_page.dart';
import '../scan/camera_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = AuthService.currentUser?.email;
  }

  Future<void> _loginOrSignup({required bool isSignup}) async {
    // TEMP credentials (safe for hackathon demo)
    final email = "demo${DateTime.now().millisecondsSinceEpoch}@mail.com";
    const password = "password123";

    try {
      if (isSignup) {
        await AuthService.signUp(email, password);
      } else {
        await AuthService.login(email, password);
      }

      setState(() {
        userEmail = AuthService.currentUser?.email;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $email")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    setState(() {
      userEmail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // ---------- APP BAR ----------
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Dyslexia App",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: userEmail == null
                ? Row(
                    children: [
                      _authButton(
                        "Login",
                        Colors.blue,
                        () => _loginOrSignup(isSignup: false),
                      ),
                      const SizedBox(width: 8),
                      _authButton(
                        "Sign Up",
                        Colors.purple,
                        () => _loginOrSignup(isSignup: true),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Text(
                        "Hi 👋",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _authButton(
                        "Logout",
                        Colors.red,
                        _logout,
                      ),
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
              MaterialPageRoute(builder: (_) => const HomePage()),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
  Widget _authButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
