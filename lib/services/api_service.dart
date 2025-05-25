import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://illusion-note-api.vercel.app';
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 토큰이 필요한 경우 헤더에 추가
          final token = await _getToken();
          print('token: $token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // 에러 로깅
          print('API Error: ${error.message}');
          if (error.response?.statusCode == 401) {
            // 토큰 만료 처리
            _handleTokenExpired();
          }
          handler.next(error);
        },
      ),
    );
  }
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  void _handleTokenExpired() {
    // 토큰 만료 시 처리 로직
    _removeToken();
    // 로그인 페이지로 리다이렉트 등의 처리
  }
  
  // GET 요청
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }
  
  // POST 요청
  Future<Response> post(String path, {dynamic data, bool requireAuth = true}) async {
    try {
      final options = Options();
      if (!requireAuth) {
        // 인증이 필요없는 요청의 경우 Authorization 헤더 제거
        options.headers = {'Authorization': null};
      }
      return await _dio.post(path, data: data, options: options);
    } catch (e) {
      rethrow;
    }
  }
  
  // PUT 요청
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  // DELETE 요청
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }
  
  // PATCH 요청
  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
} 