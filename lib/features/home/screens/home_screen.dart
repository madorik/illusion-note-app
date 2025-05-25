import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../emotion/providers/emotion_provider.dart';
import '../../history/providers/history_provider.dart';
import '../../../core/models/emotion_analysis_model.dart';
import '../../../services/service_locator.dart';
import '../../../core/utils/time_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EmotionPost? _todayEmotion;
  bool _isLoadingTodayEmotion = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // 필요한 데이터 로드
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    historyProvider.loadRecentEntries();
    
    // 오늘의 감정 로드
    _loadTodayEmotion();
  }

  Future<void> _loadTodayEmotion() async {
    setState(() {
      _isLoadingTodayEmotion = true;
    });

    try {
      // 최근 감정 기록들을 가져와서 오늘 것만 필터링
      final recentEmotions = await services.emotionService.getRecentEmotions(count: 50);
      final today = TimeUtils.nowInKorea();
      
      // 오늘 날짜의 감정 기록 찾기
      EmotionPost? todayEmotion;
      for (final post in recentEmotions.posts) {
        final koreaPostDate = post.createdAt.isUtc ? TimeUtils.toKoreaTime(post.createdAt) : post.createdAt;
        if (koreaPostDate.year == today.year &&
            koreaPostDate.month == today.month &&
            koreaPostDate.day == today.day) {
          todayEmotion = post;
          break; // 가장 최근 것만 사용
        }
      }
      
      setState(() {
        _todayEmotion = todayEmotion;
        _isLoadingTodayEmotion = false;
      });
      
    } catch (e) {
      setState(() {
        _todayEmotion = null;
        _isLoadingTodayEmotion = false;
      });
      
      // 사용자에게 에러 표시 (선택적)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오늘의 감정을 불러오는데 실패했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildQuickActions(),
              const SizedBox(height: 32),
              _buildEmotionStatus(),
              const SizedBox(height: 32),
              _buildWeeklyStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting!',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$userName님',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '오늘 기분은 어떠신가요?',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.lightBlue,
                backgroundImage: user?.photoURL != null 
                    ? NetworkImage(user!.photoURL!) 
                    : null,
                child: user?.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 28,
                        color: AppColors.primaryBlue,
                      )
                    : null,
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
        Text(
          '빠른 실행',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                '감정 기록',
                '지금 느끼는 감정을\n기록해보세요',
                Icons.edit_note,
                AppColors.primaryBlue,
                () async {
                  final result = await context.push('/emotion-input');
                  // 감정 기록 후 돌아오면 새로고침
                  if (result == true) {
                    _loadTodayEmotion();
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                '기록 보기',
                '이전 감정 기록들을\n확인해보세요',
                Icons.history,
                AppColors.successGreen,
                () => context.push('/history'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    size: 20,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionStatus() {
    return Container(
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
                Icons.favorite,
                color: AppColors.errorRed,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 감정',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _isLoadingTodayEmotion ? null : _loadTodayEmotion,
                icon: _isLoadingTodayEmotion 
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                        ),
                      )
                    : Icon(
                        Icons.refresh,
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                tooltip: _isLoadingTodayEmotion ? '로딩 중...' : '오늘의 감정 새로고침',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_isLoadingTodayEmotion)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_todayEmotion == null)
            GestureDetector(
              onTap: () async {
                final result = await context.push('/emotion-input');
                // 감정 기록 후 돌아오면 새로고침
                if (result == true) {
                  _loadTodayEmotion();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_neutral,
                      color: AppColors.textTertiary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '아직 오늘의 감정을 기록하지 않았어요.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '첫 감정을 기록해보세요!',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '현재 시간: ${TimeUtils.formatKoreaTime(TimeUtils.nowInKorea(), pattern: 'MM월 dd일 HH:mm')}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textTertiary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => context.push('/emotion-detail', extra: _todayEmotion),
              child: _buildTodayEmotionCard(_todayEmotion!),
            ),
        ],
      ),
    );
  }

  Widget _buildTodayEmotionCard(EmotionPost emotion) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getEmotionColorFromString(emotion.emotion).withOpacity(0.1),
            _getEmotionColorFromString(emotion.emotion).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getEmotionColorFromString(emotion.emotion).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getEmotionColorFromString(emotion.emotion),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  emotion.emotion,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    TimeUtils.getRelativeTime(emotion.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    TimeUtils.formatKoreaTime(emotion.createdAt, pattern: 'MM/dd HH:mm'),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            emotion.title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            emotion.text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: _getEmotionColorFromString(emotion.emotion),
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'AI 분석 완료',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _getEmotionColorFromString(emotion.emotion),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textTertiary,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이번 주 통계',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Consumer<EmotionProvider>(
            builder: (context, emotionProvider, child) {
              final stats = emotionProvider.getWeeklyStats();
              
              return Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      '총 기록',
                      '${stats['total']}개',
                      AppColors.primaryBlue,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      '연속 기록',
                      '${stats['streak']}일',
                      AppColors.successGreen,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      '평균 점수',
                      stats['avgScore'],
                      AppColors.warningOrange,
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

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getEmotionColorFromString(String emotion) {
    switch (emotion) {
      case '기쁨':
      case '행복':
      case '좋음':
        return const Color(0xFFEF4444);
      case '슬픔':
      case '우울':
        return const Color(0xFF3B82F6);
      case '화남':
      case '분노':
        return const Color(0xFFDC2626);
      case '불안':
      case '걱정':
        return const Color(0xFF8B5CF6);
      case '놀람':
        return const Color(0xFF10B981);
      case '평온':
      case '차분':
        return const Color(0xFF06B6D4);
      case '피곤':
      case '지침':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B73FF);
    }
  }
} 