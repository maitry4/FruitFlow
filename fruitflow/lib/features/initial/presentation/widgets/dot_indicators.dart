import 'package:flutter/material.dart';

class DotIndicators extends StatelessWidget {
  final int currentPage;
  final int kTotalOnboardingPages;
  const DotIndicators({required this.currentPage, required this.kTotalOnboardingPages});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(kTotalOnboardingPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.25),
          ),
        );
      }),
    );
  }
}
