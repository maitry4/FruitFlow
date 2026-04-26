import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/features/game_play/presentation/cubit/game_play_cubit.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/action_button.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/game_play_board.dart';
import 'package:confetti/confetti.dart';

class GamePlayScreen extends StatelessWidget {
  final int levelNumber;

  const GamePlayScreen({super.key, required this.levelNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamePlayCubit()..loadLevel(levelNumber),
      child: Scaffold(
        body: BlocListener<GamePlayCubit, GamePlayState>(
          listener: (context, state) {
            if (state is GamePlayVictory) {
              _showVictoryDialog(context, state.levelNumber);
            }
          },
          child: BlocBuilder<GamePlayCubit, GamePlayState>(
            builder: (context, state) {
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2000),
                tween: Tween(begin: 1.1, end: 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        _backgroundAsset(context),
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    switch (state) {
                      GamePlayLoading() => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      GamePlayLoaded(:final level, :final selectedTubeIndex) =>
                        GamePlayBoard(
                          level: level,
                          selectedIdx: selectedTubeIndex,
                        ),
                      GamePlayVictory() => const SizedBox.shrink(),
                      GamePlayError(:final message) => Center(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    },
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showVictoryDialog(BuildContext context, int currentLevel) {
    final confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  // 🎉 Confetti
                  Positioned.fill(
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      emissionFrequency: 0.05,
                      numberOfParticles: 20,
                      gravity: 0.3,
                    ),
                  ),

                  // 💫 Main Card
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween(begin: 0.8, end: 1.0),
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 60),
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Level Complete!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "That was smooth...",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: 300,
                            child: ActionButton(
                              onTap: () {
                                confettiController.stop();
                                context.go(AppRoutes.gameMap);
                              },
                              child: const Text("Next Level"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Orange Image (floating on top)
                  Positioned(
                    top: 0,
                    child: Image.asset(
                      'assets/play/win_orange.webp',
                      height: 120,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _backgroundAsset(BuildContext context) {
    return Responsive.isMobile(context)
        ? 'assets/play/game_play_background_mobile.webp'
        : 'assets/play/game_play_background_desktop.webp';
  }
}
