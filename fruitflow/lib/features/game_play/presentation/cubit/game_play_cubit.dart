import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/services/hive_service.dart';
import 'package:fruitflow/features/game_play/domain/ui_level.dart';
import 'package:fruitflow/features/game_play/presentation/cubit/level_generator.dart';
import 'package:fruitflow/features/game_play/domain/tube.dart';

part 'game_play_state.dart';

class GamePlayCubit extends Cubit<GamePlayState> {
  GamePlayCubit() : super(const GamePlayLoading());

  void loadLevel(int levelNumber) {
    emit(const GamePlayLoading());
    try {
      final level = LevelGenerator.generate(levelNumber);
      emit(GamePlayLoaded(level: level, history: const []));
    } catch (e) {
      emit(GamePlayError(message: e.toString()));
    }
  }

  void reset() {
    if (state is GamePlayLoaded) {
      loadLevel((state as GamePlayLoaded).level.levelNumber);
    }
  }

  void undo() {
    final currentState = state;
    if (currentState is GamePlayLoaded && currentState.history.isNotEmpty) {
      final newHistory = List<List<Tube>>.from(currentState.history);
      final previousTubes = newHistory.removeLast();

      final newLevel = UILevel(
        levelNumber: currentState.level.levelNumber,
        tubes: previousTubes,
        numColors: currentState.level.numColors,
      );

      emit(currentState.copyWith(
        level: newLevel,
        history: newHistory,
        clearSelection: true,
      ));
    }
  }

  void onTubeTapped(int index) {
    final currentState = state;
    if (currentState is! GamePlayLoaded) return;

    final selectedIdx = currentState.selectedTubeIndex;

    if (selectedIdx == null) {
      if (!currentState.level.tubes[index].isEmpty) {
        emit(currentState.copyWith(selectedTubeIndex: index));
      }
    } else if (selectedIdx == index) {
      emit(currentState.copyWith(clearSelection: true));
    } else {
      _handlePour(currentState, selectedIdx, index);
    }
  }

  void _handlePour(GamePlayLoaded state, int fromIdx, int toIdx) {
    final tubes = List<Tube>.from(state.level.tubes);
    final source = tubes[fromIdx];
    final target = tubes[toIdx];
    final fruitToMove = source.top;

    if (fruitToMove != null && target.canReceive(fruitToMove)) {
      // Save current state to history before making the move
      final updatedHistory = List<List<Tube>>.from(state.history)
        ..add(state.level.tubes);

      var tempSource = source;
      var tempTarget = target;

      // Pour all matching consecutive fruits
      while (tempSource.top == fruitToMove && tempTarget.canReceive(fruitToMove)) {
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

      emit(state.copyWith(
        level: newLevel,
        history: updatedHistory,
        clearSelection: true,
      ));

      if (tubes.every((t) => t.isSorted)) {
        _handleWin(state.level.levelNumber);
      }
    } else {
      if (!tubes[toIdx].isEmpty) {
        emit(state.copyWith(selectedTubeIndex: toIdx));
      } else {
        emit(state.copyWith(clearSelection: true));
      }
    }
  }

  void _handleWin(int currentLevel) {
      HiveService.instance.unlockNextLevel(currentLevel);
    emit(GamePlayVictory(levelNumber: currentLevel));
  }
}