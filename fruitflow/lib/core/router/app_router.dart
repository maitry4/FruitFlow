import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/core/router/error_page.dart';
import 'package:fruitflow/features/game_map/presentation/pages/game_map_screen.dart';
import 'package:fruitflow/features/game_play/presentation/pages/game_play_screen.dart';
import 'package:fruitflow/features/initial/presentation/pages/onboarding_screen.dart';
import 'package:fruitflow/features/initial/presentation/pages/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  errorBuilder: (context, state) => ErrorPage(error: state.error),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.gameMap,
      name: AppRoutes.gameMap,
      builder: (context, state) => const GameMapScreen(),
    ),
    GoRoute(
      path: AppRoutes.gamePlay,
      name: AppRoutes.gamePlay,
      builder: (context, state) => const GamePlayScreen(),
    ),
  ],
);