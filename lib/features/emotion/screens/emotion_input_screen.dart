import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/emotion_provider.dart';

class EmotionInputScreen extends StatefulWidget {
  const EmotionInputScreen({super.key});

  @override
  State<EmotionInputScreen> createState() => _EmotionInputScreenState();
}

class _EmotionInputScreenState extends State<EmotionInputScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedEmotion;
  double _emotionScore = 5.0;

  final List<EmotionOption> _emotionOptions = [
    EmotionOption(
      emotion: 'happy',
      label: '기쁨',
      emoji: '😊',
      color: const Color(0xFF38A169),
    ),
    EmotionOption(
      emotion: 'excited',
      label: '신남',
      emoji: '🤩',
      color: const Color(0xFFD69E2E),
    ),
    EmotionOption(
      emotion: 'calm',
      label: '평온',
      emoji: '😌',
      color: const Color(0xFF38B2AC),
    ),
    EmotionOption(
      emotion: 'neutral',
      label: '보통',
      emoji: '😐',
      color: const Color(0xFF718096),
    ),
    EmotionOption(
      emotion: 'sad',
      label: '슬픔',
      emoji: '😢',
      color: const Color(0xFF4299E1),
    ),
    EmotionOption(
      emotion: 'angry',
      label: '화남',
      emoji: '😡',
      color: const Color(0xFFE53E3E),
    ),
    EmotionOption(
      emotion: 'anxious',
      label: '불안',
      emoji: '😰',
      color: const Color(0xFF9F7AEA),
    ),
    EmotionOption(
      emotion: 'tired',
      label: '피곤',
      emoji: '😴',
      color: const Color(0xFF718096),
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          '감정 기록하기',
          style: TextStyle(fontFamily: 'NotoSansKR'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Consumer<EmotionProvider>(
            builder: (context, emotionProvider, child) => TextButton(
              onPressed: emotionProvider.isLoading || _selectedEmotion == null
                  ? null
                  : _saveEmotion,
              child: emotionProvider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 감정 선택 섹션
            _buildEmotionSelectionSection(),
            const SizedBox(height: 24),

            // 강도 조절 섹션
            if (_selectedEmotion != null) ...[
              _buildIntensitySection(),
              const SizedBox(height: 24),
            ],

            // 제목 입력 섹션
            _buildTitleSection(),
            const SizedBox(height: 24),

            // 내용 입력 섹션
            _buildContentSection(),
            const SizedBox(height: 24),

            // 에러 메시지
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, child) {
                if (emotionProvider.errorMessage != null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      emotionProvider.errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                        fontFamily: 'NotoSansKR',
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

  Widget _buildEmotionSelectionSection() {
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
          const Row(
            children: [
              Icon(
                Icons.psychology,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '지금 느끼는 감정을 선택해주세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _emotionOptions.length,
            itemBuilder: (context, index) {
              final option = _emotionOptions[index];
              final isSelected = _selectedEmotion == option.emotion;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEmotion = option.emotion;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? option.color.withOpacity(0.1) : const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? option.color : const Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? option.color : const Color(0xFF718096),
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIntensitySection() {
    final selectedOption = _emotionOptions.firstWhere(
      (option) => option.emotion == _selectedEmotion,
    );

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
                Icons.tune,
                color: selectedOption.color,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '감정의 강도는 어느 정도인가요?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Text(
                selectedOption.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '약함',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718096),
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                        Text(
                          _emotionScore.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selectedOption.color,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                        const Text(
                          '강함',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718096),
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: selectedOption.color,
                        inactiveTrackColor: selectedOption.color.withOpacity(0.3),
                        thumbColor: selectedOption.color,
                        overlayColor: selectedOption.color.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _emotionScore,
                        min: 1.0,
                        max: 10.0,
                        divisions: 18,
                        onChanged: (value) {
                          setState(() {
                            _emotionScore = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
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
          const Row(
            children: [
              Icon(
                Icons.title,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '제목 (선택사항)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: '오늘의 감정을 한 줄로 표현해보세요',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(fontFamily: 'NotoSansKR'),
            maxLength: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
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
          const Row(
            children: [
              Icon(
                Icons.edit_note,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '자세한 내용 (선택사항)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              hintText: '감정에 대해 더 자세히 적어보세요...\n무엇이 이 감정을 느끼게 했나요?',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(16),
            ),
            style: const TextStyle(fontFamily: 'NotoSansKR'),
            maxLines: 5,
            maxLength: 500,
          ),
        ],
      ),
    );
  }

  Future<void> _saveEmotion() async {
    if (_selectedEmotion == null) return;

    final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
    emotionProvider.clearError();

    final success = await emotionProvider.addEmotionEntry(
      emotion: _selectedEmotion!,
      title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
      content: _contentController.text.trim().isEmpty ? null : _contentController.text.trim(),
      score: _emotionScore,
    );

    if (success && mounted) {
      // 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '감정이 성공적으로 기록되었습니다!',
            style: TextStyle(fontFamily: 'NotoSansKR'),
          ),
          backgroundColor: Color(0xFF38A169),
        ),
      );
      
      // 홈으로 돌아가기
      context.go('/home');
    }
  }
}

class EmotionOption {
  final String emotion;
  final String label;
  final String emoji;
  final Color color;

  EmotionOption({
    required this.emotion,
    required this.label,
    required this.emoji,
    required this.color,
  });
} 