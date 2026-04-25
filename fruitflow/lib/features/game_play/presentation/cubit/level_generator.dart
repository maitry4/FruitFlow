// lib/core/level_generator.dart

import 'dart:math';

import 'package:layered/features/game_play/domain/fruit_type.dart';
import 'package:layered/features/game_play/domain/tube.dart';
import 'package:layered/features/game_play/domain/ui_level.dart';


class LevelGenerator {
  static const int _tubeCapacity = 4;
  static const int _maxSeedOffsets = 30; // more retries for hard boards
  static const int _maxAttempts = 5000;  // more scramble attempts

  // Only 1 extra empty tube for most difficulties.
  // High color counts need 2 to keep the puzzle solvable.
  static int _numEmptyTubes(int numColors) {
    if (numColors >= 7) return 2;
    return 1;
  }

  // Difficulty scaling:
  //   numColors : 3 at level 1, +1 every 5 levels, capped at 8
  //   numMixes  : 60 at level 1 → 200 at level 100
  static ({int numColors, int numMixes}) _getParams(int levelNumber) {
    int numColors = 3 + (levelNumber - 1) ~/ 5;
    if (numColors > 8) numColors = 8;

    final double t = ((levelNumber - 1) / 99.0).clamp(0.0, 1.0);
    final int numMixes = (60 + t * 140).toInt();

    return (numColors: numColors, numMixes: numMixes);
  }

  static bool _isAlreadySolved(List<Tube> tubes) {
    final nonEmpty = tubes.where((t) => !t.isEmpty).toList();
    if (nonEmpty.isEmpty) return true;
    return nonEmpty.every((t) => t.isComplete);
  }

  static bool _isDeadlocked(List<List<FruitType>> tubes, int capacity) {
    final n = tubes.length;
    for (int si = 0; si < n; si++) {
      final src = tubes[si];
      if (src.isEmpty) continue;
      final color = src.last;
      for (int ti = 0; ti < n; ti++) {
        if (ti == si) continue;
        final tgt = tubes[ti];
        if (tgt.length >= capacity) continue;
        if (tgt.isNotEmpty && tgt.last != color) continue;
        return false;
      }
    }
    return true;
  }

  // Homogeneity: 0.0 = perfectly mixed, 1.0 = perfectly sorted.
  // We reject boards above 0.75 (too easy).
  static double _homogeneity(List<List<FruitType>> tubes) {
    final nonEmpty = tubes.where((t) => t.isNotEmpty).toList();
    if (nonEmpty.isEmpty) return 1.0;

    double total = 0.0;
    for (final tube in nonEmpty) {
      final counts = <FruitType, int>{};
      for (final s in tube) counts[s] = (counts[s] ?? 0) + 1;
      final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
      total += maxCount / tube.length;
    }
    return total / nonEmpty.length;
  }

  // ── Main entry point ──────────────────────────────────────────────
  static UILevel generate(int levelNumber) {
    final params = _getParams(levelNumber);
    final int C = params.numColors;
    final int K = _tubeCapacity;
    final int E = _numEmptyTubes(C);
    final int N = C + E;

    for (int seedOffset = 0; seedOffset < _maxSeedOffsets; seedOffset++) {
      final random = Random(levelNumber * 997 + seedOffset * 31);

      // 1. Create K slabs of each color — start fully sorted
      final List<FruitType> allSlabs = [];
      for (int i = 0; i < C; i++) {
        for (int j = 0; j < K; j++) {
          allSlabs.add(FruitType.values[i]);
        }
      }

      // 2. DEEP SLAB SHUFFLE — scramble every individual slab
      //    across all positions before distributing into tubes.
      _shuffle(allSlabs, random);

      // 3. Distribute into C filled tubes + E empty tubes
      List<List<FruitType>> tubes = [];
      int idx = 0;
      for (int i = 0; i < C; i++) {
        tubes.add(List<FruitType>.from(allSlabs.sublist(idx, idx + K)));
        idx += K;
      }
      for (int i = 0; i < E; i++) {
        tubes.add([]);
      }

      // 4. SINGLE-SLAB pour-scramble with anti-sort bias
      int successful = 0;
      int attempts = 0;
      while (successful < params.numMixes && attempts < _maxAttempts) {
        attempts++;
        final srcI = random.nextInt(N);
        final tgtIdx = random.nextInt(N);
        if (srcI == tgtIdx) continue;

        final src = tubes[srcI];
        final tgt = tubes[tgtIdx];
        if (src.isEmpty || tgt.length >= K) continue;

        final color = src.last;

        // Only allow pour onto matching color or empty — game rules
        if (tgt.isNotEmpty && tgt.last != color) continue;
        // 🔥 NEW FIX — preserve required empty tubes
int emptyCount = tubes.where((t) => t.isEmpty).length;

// If target is empty, make sure we don't consume the last required empty tubes
if (tgt.isEmpty && emptyCount <= E) {
  continue;
}
        // Anti-sort: reject if this would complete a tube
        // (all remaining slabs in tgt would be the same color as `color`
        //  AND tgt is about to hit capacity)
        if (tgt.length == K - 1 &&
            tgt.isNotEmpty &&
            tgt.every((s) => s == color)) {
          continue; // skip moves that sort a tube during scrambling
        }

        // Pour exactly ONE slab
        tgt.add(src.removeLast());
        successful++;
      }

      // 5. Randomise display order
      _shuffleTubes(tubes, random);

      final tubeObjects = tubes
          .map((t) => Tube(capacity: K, slabs: List<FruitType>.from(t)))
          .toList();

      // Reject if accidentally solved
      if (_isAlreadySolved(tubeObjects)) continue;

      // Reject if deadlocked
      if (_isDeadlocked(tubes, K)) continue;

      // Reject if board is still too homogeneous (too easy)
      final h = _homogeneity(tubes);
      if (h > 0.75) continue;

      return UILevel(
        levelNumber: levelNumber,
        tubes: tubeObjects,
        numColors: C,
      );
    }

    throw StateError(
      'Could not generate a valid hard puzzle for level $levelNumber',
    );
  }

  static void _shuffle(List<FruitType> list, Random random) {
    for (int i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }

  static void _shuffleTubes(List<List<FruitType>> list, Random random) {
    for (int i = list.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }
}