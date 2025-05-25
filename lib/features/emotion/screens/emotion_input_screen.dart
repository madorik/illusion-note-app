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
  String _selectedMode = '위로';

  final List<String> _modes = ['위로', '팩트', '조언'];

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              '오늘 당신의 감정을\n들려주세요',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            
            // 텍스트 입력 영역
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: '마음을 자유롭게 적어보세요...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 모드 선택
            Row(
              children: _modes.map((mode) {
                final isSelected = _selectedMode == mode;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMode = mode;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        mode,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // AI 분석 버튼
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: emotionProvider.isLoading || _textController.text.trim().isEmpty
                        ? null
                        : _analyzeEmotion,
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
    
    // 모드를 API 요청 형식으로 변환
    String responseType;
    switch (_selectedMode) {
      case '위로':
        responseType = 'comfort';
        break;
      case '팩트':
        responseType = 'fact';
        break;
      case '조언':
        responseType = 'advice';
        break;
      default:
        responseType = 'comfort';
    }

    try {
      final result = await emotionProvider.analyzeEmotionWithOpenAI(
        text: text,
        responseType: responseType,
      );

      if (result != null && mounted) {
        // 분석 결과를 보여주는 다이얼로그 또는 새 화면으로 이동
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
              if (result['analyze_text'] != null) ...[
                Text(
                  '분석: ${result['analyze_text']}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // 감정 입력 화면도 닫기
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