import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/features/game_play/domain/ui_level.dart';
import 'package:fruitflow/features/game_play/presentation/cubit/game_play_cubit.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/action_button.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/bottle_widget.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/level_pill.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/round_button.dart';

class GamePlayBoard extends StatelessWidget {
  final UILevel level;
  final int? selectedIdx;
  const GamePlayBoard({super.key, required this.level, this.selectedIdx});

  @override
  Widget build(BuildContext context) {
    // final isMobile = Responsive.isMobile(context);
    // final crossAxisCount = isMobile ? 3 : 6;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TOP: HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundButton(
                    icon: Icons.arrow_back, onTap: () {
                      // Navigator.pop);
                      context.go(AppRoutes.gameMap); 
                    }),
                LevelPill(levelNumber: level.levelNumber),
                const SizedBox(width: 50), // Balance the row
              ],
            ),
          ),

          // MIDDLE: BOTTLES
          Expanded(
  child: Center(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        
        final crossAxisCount = isMobile ? 5 :level.tubes.length;

        // Calculate exact width needed for grid
        final itemWidth = constraints.maxWidth / crossAxisCount;
        final gridWidth =
            (itemWidth * crossAxisCount) - (0.0 * (crossAxisCount - 1));

        return SizedBox(
          width: gridWidth * 0.8, // shrink width to center items nicely
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: level.tubes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: isMobile ? 190 : 350,
              mainAxisSpacing: 20,
              crossAxisSpacing: 1.0, // reduced gap
              childAspectRatio: 0.5,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () =>
                  context.read<GamePlayCubit>().onTubeTapped(index),
              child: BottleWidget(
                tube: level.tubes[index],
                isSelected: selectedIdx == index,
              ),
            ),
          ),
        );
      },
    ),
  ),
),
          // BOTTOM: ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.only(bottom: 40, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  child: const Icon(Icons.undo, color: Colors.white, size: 32),
                  onTap: () => context.read<GamePlayCubit>().undo(),
                ),
                const SizedBox(width: 30),
                ActionButton(
                  label: "RESET",
                  onTap: () => context.read<GamePlayCubit>().reset(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}