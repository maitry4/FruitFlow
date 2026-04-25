import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered/core/responsive/responsive_config.dart';
import 'package:layered/features/game_play/domain/fruit_type.dart';
import 'package:layered/features/game_play/domain/tube.dart';
import 'package:layered/features/game_play/domain/ui_level.dart';
import 'package:layered/features/game_play/presentation/cubit/game_play_cubit.dart';

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
                    child: _GamePlayBoard(level: level),
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
        ? 'assets/map/game_map_background_mobile.webp'
        : 'assets/map/game_map_background_desktop.webp';
  }
}

class _GamePlayBoard extends StatelessWidget {
  final UILevel level;

  const _GamePlayBoard({required this.level});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final crossAxisCount = isMobile ? 4 : 6;

    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          'Level ${level.levelNumber}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: level.tubes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (_, index) => _BottleWidget(tube: level.tubes[index]),
          ),
        ),
      ],
    );
  }
}

class _BottleWidget extends StatelessWidget {
  final Tube tube;
  static const String _emptyBottleAsset = 'assets/play/empty_bottle_image.webp';

  const _BottleWidget({required this.tube});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final slotSpacing = constraints.maxHeight * 0.02;

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                _emptyBottleAsset,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: constraints.maxWidth * 0.18,
              right: constraints.maxWidth * 0.18,
              bottom: constraints.maxHeight * 0.09,
              top: constraints.maxHeight * 0.17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(tube.capacity, (slotFromBottom) {
                  final hasSlab = slotFromBottom < tube.slabs.length;
                  final fruit = hasSlab ? tube.slabs[slotFromBottom] : null;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: slotSpacing),
                      child: fruit == null
                          ? DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            )
                          : Image.asset(
                              _fruitAsset(fruit),
                              fit: BoxFit.contain,
                            ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

String _fruitAsset(FruitType type) {
  return switch (type) {
    FruitType.apple => 'assets/fruits/apple.webp',
    FruitType.banana => 'assets/fruits/banana.webp',
    FruitType.watermelon => 'assets/fruits/watermelon.webp',
    FruitType.lime => 'assets/fruits/lime.webp',
    FruitType.grapes => 'assets/fruits/grapes.webp',
    FruitType.mango => 'assets/fruits/mango.webp',
    FruitType.strawberry => 'assets/fruits/strawberry.webp',
    FruitType.blueberry => 'assets/fruits/blueberry.webp',
  };
}