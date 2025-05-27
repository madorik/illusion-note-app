import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/content_model.dart';

class RecommendationProvider extends ChangeNotifier {
  final List<RecommendedContent> _recommendations = [];
  bool _isLoading = false;
  String? _error;
  List<String> _frequentEmotions = [];

  List<RecommendedContent> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get frequentEmotions => _frequentEmotions;

  // 초기화 시 더미 데이터 생성
  RecommendationProvider() {
    _loadInitialData();
  }

  // 초기 데이터 로드
  Future<void> _loadInitialData() async {
    _setLoading(true);
    try {
      // 나중에 실제 API 요청으로 대체
      await Future.delayed(const Duration(seconds: 1));
      _recommendations.addAll(_generateDummyRecommendations());
      
      // 기본 빈번 감정 설정 (나중에 실제 데이터로 대체)
      _frequentEmotions = ['슬픔', '불안', '외로움', '혼란'];
      
      _setLoading(false);
    } catch (e) {
      _setError('콘텐츠를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  // 데이터 새로고침 (public 메서드)
  Future<void> refreshData() async {
    _setLoading(true);
    try {
      // 기존 데이터 초기화
      _recommendations.clear();
      
      // 새 데이터 로딩
      await Future.delayed(const Duration(seconds: 1));
      _recommendations.addAll(_generateDummyRecommendations());
      
      // 기본 빈번 감정 설정 (나중에 실제 데이터로 대체)
      _frequentEmotions = ['슬픔', '불안', '외로움', '혼란'];
      
      _setLoading(false);
      _setError(null); // 에러 상태 초기화
    } catch (e) {
      _setError('콘텐츠를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  // 감정에 따른 추천 콘텐츠 필터링
  List<RecommendedContent> getRecommendationsByEmotion(String emotion) {
    return _recommendations
        .where((content) => content.emotions.contains(emotion))
        .toList();
  }

  // 콘텐츠 타입별 필터링
  List<RecommendedContent> getRecommendationsByType(ContentType type) {
    return _recommendations.where((content) => content.type == type).toList();
  }

  // 감정과 타입 모두로 필터링
  List<RecommendedContent> getRecommendationsByEmotionAndType(
      String emotion, ContentType type) {
    return _recommendations
        .where((content) =>
            content.emotions.contains(emotion) && content.type == type)
        .toList();
  }

  // 최근 추가된 콘텐츠
  List<RecommendedContent> getRecentRecommendations({int limit = 5}) {
    final sorted = List<RecommendedContent>.from(_recommendations)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  // 자주 느끼는 감정 업데이트
  void updateFrequentEmotions(List<String> emotions) {
    _frequentEmotions = emotions;
    notifyListeners();
  }

  // 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 오류 설정
  void _setError(String? errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  // 테스트용 더미 데이터 생성
  List<RecommendedContent> _generateDummyRecommendations() {
    return [
      // 음악 추천
      RecommendedContent(
        id: const Uuid().v4(),
        title: '마음을 안정시키는 클래식 음악',
        description: '스트레스와 불안을 줄이는 데 도움이 되는 클래식 명곡 모음입니다.',
        type: ContentType.music,
        imageUrl: 'assets/images/content/calm_music.jpg',
        audioUrl: 'https://example.com/calm_classics.mp3',
        emotions: ['불안', '스트레스', '우울', '혼란'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      RecommendedContent(
        id: const Uuid().v4(),
        title: '힐링 재즈 플레이리스트',
        description: '슬픔과 우울함을 달래주는 감성적인 재즈 음악입니다.',
        type: ContentType.music,
        imageUrl: 'assets/images/content/jazz_music.jpg',
        audioUrl: 'https://example.com/healing_jazz.mp3',
        emotions: ['슬픔', '우울', '외로움'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      
      // 명상 콘텐츠
      RecommendedContent(
        id: const Uuid().v4(),
        title: '5분 호흡 명상',
        description: '짧은 시간에 불안과 스트레스를 해소할 수 있는 호흡 명상입니다.',
        type: ContentType.meditation,
        imageUrl: 'assets/images/content/breathing.jpg',
        audioUrl: 'https://example.com/breathing_meditation.mp3',
        emotions: ['불안', '스트레스', '분노', '혼란'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RecommendedContent(
        id: const Uuid().v4(),
        title: '슬픔을 위한 자비 명상',
        description: '슬픔과 상실감을 경험할 때 도움이 되는 자비 명상입니다.',
        type: ContentType.meditation,
        imageUrl: 'assets/images/content/compassion.jpg',
        audioUrl: 'https://example.com/compassion_meditation.mp3',
        emotions: ['슬픔', '우울', '상실', '외로움'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      
      // 명언/글귀
      RecommendedContent(
        id: const Uuid().v4(),
        title: '어두운 밤이 지나면 새벽이 옵니다',
        description: '힘든 시간을 이겨내는 데 도움이 되는 희망적인 명언입니다.',
        type: ContentType.quote,
        imageUrl: 'assets/images/content/dawn_quote.jpg',
        emotions: ['슬픔', '절망', '우울', '좌절'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RecommendedContent(
        id: const Uuid().v4(),
        title: '불안은 내일의 슬픔을 미리 빌리는 것입니다',
        description: '불안과 걱정을 다루는 데 도움이 되는 명언입니다.',
        type: ContentType.quote,
        imageUrl: 'assets/images/content/anxiety_quote.jpg',
        emotions: ['불안', '걱정', '혼란'],
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      
      // 심리 팁
      RecommendedContent(
        id: const Uuid().v4(),
        title: '불안을 완화하는 3가지 인지행동 기법',
        description: '불안한 순간에 즉시 적용할 수 있는 실용적인 심리 기법입니다.',
        type: ContentType.tip,
        imageUrl: 'assets/images/content/cbt_tip.jpg',
        link: 'https://example.com/anxiety_cbt_techniques',
        emotions: ['불안', '공포', '스트레스'],
        createdAt: DateTime.now(),
      ),
      RecommendedContent(
        id: const Uuid().v4(),
        title: '우울함을 이겨내는 5가지 일상 습관',
        description: '우울한 기분을 개선하는 데 도움이 되는 일상 습관들입니다.',
        type: ContentType.tip,
        imageUrl: 'assets/images/content/habits_tip.jpg',
        link: 'https://example.com/depression_daily_habits',
        emotions: ['우울', '슬픔', '무기력', '외로움'],
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  // 새 콘텐츠 추가 (관리자 기능)
  void addContent(RecommendedContent content) {
    _recommendations.add(content);
    notifyListeners();
  }

  // 콘텐츠 삭제 (관리자 기능)
  void removeContent(String id) {
    _recommendations.removeWhere((content) => content.id == id);
    notifyListeners();
  }
} 