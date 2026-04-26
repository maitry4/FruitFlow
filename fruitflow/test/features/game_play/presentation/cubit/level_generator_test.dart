import 'package:flutter_test/flutter_test.dart';
import 'package:fruitflow/features/game_play/presentation/cubit/level_generator.dart';

void main() {
  group('LevelGenerator', () {
    test('generate returns a valid UILevel for level 1', () {
      final level = LevelGenerator.generate(1);
      
      expect(level.levelNumber, 1);
      expect(level.numColors, 3);
      expect(level.tubes.length, 5); // 3 colors + 2 empty (since >= 3 colors gets 2 empty)
      
      // Verify all tubes have capacity 4
      for (final tube in level.tubes) {
        expect(tube.capacity, 4);
      }
    });

    test('generate returns more colors for higher levels', () {
      final level1 = LevelGenerator.generate(1);
      final level50 = LevelGenerator.generate(50);
      
      expect(level50.numColors, greaterThanOrEqualTo(level1.numColors));
      expect(level50.numColors, lessThanOrEqualTo(8));
    });

    test('generated level is not already solved', () {
      for (int i = 1; i <= 5; i++) {
        final level = LevelGenerator.generate(i);
        final isSolved = level.tubes.where((t) => !t.isEmpty).every((t) => t.isComplete);
        expect(isSolved, isFalse, reason: 'Level $i should not be pre-solved');
      }
    });

    test('total fruit slabs matches numColors * capacity', () {
      final level = LevelGenerator.generate(10);
      int totalSlabs = 0;
      for (final tube in level.tubes) {
        totalSlabs += tube.slabs.length;
      }
      expect(totalSlabs, level.numColors * 4);
    });
  });
}