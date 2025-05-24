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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IllusionApp());
}

class IllusionApp extends StatelessWidget {
  const IllusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => EmotionProvider()),
              ChangeNotifierProvider(create: (_) => HistoryProvider()),
            ],
            child: MaterialApp.router(
              title: '착각노트',
              theme: AppTheme.lightTheme,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
            ),
          );
        }
        // 로딩 중 화면
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
