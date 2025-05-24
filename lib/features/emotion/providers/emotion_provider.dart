import 'package:flutter/material.dart';
import '../models/emotion_analysis.dart';
// import '../../../services/openai_service.dart';

class EmotionEntry {
  final String id;
  final String emotion;
  final String? title;
  final String? content;
  final DateTime createdAt;
  final double? score;

  EmotionEntry({
    required this.id,
    required this.emotion,
    this.title,
    this.content,
    required this.createdAt,
    this.score,
  });
}

class EmotionProvider extends ChangeNotifier {
  // final OpenAIService _openAIService = OpenAIService();
  
  List<EmotionEntry> _entries = [];
  bool _isLoading = false;
  String? _errorMessage;
  EmotionAnalysis? _currentAnalysis;

  List<EmotionEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  EmotionAnalysis? get currentAnalysis => _currentAnalysis;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // 오늘의 감정 엔트리들 가져오기
  List<EmotionEntry> getTodayEntries() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return _entries.where((entry) {
      return entry.createdAt.isAfter(startOfDay) && 
             entry.createdAt.isBefore(endOfDay);
    }).toList();
  }

  // 감정 엔트리 추가
  Future<bool> addEmotionEntry({
    required String emotion,
    String? title,
    String? content,
    double? score,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final entry = EmotionEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        emotion: emotion,
        title: title,
        content: content,
        createdAt: DateTime.now(),
        score: score,
      );

      _entries.insert(0, entry);
      _setLoading(false);
      
      // TODO: Firebase Firestore에 저장
      
      return true;
    } catch (e) {
      _setError('감정 기록 저장에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // 감정 엔트리 삭제
  Future<bool> deleteEmotionEntry(String id) async {
    try {
      _setLoading(true);
      _setError(null);

      _entries.removeWhere((entry) => entry.id == id);
      _setLoading(false);
      
      // TODO: Firebase Firestore에서 삭제
      
      return true;
    } catch (e) {
      _setError('감정 기록 삭제에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // 감정 엔트리 업데이트
  Future<bool> updateEmotionEntry({
    required String id,
    String? emotion,
    String? title,
    String? content,
    double? score,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final index = _entries.indexWhere((entry) => entry.id == id);
      if (index == -1) {
        throw Exception('감정 기록을 찾을 수 없습니다.');
      }

      final oldEntry = _entries[index];
      final updatedEntry = EmotionEntry(
        id: oldEntry.id,
        emotion: emotion ?? oldEntry.emotion,
        title: title ?? oldEntry.title,
        content: content ?? oldEntry.content,
        createdAt: oldEntry.createdAt,
        score: score ?? oldEntry.score,
      );

      _entries[index] = updatedEntry;
      _setLoading(false);
      
      // TODO: Firebase Firestore에서 업데이트
      
      return true;
    } catch (e) {
      _setError('감정 기록 수정에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // 사용자의 감정 기록 로드
  Future<void> loadEmotionEntries() async {
    try {
      _setLoading(true);
      _setError(null);

      // TODO: Firebase Firestore에서 사용자의 감정 기록 로드
      // 임시로 빈 리스트로 설정
      await Future.delayed(const Duration(milliseconds: 500));
      
      _entries = [];
      _setLoading(false);
    } catch (e) {
      _setError('감정 기록 로드에 실패했습니다: ${e.toString()}');
      _setLoading(false);
    }
  }

  // 주간 통계 가져오기
  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    final weekEntries = _entries.where((entry) {
      return entry.createdAt.isAfter(startOfWeek) && 
             entry.createdAt.isBefore(endOfWeek);
    }).toList();

    final totalEntries = weekEntries.length;
    final avgScore = weekEntries.isNotEmpty
        ? weekEntries
            .where((e) => e.score != null)
            .map((e) => e.score!)
            .fold(0.0, (a, b) => a + b) / weekEntries.length
        : 0.0;

    // 연속 기록 일수 계산 (간단한 버전)
    final streak = _calculateStreak();

    return {
      'total': totalEntries,
      'avgScore': avgScore.toStringAsFixed(1),
      'streak': streak,
    };
  }

  int _calculateStreak() {
    if (_entries.isEmpty) return 0;

    final sortedEntries = List<EmotionEntry>.from(_entries)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    int streak = 0;
    DateTime? lastDate;

    for (final entry in sortedEntries) {
      final entryDate = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );

      if (lastDate == null) {
        lastDate = entryDate;
        streak = 1;
      } else {
        final daysDifference = lastDate.difference(entryDate).inDays;
        if (daysDifference == 1) {
          streak++;
          lastDate = entryDate;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  // 감정 분석 수행
  Future<EmotionAnalysis?> analyzeEmotion(String emotionText) async {
    try {
      _setLoading(true);
      _setError(null);

      // final analysis = await _openAIService.analyzeEmotion(emotionText);
      // _currentAnalysis = analysis;
      
      _setLoading(false);
      return null;
    } catch (e) {
      _setError('감정 분석에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      
      // 오프라인 대체 분석 제공
      _currentAnalysis = _generateFallbackAnalysis(emotionText);
      return _currentAnalysis;
    }
  }

  // 오프라인 대체 분석
  EmotionAnalysis _generateFallbackAnalysis(String emotionText) {
    return EmotionAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalText: emotionText,
      emotionScore: _calculateBasicEmotionScore(emotionText),
      cognitiveDistortions: _detectBasicDistortions(emotionText),
      alternativeThoughts: _generateBasicAlternatives(emotionText),
      recommendations: _generateBasicRecommendations(),
      managementTips: [
        '깊게 숨을 쉬고 잠시 휴식을 취해보세요.',
        '현재 상황을 객관적으로 바라보려 노력해보세요.',
        '감정일기를 써보는 것도 도움이 됩니다.',
      ],
      createdAt: DateTime.now(),
    );
  }

  double _calculateBasicEmotionScore(String text) {
    // 간단한 감정 점수 계산
    final negativeWords = ['힘들다', '우울', '슬프다', '화나다', '짜증', '스트레스'];
    final positiveWords = ['기쁘다', '행복', '즐겁다', '만족', '좋다'];
    
    int negativeCount = 0;
    int positiveCount = 0;
    
    for (String word in negativeWords) {
      if (text.contains(word)) negativeCount++;
    }
    
    for (String word in positiveWords) {
      if (text.contains(word)) positiveCount++;
    }
    
    if (negativeCount > positiveCount) {
      return 0.3; // 부정적
    } else if (positiveCount > negativeCount) {
      return 0.8; // 긍정적
    } else {
      return 0.5; // 중립
    }
  }

  List<String> _detectBasicDistortions(String text) {
    List<String> distortions = [];
    
    if (text.contains('항상') || text.contains('절대') || text.contains('모든')) {
      distortions.add('전부 아니면 전무 사고');
    }
    
    if (text.contains('안 될') || text.contains('실패') || text.contains('망했다')) {
      distortions.add('파국적 사고');
    }
    
    if (text.contains('내 탓') || text.contains('내가 잘못')) {
      distortions.add('자기 비난');
    }
    
    return distortions;
  }

  List<String> _generateBasicAlternatives(String text) {
    return [
      '이 상황이 영원히 지속되지는 않을 것입니다.',
      '완벽하지 않더라도 괜찮습니다.',
      '실수는 배움의 기회가 될 수 있습니다.',
      '다른 관점에서 생각해볼 여지가 있습니다.',
    ];
  }

  List<String> _generateBasicRecommendations() {
    return [
      '규칙적인 운동으로 스트레스를 해소해보세요.',
      '충분한 수면을 취하세요.',
      '신뢰할 수 있는 사람과 대화해보세요.',
      '명상이나 요가를 시도해보세요.',
      '취미 활동에 시간을 투자해보세요.',
    ];
  }

  // 에러 메시지 초기화
  void clearError() {
    _setError(null);
  }

  // 현재 분석 초기화
  void clearCurrentAnalysis() {
    _currentAnalysis = null;
    notifyListeners();
  }

  // 예시: void saveEmotion({ ... }) => addEmotionEntry(...);
  // 또는 실제 저장 로직을 saveEmotion으로 래핑

  Future<bool> saveEmotion({
    required String emotion,
    String? title,
    String? content,
    double? score,
  }) async {
    return await addEmotionEntry(
      emotion: emotion,
      title: title,
      content: content,
      score: score,
    );
  }
} 