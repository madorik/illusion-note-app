import 'package:flutter/material.dart';
import '../constants/menu_items.dart';

/// 메뉴 시스템 확장성 예제
/// 이 파일은 메뉴를 어떻게 동적으로 추가/제거할 수 있는지 보여줍니다.
class MenuUsageExample {
  
  /// 기본 메뉴에 새로운 섹션 추가 예제
  static List<MenuSection> addBusinessSection(List<MenuSection> currentSections) {
    final businessSection = MenuSection(
      title: '비즈니스',
      headerIcon: Icons.business_outlined,
      items: [
        MenuItem(
          id: 'team_management',
          icon: Icons.groups_outlined,
          title: '팀 관리',
          subtitle: '팀원들의 감정 상태 관리',
          route: '/team-management',
        ),
        MenuItem(
          id: 'company_insights',
          icon: Icons.insights_outlined,
          title: '회사 인사이트',
          subtitle: '조직 전체 감정 분석',
          route: '/company-insights',
        ),
        MenuItem(
          id: 'hr_dashboard',
          icon: Icons.dashboard_outlined,
          title: 'HR 대시보드',
          subtitle: '인사 관리 도구',
          route: '/hr-dashboard',
        ),
      ],
    );
    
    return MenuConstants.addCustomSection(
      currentSections, 
      businessSection,
      insertIndex: 2, // 기능 섹션 다음에 추가
    );
  }

  /// 특정 사용자 레벨에 따른 메뉴 추가
  static List<MenuSection> addUserLevelMenus(
    List<MenuSection> currentSections,
    UserLevel userLevel,
  ) {
    switch (userLevel) {
      case UserLevel.basic:
        return _addBasicUserMenus(currentSections);
      case UserLevel.premium:
        return _addPremiumUserMenus(currentSections);
      case UserLevel.enterprise:
        return _addEnterpriseUserMenus(currentSections);
    }
  }

  static List<MenuSection> _addBasicUserMenus(List<MenuSection> sections) {
    // 기본 사용자는 업그레이드 유도 메뉴만 추가
    final upgradeItem = MenuItem(
      id: 'upgrade_to_premium',
      icon: Icons.upgrade_outlined,
      title: '프리미엄 업그레이드',
      subtitle: '더 많은 기능을 잠금 해제하세요',
      route: '/upgrade',
      iconColor: Colors.orange,
    );
    
    return MenuConstants.addItemToSection(sections, '기능', upgradeItem);
  }

  static List<MenuSection> _addPremiumUserMenus(List<MenuSection> sections) {
    final premiumItems = [
      MenuItem(
        id: 'advanced_analytics',
        icon: Icons.analytics_outlined,
        title: '고급 분석',
        subtitle: '상세한 감정 패턴 분석',
        route: '/advanced-analytics',
        iconColor: Colors.purple,
      ),
      MenuItem(
        id: 'mood_prediction',
        icon: Icons.psychology_outlined,
        title: '기분 예측',
        subtitle: 'AI 기반 감정 상태 예측',
        route: '/mood-prediction',
        iconColor: Colors.purple,
      ),
    ];

    var updatedSections = sections;
    for (final item in premiumItems) {
      updatedSections = MenuConstants.addItemToSection(
        updatedSections, 
        '기능', 
        item,
      );
    }
    
    return updatedSections;
  }

  static List<MenuSection> _addEnterpriseUserMenus(List<MenuSection> sections) {
    // 프리미엄 기능도 포함
    var updatedSections = _addPremiumUserMenus(sections);
    
    // 엔터프라이즈 전용 섹션 추가
    final enterpriseSection = MenuSection(
      title: '엔터프라이즈',
      headerIcon: Icons.corporate_fare,
      items: [
        MenuItem(
          id: 'admin_panel',
          icon: Icons.admin_panel_settings_outlined,
          title: '관리자 패널',
          subtitle: '시스템 전체 관리',
          route: '/admin-panel',
          iconColor: Colors.red,
        ),
        MenuItem(
          id: 'api_access',
          icon: Icons.api_outlined,
          title: 'API 접근',
          subtitle: '개발자 API 관리',
          route: '/api-access',
          iconColor: Colors.red,
        ),
        MenuItem(
          id: 'white_label',
          icon: Icons.branding_watermark_outlined,
          title: '화이트 라벨',
          subtitle: '브랜딩 커스터마이징',
          route: '/white-label',
          iconColor: Colors.red,
        ),
      ],
    );
    
    return MenuConstants.addCustomSection(updatedSections, enterpriseSection);
  }

