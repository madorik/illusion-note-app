import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/emotion_analysis_model.dart';
import '../../../core/utils/time_utils.dart';

class EmotionDetailScreen extends StatelessWidget {
  final EmotionPost post;

  const EmotionDetailScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '감정 기록 상세',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목과 날짜 카드
            _buildTitleCard(),
            const SizedBox(height: 16),
            
            // 내가 쓴 글 카드
            _buildUserTextCard(),
            const SizedBox(height: 16),
            
            // AI 분석 결과 카드
            _buildAIAnalysisCard(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 감정 태그
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getEmotionColorFromString(post.emotion),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 감정 이미지
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _getEmotionImagePath(post.emotion),
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('❌ Image load error: $error');
                        debugPrint('❌ Image path: ${_getEmotionImagePath(post.emotion)}');
                        return const Icon(
                          Icons.mood,
                          color: Colors.white,
                          size: 16,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  post.emotion,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 제목
          Text(
            post.title,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A202C),
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 날짜
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                TimeUtils.getSmartDateTimeDisplay(post.createdAt),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserTextCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F9FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_note,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '내가 쓴 글',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A202C),
                  ),
                ),
              ],
            ),
          ),
          
          // 내용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Text(
              post.text,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF374151),
                height: 1.6,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 분석 결과',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A202C),
                      ),
                    ),
                    Text(
                      _getResponseTypeLabel(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 분석 내용들
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI 응답
                if (post.response.isNotEmpty) ...[
                  _buildAnalysisSection(
                    'AI 응답',
                    post.response,
                    Icons.chat_bubble_outline,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // 상세 분석
                if (post.analyzeText != null && post.analyzeText!.isNotEmpty) ...[
                  _buildAnalysisSection(
                    '상세 분석',
                    post.analyzeText!,
                    Icons.analytics,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // 요약
                if (post.summary != null && post.summary!.isNotEmpty) ...[
                  _buildAnalysisSection(
                    '요약',
                    post.summary!,
                    Icons.summarize,
                    const Color(0xFFF59E0B),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildAnalysisSection(String label, String content, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: color,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF374151),
              height: 1.6,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  String _getResponseTypeLabel() {
    switch (post.responseType) {
      case 'comfort':
        return '위로 모드';
      case 'fact':
        return '팩트 모드';
      case 'advice':
        return '조언 모드';
      default:
        return '분석 모드';
    }
  }

  String _getEmotionImagePath(String emotion) {
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

  Color _getEmotionColorFromString(String emotion) {
    switch (emotion) {
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