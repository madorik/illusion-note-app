import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/menu_items.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuSection> _menuSections = [];
  
  // 설정 값들
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _analyticsEnabled = true;

  // Getters
  List<MenuSection> get menuSections => _menuSections;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get analyticsEnabled => _analyticsEnabled;

  MenuProvider() {
    _initializeMenu();
  }

  void _initializeMenu() {
    _menuSections = MenuConstants.getDefaultMenuSections();
    _updateSwitchValues();
  }

  void _updateSwitchValues() {
    _menuSections = _menuSections.map((section) {
      final updatedItems = section.items.map((item) {
        switch (item.id) {
          case MenuConstants.notifications:
            return MenuItem(
              id: item.id,
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              isSwitch: true,
              switchValue: _notificationsEnabled,
              onSwitchChanged: (value) => setNotificationsEnabled(value),
              iconColor: item.iconColor,
              titleColor: item.titleColor,
            );
          case MenuConstants.darkMode:
            return MenuItem(
              id: item.id,
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              isSwitch: true,
              switchValue: _darkModeEnabled,
              onSwitchChanged: (value) => setDarkModeEnabled(value),
              iconColor: item.iconColor,
              titleColor: item.titleColor,
            );
          case MenuConstants.analytics:
            return MenuItem(
              id: item.id,
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              isSwitch: true,
              switchValue: _analyticsEnabled,
              onSwitchChanged: (value) => setAnalyticsEnabled(value),
              iconColor: item.iconColor,
              titleColor: item.titleColor,
            );
          default:
            return item;
        }
      }).toList();
      
      return MenuSection(
        title: section.title,
        items: updatedItems,
        headerIcon: section.headerIcon,
        headerColor: section.headerColor,
      );
    }).toList();
    
    notifyListeners();
  }

  // 설정 값 변경 메서드들
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _updateSwitchValues();
  }

  void setDarkModeEnabled(bool value) {
    _darkModeEnabled = value;
    _updateSwitchValues();
  }

  void setAnalyticsEnabled(bool value) {
    _analyticsEnabled = value;
    _updateSwitchValues();
  }

  // 메뉴 관리 메서드들
  void addSection(MenuSection section, {int? insertIndex}) {
    _menuSections = MenuConstants.addCustomSection(_menuSections, section, insertIndex: insertIndex);
    notifyListeners();
  }

  void addItemToSection(String sectionTitle, MenuItem item, {int? insertIndex}) {
    _menuSections = MenuConstants.addItemToSection(_menuSections, sectionTitle, item, insertIndex: insertIndex);
    notifyListeners();
  }

  void removeItem(String itemId) {
    _menuSections = MenuConstants.removeItemFromSection(_menuSections, itemId);
    notifyListeners();
  }

  void updateItem(String itemId, MenuItem updatedItem) {
    _menuSections = MenuConstants.updateMenuItem(_menuSections, itemId, updatedItem);
    notifyListeners();
  }

  // 메뉴 액션 핸들러들
  Future<void> handleMenuAction(String itemId) async {
    switch (itemId) {
      case MenuConstants.shareApp:
        await _shareApp();
        break;
      case MenuConstants.dataExport:
        await _exportData();
        break;
      case MenuConstants.feedback:
        await _openFeedback();
        break;
      // 추가 액션들...
    }
  }

  Future<void> _shareApp() async {
    try {
      // TODO: Share Plus 패키지 추가 후 구현
      debugPrint('앱 공유 기능 - 준비 중');
    } catch (e) {
      debugPrint('앱 공유 실패: $e');
    }
  }

  Future<void> _exportData() async {
    // 데이터 내보내기 로직
    debugPrint('데이터 내보내기 기능 실행');
    // TODO: 실제 데이터 내보내기 구현
  }

  Future<void> _openFeedback() async {
    // 피드백 기능
    debugPrint('피드백 기능 실행');
    // TODO: 실제 피드백 구현
  }

  // 확장 예제: 새로운 기능 메뉴 추가
  void addFeatureMenu() {
    final newItem = MenuItem(
      id: 'new_feature',
      icon: Icons.new_releases_outlined,
      title: '새로운 기능',
      subtitle: '최신 업데이트된 기능을 확인하세요',
      route: '/new-features',
    );
    
    addItemToSection('기능', newItem);
  }

  // 확장 예제: 프리미엄 기능 섹션 추가
  void addPremiumSection() {
    final premiumSection = MenuSection(
      title: '프리미엄',
      headerIcon: Icons.workspace_premium,
      items: [
        MenuItem(
          id: 'premium_features',
          icon: Icons.star_outlined,
          title: '프리미엄 기능',
          subtitle: '고급 분석 및 추가 기능 이용',
          route: '/premium-features',
        ),
        MenuItem(
          id: 'subscription',
          icon: Icons.card_membership_outlined,
          title: '구독 관리',
          subtitle: '구독 상태 및 결제 정보',
          route: '/subscription',
        ),
      ],
    );
    
    addSection(premiumSection, insertIndex: 2); // 기능 섹션 다음에 추가
  }

  // 확장 예제: 개발자 옵션 (디버그 모드에서만)
  void addDeveloperOptions() {
    if (kDebugMode) {
      final devSection = MenuSection(
        title: '개발자 옵션',
        headerIcon: Icons.developer_mode,
        items: [
          MenuItem(
            id: 'debug_info',
            icon: Icons.bug_report_outlined,
            title: '디버그 정보',
            subtitle: '앱 디버그 정보 확인',
            route: '/debug-info',
          ),
          MenuItem(
            id: 'test_features',
            icon: Icons.science_outlined,
            title: '테스트 기능',
            subtitle: '실험적 기능 테스트',
            route: '/test-features',
          ),
        ],
      );
      
      addSection(devSection);
    }
  }

  // 조건부 메뉴 표시
  void updateMenuForUserType(bool isPremiumUser) {
    if (isPremiumUser) {
      addPremiumSection();
    } else {
      // 프리미엄 유도 메뉴 추가
      final upgradeItem = MenuItem(
        id: 'upgrade_premium',
        icon: Icons.upgrade_outlined,
        title: '프리미엄 업그레이드',
        subtitle: '더 많은 기능을 이용해보세요',
        route: '/upgrade',
      );
      
      addItemToSection('기능', upgradeItem);
    }
  }
} 