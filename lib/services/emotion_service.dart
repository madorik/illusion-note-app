import 'package:dio/dio.dart';
import '../core/models/emotion_model.dart';
import '../core/models/emotion_analysis_model.dart';
import '../core/utils/time_utils.dart';
import 'api_service.dart';

class EmotionService {
  final ApiService _apiService = ApiService();

  // OpenAI 감정 분석 (새로운 API)
  Future<EmotionAnalysisResponse> analyzeEmotionOpenAI({
    required String text,
    String? moodId,
    String mode = 'chat',
    String responseType = 'comfort',
    String? context,
  }) async {
    try {
      final request = EmotionAnalysisRequest(
        text: text,
        moodId: moodId,
        mode: mode,
        responseType: responseType,
        context: context,
      );
      
      final response = await _apiService.post('/api/emotion/openai', data: request.toJson());
      
      if (response.data != null) {
        return EmotionAnalysisResponse.fromJson(response.data);
      } else {
        throw Exception('감정 분석 응답이 비어있습니다');
      }
    } catch (e) {
      throw Exception('감정 분석 실패: $e');
    }
  }

  // 최근 감정 분석 기록 조회
  Future<RecentEmotionResponse> getRecentEmotions({int count = 3, int offset = 0}) async {
    try {
      final response = await _apiService.get('/api/emotion/recent', queryParameters: {
        'count': count,
        // 서버에서 offset을 지원하지 않으므로 클라이언트에서 처리
      });
      
      if (response.data != null) {
        final recentResponse = RecentEmotionResponse.fromJson(response.data);
        
        // 클라이언트 사이드 페이지네이션 시뮬레이션
        // 실제 구현에서는 서버에서 offset/limit을 지원해야 함
        if (offset > 0 && recentResponse.posts.length > offset) {
          final paginatedPosts = recentResponse.posts.skip(offset).take(count).toList();
          return RecentEmotionResponse(
            userId: recentResponse.userId,
            count: paginatedPosts.length,
            posts: paginatedPosts,
          );
        }
        
        return recentResponse;
      } else {
        throw Exception('최근 감정 기록 응답이 비어있습니다');
      }
    } catch (e) {
      throw Exception('최근 감정 기록 조회 실패: $e');
    }
  }

  // 날짜별 감정 기록 조회
  Future<List<EmotionPost>> getEmotionsByDate({required DateTime date}) async {
    try {
      // 한국시간 기준으로 날짜 문자열 생성
      final koreaDate = date.isUtc ? TimeUtils.toKoreaTime(date) : date;
      final dateString = TimeUtils.formatKoreaDate(koreaDate, pattern: 'yyyy-MM-dd');
      
      final response = await _apiService.get('/api/emotion/by-date', queryParameters: {
        'startDate': dateString,
      });
      
      if (response.data != null) {
        // API 응답 구조: {total: 3, statistics: {...}, data: [...]}
        if (response.data is Map<String, dynamic> && response.data['data'] != null) {
          final List<dynamic> postsData = response.data['data'];
          return postsData.map((post) => EmotionPost.fromJson(post)).toList();
        } else if (response.data is List) {
          // 혹시 배열로 직접 오는 경우도 처리
          final List<dynamic> postsData = response.data;
          return postsData.map((post) => EmotionPost.fromJson(post)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('날짜별 감정 기록 조회 실패: $e');
    }
  }

  // 기존 텍스트 감정 분석 (호환성 유지)
  Future<EmotionAnalysis> analyzeEmotion(String text, {String? language}) async {
    try {
      final request = EmotionRequest(text: text, language: language);
      final response = await _apiService.post('/api/emotion/analyze', data: request.toJson());
      
      if (response.data['success'] == true) {
        return EmotionAnalysis.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to analyze emotion');
      }
    } catch (e) {
      throw Exception('Failed to analyze emotion: $e');
    }
  }

  // 배치 감정 분석 (여러 텍스트 동시 분석)
  Future<List<EmotionAnalysis>> analyzeBatchEmotions(List<String> texts, {String? language}) async {
    try {
      final requestData = {
        'texts': texts,
        if (language != null) 'language': language,
      };
      
      final response = await _apiService.post('/api/emotion/analyze/batch', data: requestData);
      
      if (response.data['success'] == true) {
        final List<dynamic> analysisData = response.data['data'] ?? [];
        return analysisData.map((json) => EmotionAnalysis.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to analyze emotions');
      }
    } catch (e) {
      throw Exception('Failed to analyze emotions: $e');
    }
  }

  // 감정 히스토리 조회
  Future<List<EmotionAnalysis>> getEmotionHistory({
    int page = 1,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get('/api/emotion/history', queryParameters: queryParams);
      
      if (response.data['success'] == true) {
        final List<dynamic> historyData = response.data['data'] ?? [];
        return historyData.map((json) => EmotionAnalysis.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch emotion history');
      }
    } catch (e) {
      throw Exception('Failed to fetch emotion history: $e');
    }
  }

  // 감정 통계 조회
  Future<Map<String, dynamic>> getEmotionStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _apiService.get('/api/emotion/statistics', queryParameters: queryParams);
      
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch emotion statistics');
      }
    } catch (e) {
      throw Exception('Failed to fetch emotion statistics: $e');
    }
  }

  // 감정 트렌드 분석
  Future<Map<String, dynamic>> getEmotionTrends({
    String period = 'week', // week, month, year
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'period': period,
      };
      
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _apiService.get('/api/emotion/trends', queryParameters: queryParams);
      
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch emotion trends');
      }
    } catch (e) {
      throw Exception('Failed to fetch emotion trends: $e');
    }
  }

