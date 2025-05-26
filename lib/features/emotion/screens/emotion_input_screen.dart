import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/emotion_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionInputScreen extends StatefulWidget {
  const EmotionInputScreen({super.key});

  @override
  State<EmotionInputScreen> createState() => _EmotionInputScreenState();
}

class _EmotionInputScreenState extends State<EmotionInputScreen> {
  final _textController = TextEditingController();
  String _selectedResponseType = 'comfort';

  final List<Map<String, dynamic>> _responseTypes = [
    {
      'id': 'comfort',
      'title': '위로받고 싶어요',
      'subtitle': '따뜻한 공감과 위로를 받고 싶을 때',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFFF6B9D),
    },
    {
      'id': 'advice',
      'title': '조언이 필요해요',
      'subtitle': '구체적인 해결책과 조언을 원할 때',
      'icon': Icons.lightbulb_rounded,
      'color': Color(0xFF4ECDC4),
    },
    {
      'id': 'empathy',
      'title': '팩트로 말해주세요',
      'subtitle': '객관적이고 사실적인 분석을 원할 때',
      'icon': Icons.analytics_rounded,
      'color': Color(0xFF6C5CE7),
    },
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '감정 기록',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              '오늘 어떤 일이\n있었나요?',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '당신의 감정과 생각을 자유롭게 표현해보세요.\nAI가 따뜻하게 들어드릴게요.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // 텍스트 입력 영역
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      maxLength: 100,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: '예: 오늘 회사에서 프레젠테이션을 했는데 너무 떨렸어요...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 12,
                    child: Text(
                      '${_textController.text.length}/100',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _textController.text.length > 90 
                            ? Colors.red 
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // AI 응답 타입 선택
            Text(
              'AI에게 어떤 답변을 원하시나요?',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '상황에 맞는 AI의 응답 스타일을 선택해주세요',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            
            // 응답 타입 버튼들
            ...List.generate(_responseTypes.length, (index) {
              final type = _responseTypes[index];
              final isSelected = _selectedResponseType == type['id'];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedResponseType = type['id'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? type['color'] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? type['color'] : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          type['icon'],
                          color: isSelected ? Colors.white : type['color'],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            type['title'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // AI 분석 버튼
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, child) {
                final isEnabled = !emotionProvider.isLoading && _textController.text.trim().isNotEmpty;
                
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEnabled ? _analyzeEmotion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B9DC3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: emotionProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'AI 분석 하기',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
            
            // 에러 메시지
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, child) {
                if (emotionProvider.errorMessage != null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      emotionProvider.errorMessage!,
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _analyzeEmotion() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
    
    try {
      final result = await emotionProvider.analyzeEmotionWithOpenAI(
        text: text,
        responseType: _selectedResponseType,
      );

      if (result != null && mounted) {
        _showAnalysisResult(result);
      }
    } catch (e) {
      // 에러는 EmotionProvider에서 처리됨
    }
  }

  void _showAnalysisResult(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          result['title'] ?? '감정 분석 결과',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result['emotion'] != null) ...[
                Text(
                  '감정: ${result['emotion']}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (result['response'] != null) ...[
                Text(
                  result['response'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(true); // 감정 입력 화면도 닫기
            },
            child: Text(
              '확인',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 