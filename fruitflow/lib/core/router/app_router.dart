import 'package:go_router/go_router.dart';
import 'package:layered/core/router/app_routes.dart';
import 'package:layered/core/router/error_page.dart';
import 'package:layered/core/services/hive_service.dart';
import 'package:layered/features/game_map/presentation/pages/game_map_screen.dart';
import 'package:layered/features/game_play/presentation/pages/game_play_screen.dart';
import 'package:layered/features/initial/presentation/pages/onboarding_screen.dart';
import 'package:layered/features/initial/presentation/pages/splash_screen.dart';

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
      redirect: (context, state) {
        final seen = HiveService.instance.hasSeenOnboarding;

        if (seen) {
          return AppRoutes.gameMap; // or wherever you want
        }

        return null; // allow onboarding
      },
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
      redirect: (context, state) {
        final level =
            int.tryParse(state.uri.queryParameters['level'] ?? '') ?? 1;

        final unlocked = HiveService.instance.unlockedUpTo;

        if (level > unlocked) {
          return '${AppRoutes.gamePlay}?level=$unlocked';
        }

        return null; // allow navigation
      },
      builder: (context, state) {
        final level =
            int.tryParse(state.uri.queryParameters['level'] ?? '') ?? 1;
        return GamePlayScreen(levelNumber: level);
      },
    ),
  ],
);