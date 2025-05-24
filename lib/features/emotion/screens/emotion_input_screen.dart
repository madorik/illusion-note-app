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
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedEmotion;
  double _emotionScore = 5.0;

  final List<EmotionOption> _emotionOptions = [
    EmotionOption(
      emotion: 'happy',
      label: '기쁨',
      emoji: '😊',
      color: AppColors.joyBlue,
    ),
    EmotionOption(
      emotion: 'excited',
      label: '신남',
      emoji: '🤩',
      color: AppColors.successGreen,
    ),
    EmotionOption(
      emotion: 'calm',
      label: '평온',
      emoji: '😌',
      color: AppColors.calmGreen,
    ),
    EmotionOption(
      emotion: 'neutral',
      label: '보통',
      emoji: '😐',
      color: AppColors.neutralGray,
    ),
    EmotionOption(
      emotion: 'sad',
      label: '슬픔',
      emoji: '😢',
      color: AppColors.sadPurple,
    ),
    EmotionOption(
      emotion: 'angry',
      label: '화남',
      emoji: '😡',
      color: AppColors.angryRed,
    ),
    EmotionOption(
      emotion: 'anxious',
      label: '불안',
      emoji: '😰',
      color: AppColors.warningOrange,
    ),
    EmotionOption(
      emotion: 'tired',
      label: '피곤',
      emoji: '😴',
      color: AppColors.neutralGray,
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
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: Text(
          '감정 기록하기',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
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
                  : Text(
                      '저장',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _selectedEmotion != null ? AppColors.primaryBlue : AppColors.textTertiary,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmotionSelectionSection(),
            const SizedBox(height: 24),
            if (_selectedEmotion != null) ...[
              _buildIntensitySection(),
              const SizedBox(height: 24),
            ],
            _buildTitleSection(),
            const SizedBox(height: 24),
            _buildContentSection(),
            const SizedBox(height: 24),
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, child) {
                if (emotionProvider.errorMessage != null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
                    ),
                    child: Text(
                      emotionProvider.errorMessage!,
                      style: GoogleFonts.inter(
                        color: AppColors.errorRed,
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

  Widget _buildEmotionSelectionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '지금 느끼는 감정을 선택해주세요',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
                    color: isSelected ? option.color.withOpacity(0.15) : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? option.color : Colors.transparent,
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
                      const SizedBox(height: 6),
                      Text(
                        option.label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? option.color : AppColors.textSecondary,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
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
              const SizedBox(width: 12),
              Text(
                '감정의 강도는 어느 정도인가요?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                selectedOption.emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '약함',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _emotionScore.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: selectedOption.color,
                          ),
                        ),
                        Text(
                          '강함',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
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
                        trackHeight: 4,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.title,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '제목',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: '오늘의 감정을 한마디로 표현해보세요',
              hintStyle: GoogleFonts.inter(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit,
                color: AppColors.successGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '상세 내용',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '감정에 대한 생각이나 상황을 자유롭게 적어보세요',
              hintStyle: GoogleFonts.inter(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _saveEmotion() {
    final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
    emotionProvider.saveEmotion(
      emotion: _selectedEmotion!,
      score: _emotionScore,
      title: _titleController.text,
      content: _contentController.text,
    );
    context.pop();
  }
}

class EmotionOption {
  final String emotion;
  final String label;
  final String emoji;
  final Color color;
  const EmotionOption({
    required this.emotion,
    required this.label,
    required this.emoji,
    required this.color,
  });
} 