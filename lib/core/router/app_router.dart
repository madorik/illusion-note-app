import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/emotion/screens/emotion_input_screen.dart';
import '../../features/emotion/screens/analysis_result_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/history/screens/calendar_screen.dart';
import '../../features/history/screens/emotion_detail_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/chat/screens/emotion_chat_screen.dart';
import '../../features/recommendation/screens/recommendation_screen.dart';
import '../../features/recommendation/screens/content_detail_screen.dart';
import '../../features/psychology/screens/psychology_test_list_screen.dart';
import '../../features/psychology/screens/psychology_test_question_screen.dart';
import '../../features/psychology/screens/psychology_test_result_screen.dart';
import '../../features/psychology/screens/psychology_test_history_screen.dart';
import '../../shared/widgets/main_layout.dart';
import '../../core/models/emotion_analysis_model.dart';
import '../../core/models/psychology_test_model.dart';
import '../../features/statistics/screens/statistics_screen.dart';
import '../../features/help/screens/help_screen.dart';
import '../../features/professional/screens/professional_help_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSplash = state.matchedLocation == '/splash';

      // 스플래시 화면은 항상 허용
      if (isGoingToSplash) return null;

      // 로그인하지 않은 사용자는 로그인 페이지로 리다이렉트
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }

      // 로그인한 사용자가 로그인 페이지에 접근하려고 하면 홈으로 리다이렉트
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }

      return null;
    },
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
          
          // Calendar
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          
          // Recommendation (메인 네비게이션에 추가)
          GoRoute(
            path: '/recommendation',
            name: 'recommendation',
            builder: (context, state) => const RecommendationScreen(),
          ),
          
          // Psychology (심리 검사)
          GoRoute(
            path: '/psychology',
            name: 'psychology',
            builder: (context, state) => const PsychologyTestListScreen(),
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
      
      // Emotion Detail (Full Screen)
      GoRoute(
        path: '/emotion-detail',
        name: 'emotion-detail',
        builder: (context, state) {
          final post = state.extra as EmotionPost;
          return EmotionDetailScreen(post: post);
        },
      ),
      
      // Settings (Full Screen)
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      // Emotion Chat (Full Screen)
      GoRoute(
        path: '/emotion-chat',
        name: 'emotion-chat',
        builder: (context, state) => const EmotionChatScreen(),
      ),
      
      // Content Detail (Full Screen)
      GoRoute(
        path: '/content-detail',
        name: 'content-detail',
        builder: (context, state) {
          final content = state.extra as dynamic;
          return ContentDetailScreen(content: content);
        },
      ),
      
      // Psychology Test Question (Full Screen)
      GoRoute(
        path: '/psychology-test-question',
        name: 'psychology-test-question',
        builder: (context, state) => const PsychologyTestQuestionScreen(),
      ),
      
      // Psychology Test Result (Full Screen)
      GoRoute(
        path: '/psychology-test-result',
        name: 'psychology-test-result',
        builder: (context, state) {
          final result = state.extra as PsychologyTestResult?;
          return PsychologyTestResultScreen(resultFromHistory: result);
        },
      ),
      
      // Psychology Test History (Full Screen)
      GoRoute(
        path: '/psychology-test-history',
        name: 'psychology-test-history',
        builder: (context, state) => const PsychologyTestHistoryScreen(),
      ),
      
      // Statistics (Full Screen)
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      
      // Help (Full Screen)
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpScreen(),
      ),
      
      // Professional Help (Full Screen)
      GoRoute(
        path: '/professional-help',
        name: 'professional-help',
        builder: (context, state) => const ProfessionalHelpScreen(),
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
  static const String calendar = '/calendar';
  static const String emotionInput = '/emotion-input';
  static const String analysisResult = '/analysis-result';
  static const String emotionDetail = '/emotion-detail';
  static const String settings = '/settings';
  static const String emotionChat = '/emotion-chat';
  static const String recommendation = '/recommendation';
  static const String contentDetail = '/content-detail';
  static const String psychology = '/psychology';
  static const String psychologyTestQuestion = '/psychology-test-question';
  static const String psychologyTestResult = '/psychology-test-result';
  static const String psychologyTestHistory = '/psychology-test-history';
  static const String statistics = '/statistics';
  static const String help = '/help';
  static const String professionalHelp = '/professional-help';
} 