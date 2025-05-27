import 'package:flutter/material.dart';

class MenuItem {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? route;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final Color? titleColor;
  final Color? iconColor;
  final bool isDestructive;
  final bool showDivider;

  const MenuItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.route,
    this.onTap,
    this.isSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.titleColor,
    this.iconColor,
    this.isDestructive = false,
    this.showDivider = false,
  });
}

class MenuSection {
  final String title;
  final List<MenuItem> items;
  final IconData? headerIcon;
  final Color? headerColor;

  const MenuSection({
    required this.title,
    required this.items,
    this.headerIcon,
    this.headerColor,
  });
}

class MenuConstants {
  // 메뉴 섹션 IDs
  static const String generalSection = 'general';
  static const String featuresSection = 'features';
  static const String privacySection = 'privacy';
  static const String supportSection = 'support';
  static const String accountSection = 'account';

  // 메뉴 아이템 IDs
  static const String notifications = 'notifications';
  static const String darkMode = 'dark_mode';
  static const String language = 'language';
  static const String dataExport = 'data_export';
  static const String statistics = 'statistics';
  static const String shareApp = 'share_app';
  static const String analytics = 'analytics';
  static const String privacy = 'privacy';
  static const String security = 'security';
  static const String help = 'help';
  static const String feedback = 'feedback';
  static const String appInfo = 'app_info';
  static const String logout = 'logout';

  // 기본 메뉴 구성
  static List<MenuSection> getDefaultMenuSections() {
    return [
      MenuSection(
        title: '일반',
        headerIcon: Icons.settings_outlined,
        items: [
          MenuItem(
            id: notifications,
            icon: Icons.notifications_outlined,
            title: '알림',
            subtitle: '푸시 알림 설정',
            isSwitch: true,
          ),
          MenuItem(
            id: darkMode,
            icon: Icons.dark_mode_outlined,
            title: '다크 모드',
            subtitle: '어두운 테마 사용',
            isSwitch: true,
          ),
          MenuItem(
            id: language,
            icon: Icons.language_outlined,
            title: '언어',
            subtitle: '한국어',
            route: '/language-settings',
          ),
        ],
      ),
      
      MenuSection(
        title: '기능',
        headerIcon: Icons.auto_awesome_outlined,
        items: [
          MenuItem(
            id: dataExport,
            icon: Icons.backup_outlined,
            title: '데이터 내보내기',
            subtitle: '감정 기록 백업 및 내보내기',
            route: '/data-export',
          ),
          MenuItem(
            id: statistics,
            icon: Icons.insights_outlined,
            title: '통계 및 분석',
            subtitle: '상세한 감정 분석 결과',
            route: '/statistics',
          ),
          MenuItem(
            id: shareApp,
            icon: Icons.share_outlined,
            title: '앱 공유',
            subtitle: '친구들과 앱을 공유해보세요',
          ),
        ],
      ),
      
      MenuSection(
        title: '개인정보 및 보안',
        headerIcon: Icons.security_outlined,
        items: [
          MenuItem(
            id: analytics,
            icon: Icons.analytics_outlined,
            title: '분석 데이터',
            subtitle: '앱 개선을 위한 데이터 수집',
            isSwitch: true,
          ),
          MenuItem(
            id: privacy,
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 처리방침',
            subtitle: '개인정보 보호 정책 확인',
            route: '/privacy-policy',
          ),
          MenuItem(
            id: security,
            icon: Icons.security_outlined,
            title: '보안',
            subtitle: '계정 보안 설정',
            route: '/security-settings',
          ),
        ],
      ),
      
      MenuSection(
        title: '지원',
        headerIcon: Icons.help_outline,
        items: [
          MenuItem(
            id: help,
            icon: Icons.help_outline,
            title: '도움말',
            subtitle: 'FAQ 및 사용 가이드',
            route: '/help',
          ),
          MenuItem(
            id: feedback,
            icon: Icons.feedback_outlined,
            title: '피드백',
            subtitle: '의견 및 제안 보내기',
            route: '/feedback',
          ),
          MenuItem(
            id: appInfo,
            icon: Icons.info_outline,
            title: '앱 정보',
            subtitle: '버전 정보 및 라이선스',
          ),
        ],
      ),
      
      MenuSection(
        title: '계정',
        headerIcon: Icons.person_outline,
        items: [
          MenuItem(
            id: logout,
            icon: Icons.logout,
            title: '로그아웃',
            subtitle: '계정에서 로그아웃',
            titleColor: Colors.red,
            iconColor: Colors.red,
            isDestructive: true,
          ),
        ],
      ),
    ];
  }

  // 확장 가능한 메뉴 추가 기능
  static List<MenuSection> addCustomSection(
    List<MenuSection> sections,
    MenuSection newSection,
    {int? insertIndex}
  ) {
    final updatedSections = List<MenuSection>.from(sections);
    if (insertIndex != null && insertIndex < sections.length) {
      updatedSections.insert(insertIndex, newSection);
    } else {
      updatedSections.add(newSection);
    }
    return updatedSections;
  }

  static List<MenuSection> addItemToSection(
    List<MenuSection> sections,
    String sectionTitle,
    MenuItem newItem,
    {int? insertIndex}
  ) {
    return sections.map((section) {
      if (section.title == sectionTitle) {
        final updatedItems = List<MenuItem>.from(section.items);
        if (insertIndex != null && insertIndex < section.items.length) {
          updatedItems.insert(insertIndex, newItem);
        } else {
          updatedItems.add(newItem);
        }
        return MenuSection(
          title: section.title,
          items: updatedItems,
          headerIcon: section.headerIcon,
          headerColor: section.headerColor,
        );
      }
      return section;
    }).toList();
  }

  static List<MenuSection> removeItemFromSection(
    List<MenuSection> sections,
    String itemId,
  ) {
    return sections.map((section) {
      final updatedItems = section.items.where((item) => item.id != itemId).toList();
      return MenuSection(
        title: section.title,
        items: updatedItems,
        headerIcon: section.headerIcon,
        headerColor: section.headerColor,
      );
    }).toList();
  }

  static List<MenuSection> updateMenuItem(
    List<MenuSection> sections,
    String itemId,
    MenuItem updatedItem,
  ) {
    return sections.map((section) {
      final updatedItems = section.items.map((item) {
        return item.id == itemId ? updatedItem : item;
      }).toList();
      return MenuSection(
        title: section.title,
        items: updatedItems,
        headerIcon: section.headerIcon,
        headerColor: section.headerColor,
      );
    }).toList();
  }
} 