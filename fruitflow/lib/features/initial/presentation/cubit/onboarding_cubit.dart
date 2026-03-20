import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'onboarding_state.dart';

const _kOnboardingBox = 'onboarding';
const _kSeenOnboardingKey = 'has_seen_onboarding';

const int kTotalOnboardingPages = 3;

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingPageChanged(currentPage: 0));

  int get _currentPage =>
      state is OnboardingPageChanged
          ? (state as OnboardingPageChanged).currentPage
          : 0;

  void onPageChanged(int page) {
    emit(OnboardingPageChanged(currentPage: page));
  }

  Future<void> next() async {
    final nextPage = _currentPage + 1;

    if (nextPage < kTotalOnboardingPages) {
      emit(OnboardingPageChanged(currentPage: nextPage));
    } else {
      await _persistSeenFlag();
      emit(const OnboardingComplete());
    }
  }

  Future<void> _persistSeenFlag() async {
    try {
      final box = await Hive.openBox<bool>(_kOnboardingBox);
      await box.put(_kSeenOnboardingKey, true);
    } catch (_) {
      // Persistence failure must never block navigation.
      // Issue #6 will harden this once Hive is fully initialised at app start.
    }
  }

  /// Called by [SplashCubit] to check whether onboarding has been seen.
  static Future<bool> hasSeenOnboarding() async {
    try {
      final box = await Hive.openBox<bool>(_kOnboardingBox);
      return box.get(_kSeenOnboardingKey, defaultValue: false) ?? false;
    } catch (_) {
      return false;
    }
  }
}