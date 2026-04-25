import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered/core/responsive/responsive_config.dart';
import 'package:layered/features/game_play/domain/ui_level.dart';
import 'package:layered/features/game_play/presentation/cubit/game_play_cubit.dart';
import 'package:layered/features/game_play/presentation/widgets/bottle_widget.dart';

class GamePlayBoard extends StatelessWidget {
  final UILevel level;

  const GamePlayBoard({required this.level});
  const GamePlayBoard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final crossAxisCount = isMobile ? 4 : 6;
    
    // Watch the cubit state to get selection info
    final state = context.watch<GamePlayCubit>().state;
    final selectedIdx = state is GamePlayLoaded ? state.selectedTubeIndex : null;

    return Column(
      children: [
@@ -33,7 +40,13 @@ class GamePlayBoard extends StatelessWidget {
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (_, index) => BottleWidget(tube: level.tubes[index]),
            itemBuilder: (_, index) => GestureDetector(
              onTap: () => context.read<GamePlayCubit>().onTubeTapped(index),
              child: BottleWidget(
                tube: level.tubes[index],
                isSelected: selectedIdx == index,
              ),
            ),
          ),
        ),
      ],