import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/user_model.dart';
import '../core/models/google_auth_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // 구글 로그인 (ID Token으로 서버 인증)
  Future<GoogleLoginResponse> googleLogin(String idToken) async {
    try {
      final request = GoogleLoginRequest(idToken: idToken);
      final response = await _apiService.post('/api/token-auth/google-login', 
          data: request.toJson(), requireAuth: false);
      
      print('=== 구글 로그인 API 응답 ===');
      print('Response: ${response.data}');
      print('========================');
      
      if (response.data != null) {
        final googleLoginResponse = GoogleLoginResponse.fromJson(response.data);
        
        // 서버에서 받은 액세스 토큰 저장
        await _saveToken(googleLoginResponse.accessToken);
        await _saveRefreshToken(googleLoginResponse.refreshToken);
        
        print('=== 서버 인증 토큰 저장 완료 ===');
        print('Access Token: ${googleLoginResponse.accessToken}');
        print('Refresh Token: ${googleLoginResponse.refreshToken}');
        print('User: ${googleLoginResponse.user}');
        print('==============================');
        
        return googleLoginResponse;
      } else {
        throw Exception('서버 응답이 비어있습니다');
      }
    } catch (e) {
      print('구글 로그인 API 오류: $e');
      throw Exception('구글 로그인 실패: $e');
    }
  }

  // 로그인
  Future<AuthResponse> login(String email, String password) async {
    try {
      final request = AuthRequest(email: email, password: password);
      final response = await _apiService.post('/api/auth/login', data: request.toJson());
      
      if (response.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        await _saveToken(authResponse.token);
        if (authResponse.refreshToken != null) {
          await _saveRefreshToken(authResponse.refreshToken!);
        }
        return authResponse;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // 회원가입
  Future<AuthResponse> register(String email, String password, {String? name}) async {
    try {
      final request = RegisterRequest(email: email, password: password, name: name);
      final response = await _apiService.post('/api/auth/register', data: request.toJson());
      
      if (response.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        await _saveToken(authResponse.token);
        if (authResponse.refreshToken != null) {
          await _saveRefreshToken(authResponse.refreshToken!);
        }
        return authResponse;
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // 로그아웃
  Future<bool> logout() async {
    try {
      final response = await _apiService.post('/api/auth/logout');
      
      // 로컬 토큰 삭제
      await _removeToken();
      await _removeRefreshToken();
      
      return response.data['success'] == true;
    } catch (e) {
      // 서버 요청이 실패해도 로컬 토큰은 삭제
      await _removeToken();
      await _removeRefreshToken();
      return true;
    }
  }

  // 토큰 갱신
  Future<String?> refreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return null;

      final response = await _apiService.post('/api/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      
      if (response.data['success'] == true) {
        final newToken = response.data['data']['token'];
        await _saveToken(newToken);
        return newToken;
      } else {
        throw Exception(response.data['message'] ?? 'Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  // 현재 사용자 정보 조회
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get('/api/auth/me');
      
      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch user info');
      }
    } catch (e) {
      throw Exception('Failed to fetch user info: $e');
    }
  }

  // 사용자 정보 업데이트
  Future<User> updateUser(User user) async {
    try {
      final response = await _apiService.put('/api/auth/me', data: user.toJson());
      
      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // 비밀번호 변경
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await _apiService.put('/api/auth/password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      
      return response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // 비밀번호 재설정 요청
  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await _apiService.post('/api/auth/password/reset', data: {
        'email': email,
      });
      
      return response.data['success'] == true;
    } catch (e) {
      throw Exception('Failed to request password reset: $e');
    }
  }

  // 계정 삭제
  Future<bool> deleteAccount() async {
    try {
      final response = await _apiService.delete('/api/auth/me');
      
      if (response.data['success'] == true) {
        await _removeToken();
        await _removeRefreshToken();
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete account');
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  // 토큰 저장/조회/삭제 메서드들
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> _saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> _removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');
  }
} 