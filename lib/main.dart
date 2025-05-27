import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/emotion/providers/emotion_provider.dart';
import 'features/history/providers/history_provider.dart';
import 'features/settings/providers/menu_provider.dart';
import 'features/psychology/providers/psychology_test_provider.dart';
import 'services/service_locator.dart';
import 'core/examples/emotion_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화 (이미 초기화되어 있으면 스킵)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase가 이미 초기화되어 있는 경우 무시
    print('Firebase already initialized: $e');
  }
  
  // 서비스 로케이터 초기화
  ServiceLocator().init();
  
  // 🧪 감정 분석 API 테스트 (개발 중에만 사용)
  // EmotionTest.runAllTests();
  
  runApp(const IllusionApp());
}

class IllusionApp extends StatelessWidget {
  const IllusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => PsychologyTestProvider()),
      ],
      child: MaterialApp.router(
        title: '착각노트',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
