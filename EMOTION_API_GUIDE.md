# 감정 분석 API 가이드

이 문서는 Illusion Note 앱에서 새로운 감정 분석 API를 사용하는 방법을 설명합니다.

## 🔥 새로운 OpenAI 감정 분석 API

### 기본 사용법

```dart
import 'package:illusion/services/service_locator.dart';

// 기본 감정 분석
final result = await services.emotionService.analyzeEmotionOpenAI(
  text: '부장님이 나한테 일 잘한다고 칭찬해줬어.',
);

print('감정: ${result.emotion}');
print('응답: ${result.response}');
print('분석: ${result.analyzeText}');
print('요약: ${result.summary}');
print('제목: ${result.title}');
```

### 고급 옵션

```dart
// 다양한 옵션을 사용한 감정 분석
final result = await services.emotionService.analyzeEmotionOpenAI(
  text: '오늘 하루가 너무 힘들었어.',
  moodId: 'mood_123',           // 기분 ID (선택사항)
  mode: 'chat',                 // 모드: 'chat' (기본값)
  responseType: 'comfort',      // 응답 타입: 'comfort', 'advice', 'empathy'
  context: '직장에서의 스트레스', // 컨텍스트 (선택사항)
);
```

### 응답 타입별 차이점

- **comfort**: 위로와 공감 중심의 응답
- **advice**: 조언과 해결책 중심의 응답  
- **empathy**: 감정 이해와 공감 중심의 응답

## 📊 최근 감정 분석 기록 조회

```dart
// 최근 3개의 감정 분석 기록 조회
final recentEmotions = await services.emotionService.getRecentEmotions(count: 3);

print('사용자 ID: ${recentEmotions.userId}');
print('총 기록 수: ${recentEmotions.count}');

for (var post in recentEmotions.posts) {
  print('제목: ${post.title}');
  print('감정: ${post.emotion}');
  print('텍스트: ${post.text}');
  print('생성일: ${post.createdAt}');
  print('---');
}
```

## 🧪 테스트 실행

개발 중에 API를 테스트하려면:

1. `lib/main.dart`에서 테스트 코드 주석 해제:
```dart
// 🧪 감정 분석 API 테스트 (개발 중에만 사용)
EmotionTest.runAllTests();
```

2. 또는 직접 테스트 메서드 호출:
```dart
import 'package:illusion/core/examples/emotion_test.dart';

// 개별 테스트 실행
await EmotionTest.testOpenAIEmotionAnalysis();
await EmotionTest.testRecentEmotions();
await EmotionTest.testResponseTypes();

// 모든 테스트 실행
await EmotionTest.runAllTests();
```

## 📝 데이터 모델

### EmotionAnalysisRequest
```dart
class EmotionAnalysisRequest {
  final String text;           // 분석할 텍스트 (필수)
  final String? moodId;        // 기분 ID (선택)
  final String mode;           // 모드 (기본: 'chat')
  final String responseType;   // 응답 타입 (기본: 'comfort')
  final String? context;       // 컨텍스트 (선택)
}
```

### EmotionAnalysisResponse
```dart
class EmotionAnalysisResponse {
  final String emotion;        // 감지된 감정
  final String response;       // AI 응답 메시지
  final String analyzeText;    // 감정 분석 설명
  final String summary;        // 요약
  final String title;          // 제목
}
```

### EmotionPost
```dart
class EmotionPost {
  final String id;             // 포스트 ID
  final String userId;         // 사용자 ID
  final String text;           // 원본 텍스트
  final String emotion;        // 감정
  final String response;       // AI 응답
  final String title;          // 제목
  final DateTime createdAt;    // 생성일시
}
```

## 🔐 인증

모든 감정 분석 API는 인증이 필요합니다. 구글 로그인 후 자동으로 서버 토큰이 설정되므로 별도 설정이 불필요합니다.

## ⚠️ 에러 처리

```dart
try {
  final result = await services.emotionService.analyzeEmotionOpenAI(
    text: '분석할 텍스트',
  );
  // 성공 처리
} catch (e) {
  print('감정 분석 실패: $e');
  // 에러 처리
}
```

## 🌐 API 엔드포인트

- **감정 분석**: `POST /api/emotion/openai`
- **최근 기록**: `GET /api/emotion/recent?count=3`
- **기본 URL**: `https://illusion-note-api.vercel.app`

## 📱 Flutter 앱에서 사용

```dart
// Provider 패턴으로 상태 관리
class EmotionProvider extends ChangeNotifier {
  EmotionAnalysisResponse? _lastResult;
  List<EmotionPost> _recentPosts = [];
  bool _isLoading = false;

  Future<void> analyzeEmotion(String text) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _lastResult = await services.emotionService.analyzeEmotionOpenAI(
        text: text,
      );
    } catch (e) {
      // 에러 처리
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## 🚀 시작하기

1. 구글 로그인으로 인증
2. `services.emotionService.analyzeEmotionOpenAI()` 호출
3. 결과 확인 및 UI 업데이트
4. 필요시 최근 기록 조회

더 자세한 예제는 `lib/core/examples/emotion_test.dart` 파일을 참고하세요. 