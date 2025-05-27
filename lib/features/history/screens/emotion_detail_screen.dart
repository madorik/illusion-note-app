import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/emotion_analysis_model.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/utils/emotion_utils.dart';

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
      body: CustomScrollView(
        slivers: [
          // 모던한 앱바
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1A1A1A),
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                '감정 기록',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          
          // 컨텐츠
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 헤더 카드
                  _buildModernHeader(),
                  const SizedBox(height: 20),
                  
                  // 내가 쓴 글 카드
                  _buildModernUserText(),
                  const SizedBox(height: 20),
                  
                  // AI 분석 결과 카드
                  _buildModernAIAnalysis(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFFBFCFE),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 감정 태그와 날짜
            Row(
              children: [
                // 감정 태그 (개선된 디자인)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        EmotionUtils.getEmotionColor(post.emotion),
                        EmotionUtils.getEmotionColor(post.emotion).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: EmotionUtils.getEmotionColor(post.emotion).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 감정 이미지
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: EmotionUtils.buildEmotionImage(
                            emotion: post.emotion,
                            size: 24,
                            fallbackIconColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.emotion,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // 날짜 (개선된 디자인)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TimeUtils.getSmartDateTimeDisplay(post.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 제목
            Text(
              post.title,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                height: 1.3,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernUserText() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0F9FF),
                  Color(0xFFE0F2FE),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '내가 쓴 글',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          
          // 내용
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              post.text,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF334155),
                height: 1.7,
                letterSpacing: -0.2,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAIAnalysis() {
    // 디버깅: AI 분석 데이터 확인
    debugPrint('🔍 AI Analysis Debug:');
    debugPrint('   post.response: "${post.response}"');
    debugPrint('   post.response.length: ${post.response.length}');
    debugPrint('   post.analyzeText: "${post.analyzeText}"');
    debugPrint('   post.analyzeText?.length: ${post.analyzeText?.length}');
    debugPrint('   post.summary: "${post.summary}"');
    debugPrint('   post.summary?.length: ${post.summary?.length}');
    debugPrint('   post.responseType: "${post.responseType}"');
    debugPrint('   post.metadata: ${post.metadata}');
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 - 내가 쓴 글과 동일한 스타일
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0F9FF),
                  Color(0xFFE0F2FE),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'AI 분석 결과',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          
          // 내용 - 내가 쓴 글과 동일한 스타일
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 모든 가능한 AI 분석 내용을 하나의 텍스트로 결합하여 표시
                Builder(
                  builder: (context) {
                    // 모든 가능한 AI 분석 텍스트를 수집
                    List<String> analysisTexts = [];
                    
                    if (post.response.isNotEmpty) {
                      analysisTexts.add(post.response);
                    }
                    
                    if (post.analyzeText != null && post.analyzeText!.isNotEmpty) {
                      analysisTexts.add(post.analyzeText!);
                    }
                    
                    if (post.summary != null && post.summary!.isNotEmpty) {
                      analysisTexts.add(post.summary!);
                    }
                    
                    // 메타데이터에서 추가 분석 정보 확인
                    if (post.metadata != null) {
                      post.metadata!.forEach((key, value) {
                        if (value is String && value.isNotEmpty && value.length > 10) {
                          // 의미있는 텍스트만 추가
                          analysisTexts.add('$key: $value');
                        }
                      });
                    }
                    
                    if (analysisTexts.isEmpty) {
                      return Text(
                        'AI 분석 결과가 없습니다.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF9CA3AF),
                          height: 1.7,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }
                    
                    // 여러 분석 텍스트를 구분선으로 분리하여 표시
                    List<Widget> widgets = [];
                    for (int i = 0; i < analysisTexts.length; i++) {
                      widgets.add(
                        Text(
                          analysisTexts[i],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF334155),
                            height: 1.7,
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                      
                      // 마지막 항목이 아니면 구분선 추가
                      if (i < analysisTexts.length - 1) {
                        widgets.add(const SizedBox(height: 24));
                        widgets.add(
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: const Color(0xFFE2E8F0),
                          ),
                        );
                        widgets.add(const SizedBox(height: 24));
                      }
                    }
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widgets,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




} 