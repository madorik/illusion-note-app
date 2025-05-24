// Firebase가 비활성화된 동안 주석 처리
/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      _user = userCredential.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('구글 로그인에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Email/Password Sign In
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      
      _user = userCredential.user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = '등록되지 않은 이메일입니다.';
          break;
        case 'wrong-password':
          errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          errorMessage = '이메일 형식이 올바르지 않습니다.';
          break;
        default:
          errorMessage = '로그인에 실패했습니다: ${e.message}';
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('로그인에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Email/Password Sign Up
  Future<bool> createUserWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      _setLoading(true);
      _setError(null);

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      
      // Set display name
      await userCredential.user?.updateDisplayName(displayName);
      
      _user = userCredential.user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다.';
          break;
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          errorMessage = '이메일 형식이 올바르지 않습니다.';
          break;
        default:
          errorMessage = '회원가입에 실패했습니다: ${e.message}';
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('회원가입에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError('로그아웃에 실패했습니다: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Clear error
  void clearError() {
    _setError(null);
  }
}
*/

// Firebase 비활성화 중에는 MockAuthProvider를 사용하세요. 