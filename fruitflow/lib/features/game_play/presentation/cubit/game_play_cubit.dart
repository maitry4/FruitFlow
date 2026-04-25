import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered/core/services/hive_service.dart';
import 'package:layered/features/game_play/domain/ui_level.dart';
import 'package:layered/features/game_play/presentation/cubit/level_generator.dart';
import 'package:layered/features/game_play/domain/tube.dart';

part 'game_play_state.dart';

class GamePlayCubit extends Cubit<GamePlayState> {
  GamePlayCubit() : super(const GamePlayLoading());

  void loadLevel(int levelNumber) {
    emit(const GamePlayLoading());
    try {
      final level = LevelGenerator.generate(levelNumber);
      emit(GamePlayLoaded(level: level));
    } catch (e) {
      emit(GamePlayError(message: e.toString()));
    }
  }

  void onTubeTapped(int index) {
    final currentState = state;
    if (currentState is! GamePlayLoaded) return;

    final selectedIdx = currentState.selectedTubeIndex;

    if (selectedIdx == null) {
      // First Tap: Select the tube if it's not empty
      if (!currentState.level.tubes[index].isEmpty) {
        emit(currentState.copyWith(selectedTubeIndex: index));
      }
    } else if (selectedIdx == index) {
      // Tap same tube: Deselect
      emit(currentState.copyWith(clearSelection: true));
    } else {
      // Second Tap: Attempt to pour
      _handlePour(currentState, selectedIdx, index);
    }
  }

  void _handlePour(GamePlayLoaded state, int fromIdx, int toIdx) {
    final tubes = List<Tube>.from(state.level.tubes);
    final source = tubes[fromIdx];
    final target = tubes[toIdx];

    // 1. Get the fruit from the TOP of the source
    final fruitToMove = source.top;

    // 2. Validate: Source not empty AND Target can receive this specific fruit
    if (fruitToMove != null && target.canReceive(fruitToMove)) {
      
      // OPTIONAL: In many games, we move ALL matching consecutive fruits from the top.
      // For simplicity, let's move one at a time first, or use a loop:
      var tempSource = source;
      var tempTarget = target;
      final colorToMove = fruitToMove;

      // Move as many as possible that match the color and fit in the target
      while (tempSource.top == colorToMove && tempTarget.canReceive(colorToMove)) {
        tempTarget = tempTarget.add(tempSource.top!);
        tempSource = tempSource.pop();
      }

      tubes[fromIdx] = tempSource;
      tubes[toIdx] = tempTarget;

      final newLevel = UILevel(
        levelNumber: state.level.levelNumber,
        tubes: tubes,
        numColors: state.level.numColors,
      );

      emit(state.copyWith(level: newLevel, clearSelection: true));

      // 3. Check win condition: All tubes are either empty or complete
      if (tubes.every((t) => t.isSorted)) {
        _handleWin(state.level.levelNumber);
      }
    } else {
      // 4. Invalid move:
      // If the user tapped a different non-empty tube, select that instead.
      // Otherwise, just deselect.
      if (!tubes[toIdx].isEmpty) {
        emit(state.copyWith(selectedTubeIndex: toIdx));
      } else {
        emit(state.copyWith(clearSelection: true));
      }
    }
  }
  void _handleWin(int currentLevel) {
    // Unlock next level in Hive
    // final nextLevel = currentLevel + 1;
    // if (nextLevel > HiveService.instance.unlockedUpTo) {
       // Assuming HiveService has a method to update progress
       HiveService.instance.unlockNextLevel(currentLevel); 
    // }
    emit(GamePlayVictory(levelNumber: currentLevel));
  }
}