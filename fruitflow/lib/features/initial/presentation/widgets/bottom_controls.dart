import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/features/initial/presentation/cubit/onboarding_cubit.dart';
import 'package:fruitflow/features/initial/presentation/widgets/dot_indicators.dart';
import 'package:fruitflow/features/initial/presentation/widgets/glossy_button.dart';

class BottomControls extends StatelessWidget {
  final int currentPage;
  final int kTotalOnboardingPages;
  const BottomControls({super.key, required this.currentPage, required this.kTotalOnboardingPages});

  bool get _isLastPage => currentPage == kTotalOnboardingPages - 1;

  @override
  Widget build(BuildContext context) {
    final label = _isLastPage ? 'Get Started' : 'Next';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DotIndicators(currentPage: currentPage, kTotalOnboardingPages: kTotalOnboardingPages),
          const SizedBox(height: 28),
          GlossyButton(
            label: label,
            onPressed: () => context.read<OnboardingCubit>().next(),
          ),
        ],
      ),
    );
  }
}
