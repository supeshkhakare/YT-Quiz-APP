import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SignInProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscureText = true;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscureText => _obscureText;

  // Update email
  void updateEmail(String value) {
    _email = value.trim();
    notifyListeners();
  }

  // Update password
  void updatePassword(String value) {
    _password = value.trim();
    notifyListeners();
  }

  // Toggle password visibility
  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // SignIn function
  Future<User?> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _isLoading = false;
      notifyListeners();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = "User does not exist. Please register first.";
      } else if (e.code == 'wrong-password') {
        _errorMessage = "Incorrect password. Try again.";
      } else if (e.code == 'invalid-email') {
        _errorMessage = "Invalid email address.";
      } else {
        _errorMessage = "Login failed: ${e.message}";
      }

      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
