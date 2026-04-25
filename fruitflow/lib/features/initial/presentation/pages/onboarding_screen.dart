import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/features/initial/presentation/cubit/onboarding_cubit.dart';
import 'package:fruitflow/features/initial/presentation/widgets/bottom_controls.dart'; 

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

// ---------------------------------------------------------------------------
// View
// ---------------------------------------------------------------------------

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingPageChanged) {
          _pageController.animateToPage(
            state.currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
        if (state is OnboardingComplete) {
          context.goNamed(AppRoutes.gameMap);
        }
      },
      builder: (context, state) {
        final currentPage =
            state is OnboardingPageChanged ? state.currentPage : 0;

        return Scaffold(
          body: Stack(
            children: [
              // ── Full-screen paged images ──────────────────────────────────
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kTotalOnboardingPages,
                itemBuilder: (_, index) => _OnboardingPage(index: index),
              ),

              // ── Bottom overlay: dots + button ─────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomControls(currentPage: currentPage, kTotalOnboardingPages:kTotalOnboardingPages),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Full-screen image page
// ---------------------------------------------------------------------------

class _OnboardingPage extends StatelessWidget {
  final int index;

  const _OnboardingPage({required this.index});

  String _assetPath(BuildContext context) {
    final suffix = Responsive.isMobile(context) ? '' : 'd';
    return 'assets/ob${index + 1}$suffix.webp';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLargeScreen = screenWidth >= AppBreakpoints.desktop;

    return Responsive(
      maxWidth: isLargeScreen ? AppBreakpoints.desktop : double.infinity,
      child: SizedBox.expand(
        child: Image.asset(
          _assetPath(context),
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
