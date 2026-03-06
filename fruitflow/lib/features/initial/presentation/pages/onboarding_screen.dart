import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/router/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.goNamed(AppRoutes.gameMap),
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}