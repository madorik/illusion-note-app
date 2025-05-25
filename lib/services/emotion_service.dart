import 'package:dio/dio.dart';
import '../core/models/emotion_model.dart';
import '../core/models/emotion_analysis_model.dart';
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
      
      print('=== 감정 분석 요청 ===');
      print('Request: ${request.toJson()}');
      print('==================');
      
      final response = await _apiService.post('/api/emotion/openai', data: request.toJson());
      
      print('=== 감정 분석 응답 ===');
      print('Response: ${response.data}');
      print('==================');
      
      if (response.data != null) {
        return EmotionAnalysisResponse.fromJson(response.data);
      } else {
        throw Exception('감정 분석 응답이 비어있습니다');
      }
    } catch (e) {
      print('감정 분석 오류: $e');
      throw Exception('감정 분석 실패: $e');
    }
  }

  // 최근 감정 분석 기록 조회
  Future<RecentEmotionResponse> getRecentEmotions({int count = 3, int offset = 0}) async {
    try {
      print('=== 최근 감정 기록 조회 ===');
      print('Count: $count, Offset: $offset');
      print('=======================');
      
      final response = await _apiService.get('/api/emotion/recent', queryParameters: {
        'count': count,
        // 서버에서 offset을 지원하지 않으므로 클라이언트에서 처리
      });
      
      print('=== 최근 감정 기록 응답 ===');
      print('Response: ${response.data}');
      print('========================');
      
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
      print('최근 감정 기록 조회 오류: $e');
      throw Exception('최근 감정 기록 조회 실패: $e');
    }
  }

  // 날짜별 감정 기록 조회
  Future<List<EmotionPost>> getEmotionsByDate({required DateTime date}) async {
    try {
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      print('=== 날짜별 감정 기록 조회 ===');
      print('날짜: $dateString');
      print('========================');
      
      final response = await _apiService.get('/api/emotion/by-date', queryParameters: {
        'startDate': dateString,
      });
      
      print('=== 날짜별 감정 기록 응답 ===');
      print('Response: ${response.data}');
      print('==========================');
      
      if (response.data != null) {
        // API 응답 구조: {total: 3, statistics: {...}, data: [...]}
        if (response.data is Map<String, dynamic> && response.data['data'] != null) {
          final List<dynamic> postsData = response.data['data'];
          print('=== 파싱된 데이터 ===');
          print('데이터 개수: ${postsData.length}');
          if (postsData.isNotEmpty) {
            print('첫 번째 데이터: ${postsData.first}');
          }
          print('==================');
          
          return postsData.map((post) => EmotionPost.fromJson(post)).toList();
        } else if (response.data is List) {
          // 혹시 배열로 직접 오는 경우도 처리
          final List<dynamic> postsData = response.data;
          return postsData.map((post) => EmotionPost.fromJson(post)).toList();
        } else {
          print('예상하지 못한 응답 구조: ${response.data.runtimeType}');
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('날짜별 감정 기록 조회 오류: $e');
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
} 