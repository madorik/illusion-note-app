import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _getCurrentPageTitle(),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansKR',
          ),
        ),
        actions: [
          // 알림 버튼 (향후 Firebase Cloud Messaging 연동)
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF718096),
            ),
            onPressed: () {
              _showNotificationsBottomSheet(context);
            },
          ),
          
          // 프로필/설정 메뉴
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
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
                    Text(
                      '프로필',
                      style: TextStyle(fontFamily: 'NotoSansKR'),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 12),
                    Text(
                      '설정',
                      style: TextStyle(fontFamily: 'NotoSansKR'),
                    ),
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
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _getCurrentPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return '착각노트';
      case 1:
        return '감정 기록';
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
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < _items.length; i++) ...[
                _buildNavItem(_items[i], i),
                if (i == 0) const SizedBox(width: 40), // FAB를 위한 공간
              ],
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
              fontFamily: 'NotoSansKR',
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

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        _showProfileBottomSheet(context);
        break;
      case 'settings':
        _showSettingsBottomSheet(context);
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
                fontFamily: 'NotoSansKR',
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
                        fontFamily: 'NotoSansKR',
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
                    fontFamily: 'NotoSansKR',
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
                              fontFamily: 'NotoSansKR',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                              fontFamily: 'NotoSansKR',
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
        style: const TextStyle(fontFamily: 'NotoSansKR'),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansKR',
              ),
            ),
            const SizedBox(height: 20),
            
            _buildSettingsMenuItem(
              icon: Icons.notifications,
              title: '알림 설정',
              onTap: () {
                Navigator.pop(context);
                // TODO: 알림 설정 화면으로 이동
              },
            ),
            _buildSettingsMenuItem(
              icon: Icons.dark_mode,
              title: '다크 모드',
              onTap: () {
                Navigator.pop(context);
                // TODO: 다크 모드 토글
              },
            ),
            _buildSettingsMenuItem(
              icon: Icons.language,
              title: '언어 설정',
              onTap: () {
                Navigator.pop(context);
                // TODO: 언어 설정 화면으로 이동
              },
            ),
            _buildSettingsMenuItem(
              icon: Icons.help,
              title: '도움말',
              onTap: () {
                Navigator.pop(context);
                // TODO: 도움말 화면으로 이동
              },
            ),
            _buildSettingsMenuItem(
              icon: Icons.info,
              title: '앱 정보',
              onTap: () {
                Navigator.pop(context);
                // TODO: 앱 정보 화면으로 이동
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B73FF)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'NotoSansKR'),
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
          style: TextStyle(fontFamily: 'NotoSansKR'),
        ),
        content: const Text(
          '정말 로그아웃하시겠습니까?',
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
                        fontFamily: 'NotoSansKR',
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

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
} 