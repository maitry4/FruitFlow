import 'package:flutter_test/flutter_test.dart';
import 'package:fruitflow/features/game_play/domain/fruit_type.dart';
import 'package:fruitflow/features/game_play/domain/tube.dart';

void main() {
  group('Tube', () {
    test('isEmpty returns true for empty tube', () {
      final tube = Tube(capacity: 4, slabs: []);
      expect(tube.isEmpty, isTrue);
    });

    test('isFull returns true when length equals capacity', () {
      final tube = Tube(capacity: 2, slabs: [FruitType.apple, FruitType.apple]);
      expect(tube.isFull, isTrue);
    });

    test('top returns the last item in slabs', () {
      final tube = Tube(capacity: 4, slabs: [FruitType.apple, FruitType.banana]);
      expect(tube.top, FruitType.banana);
    });

    test('isComplete returns true only if full and all items match', () {
      final completeTube = Tube(capacity: 2, slabs: [FruitType.apple, FruitType.apple]);
      final incompleteTube = Tube(capacity: 2, slabs: [FruitType.apple, FruitType.banana]);
      final partialTube = Tube(capacity: 4, slabs: [FruitType.apple, FruitType.apple]);

      expect(completeTube.isComplete, isTrue);
      expect(incompleteTube.isComplete, isFalse);
      expect(partialTube.isComplete, isFalse);
    });

    test('isSorted returns true for empty or complete tubes', () {
      final emptyTube = Tube(capacity: 4, slabs: []);
      final completeTube = Tube(capacity: 2, slabs: [FruitType.apple, FruitType.apple]);
      final mixedTube = Tube(capacity: 4, slabs: [FruitType.apple, FruitType.banana]);

      expect(emptyTube.isSorted, isTrue);
      expect(completeTube.isSorted, isTrue);
      expect(mixedTube.isSorted, isFalse);
    });

    test('canReceive validation logic', () {
      final emptyTube = Tube(capacity: 4, slabs: []);
      final partialTube = Tube(capacity: 4, slabs: [FruitType.apple]);
      final fullTube = Tube(capacity: 1, slabs: [FruitType.apple]);

      expect(emptyTube.canReceive(FruitType.banana), isTrue, reason: 'Can pour anything into empty');
      expect(partialTube.canReceive(FruitType.apple), isTrue, reason: 'Can pour matching fruit');
      expect(partialTube.canReceive(FruitType.banana), isFalse, reason: 'Cannot pour mismatching fruit');
      expect(fullTube.canReceive(FruitType.apple), isFalse, reason: 'Cannot pour into full tube');
    });

    test('add returns a new Tube with added fruit', () {
      final tube = Tube(capacity: 4, slabs: [FruitType.apple]);
      final nextTube = tube.add(FruitType.apple);
      
      expect(nextTube.slabs.length, 2);
      expect(nextTube.slabs.last, FruitType.apple);
      expect(tube.slabs.length, 1, reason: 'Original tube should remain unchanged');
    });

    test('pop returns a new Tube with last fruit removed', () {
      final tube = Tube(capacity: 4, slabs: [FruitType.apple, FruitType.banana]);
      final nextTube = tube.pop();
      
      expect(nextTube.slabs.length, 1);
      expect(nextTube.slabs.last, FruitType.apple);
      expect(tube.slabs.length, 2, reason: 'Original tube should remain unchanged');
    });
  });
}