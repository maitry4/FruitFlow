import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:layered/core/responsive/responsive_config.dart';
import 'package:layered/features/game_play/presentation/cubit/game_play_cubit.dart';
import 'package:layered/features/game_play/presentation/widgets/game_play_board.dart';
@@ -14,48 +15,115 @@ class GamePlayScreen extends StatelessWidget {
    return BlocProvider(
      create: (_) => GamePlayCubit()..loadLevel(levelNumber),
      child: Scaffold(
        body: BlocBuilder<GamePlayCubit, GamePlayState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _backgroundAsset(context),
                    fit: BoxFit.cover,
                  ),
                ),
                switch (state) {
                  GamePlayLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  GamePlayLoaded(:final level) => SafeArea(
                    child: GamePlayBoard(level: level),
        // We use BlocListener for "one-time" side effects like navigation or dialogs
        body: BlocListener<GamePlayCubit, GamePlayState>(
          listener: (context, state) {
            if (state is GamePlayVictory) {
              _showVictoryDialog(context, state.levelNumber);
            }
          },
          child: BlocBuilder<GamePlayCubit, GamePlayState>(
            builder: (context, state) {
              return Stack(
                children: [
                  // 1. Background layer
                  Positioned.fill(
                    child: Image.asset(
                      _backgroundAsset(context),
                      fit: BoxFit.cover,
                    ),
                  ),
                  GamePlayError(:final message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Failed to load level.\n$message',
                        textAlign: TextAlign.center,

                  // 2. Interactive layer
                  switch (state) {
                    GamePlayLoading() => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    
                    // Show board for both Loaded and Victory states
                    GamePlayLoaded(:final level) => SafeArea(
                        child: GamePlayBoard(level: level),
                      ),
                    
                    // We keep the board visible even when victory state is reached
                    // Note: This assumes GamePlayVictory also carries the level data
                    // or the Cubit is designed to keep the last state.
                    GamePlayVictory(:final levelNumber) => const Center(
                      // You can add a confetti overlay here if desired
                      child: SizedBox.shrink(), 
                    ),

                    GamePlayError(:final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Failed to load level.\n$message',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  },
                  
                  // Optional: Back button
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                },
              ],
            );
          },
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showVictoryDialog(BuildContext context, int currentLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Level Complete!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content: Text(
          'You successfully sorted all the fruits in Level $currentLevel!',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: StadiumBorder(),
            ),
            onPressed: () {
              // Close dialog and navigate to next level
              Navigator.of(dialogContext).pop();
              context.pushReplacement('/game-play?level=${currentLevel + 1}');
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('Next Level', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String _backgroundAsset(BuildContext context) {
    return Responsive.isMobile(context)
        ? 'assets/play/game_play_background_mobile.webp'
        : 'assets/play/game_play_background_desktop.webp';
  }
}




}