import 'api_service.dart';
import 'auth_service.dart';
import 'note_service.dart';
import 'emotion_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // 서비스 인스턴스들
  late final ApiService _apiService;
  late final AuthService _authService;
  late final NoteService _noteService;
  late final EmotionService _emotionService;

  // 초기화
  void init() {
    _apiService = ApiService();
    _authService = AuthService();
    _noteService = NoteService();
    _emotionService = EmotionService();
  }

  // 서비스 접근자들
  ApiService get apiService => _apiService;
  AuthService get authService => _authService;
  NoteService get noteService => _noteService;
  EmotionService get emotionService => _emotionService;
}

// 전역 접근을 위한 getter
ServiceLocator get services => ServiceLocator(); 