import 'package:flutter/material.dart';
import '../../emotion/providers/emotion_provider.dart';
import '../../../core/models/emotion_analysis_model.dart';
import '../../../services/service_locator.dart';

// 주간 통계 모델
class WeeklyStats {
  final int totalEntries;
  final int changeFromLastWeek;
  final String mostCommonEmotion;
  final int mostCommonEmotionCount;
  final double averageScore;
  final int streak;

  WeeklyStats({
    required this.totalEntries,
    required this.changeFromLastWeek,
    required this.mostCommonEmotion,
    required this.mostCommonEmotionCount,
    required this.averageScore,
    required this.streak,
  });
}

class HistoryProvider extends ChangeNotifier {
  List<EmotionPost> _emotionPosts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String? _errorMessage;
  int _currentPage = 0;
  static const int _pageSize = 10;

  List<EmotionPost> get emotionPosts => _emotionPosts;
  List<EmotionEntry> get recentEntries => []; // 호환성을 위해 유지
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
  String? get errorMessage => _errorMessage;

  // 주간 통계 getter 추가
  WeeklyStats get weeklyStats {
    final stats = getWeeklyStats();
    return WeeklyStats(
      totalEntries: stats['total'] as int,
      changeFromLastWeek: stats['changeFromLastWeek'] as int? ?? 0,
      mostCommonEmotion: stats['mostCommonEmotion'] as String? ?? '',
      mostCommonEmotionCount: stats['mostCommonEmotionCount'] as int? ?? 0,
      averageScore: (stats['avgScore'] as String).isEmpty ? 0.0 : double.tryParse(stats['avgScore'] as String) ?? 0.0,
      streak: stats['streak'] as int,
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // 최근 기록들 로드 (첫 페이지)
  Future<void> loadRecentEntries() async {
    try {
      _setLoading(true);
      _setError(null);
      _currentPage = 0;
      _hasMoreData = true;

      print('=== 첫 페이지 감정 기록 로드 ===');
      final recentEmotions = await services.emotionService.getRecentEmotions(count: _pageSize);
      
      _emotionPosts = recentEmotions.posts;
      _hasMoreData = recentEmotions.posts.length >= _pageSize;
      
      print('로드된 기록 수: ${_emotionPosts.length}');
      print('더 많은 데이터 있음: $_hasMoreData');
      print('============================');
      
      _setLoading(false);
    } catch (e) {
      print('최근 기록 로드 실패: $e');
      _setError('최근 기록 로드에 실패했습니다: ${e.toString()}');
      _setLoading(false);
    }
  }

  // 더 많은 기록들 로드 (다음 페이지)
  Future<void> loadMoreEntries() async {
    if (_isLoadingMore || !_hasMoreData) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      print('=== 추가 감정 기록 로드 ===');
      print('현재 페이지: $_currentPage');
      print('현재 기록 수: ${_emotionPosts.length}');
      
      // 더 많은 데이터를 가져오기 위해 큰 수로 요청
      // 실제 서버에서는 offset/limit을 지원해야 함
      final recentEmotions = await services.emotionService.getRecentEmotions(count: 100);
      
      // 현재 가지고 있는 기록보다 더 많은 기록이 있는지 확인
      if (recentEmotions.posts.length > _emotionPosts.length) {
        // 새로운 기록들만 추가
        final newPosts = recentEmotions.posts.skip(_emotionPosts.length).take(_pageSize).toList();
        
        if (newPosts.isNotEmpty) {
          _emotionPosts.addAll(newPosts);
          _currentPage++;
        }
        
        // 더 많은 데이터가 있는지 확인
        _hasMoreData = recentEmotions.posts.length > _emotionPosts.length;
        
        print('새로 로드된 기록 수: ${newPosts.length}');
        print('총 기록 수: ${_emotionPosts.length}');
        print('서버 총 기록 수: ${recentEmotions.posts.length}');
        print('더 많은 데이터 있음: $_hasMoreData');
      } else {
        _hasMoreData = false;
        print('더 이상 로드할 데이터가 없습니다');
      }
      
      print('========================');
      
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      print('추가 기록 로드 실패: $e');
      _isLoadingMore = false;
      notifyListeners();
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
    
    for (final post in _emotionPosts) {
      counts[post.emotion] = (counts[post.emotion] ?? 0) + 1;
    }
    
    return counts;
  }

  // 주간 통계 계산 (실제 데이터 기반)
  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    final weeklyPosts = _emotionPosts.where((post) {
      return post.createdAt.isAfter(weekStart) && post.createdAt.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
    
    // 지난 주 데이터 계산
    final lastWeekStart = weekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = weekStart.subtract(const Duration(days: 1));
    final lastWeekPosts = _emotionPosts.where((post) {
      return post.createdAt.isAfter(lastWeekStart) && post.createdAt.isBefore(lastWeekEnd.add(const Duration(days: 1)));
    }).toList();
    
    // 가장 많은 감정 계산
    final emotionCounts = <String, int>{};
    for (final post in weeklyPosts) {
      emotionCounts[post.emotion] = (emotionCounts[post.emotion] ?? 0) + 1;
    }
    
    String mostCommonEmotion = '';
    int mostCommonCount = 0;
    emotionCounts.forEach((emotion, count) {
      if (count > mostCommonCount) {
        mostCommonEmotion = emotion;
        mostCommonCount = count;
      }
    });
    
    // 연속 기록 일수 계산
    int streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final hasRecord = _emotionPosts.any((post) {
        return post.createdAt.year == checkDate.year &&
               post.createdAt.month == checkDate.month &&
               post.createdAt.day == checkDate.day;
      });
      
      if (hasRecord) {
        streak++;
      } else {
        break;
      }
    }
    
    return {
      'total': weeklyPosts.length,
      'changeFromLastWeek': weeklyPosts.length - lastWeekPosts.length,
      'mostCommonEmotion': mostCommonEmotion,
      'mostCommonEmotionCount': mostCommonCount,
      'avgScore': weeklyPosts.isEmpty ? '0.0' : '4.2', // 임시 평균값
      'streak': streak,
    };
  }

  // 에러 메시지 클리어
  void clearError() {
    _setError(null);
  }
} 