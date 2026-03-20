part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingPageChanged extends OnboardingState {
  final int currentPage;

  const OnboardingPageChanged({required this.currentPage});

  @override
  List<Object> get props => [currentPage];
}

final class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}