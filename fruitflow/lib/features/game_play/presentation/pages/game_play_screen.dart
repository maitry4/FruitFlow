import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/features/game_play/presentation/cubit/game_play_cubit.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/game_play_board.dart';

class GamePlayScreen extends StatelessWidget {
  final int levelNumber;

  const GamePlayScreen({super.key, required this.levelNumber});

  @override
  Widget build(BuildContext context) {
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
                  ),
                  GamePlayError(:final message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Failed to load level.\n$message',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                },
              ],
            );
          },
        ),
      ),
    );
  }

  String _backgroundAsset(BuildContext context) {
    return Responsive.isMobile(context)
        ? 'assets/play/game_play_background_mobile.webp'
        : 'assets/play/game_play_background_desktop.webp';
  }
}



