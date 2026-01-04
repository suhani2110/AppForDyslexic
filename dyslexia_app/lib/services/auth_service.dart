class AuthService {
  static String? _currentUserEmail;

  static String? get currentUser => _currentUserEmail;

  static Future<String?> signUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserEmail = email;
    return _currentUserEmail;
  }

  static Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserEmail = email;
    return _currentUserEmail;
  }

  static Future<void> logout() async {
    _currentUserEmail = null;
  }
}
