import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/psychology_test_provider.dart';
import '../../../core/models/psychology_test_model.dart';

class PsychologyTestListScreen extends StatelessWidget {
  const PsychologyTestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PsychologyTestProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                const Text(
                  '심리검사로 나를 더 알아봐요',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '신뢰할 수 있는 심리검사를 통해 나의 성격과 감정 패턴을 파악해보세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTestList(context, provider),
                const SizedBox(height: 32),
                _buildHistorySection(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6B73FF).withOpacity(0.9),
            const Color(0xFF000DFF).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B73FF).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_alt,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '심리검사',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '내면의 자아를 탐색하는 여정',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '재미있고 간단한 심리검사를 통해\n나의 감정 패턴과 성격 유형을 알아보세요.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestList(BuildContext context, PsychologyTestProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: provider.tests.map((test) => _buildTestCard(context, test, provider)).toList(),
    );
  }

  Widget _buildTestCard(BuildContext context, PsychologyTest test, PsychologyTestProvider provider) {
    final bool isLocked = test.isPremium && !provider.isPremiumUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLocked 
            ? () => _showPremiumDialog(context) 
            : () {
                provider.startTest(test.id);
                context.push('/psychology-test-question');
              },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFFF0F4FF),
                    child: test.thumbnail != null 
                      ? Image.asset(test.thumbnail!, fit: BoxFit.cover)
                      : const Icon(Icons.psychology, size: 40, color: Color(0xFF6B73FF)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              test.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          if (test.isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLocked ? Colors.grey[300] : const Color(0xFFFFF4DE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isLocked ? Icons.lock : Icons.workspace_premium,
                                    size: 12,
                                    color: isLocked ? Colors.grey[700] : const Color(0xFFFFB020),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '프리미엄',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isLocked ? Colors.grey[700] : const Color(0xFFFFB020),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        test.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoChip(Icons.access_time, test.timeEstimate),
                          const SizedBox(width: 12),
                          _buildInfoChip(Icons.question_answer_outlined, '${test.questionCount}문항'),
                          const SizedBox(width: 12),
                          _buildInfoChip(
                            test.isCompleted ? Icons.check_circle_outline : Icons.circle_outlined, 
                            test.isCompleted ? '완료' : '미완료', 
                            color: test.isCompleted ? Colors.green : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color color = const Color(0xFF718096)}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, PsychologyTestProvider provider) {
    if (provider.testHistory.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '내 검사 기록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.testHistory.length > 3 ? 3 : provider.testHistory.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final result = provider.testHistory[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: const Color(0xFFF0F4FF),
                    child: Image.asset(
                      result.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.psychology, size: 24, color: Color(0xFF6B73FF));
                      },
                    ),
                  ),
                ),
                title: Text(
                  result.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${result.completedAt.year}.${result.completedAt.month}.${result.completedAt.day}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/psychology-test-result', extra: result),
              );
            },
          ),
        ),
        if (provider.testHistory.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: () => context.push('/psychology-test-history'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '모든 기록 보기',
                    style: TextStyle(
                      color: Color(0xFF6B73FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Color(0xFF6B73FF),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: Color(0xFFFFB020),
            ),
            SizedBox(width: 12),
            Text('프리미엄 기능'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '이 심리검사는 프리미엄 회원만 이용할 수 있습니다.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '프리미엄 멤버십에 가입하고 모든 심리검사를 무제한으로 이용해보세요!',
              style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              // TODO: 실제 구현에서는 결제 페이지로 이동
              context.read<PsychologyTestProvider>().setPremiumUser(true);
            },
            child: const Text(
              '프리미엄 가입하기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 