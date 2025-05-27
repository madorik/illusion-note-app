import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/history_provider.dart';
import '../../emotion/providers/emotion_provider.dart';
import '../../../core/models/emotion_analysis_model.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/utils/emotion_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _setupScrollListener();
    _loadData();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
        historyProvider.loadMoreEntries();
      }
    });
  }

  void _loadData() {
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    historyProvider.loadRecentEntries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 헤더 섹션
          _buildHeader(),
          
          // 탭 바
          _buildTabBar(),
          
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '감정 기록',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '당신의 감정 여행을 되돌아보세요',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6B73FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => context.push('/calendar'),
              icon: const Icon(
                Icons.calendar_today,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              tooltip: '달력 보기',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF6B73FF),
        unselectedLabelColor: const Color(0xFF718096),
        indicatorColor: const Color(0xFF6B73FF),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: '최근 기록'),
          Tab(text: '통계'),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        if (historyProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6B73FF),
            ),
          );
        }

        if (historyProvider.errorMessage != null) {
          return _buildErrorState(historyProvider.errorMessage!);
        }

        if (historyProvider.emotionPosts.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await historyProvider.loadRecentEntries();
          },
          color: const Color(0xFF6B73FF),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: historyProvider.emotionPosts.length + (historyProvider.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == historyProvider.emotionPosts.length) {
                return _buildLoadingIndicator(historyProvider);
              }
              
              final post = historyProvider.emotionPosts[index];
              return _buildNewsStyleCard(post, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildNewsStyleCard(EmotionPost post, int index) {
    final isEven = index % 2 == 0;
    
    return GestureDetector(
      onTap: () => context.push('/emotion-detail', extra: post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // 감정 아바타
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getEmotionColorFromString(post.emotion),
                          _getEmotionColorFromString(post.emotion).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: EmotionUtils.buildEmotionImage(
                        emotion: post.emotion,
                        size: 24,
                        fallbackIconColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 메타 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getEmotionColorFromString(post.emotion).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                post.emotion,
                                style: GoogleFonts.inter(
                                  color: _getEmotionColorFromString(post.emotion),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              TimeUtils.getRelativeTime(post.createdAt),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF718096),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          TimeUtils.getSmartDateTimeDisplay(post.createdAt),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 콘텐츠 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    post.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A202C),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // 내용 미리보기
                  Text(
                    post.text,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF4A5568),
                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // AI 응답 섹션 (있는 경우)
            if (post.response.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6B73FF).withOpacity(0.05),
                      const Color(0xFF9F7AEA).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6B73FF).withOpacity(0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B73FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Color(0xFF6B73FF),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI 분석',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B73FF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post.response,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF4A5568),
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // 하단 액션 바
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.visibility_outlined,
                    label: '자세히 보기',
                    onTap: () => context.push('/emotion-detail', extra: post),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: '공유',
                    onTap: () {
                      // 공유 기능 구현
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF718096),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6B73FF).withOpacity(0.1),
                    const Color(0xFF9F7AEA).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.sentiment_neutral,
                size: 60,
                color: Color(0xFF6B73FF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '아직 기록된 감정이 없어요',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '첫 번째 감정을 기록하고\n당신만의 감정 여행을 시작해보세요',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF718096),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => context.push('/emotion-input'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  '감정 기록하기',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '오류가 발생했어요',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF718096),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B73FF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(
                '다시 시도',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(HistoryProvider historyProvider) {
    if (!historyProvider.isLoadingMore) return const SizedBox();
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6B73FF),
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        if (historyProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6B73FF),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '감정 통계',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 20),
              
              // 주간 통계
              _buildStatCard(
                title: '이번 주 기록',
                value: '${historyProvider.weeklyStats.totalEntries}개',
                subtitle: '지난 주 대비 ${historyProvider.weeklyStats.changeFromLastWeek > 0 ? '+' : ''}${historyProvider.weeklyStats.changeFromLastWeek}개',
                icon: Icons.calendar_today,
                color: const Color(0xFF6B73FF),
              ),
              
              const SizedBox(height: 16),
              
              // 가장 많은 감정
              _buildStatCard(
                title: '가장 많은 감정',
                value: historyProvider.weeklyStats.mostCommonEmotion.isNotEmpty 
                    ? historyProvider.weeklyStats.mostCommonEmotion 
                    : '없음',
                subtitle: '${historyProvider.weeklyStats.mostCommonEmotionCount}회 기록',
                icon: Icons.favorite,
                color: const Color(0xFFED8936),
              ),
              
              const SizedBox(height: 16),
              
              // 평균 감정 점수
              _buildStatCard(
                title: '평균 감정 점수',
                value: historyProvider.weeklyStats.averageScore.toStringAsFixed(1),
                subtitle: '10점 만점',
                icon: Icons.trending_up,
                color: const Color(0xFF38A169),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 유틸리티 메서드들
  Color _getEmotionColorFromString(String emotion) {
    switch (emotion.toLowerCase()) {
      case '기쁨':
      case '좋음':
      case '행복':
        return const Color(0xFFFFD93D);
      case '슬픔':
      case '우울':
        return const Color(0xFF4A90E2);
      case '화남':
      case '분노':
        return const Color(0xFFFF6B6B);
      case '불안':
      case '걱정':
        return const Color(0xFFFF8C42);
      case '평온':
      case '차분':
        return const Color(0xFF4ECDC4);
      case '놀람':
        return const Color(0xFF9B59B6);
      case '사랑':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF6B73FF);
    }
  }




} 