  /// 지역별 메뉴 커스터마이징
  static List<MenuSection> addRegionalMenus(
    List<MenuSection> sections,
    String countryCode,
  ) {
    switch (countryCode) {
      case 'KR':
        return _addKoreanMenus(sections);
      case 'US':
        return _addUSMenus(sections);
      case 'JP':
        return _addJapaneseMenus(sections);
      default:
        return sections;
    }
  }

  static List<MenuSection> _addKoreanMenus(List<MenuSection> sections) {
    final koreanItems = [
      MenuItem(
        id: 'korean_support',
        icon: Icons.support_agent_outlined,
        title: '한국 고객지원',
        subtitle: '24시간 한국어 지원',
        route: '/korean-support',
      ),
      MenuItem(
        id: 'korean_community',
        icon: Icons.groups_outlined,
        title: '한국 커뮤니티',
        subtitle: '한국 사용자 모임',
        route: '/korean-community',
      ),
    ];

    var updatedSections = sections;
    for (final item in koreanItems) {
      updatedSections = MenuConstants.addItemToSection(
        updatedSections,
        '지원',
        item,
      );
    }
    
    return updatedSections;
  }

  static List<MenuSection> _addUSMenus(List<MenuSection> sections) {
    // 미국용 메뉴 (HIPAA 준수 등)
    final usItem = MenuItem(
      id: 'hipaa_compliance',
      icon: Icons.security_outlined,
      title: 'HIPAA 준수',
      subtitle: '의료 정보 보호법 준수',
      route: '/hipaa-compliance',
    );
    
    return MenuConstants.addItemToSection(sections, '개인정보 및 보안', usItem);
  }

  static List<MenuSection> _addJapaneseMenus(List<MenuSection> sections) {
    // 일본용 메뉴
    final japaneseItem = MenuItem(
      id: 'japanese_wellness',
      icon: Icons.spa_outlined,
      title: 'ウェルネス機能',
      subtitle: '日本式の心の健康管理',
      route: '/japanese-wellness',
    );
    
    return MenuConstants.addItemToSection(sections, '기능', japaneseItem);
  }

  /// 시즌별 이벤트 메뉴 추가
  static List<MenuSection> addSeasonalMenus(List<MenuSection> sections) {
    final now = DateTime.now();
    final month = now.month;
    
    List<MenuItem> seasonalItems = [];
    
    // 봄 (3-5월)
    if (month >= 3 && month <= 5) {
      seasonalItems.add(
        MenuItem(
          id: 'spring_challenge',
          icon: Icons.local_florist_outlined,
          title: '봄맞이 챌린지',
          subtitle: '새로운 시작과 함께하는 감정 관리',
          route: '/spring-challenge',
          iconColor: Colors.green,
        ),
      );
    }
    
    // 여름 (6-8월)
    if (month >= 6 && month <= 8) {
      seasonalItems.add(
        MenuItem(
          id: 'summer_vacation',
          icon: Icons.beach_access_outlined,
          title: '여름휴가 모드',
          subtitle: '휴가철 스트레스 관리',
          route: '/summer-vacation',
          iconColor: Colors.orange,
        ),
      );
    }
    
    // 가을 (9-11월)
    if (month >= 9 && month <= 11) {
      seasonalItems.add(
        MenuItem(
          id: 'autumn_reflection',
          icon: Icons.park_outlined,
          title: '가을 성찰',
          subtitle: '한 해를 돌아보는 시간',
          route: '/autumn-reflection',
          iconColor: Colors.brown,
        ),
      );
    }
    
    // 겨울 (12-2월)
    if (month == 12 || month <= 2) {
      seasonalItems.add(
        MenuItem(
          id: 'winter_wellness',
          icon: Icons.ac_unit_outlined,
          title: '겨울 건강관리',
          subtitle: '추위와 우울감 극복하기',
          route: '/winter-wellness',
          iconColor: Colors.blue,
        ),
      );
    }
    
    // 시즌 메뉴가 있으면 이벤트 섹션에 추가
    if (seasonalItems.isNotEmpty) {
      final eventSection = MenuSection(
        title: '이벤트',
        headerIcon: Icons.event_outlined,
        items: seasonalItems,
      );
      
      return MenuConstants.addCustomSection(sections, eventSection, insertIndex: 1);
    }
    
    return sections;
  }

