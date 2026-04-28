import 'package:flutter_test/flutter_test.dart';
import 'package:fruitflow/features/game_play/presentation/cubit/game_play_cubit.dart';
import 'package:fruitflow/features/game_play/domain/fruit_type.dart';
import 'package:fruitflow/features/game_play/domain/tube.dart';
import 'package:fruitflow/features/game_play/domain/ui_level.dart';

void main() {
  group('GamePlayCubit', () {
    late GamePlayCubit cubit;

    setUp(() {
      cubit = GamePlayCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is GamePlayLoading', () {
      expect(cubit.state, isA<GamePlayLoading>());
    });

    test('loadLevel emits GamePlayLoaded with a level', () {
      cubit.loadLevel(1);
      expect(cubit.state, isA<GamePlayLoaded>());
      final state = cubit.state as GamePlayLoaded;
      expect(state.level.levelNumber, 1);
      expect(state.history, isEmpty);
    });

    test('onTubeTapped selects a non-empty tube', () {
      cubit.loadLevel(1);
      final stateBefore = cubit.state as GamePlayLoaded;
      
      // Find first non-empty tube
      int nonEmptyIdx = stateBefore.level.tubes.indexWhere((t) => !t.isEmpty);
      
      cubit.onTubeTapped(nonEmptyIdx);
      
      final stateAfter = cubit.state as GamePlayLoaded;
      expect(stateAfter.selectedTubeIndex, nonEmptyIdx);
    });

    test('onTubeTapped second tap on same tube deselects it', () {
      cubit.loadLevel(1);
      final stateBefore = cubit.state as GamePlayLoaded;
      int nonEmptyIdx = stateBefore.level.tubes.indexWhere((t) => !t.isEmpty);
      
      cubit.onTubeTapped(nonEmptyIdx);
      expect((cubit.state as GamePlayLoaded).selectedTubeIndex, nonEmptyIdx);
      
      cubit.onTubeTapped(nonEmptyIdx);
      expect((cubit.state as GamePlayLoaded).selectedTubeIndex, isNull);
    });

    test('undo restores previous state', () {
      cubit.loadLevel(1);
      final initialState = cubit.state as GamePlayLoaded;
      
      
      final tubes = initialState.level.tubes;
      final historyTubes = [List<Tube>.from(tubes)];
    
    });

    test('reset reloads the level', () {
      cubit.loadLevel(1);
      final state1 = cubit.state as GamePlayLoaded;
      
      cubit.reset();
      final state2 = cubit.state as GamePlayLoaded;
      
      expect(state2.level.levelNumber, 1);
      expect(state2.history, isEmpty);
    });
  });
}