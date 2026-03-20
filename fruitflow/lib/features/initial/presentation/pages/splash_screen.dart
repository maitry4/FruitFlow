import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/features/initial/presentation/cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashView();
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      context.read<SplashCubit>().loadSplash(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
      listener: (context, state) async {
        if (state is SplashReady) {
          await Future.delayed(const Duration(milliseconds: 2500));
          if (context.mounted) context.goNamed(state.targetRoute);
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: switch (state) {
            SplashReady(:final assetPath) =>
              _SplashImage(assetPath: assetPath),
            SplashError(:final message) =>
              _SplashErrorView(message: message),
            _ => const SizedBox.expand(),
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Splash image — responsive, theme-aware background
// ---------------------------------------------------------------------------

class _SplashImage extends StatelessWidget {
  final String assetPath;

  const _SplashImage({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLargeScreen = screenWidth >= AppBreakpoints.desktop;

    return Responsive(
      maxWidth: isLargeScreen ? AppBreakpoints.desktop : double.infinity,
      child: SizedBox.expand(
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error view — fully theme-driven, no hardcoded colors
// ---------------------------------------------------------------------------

class _SplashErrorView extends StatelessWidget {
  final String message;

  const _SplashErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load splash',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}