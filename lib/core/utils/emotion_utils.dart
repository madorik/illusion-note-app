import 'package:flutter/material.dart';

class EmotionUtils {
  /// 감정명을 기반으로 이미지 경로를 반환하는 함수
  static String getEmotionImagePath(String emotion) {
    // 디버깅: 실제 emotion 값 확인
    debugPrint('🔍 Original emotion: "$emotion"');
    
    // API 응답의 emotion 값을 이미지 파일명과 맵핑
    // 정확한 문자열 매칭을 위해 trim()과 toLowerCase() 적용
    final cleanEmotion = emotion.trim().toLowerCase();
    debugPrint('🔍 Clean emotion: "$cleanEmotion"');
    
    String imagePath;
    
    // 감정 키워드 포함 여부로 매칭 (더 유연한 매칭)
    if (cleanEmotion.contains('기쁨') || cleanEmotion.contains('행복') || 
        cleanEmotion.contains('좋') || cleanEmotion.contains('즐거') ||
        cleanEmotion.contains('만족') || cleanEmotion.contains('joy') ||
        cleanEmotion.contains('happy')) {
      imagePath = 'assets/images/emotion/기쁨.png';
    }
    else if (cleanEmotion.contains('슬픔') || cleanEmotion.contains('슬프') ||
        cleanEmotion.contains('아쉬') || cleanEmotion.contains('속상') ||
        cleanEmotion.contains('sad') || cleanEmotion.contains('우')) {
      imagePath = 'assets/images/emotion/슬픔.png';
    }
    else if (cleanEmotion.contains('화') || cleanEmotion.contains('분노') ||
        cleanEmotion.contains('짜증') || cleanEmotion.contains('angry') ||
        cleanEmotion.contains('anger')) {
      imagePath = 'assets/images/emotion/화남.png';
    }
    else if (cleanEmotion.contains('불안') || cleanEmotion.contains('걱정') ||
        cleanEmotion.contains('초조') || cleanEmotion.contains('anxious') ||
        cleanEmotion.contains('worried')) {
      imagePath = 'assets/images/emotion/불안.png';
    }
    else if (cleanEmotion.contains('우울') || cleanEmotion.contains('depressed') ||
        cleanEmotion.contains('depression')) {
      imagePath = 'assets/images/emotion/우울.png';
    }
    else {
      // 기본값
      imagePath = 'assets/images/emotion/보통.png';
    }
    
    debugPrint('✅ Selected image path: $imagePath');
    return imagePath;
  }

  /// 감정 이미지 위젯을 생성하는 함수
  static Widget buildEmotionImage({
    required String emotion,
    double size = 20,
    Color? fallbackIconColor,
    IconData fallbackIcon = Icons.mood,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          getEmotionImagePath(emotion),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Image load error: $error');
            debugPrint('❌ Image path: ${getEmotionImagePath(emotion)}');
            return Container(
              decoration: BoxDecoration(
                color: fallbackIconColor?.withOpacity(0.3) ?? Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Icon(
                fallbackIcon,
                color: fallbackIconColor ?? Colors.grey,
                size: size * 0.8,
              ),
            );
          },
        ),
      ),
    );
  }

  /// 감정별 색상을 반환하는 함수
  static Color getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case '기쁨':
      case '행복':
      case '좋음':
        return const Color(0xFFEF4444);
      case '슬픔':
      case '우울':
        return const Color(0xFF3B82F6);
      case '화남':
      case '분노':
        return const Color(0xFFDC2626);
      case '불안':
      case '걱정':
        return const Color(0xFF8B5CF6);
      case '놀람':
        return const Color(0xFF10B981);
      case '평온':
      case '차분':
        return const Color(0xFF06B6D4);
      case '피곤':
      case '지침':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B73FF);
    }
  }
} 