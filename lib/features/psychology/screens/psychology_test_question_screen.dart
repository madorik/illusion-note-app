import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/psychology_test_provider.dart';
import '../../../core/models/psychology_test_model.dart';

class PsychologyTestQuestionScreen extends StatelessWidget {
  const PsychologyTestQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '심리 검사',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmationDialog(context),
        ),
      ),
      body: Consumer<PsychologyTestProvider>(
        builder: (context, provider, _) {
          if (provider.currentTest == null) {
            return const Center(child: Text('테스트 정보를 불러올 수 없습니다.'));
          }

          final test = provider.currentTest!;
          final currentIndex = provider.currentQuestionIndex;
          
          if (currentIndex >= test.questions.length) {
            return const Center(child: Text('더 이상 질문이 없습니다.'));
          }
          
          final currentQuestion = test.questions[currentIndex];
          
          return Column(
            children: [
              _buildProgressBar(provider),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${currentIndex + 1}.',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B73FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ...List.generate(
                        currentQuestion.options.length,
                        (optionIndex) => _buildOptionCard(
                          context,
                          optionIndex,
                          currentQuestion.options[optionIndex],
                          isSelected: currentQuestion.selectedOptionIndex == optionIndex,
                          onTap: () {
                            provider.selectOption(currentIndex, optionIndex);
                            
                            // 마지막 질문이거나 다음 버튼을 사용하는 경우 자동 진행하지 않음
                            if (provider.isLastQuestion) {
                              return;
                            }
                            
                            // 잠시 후 자동으로 다음 질문으로 이동
                            Future.delayed(const Duration(milliseconds: 500), () {
                              provider.nextQuestion();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(PsychologyTestProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${provider.currentQuestionIndex + 1}/${provider.currentTest?.questions.length ?? 0}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B73FF),
                ),
              ),
              Text(
                '${(provider.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B73FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: provider.progress,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, 
    int optionIndex,
    PsychologyTestOption option, 
    {required bool isSelected, required VoidCallback onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFFE2E8F0),
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Color(0x1A6B73FF),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFFF7FAFC),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFFE2E8F0),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : Center(
                        child: Text(
                          String.fromCharCode(65 + optionIndex), // A, B, C, D...
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? const Color(0xFF2D3748) : const Color(0xFF4A5568),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, PsychologyTestProvider provider) {
    final currentIndex = provider.currentQuestionIndex;
    final totalQuestions = provider.currentTest!.questions.length;
    final isLastQuestion = provider.isLastQuestion;
    final canMoveNext = provider.currentTest!.questions[currentIndex].selectedOptionIndex != null;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => provider.previousQuestion(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF6B73FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '이전',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B73FF),
                  ),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canMoveNext
                  ? () {
                      if (isLastQuestion) {
                        provider.completeTest();
                        context.push('/psychology-test-result');
                      } else {
                        provider.nextQuestion();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF6B73FF),
                disabledBackgroundColor: const Color(0xFFB0B0B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isLastQuestion ? '결과 보기' : '다음',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('검사 종료'),
        content: const Text('진행 중인 검사를 종료하시겠습니까?\n지금까지의 답변은 저장되지 않습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속 진행'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<PsychologyTestProvider>().endTest();
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('종료하기'),
          ),
        ],
      ),
    );
  }
} 