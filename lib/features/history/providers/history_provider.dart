import 'package:flutter/material.dart';
import '../../emotion/providers/emotion_provider.dart';

class HistoryProvider extends ChangeNotifier {
  List<EmotionEntry> _recentEntries = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EmotionEntry> get recentEntries => _recentEntries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // 최근 기록들 로드
  Future<void> loadRecentEntries() async {
    try {
      _setLoading(true);
      _setError(null);

      // TODO: Firebase Firestore에서 최근 기록들 로드
      // 임시로 빈 리스트로 설정
      await Future.delayed(const Duration(milliseconds: 500));
      
      _recentEntries = [];
      _setLoading(false);
    } catch (e) {
      _setError('최근 기록 로드에 실패했습니다: ${e.toString()}');
      _setLoading(false);
    }
  }

  // 모든 기록들 로드
  Future<List<EmotionEntry>> loadAllEntries() async {
    try {
      _setLoading(true);
      _setError(null);

      // TODO: Firebase Firestore에서 모든 기록들 로드
      await Future.delayed(const Duration(milliseconds: 500));
      
      _setLoading(false);
      return [];
    } catch (e) {
      _setError('기록 로드에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return [];
    }
  }

  // 주간 통계 가져오기
  Map<String, dynamic> getWeeklyStats() {
    // TODO: 실제 통계 계산 로직 구현
    return {
      'total': 0,
      'avgScore': '0.0',
      'streak': 0,
    };
  }

  // 월별 통계 가져오기
  Map<String, dynamic> getMonthlyStats() {
    // TODO: 월별 통계 계산 로직 구현
    return {
      'total': 0,
      'avgScore': '0.0',
      'mostCommonEmotion': 'neutral',
    };
  }

  // 특정 기간의 기록들 가져오기
  Future<List<EmotionEntry>> getEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      // TODO: Firebase Firestore에서 특정 기간의 기록들 로드
      await Future.delayed(const Duration(milliseconds: 500));
      
      _setLoading(false);
      return [];
    } catch (e) {
      _setError('기록 로드에 실패했습니다: ${e.toString()}');
      _setLoading(false);
      return [];
    }
  }

  // 감정별 기록 개수 가져오기
  Map<String, int> getEmotionCounts() {
    final counts = <String, int>{};
    
    for (final entry in _recentEntries) {
      counts[entry.emotion] = (counts[entry.emotion] ?? 0) + 1;
    }
    
    return counts;
  }

  // 에러 메시지 클리어
  void clearError() {
    _setError(null);
  }
} 