  /// A/B 테스트를 위한 메뉴 변형
  static List<MenuSection> addABTestMenus(
    List<MenuSection> sections,
    String testVariant,
  ) {
    switch (testVariant) {
      case 'variant_a':
        // 기본 메뉴 구조 유지
        return sections;
      case 'variant_b':
        // 기능 섹션을 맨 위로 이동
        return _moveFeaturesToTop(sections);
      case 'variant_c':
        // 간소화된 메뉴
        return _createSimplifiedMenu(sections);
      default:
        return sections;
    }
  }

  static List<MenuSection> _moveFeaturesToTop(List<MenuSection> sections) {
    final featuresSectionIndex = sections.indexWhere((s) => s.title == '기능');
    if (featuresSectionIndex > 0) {
      final featuresSection = sections[featuresSectionIndex];
      final reorderedSections = List<MenuSection>.from(sections);
      reorderedSections.removeAt(featuresSectionIndex);
      reorderedSections.insert(0, featuresSection);
      return reorderedSections;
    }
    return sections;
  }

  static List<MenuSection> _createSimplifiedMenu(List<MenuSection> sections) {
    // 필수 섹션만 유지
    return sections.where((section) => 
      section.title == '일반' || 
      section.title == '계정'
    ).toList();
  }
}

/// 사용자 레벨 열거형
enum UserLevel {
  basic,
  premium,
  enterprise,
}

/// 메뉴 활용 예제 위젯
class MenuExampleWidget extends StatefulWidget {
  const MenuExampleWidget({super.key});

  @override
  State<MenuExampleWidget> createState() => _MenuExampleWidgetState();
}

class _MenuExampleWidgetState extends State<MenuExampleWidget> {
  List<MenuSection> menuSections = MenuConstants.getDefaultMenuSections();

  @override
  void initState() {
    super.initState();
    _customizeMenus();
  }

  void _customizeMenus() {
    // 기본 메뉴에 다양한 커스터마이징 적용
    var customizedSections = menuSections;
    
    // 1. 사용자 레벨에 따른 메뉴 추가
    customizedSections = MenuUsageExample.addUserLevelMenus(
      customizedSections,
      UserLevel.premium, // 예시: 프리미엄 사용자
    );
    
    // 2. 지역별 메뉴 추가
    customizedSections = MenuUsageExample.addRegionalMenus(
      customizedSections,
      'KR', // 한국
    );
    
    // 3. 시즌별 메뉴 추가
    customizedSections = MenuUsageExample.addSeasonalMenus(customizedSections);
    
    // 4. A/B 테스트 적용
    customizedSections = MenuUsageExample.addABTestMenus(
      customizedSections,
      'variant_a',
    );
    
    setState(() {
      menuSections = customizedSections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴 커스터마이징 예제'),
      ),
      body: ListView.builder(
        itemCount: menuSections.length,
        itemBuilder: (context, index) {
          final section = menuSections[index];
          return ExpansionTile(
            title: Text(section.title),
            leading: section.headerIcon != null 
                ? Icon(section.headerIcon) 
                : null,
            children: section.items.map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
            )).toList(),
          );
        },
      ),
    );
  }
} 