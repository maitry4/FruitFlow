import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/core/services/hive_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  String _resolveAsset(double screenWidth) {
    return screenWidth >= AppBreakpoints.mobile
        ? 'assets/splash/splash_desktop.webp'
        : 'assets/splash/splash_mobile.webp';
  }

  Future<void> loadSplash(BuildContext context) async {
    emit(SplashLoading());

    try {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final asset = _resolveAsset(screenWidth);

      await precacheImage(AssetImage(asset), context);

      if (isClosed) return;

      final targetRoute = HiveService.instance.hasSeenOnboarding
          ? AppRoutes.gameMap
          : AppRoutes.onboarding;

      emit(SplashReady(assetPath: asset, targetRoute: targetRoute));
    } catch (e) {
      if (isClosed) return;
      emit(SplashError(message: e.toString()));
    }
  }
}