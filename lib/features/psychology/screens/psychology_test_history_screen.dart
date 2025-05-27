import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/psychology_test_provider.dart';
import '../../../core/models/psychology_test_model.dart';

class PsychologyTestHistoryScreen extends StatelessWidget {
  const PsychologyTestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '검사 기록',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PsychologyTestProvider>(
        builder: (context, provider, _) {
          final testHistory = provider.testHistory;
          
          if (testHistory.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 64,
                    color: Color(0xFFE2E8F0),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '아직 완료한 심리검사가 없습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildFilterSection(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: testHistory.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final result = testHistory[index];
                    return _buildHistoryCard(context, result);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            '정렬:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: '최신순',
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B73FF)),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B73FF),
            ),
            items: const [
              DropdownMenuItem(
                value: '최신순',
                child: Text('최신순'),
              ),
              DropdownMenuItem(
                value: '오래된순',
                child: Text('오래된순'),
              ),
            ],
            onChanged: (value) {
              // 정렬 기능 구현 예정
            },
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {
              // 필터 기능 구현 예정
            },
            icon: const Icon(
              Icons.filter_list,
              size: 18,
            ),
            label: const Text('필터'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B73FF),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, PsychologyTestResult result) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('/psychology-test-result', extra: result),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        result.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.psychology_alt,
                            size: 24,
                            color: Color(0xFF6B73FF),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTestTitle(result.testId),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${result.completedAt.year}.${result.completedAt.month}.${result.completedAt.day}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B73FF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                result.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildKeywordChip(result.characteristics.isNotEmpty ? result.characteristics[0] : '특성 없음'),
                  const SizedBox(width: 8),
                  if (result.characteristics.length > 1)
                    _buildKeywordChip(result.characteristics[1]),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF6B73FF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeywordChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF6B73FF),
        ),
      ),
    );
  }

  String _getTestTitle(String testId) {
    switch (testId) {
      case 'emotion_response':
        return '감정 대응 유형 검사';
      case 'stress_response':
        return '스트레스 대응 유형 검사';
      case 'illusion_index':
        return '착각지수 체크리스트';
      default:
        return '심리 검사';
    }
  }
} 