  // 감정 추천 (비슷한 감정의 노트나 조언)
  Future<Map<String, dynamic>> getEmotionRecommendations(String emotion) async {
    try {
      final response = await _apiService.get('/api/emotion/recommendations/$emotion');
      
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch recommendations');
      }
    } catch (e) {
      throw Exception('Failed to fetch recommendations: $e');
    }
  }
  
  // 월간 통계 조회
  Future<Map<String, dynamic>> getMonthlyStats() async {
    try {
      // 현재 년도와 월을 가져와서 yearMonth 형식으로 만들기 (YYYY-MM)
      final now = TimeUtils.nowInKorea();
      final yearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      
      print('월간 통계 요청: yearMonth=$yearMonth');
      
      // 서버에 요청 - 올바른 API 엔드포인트와 파라미터 사용
      final response = await _apiService.get('/api/emotion/monthly-stats', queryParameters: {
        'yearMonth': yearMonth,
      });
      
      // 응답 로그 추가
      print('월간 통계 API 응답: ${response.data}');
      
      // 응답이 null인 경우
      if (response.data == null) {
        print('월간 통계 API 응답이 null입니다');
        return _getDefaultStats();
      }
      
      // 응답이 Map이고 stats 배열이 있는 경우 (실제 API 응답 형태)
      if (response.data is Map && response.data.containsKey('stats')) {
        final statsList = response.data['stats'] as List;
        if (statsList.isNotEmpty) {
          // 첫 번째 통계 데이터 가져오기
          final statsData = statsList[0] as Map<String, dynamic>;
          final total = statsData['total'] ?? 0;
          
          // 감정별 수치 계산
          int emotionCount = 0;
          double emotionSum = 0;
          if (statsData.containsKey('emotions') && statsData['emotions'] is Map) {
            final emotions = statsData['emotions'] as Map;
            emotions.forEach((emotion, count) {
              emotionCount += (count as int);
              // 감정별 점수 가중치 (예시: 기쁨=0.8, 슬픔=0.3 등)
              double score = 0.5; // 기본 점수
              if (emotion == '기쁨' || emotion == '행복') score = 0.8;
              if (emotion == '슬픔' || emotion == '우울') score = 0.3;
              emotionSum += (count as int) * score;
            });
          }
          
          // 평균 점수 계산
          final avgScore = emotionCount > 0 ? emotionSum / emotionCount : 0.0;
          
          // 연속 기록 일수 (임의로 설정)
          final streak = total > 0 ? (total > 7 ? 7 : total) : 0;
          
          // 통계 데이터 반환
          return {
            'total': total,
            'avgScore': avgScore.toStringAsFixed(1),
            'streak': streak,
          };
        }
      }
      
      // 성공 플래그가 있고 성공인 경우
      else if (response.data is Map && response.data.containsKey('success') && response.data['success'] == true) {
        var data = response.data['data'];
        if (data != null) return data;
      }
      
      // 성공 플래그 없이 바로 데이터가 오는 경우
      else if (response.data is Map && (response.data.containsKey('total') || 
               response.data.containsKey('avgScore') || 
               response.data.containsKey('streak'))) {
        return response.data;
      }
      
      // 기본 값 반환
      return _getDefaultStats();
    } catch (e) {
      // 예외 발생 시 기본 값 반환
      print('월간 통계 API 예외 발생: $e');
      return _getDefaultStats();
    }
  }
  
  // 기본 통계 값 반환
  Map<String, dynamic> _getDefaultStats() {
    return {
      'total': 0,
      'avgScore': '0.0',
      'streak': 0,
    };
  }
}