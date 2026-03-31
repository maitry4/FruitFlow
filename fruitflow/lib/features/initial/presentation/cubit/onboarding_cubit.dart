import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/services/hive_service.dart';

part 'onboarding_state.dart';

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
      await HiveService.instance.markOnboardingSeen();
    } catch (_) {
      // Persistence failure must never block navigation.
    }
  }
}