import '../models/note_model.dart';
import '../models/emotion_model.dart';
import '../models/emotion_analysis_model.dart';
import '../models/user_model.dart';
import '../../services/service_locator.dart';

/// API 사용 예제들을 보여주는 클래스
class ApiUsageExample {
  
  /// 인증 관련 예제
  static Future<void> authExamples() async {
    try {
      // 회원가입
      final authResponse = await services.authService.register(
        'user@example.com',
        'password123',
        name: 'Test User',
      );
      print('회원가입 성공: ${authResponse.user.name}');

      // 로그인
      final loginResponse = await services.authService.login(
        'user@example.com',
        'password123',
      );
      print('로그인 성공: ${loginResponse.token}');

      // 현재 사용자 정보 조회
      final currentUser = await services.authService.getCurrentUser();
      print('현재 사용자: ${currentUser.email}');

      // 로그아웃
      await services.authService.logout();
      print('로그아웃 완료');

    } catch (e) {
      print('인증 오류: $e');
    }
  }

  /// 노트 관련 예제
  static Future<void> noteExamples() async {
    try {
      // 새 노트 생성
      final newNote = Note(
        title: '오늘의 기분',
        content: '오늘은 정말 좋은 하루였다. 친구들과 즐거운 시간을 보냈고, 새로운 것을 배웠다.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: ['행복', '친구', '학습'],
        category: '일상',
      );

      final createdNote = await services.noteService.createNote(newNote);
      print('노트 생성 완료: ${createdNote.id}');

      // 모든 노트 조회
      final notes = await services.noteService.getNotes(
        page: 1,
        limit: 10,
        emotion: '행복',
      );
      print('노트 목록 조회: ${notes.length}개');

      // 특정 노트 조회
      if (createdNote.id != null) {
        final note = await services.noteService.getNoteById(createdNote.id!);
        print('노트 상세 조회: ${note.title}');

        // 노트 수정
        final updatedNote = note.copyWith(
          title: '수정된 제목',
          content: '수정된 내용',
          updatedAt: DateTime.now(),
        );
        
        final result = await services.noteService.updateNote(note.id!, updatedNote);
        print('노트 수정 완료: ${result.title}');

        // 노트 삭제
        await services.noteService.deleteNote(note.id!);
        print('노트 삭제 완료');
      }

      // 노트 검색
      final searchResults = await services.noteService.searchNotes('행복');
      print('검색 결과: ${searchResults.length}개');

      // 감정별 통계
      final emotionStats = await services.noteService.getEmotionStats();
      print('감정 통계: $emotionStats');

    } catch (e) {
      print('노트 오류: $e');
    }
  }

  /// 감정 분석 관련 예제
  static Future<void> emotionExamples() async {
    try {
      // 🔥 새로운 OpenAI 감정 분석
      const text = '부장님이 나한테 일 잘한다고 칭찬해줬어.';
      final emotionResult = await services.emotionService.analyzeEmotionOpenAI(
        text: text,
        mode: 'chat',
        responseType: 'comfort',
      );
      print('=== OpenAI 감정 분석 결과 ===');
      print('감정: ${emotionResult.emotion}');
      print('응답: ${emotionResult.response}');
      print('분석: ${emotionResult.analyzeText}');
      print('요약: ${emotionResult.summary}');
      print('제목: ${emotionResult.title}');
      print('============================');

      // 🔥 최근 감정 분석 기록 조회
      final recentEmotions = await services.emotionService.getRecentEmotions(count: 5);
      print('=== 최근 감정 기록 ===');
      print('사용자 ID: ${recentEmotions.userId}');
      print('기록 수: ${recentEmotions.count}');
      for (var post in recentEmotions.posts) {
        print('- ${post.title} (${post.emotion}) - ${post.createdAt}');
      }
      print('==================');

      // 기존 감정 분석 (호환성)
      final emotion = await services.emotionService.analyzeEmotion(text);
      print('기존 감정 분석 결과: ${emotion.emotion} (신뢰도: ${emotion.confidence})');

      // 배치 감정 분석
      const texts = [
        '오늘은 우울한 하루였다.',
        '친구들과 즐거운 시간을 보냈다.',
        '시험이 걱정된다.',
      ];
      final batchResults = await services.emotionService.analyzeBatchEmotions(texts);
      print('배치 분석 결과: ${batchResults.length}개');

      // 감정 히스토리 조회
      final history = await services.emotionService.getEmotionHistory(
        page: 1,
        limit: 10,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      );
      print('감정 히스토리: ${history.length}개');

      // 감정 통계
      final statistics = await services.emotionService.getEmotionStatistics(
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now(),
      );
      print('감정 통계: $statistics');

      // 감정 트렌드
      final trends = await services.emotionService.getEmotionTrends(
        period: 'week',
        limit: 10,
      );
      print('감정 트렌드: $trends');

      // 감정 추천
      final recommendations = await services.emotionService.getEmotionRecommendations('행복');
      print('추천 결과: $recommendations');

    } catch (e) {
      print('감정 분석 오류: $e');
    }
  }

  /// 모든 예제 실행
  static Future<void> runAllExamples() async {
    print('=== API 사용 예제 시작 ===');
    
    print('\n--- 인증 예제 ---');
    await authExamples();
    
    print('\n--- 노트 예제 ---');
    await noteExamples();
    
    print('\n--- 감정 분석 예제 ---');
    await emotionExamples();
    
    print('\n=== API 사용 예제 완료 ===');
  }
} 