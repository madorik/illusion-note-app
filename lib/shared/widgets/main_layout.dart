import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  
  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: '홈',
      route: '/home',
    ),
    NavigationItem(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: '기록',
      route: '/history',
    ),
    NavigationItem(
      icon: Icons.recommend_outlined,
      selectedIcon: Icons.recommend,
      label: '추천',
      route: '/recommendation',
    ),
    NavigationItem(
      icon: Icons.psychology_outlined,
      selectedIcon: Icons.psychology,
      label: '심리검사',
      route: '/psychology',
    ),
    NavigationItem(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month,
      label: '캘린더',
      route: '/calendar',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouter.of(context).state?.fullPath ?? '';
    for (int i = 0; i < _items.length; i++) {
      if (location.startsWith(_items[i].route)) {
    setState(() {
          _selectedIndex = i;
    });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFF6B73FF).withOpacity(0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  border: Border.all(
                    color: const Color(0xFF6B73FF).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.menu_outlined,
                  color: Color(0xFF6B73FF),
                  size: 20,
                ),
              ),
              onSelected: (value) => _handleMainMenuAction(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'emotion_input',
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF6B73FF)),
                      SizedBox(width: 12),
                      Text('감정기록'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history_outlined, size: 20, color: Color(0xFF6B73FF)),
                      SizedBox(width: 12),
                      Text('기록보기'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'calendar',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 20, color: Color(0xFF6B73FF)),
                      SizedBox(width: 12),
                      Text('캘린더'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'chat',
                  child: Row(
                    children: [
                      Icon(Icons.chat_outlined, size: 20, color: Color(0xFF6B73FF)),
                      SizedBox(width: 12),
                      Text('감정 대화'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'recommendation',
                  child: Row(
                    children: [
                      Icon(Icons.recommend_outlined, size: 20, color: Color(0xFF6B73FF)),
                      SizedBox(width: 12),
                      Text('감정 맞춤 추천'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'psychology',
                  child: Row(
                    children: [
                      Icon(Icons.psychology_outlined, size: 20, color: Color(0xFF6B73FF)),
                      SizedBox(width: 12),
                      Text('심리 검사'),
                    ],
                  ),
                ),
              ],
            ),
            title: Text(
              _getCurrentPageTitle(),
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
        actions: [
          // 알림 버튼
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF718096),
            ),
            onPressed: () {
              _showNotificationsBottomSheet(context);
            },
          ),
          
          // 프로필 메뉴
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF718096),
            ),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('프로필'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
          ),
        ),
      ),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _getCurrentPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return '착각노트';
      case 1:
        return '감정 기록';
      case 2:
        return '감정 맞춤 추천';
      case 3:
        return '심리 검사';
      case 4:
        return '감정 캘린더';
      default:
        return '착각노트';
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < _items.length; i++) 
                _buildNavItem(_items[i], i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
          context.go(item.route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? item.selectedIcon : item.icon,
            color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFF718096),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF6B73FF) : const Color(0xFF718096),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => context.push('/emotion-input'),
      backgroundColor: const Color(0xFF6B73FF),
      elevation: 8,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _handleMainMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'emotion_input':
        context.push('/emotion-input');
        break;
      case 'history':
        context.push('/history');
        break;
      case 'calendar':
        context.push('/calendar');
        break;
      case 'statistics':
        context.push('/statistics');
        break;
      case 'chat':
        context.push('/emotion-chat');
        break;
      case 'recommendation':
        context.push('/recommendation');
        break;
      case 'psychology':
        context.push('/psychology');
        break;
    }
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        _showProfileBottomSheet(context);
        break;
      case 'settings':
        context.push('/settings');
        break;
      case 'logout':
        _showLogoutConfirmation(context);
        break;
    }
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '알림',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '새로운 알림이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          return Container(
            padding: const EdgeInsets.all(20),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '프로필',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 프로필 정보
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF6B73FF).withOpacity(0.1),
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
                                    color: Color(0xFF6B73FF),
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 30,
                              color: Color(0xFF6B73FF),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? '사용자',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // 프로필 메뉴들
                _buildProfileMenuItem(
                  icon: Icons.edit,
                  title: '프로필 편집',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: 프로필 편집 화면으로 이동
                  },
                ),
                _buildProfileMenuItem(
                  icon: Icons.security,
                  title: '계정 보안',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: 계정 보안 화면으로 이동
                  },
                ),
                _buildProfileMenuItem(
                  icon: Icons.privacy_tip,
                  title: '개인정보 보호',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: 개인정보 보호 화면으로 이동
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B73FF)),
      title: Text(
        title,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '로그아웃',
        ),
        content: const Text(
          '정말 로그아웃하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '취소',
            ),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) => TextButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      await authProvider.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        context.go('/login');
                      }
                    },
              child: authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      '로그아웃',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final bool isMenuTab;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    this.isMenuTab = false,
  });
} 