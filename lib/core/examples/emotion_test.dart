import '../models/emotion_analysis_model.dart';
import '../../services/service_locator.dart';

/// 감정 분석 API 테스트 클래스
class EmotionTest {
  
  /// OpenAI 감정 분석 테스트
  static Future<void> testOpenAIEmotionAnalysis() async {
    print('🧪 OpenAI 감정 분석 테스트 시작');
    
    try {
      // 테스트 케이스들
      final testCases = [
        {
          'text': '부장님이 나한테 일 잘한다고 칭찬해줬어.',
          'description': '긍정적인 피드백'
        },
        {
          'text': '오늘 시험에서 떨어졌어. 너무 속상하다.',
          'description': '부정적인 결과'
        },
        {
          'text': '내일 면접이 있는데 너무 긴장된다.',
          'description': '불안감'
        },
        {
          'text': '친구들과 여행 가서 정말 즐거웠어!',
          'description': '즐거운 경험'
        },
      ];

      for (var testCase in testCases) {
        print('\n--- ${testCase['description']} ---');
        print('입력: ${testCase['text']}');
        
        final result = await services.emotionService.analyzeEmotionOpenAI(
          text: testCase['text']!,
          mode: 'chat',
          responseType: 'comfort',
        );
        
        print('감정: ${result.emotion}');
        print('응답: ${result.response}');
        print('분석: ${result.analyzeText}');
        print('요약: ${result.summary}');
        print('제목: ${result.title}');
        print('-------------------');
      }
      
    } catch (e) {
      print('❌ 감정 분석 테스트 실패: $e');
    }
  }

  /// 최근 감정 기록 조회 테스트
  static Future<void> testRecentEmotions() async {
    print('\n🧪 최근 감정 기록 조회 테스트 시작');
    
    try {
      final recentEmotions = await services.emotionService.getRecentEmotions(count: 3);
      
      print('사용자 ID: ${recentEmotions.userId}');
      print('총 기록 수: ${recentEmotions.count}');
      print('조회된 기록:');
      
      if (recentEmotions.posts.isEmpty) {
        print('- 기록이 없습니다.');
      } else {
        for (var i = 0; i < recentEmotions.posts.length; i++) {
          final post = recentEmotions.posts[i];
          print('${i + 1}. ${post.title}');
          print('   감정: ${post.emotion}');
          print('   텍스트: ${post.text}');
          print('   생성일: ${post.createdAt}');
          print('');
        }
      }
      
    } catch (e) {
      print('❌ 최근 감정 기록 조회 테스트 실패: $e');
    }
  }

  /// 다양한 응답 타입 테스트
  static Future<void> testResponseTypes() async {
    print('\n🧪 다양한 응답 타입 테스트 시작');
    
    const text = '오늘 하루가 너무 힘들었어.';
    final responseTypes = ['comfort', 'advice', 'empathy'];
    
    try {
      for (var responseType in responseTypes) {
        print('\n--- 응답 타입: $responseType ---');
        
        final result = await services.emotionService.analyzeEmotionOpenAI(
          text: text,
          mode: 'chat',
          responseType: responseType,
        );
        
        print('감정: ${result.emotion}');
        print('응답: ${result.response}');
        print('------------------------');
      }
      
    } catch (e) {
      print('❌ 응답 타입 테스트 실패: $e');
    }
  }

  /// 모든 테스트 실행
  static Future<void> runAllTests() async {
    print('🚀 감정 분석 API 테스트 시작');
    print('================================');
    
    await testOpenAIEmotionAnalysis();
    await testRecentEmotions();
    await testResponseTypes();
    
    print('\n✅ 모든 테스트 완료');
    print('================================');
  }
} 