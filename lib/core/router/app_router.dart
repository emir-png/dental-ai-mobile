import 'package:go_router/go_router.dart';
import '../../core/services/session_service.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/xray/presentation/xray_upload_screen.dart';
import '../../features/results/presentation/results_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/info/presentation/about_screen.dart';
import '../../features/info/presentation/contact_screen.dart';
import '../../features/info/presentation/privacy_screen.dart';
import '../../features/admin/presentation/admin_panel_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = SessionService.instance;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';

      // Not logged in → force to login
      if (!session.isLoggedIn && !isAuthRoute) return '/login';

      // Already logged in → redirect away from auth screens
      if (session.isLoggedIn && isAuthRoute) {
        return session.isAdmin ? '/admin' : '/upload';
      }

      // Non-admin trying to access /admin
      if (session.isLoggedIn && loc.startsWith('/admin') && !session.isAdmin) {
        return '/upload';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/upload',
        builder: (context, state) => const XrayUploadScreen(),
      ),
      GoRoute(
        path: '/results/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ResultsScreen(analysisId: id);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPanelScreen(),
      ),
    ],
  );
}
