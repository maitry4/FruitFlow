import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/features/initial/presentation/cubit/onboarding_cubit.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  String _resolveAsset(double screenWidth) {
    return screenWidth >= AppBreakpoints.mobile
        ? 'assets/splash_desktop.webp'
        : 'assets/splash_mobile.webp';
  }

  Future<void> loadSplash(BuildContext context) async {
    emit(SplashLoading());

    try {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final asset = _resolveAsset(screenWidth);

      // Run image precache and Hive flag check concurrently
      final results = await Future.wait([
        precacheImage(AssetImage(asset), context).then((_) => true),
        OnboardingCubit.hasSeenOnboarding(),
      ]);

      if (isClosed) return;

      final hasSeenOnboarding = results[1];
      final targetRoute =
          hasSeenOnboarding ? AppRoutes.gameMap : AppRoutes.onboarding;

      emit(SplashReady(assetPath: asset, targetRoute: targetRoute));
    } catch (e) {
      if (isClosed) return;
      emit(SplashError(message: e.toString()));
    }
  }
}