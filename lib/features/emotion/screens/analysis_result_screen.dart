import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisResultScreen extends StatelessWidget {
  final String emotionText;

  const AnalysisResultScreen({
    super.key,
    required this.emotionText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Text(
          '분석 결과',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 분석 결과 요약
            _buildAnalysisSummary(),
            const SizedBox(height: 24),

            // 감정 상세 분석
            _buildDetailedAnalysis(),
            const SizedBox(height: 24),

            // 추천 사항
            _buildRecommendations(),
            const SizedBox(height: 24),

            // 액션 버튼들
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                '감정 분석 완료',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 주요 감정
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '감지된 주요 감정',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '😊',
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '긍정적인 감정',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '신뢰도: 85%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis() {
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
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '상세 분석',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 감정 구성 요소
          const Text(
            '감정 구성 요소',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          
          _buildEmotionComponent('기쁨', 0.7, const Color(0xFF38A169)),
          const SizedBox(height: 8),
          _buildEmotionComponent('만족', 0.6, const Color(0xFF38B2AC)),
          const SizedBox(height: 8),
          _buildEmotionComponent('평온', 0.4, const Color(0xFF4299E1)),
          const SizedBox(height: 8),
          _buildEmotionComponent('불안', 0.2, const Color(0xFF9F7AEA)),
          
          const SizedBox(height: 20),
          
          // 키워드
          const Text(
            '핵심 키워드',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildKeywordChip('성취감'),
              _buildKeywordChip('만족'),
              _buildKeywordChip('감사'),
              _buildKeywordChip('희망'),
              _buildKeywordChip('자신감'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionComponent(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Color(0xFF4A5568),
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildKeywordChip(String keyword) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6B73FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6B73FF).withOpacity(0.3),
        ),
      ),
      child: Text(
        keyword,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B73FF),
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
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
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Color(0xFFD69E2E),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '추천 사항',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildRecommendationItem(
            '🧘‍♀️',
            '마음챙김 명상',
            '5분간의 깊은 호흡과 명상으로 현재의 긍정적인 감정을 더욱 깊이 느껴보세요.',
          ),
          const SizedBox(height: 16),
          
          _buildRecommendationItem(
            '📝',
            '감사 일기',
            '오늘 감사했던 3가지를 적어보세요. 긍정적인 감정을 지속시키는데 도움이 됩니다.',
          ),
          const SizedBox(height: 16),
          
          _buildRecommendationItem(
            '🎵',
            '기분 좋은 음악',
            '현재의 좋은 기분에 어울리는 음악을 들으며 이 순간을 만끽해보세요.',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 기록 저장 버튼
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: 분석 결과 저장 로직
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '분석 결과가 저장되었습니다!',
                  ),
                  backgroundColor: Color(0xFF38A169),
                ),
              );
              context.go('/home');
            },
            icon: const Icon(Icons.save),
            label: const Text(
              '분석 결과 저장하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // 공유 버튼
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: 공유 기능 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '공유 기능은 곧 출시될 예정입니다',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text(
              '결과 공유하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B73FF),
              side: const BorderSide(color: Color(0xFF6B73FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // 홈으로 돌아가기
        TextButton(
          onPressed: () => context.go('/home'),
          child: const Text(
            '홈으로 돌아가기',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
        ),
      ],
    );
  }
} 