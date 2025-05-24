import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/history_provider.dart';
import '../../emotion/providers/emotion_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    historyProvider.loadRecentEntries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Column(
        children: [
          // 탭 바
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6B73FF),
              unselectedLabelColor: const Color(0xFF718096),
              indicatorColor: const Color(0xFF6B73FF),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'NotoSansKR',
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'NotoSansKR',
              ),
              tabs: const [
                Tab(text: '기록'),
                Tab(text: '통계'),
              ],
            ),
          ),
          
          // 탭 바 뷰
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryTab(),
                _buildStatisticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        if (historyProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (historyProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  historyProvider.errorMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    fontFamily: 'NotoSansKR',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text(
                    '다시 시도',
                    style: TextStyle(fontFamily: 'NotoSansKR'),
                  ),
                ),
              ],
            ),
          );
        }

        if (historyProvider.recentEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_neutral,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  '아직 기록된 감정이 없어요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '첫 번째 감정을 기록해보세요!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // 감정 입력 화면으로 이동
                    Navigator.of(context).pushNamed('/emotion-input');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    '감정 기록하기',
                    style: TextStyle(fontFamily: 'NotoSansKR'),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await historyProvider.loadRecentEntries();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyProvider.recentEntries.length,
            itemBuilder: (context, index) {
              final entry = historyProvider.recentEntries[index];
              return _buildHistoryCard(entry);
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(EmotionEntry entry) {
    return Container(
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
                _getEmotionEmoji(entry.emotion),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title ?? _getEmotionLabel(entry.emotion),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          DateFormat('yyyy년 MM월 dd일 HH:mm').format(entry.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF718096),
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                        if (entry.score != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getEmotionColor(entry.emotion).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '강도 ${entry.score!.toStringAsFixed(1)}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getEmotionColor(entry.emotion),
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF718096),
                ),
                onSelected: (value) => _handleEntryAction(value, entry),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '수정',
                          style: TextStyle(fontFamily: 'NotoSansKR'),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          '삭제',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (entry.content != null && entry.content!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              entry.content!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568),
                fontFamily: 'NotoSansKR',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이번 주 통계
          _buildWeeklyStatsCard(),
          const SizedBox(height: 16),

          // 감정별 통계
          _buildEmotionStatsCard(),
          const SizedBox(height: 16),

          // 월별 트렌드 (추후 구현)
          _buildTrendCard(),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsCard() {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        final weeklyStats = historyProvider.getWeeklyStats();
        
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
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '총 기록',
                    '${weeklyStats['total'] ?? 0}회',
                    Icons.edit,
                    const Color(0xFF6B73FF),
                  ),
                  _buildStatItem(
                    '연속 기록',
                    '${weeklyStats['streak'] ?? 0}일',
                    Icons.local_fire_department,
                    const Color(0xFFE53E3E),
                  ),
                  _buildStatItem(
                    '평균 강도',
                    '${weeklyStats['avgScore'] ?? '0.0'}',
                    Icons.star,
                    const Color(0xFFD69E2E),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
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
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
            fontFamily: 'NotoSansKR',
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionStatsCard() {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        final emotionCounts = historyProvider.getEmotionCounts();
        
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
                    Icons.pie_chart,
                    color: Color(0xFF6B73FF),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '감정별 통계',
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
              
              if (emotionCounts.isEmpty)
                const Center(
                  child: Text(
                    '아직 충분한 데이터가 없어요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF718096),
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                )
              else
                ...emotionCounts.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          _getEmotionEmoji(entry.key),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getEmotionLabel(entry.key),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3748),
                              fontFamily: 'NotoSansKR',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getEmotionColor(entry.key).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${entry.value}회',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _getEmotionColor(entry.key),
                              fontFamily: 'NotoSansKR',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendCard() {
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
                Icons.trending_up,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '감정 트렌드',
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
          
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                const Text(
                  '곧 출시될 기능이에요!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '시간별 감정 변화를 차트로 보여드릴 예정입니다',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA0AEC0),
                    fontFamily: 'NotoSansKR',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleEntryAction(String action, EmotionEntry entry) {
    switch (action) {
      case 'edit':
        _showEditDialog(entry);
        break;
      case 'delete':
        _showDeleteConfirmation(entry);
        break;
    }
  }

  void _showEditDialog(EmotionEntry entry) {
    // TODO: 편집 다이얼로그 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '편집 기능은 곧 구현될 예정입니다',
          style: TextStyle(fontFamily: 'NotoSansKR'),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(EmotionEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '기록 삭제',
          style: TextStyle(fontFamily: 'NotoSansKR'),
        ),
        content: const Text(
          '이 감정 기록을 삭제하시겠습니까?\n삭제된 기록은 복구할 수 없습니다.',
          style: TextStyle(fontFamily: 'NotoSansKR'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '취소',
              style: TextStyle(fontFamily: 'NotoSansKR'),
            ),
          ),
          Consumer<EmotionProvider>(
            builder: (context, emotionProvider, child) => TextButton(
              onPressed: emotionProvider.isLoading
                  ? null
                  : () async {
                      final success = await emotionProvider.deleteEmotionEntry(entry.id);
                      if (success && context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '기록이 삭제되었습니다',
                              style: TextStyle(fontFamily: 'NotoSansKR'),
                            ),
                          ),
                        );
                        _loadData(); // 데이터 새로고침
                      }
                    },
              child: emotionProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      '삭제',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'excited':
        return '🤩';
      case 'calm':
        return '😌';
      case 'neutral':
        return '😐';
      case 'sad':
        return '😢';
      case 'angry':
        return '😡';
      case 'anxious':
        return '😰';
      case 'tired':
        return '😴';
      default:
        return '😐';
    }
  }

  String _getEmotionLabel(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return '기쁨';
      case 'excited':
        return '신남';
      case 'calm':
        return '평온';
      case 'neutral':
        return '보통';
      case 'sad':
        return '슬픔';
      case 'angry':
        return '화남';
      case 'anxious':
        return '불안';
      case 'tired':
        return '피곤';
      default:
        return '보통';
    }
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return const Color(0xFF38A169);
      case 'excited':
        return const Color(0xFFD69E2E);
      case 'calm':
        return const Color(0xFF38B2AC);
      case 'neutral':
        return const Color(0xFF718096);
      case 'sad':
        return const Color(0xFF4299E1);
      case 'angry':
        return const Color(0xFFE53E3E);
      case 'anxious':
        return const Color(0xFF9F7AEA);
      case 'tired':
        return const Color(0xFF718096);
      default:
        return const Color(0xFF718096);
    }
  }
} 