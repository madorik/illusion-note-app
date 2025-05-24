import 'package:flutter/material.dart';

class MockUser {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  MockUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
  });
}

class MockAuthProvider extends ChangeNotifier {
  MockUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  MockUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Google Sign In (Mock)
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      // 임시 지연을 통해 로딩 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));

      _user = MockUser(
        uid: 'mock_google_user_id',
        displayName: '김사용자',
        email: 'user@example.com',
        photoURL: null,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('구글 로그인에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Email/Password Sign In (Mock)
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);

      await Future.delayed(const Duration(seconds: 1));

      // 간단한 검증
      if (email.isEmpty || password.isEmpty) {
        throw Exception('이메일과 비밀번호를 입력해주세요.');
      }

      if (!email.contains('@')) {
        throw Exception('올바른 이메일 형식이 아닙니다.');
      }

      if (password.length < 6) {
        throw Exception('비밀번호는 6자 이상이어야 합니다.');
      }

      _user = MockUser(
        uid: 'mock_email_user_id',
        displayName: email.split('@')[0],
        email: email,
        photoURL: null,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Email/Password Sign Up (Mock)
  Future<bool> createUserWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      _setLoading(true);
      _setError(null);

      await Future.delayed(const Duration(seconds: 1));

      // 간단한 검증
      if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
        throw Exception('모든 필드를 입력해주세요.');
      }

      if (!email.contains('@')) {
        throw Exception('올바른 이메일 형식이 아닙니다.');
      }

      if (password.length < 6) {
        throw Exception('비밀번호는 6자 이상이어야 합니다.');
      }

      _user = MockUser(
        uid: 'mock_new_user_id',
        displayName: displayName,
        email: email,
        photoURL: null,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign Out (Mock)
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await Future.delayed(const Duration(milliseconds: 500));
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