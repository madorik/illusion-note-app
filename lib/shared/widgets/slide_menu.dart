import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideMenu extends StatefulWidget {
  const SlideMenu({super.key});

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeMenu() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeMenu,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Stack(
          children: [
            // 배경 터치 영역
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                child: Container(color: Colors.transparent),
              ),
            ),
            
            // 슬라이드 메뉴 본체
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    elevation: 16,
                    shadowColor: Colors.black.withOpacity(0.3),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: _buildMenuContent(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return SafeArea(
      child: Column(
        children: [
          // 헤더 섹션
          _buildMenuHeader(),
          
          // 메뉴 아이템들
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),
                _buildMenuSection('주요 기능', [
                  _MenuItemData(
                    icon: Icons.add_circle_outline,
                    title: '감정 기록',
                    subtitle: '오늘의 감정을 기록해보세요',
                    route: '/emotion-input',
                    color: const Color(0xFF6B73FF),
                  ),
                  _MenuItemData(
                    icon: Icons.history_outlined,
                    title: '기록 보기',
                    subtitle: '지난 감정 기록들을 확인',
                    route: '/history',
                    color: const Color(0xFF8B5CF6),
                  ),
                  _MenuItemData(
                    icon: Icons.chat_outlined,
                    title: '감정 대화',
                    subtitle: 'AI와 감정 대화하기',
                    route: '/emotion-chat',
                    color: const Color(0xFF10B981),
                  ),
                  _MenuItemData(
                    icon: Icons.recommend_outlined,
                    title: '감정 맞춤 추천',
                    subtitle: '당신을 위한 맞춤 추천',
                    route: '/recommendation',
                    color: const Color(0xFFF59E0B),
                  ),
                ]),
                
                _buildMenuDivider(),
                
                _buildMenuSection('분석 도구', [
                  _MenuItemData(
                    icon: Icons.psychology_outlined,
                    title: '심리 검사',
                    subtitle: '나의 심리 상태 분석',
                    route: '/psychology',
                    color: const Color(0xFFEF4444),
                  ),
                  _MenuItemData(
                    icon: Icons.calendar_month_outlined,
                    title: '감정 캘린더',
                    subtitle: '감정 변화를 달력으로',
                    route: '/calendar',
                    color: const Color(0xFF3B82F6),
                  ),
                  _MenuItemData(
                    icon: Icons.insights_outlined,
                    title: '통계 분석',
                    subtitle: '상세한 감정 통계',
                    route: '/statistics',
                    color: const Color(0xFF8B5CF6),
                  ),
                ]),
                
                _buildMenuDivider(),
                
                _buildMenuSection('설정', [
                  _MenuItemData(
                    icon: Icons.settings_outlined,
                    title: '설정',
                    subtitle: '앱 설정 및 환경설정',
                    route: '/settings',
                    color: const Color(0xFF6B7280),
                  ),
                  _MenuItemData(
                    icon: Icons.help_outline,
                    title: '도움말',
                    subtitle: 'FAQ 및 사용 가이드',
                    route: '/help',
                    color: const Color(0xFF6B7280),
                  ),
                  _MenuItemData(
                    icon: Icons.local_hospital_outlined,
                    title: '전문 도움받기',
                    subtitle: '심리 치료사 및 전문 상담',
                    route: '/professional-help',
                    color: const Color(0xFFEF4444),
                  ),
                ]),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6B73FF),
                  Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '착각노트',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                Text(
                  '감정을 이해하는 여정',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _closeMenu,
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xFF6B7280),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItemData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(item)).toList(),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // 메뉴를 먼저 완전히 닫고 나서 네비게이션
            _animationController.reverse().then((_) {
              if (mounted) {
                Navigator.of(context).pop();
                
                // 메뉴가 완전히 닫힌 후 네비게이션 실행
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (!mounted) return;
                  
                  try {
                    switch (item.route) {
                      case '/emotion-input':
                      case '/history':
                      case '/emotion-chat':
                      case '/recommendation':
                      case '/psychology':
                      case '/calendar':
                      case '/settings':
                      case '/statistics':
                      case '/help':
                      case '/professional-help':
                        context.push(item.route);
                        break;
                      default:
                        _showComingSoonMessage(item.route);
                        break;
                    }
                  } catch (e) {
                    if (mounted) {
                      context.go('/home');
                    }
                  }
                });
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonMessage(String route) {
    if (!mounted) return;
    
    String featureName = '';
    switch (route) {
      case '/language-settings':
        featureName = '언어 설정';
        break;
      case '/data-export':
        featureName = '데이터 내보내기';
        break;
      case '/privacy-policy':
        featureName = '개인정보 처리방침';
        break;
      case '/security-settings':
        featureName = '보안 설정';
        break;
      case '/feedback':
        featureName = '피드백';
        break;
      default:
        featureName = '해당 기능';
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$featureName 기능을 준비 중입니다.',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFE5E7EB),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  const _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
} 