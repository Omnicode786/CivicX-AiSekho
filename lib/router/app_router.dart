import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_shell.dart';
import '../features/reasoning/reasoning_screen.dart';
import '../features/simulation/simulation_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/admin/admin_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
  GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
  GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
  GoRoute(path: '/app', builder: (_, __) => const HomeShell()),
  GoRoute(path: '/reasoning/:id', builder: (_, s) => ReasoningScreen(crisisId: s.pathParameters['id']!)),
  GoRoute(path: '/simulation/:id', builder: (_, s) => SimulationScreen(crisisId: s.pathParameters['id']!)),
  GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
  GoRoute(path: '/admin', builder: (_, __) => const AdminScreen()),
]);
