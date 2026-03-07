import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/features/initial/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  String resolveAsset(double screenWidth) {
    return screenWidth >= AppBreakpoints.mobile
        ? 'assets/splash_desktop.webp'
        : 'assets/splash_mobile.webp';
  }

  Future<void> loadSplash(BuildContext context) async {
    emit(SplashLoading());

    try {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final asset = resolveAsset(screenWidth);

      await precacheImage(AssetImage(asset), context);

      if (isClosed) return;
      emit(SplashReady(assetPath: asset));
    } catch (e) {
      if (isClosed) return;
      emit(SplashError(message: e.toString()));
    }
  }
}