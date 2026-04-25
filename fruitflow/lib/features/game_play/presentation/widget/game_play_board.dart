import 'package:flutter/material.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/features/game_play/domain/ui_level.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/bottle_widget.dart';
class GamePlayBoard extends StatelessWidget {
  final UILevel level;

  const GamePlayBoard({required this.level});

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
            itemBuilder: (_, index) => BottleWidget(tube: level.tubes[index]),
          ),
        ),
      ],
    );
  }
}