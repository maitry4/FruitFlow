import 'package:fruitflow/features/game_play/domain/fruit_type.dart';

class Tube {
  final int capacity;
  final List<FruitType> slabs; // [0] is bottom, [last] is top

  Tube({required this.capacity, required List<FruitType> slabs})
      : slabs = List.unmodifiable(slabs);

  bool get isEmpty => slabs.isEmpty;
  bool get isFull => slabs.length == capacity;
  FruitType? get top => slabs.isNotEmpty ? slabs.last : null;

  // A tube is "Complete" only if it's full and all items match
  bool get isComplete =>
      isFull && slabs.every((s) => s == slabs.first);

  // A tube is "Sorted" (for win condition) if it is either totally empty 
  // or completely filled with the same fruit.
  bool get isSorted => isEmpty || isComplete;

  // Validation: Can this tube receive the specific fruit?
  bool canReceive(FruitType fruit) {
    if (isFull) return false; // No room
    if (isEmpty) return true; // Can pour anything into empty
    return top == fruit;      // Otherwise, must match the top fruit
  }

  Tube add(FruitType fruit) {
    final newSlabs = List<FruitType>.from(slabs)..add(fruit);
    return Tube(capacity: capacity, slabs: newSlabs);
  }

  Tube pop() {
    final newSlabs = List<FruitType>.from(slabs)..removeLast();
    return Tube(capacity: capacity, slabs: newSlabs);
  }
}