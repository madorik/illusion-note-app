import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/emotion/screens/emotion_input_screen.dart';
import '../../features/emotion/screens/analysis_result_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../shared/widgets/main_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Login Screen
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          
          // History
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
        ],
      ),
      
      // Emotion Input (Full Screen)
      GoRoute(
        path: '/emotion-input',
        name: 'emotion-input',
        builder: (context, state) => const EmotionInputScreen(),
      ),
      
      // Analysis Result (Full Screen)
      GoRoute(
        path: '/analysis-result',
        name: 'analysis-result',
        builder: (context, state) {
          final emotionText = state.extra as String? ?? '';
          return AnalysisResultScreen(emotionText: emotionText);
        },
      ),
    ],
  );
}

// Route Names
class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String history = '/history';
  static const String emotionInput = '/emotion-input';
  static const String analysisResult = '/analysis-result';
} 