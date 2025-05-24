import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../auth/providers/mock_auth_provider.dart';
import '../../emotion/providers/emotion_provider.dart';
import '../../history/providers/history_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // 필요한 데이터 로드
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    historyProvider.loadRecentEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 인사 및 프로필
            _buildUserGreeting(),
            const SizedBox(height: 24),

            // 빠른 액션 버튼들
            _buildQuickActions(),
            const SizedBox(height: 24),

            // 오늘의 감정 상태
            _buildTodayEmotionStatus(),
            const SizedBox(height: 24),

            // 최근 기록
            _buildRecentEntries(),
            const SizedBox(height: 24),

            // 통계 정보
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Consumer<MockAuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final userName = user?.displayName ?? user?.email?.split('@')[0] ?? '사용자';
        final currentHour = DateTime.now().hour;
        String greeting;

        if (currentHour < 12) {
          greeting = '좋은 아침이에요';
        } else if (currentHour < 18) {
          greeting = '좋은 오후에요';
        } else {
          greeting = '좋은 저녁이에요';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting!',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$userName님',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '오늘의 감정은 어떠신가요?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: user?.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          user!.photoURL!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '빠른 실행',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
            fontFamily: 'NotoSansKR',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.add_circle,
                title: '감정 기록',
                subtitle: '지금 느끼는 감정을\n기록해보세요',
                color: const Color(0xFF6B73FF),
                onTap: () => context.push('/emotion-input'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.history,
                title: '기록 보기',
                subtitle: '지난 감정 기록을\n확인해보세요',
                color: const Color(0xFF38B2AC),
                onTap: () => context.push('/history'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                fontFamily: 'NotoSansKR',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF718096),
                fontFamily: 'NotoSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayEmotionStatus() {
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
              const Icon(
                Icons.today,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 감정',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontFamily: 'NotoSansKR',
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('MM월 dd일').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<EmotionProvider>(
            builder: (context, emotionProvider, child) {
              final todayEntries = emotionProvider.getTodayEntries();
              
              if (todayEntries.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sentiment_neutral,
                        size: 48,
                        color: Color(0xFF718096),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '오늘 아직 감정을 기록하지 않았어요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF718096),
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => context.push('/emotion-input'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B73FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '지금 기록하기',
                          style: TextStyle(fontFamily: 'NotoSansKR'),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildEmotionStat('😊', '긍정', todayEntries.where((e) => e.emotion == 'positive').length),
                      _buildEmotionStat('😢', '부정', todayEntries.where((e) => e.emotion == 'negative').length),
                      _buildEmotionStat('😐', '중립', todayEntries.where((e) => e.emotion == 'neutral').length),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '총 ${todayEntries.length}개의 감정을 기록했어요',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF718096),
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionStat(String emoji, String label, int count) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
            fontFamily: 'NotoSansKR',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$count회',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
            fontFamily: 'NotoSansKR',
          ),
        ),
      ],
    );
  }

  Widget _buildRecentEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '최근 기록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                fontFamily: 'NotoSansKR',
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/history'),
              child: const Text(
                '전체보기',
                style: TextStyle(
                  color: Color(0xFF6B73FF),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<HistoryProvider>(
          builder: (context, historyProvider, child) {
            final recentEntries = historyProvider.recentEntries.take(3).toList();
            
            if (recentEntries.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '아직 기록된 감정이 없어요\n첫 번째 감정을 기록해보세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              );
            }

            return Column(
              children: recentEntries.map((entry) => _buildEntryCard(entry)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEntryCard(dynamic entry) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Text(
                _getEmotionEmoji(entry.emotion ?? 'neutral'),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.title ?? '감정 기록',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
              Text(
                DateFormat('MM/dd HH:mm').format(entry.createdAt ?? DateTime.now()),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          if (entry.content != null && entry.content!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              entry.content!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568),
                fontFamily: 'NotoSansKR',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatistics() {
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
                Icons.analytics,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '이번 주 통계',
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
          Consumer<HistoryProvider>(
            builder: (context, historyProvider, child) {
              final weeklyStats = historyProvider.getWeeklyStats();
              
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('총 기록', '${weeklyStats['total'] ?? 0}회', Icons.edit),
                  _buildStatCard('연속 기록', '${weeklyStats['streak'] ?? 0}일', Icons.local_fire_department),
                  _buildStatCard('평균 점수', '${weeklyStats['avgScore'] ?? 0}점', Icons.star),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF6B73FF),
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
            fontFamily: 'NotoSansKR',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
            fontFamily: 'NotoSansKR',
          ),
        ),
      ],
    );
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'positive':
      case 'happy':
      case 'joy':
        return '😊';
      case 'negative':
      case 'sad':
      case 'angry':
        return '😢';
      case 'neutral':
        return '😐';
      case 'excited':
        return '🤩';
      case 'calm':
        return '😌';
      default:
        return '😐';
    }
  }
} 