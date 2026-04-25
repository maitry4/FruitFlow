class Tube {
  final int capacity;
  final List<FruitType> slabs; // bottom → top
  final List<FruitType> slabs; // [0] is bottom, [last] is top

  Tube({required this.capacity, required List<FruitType> slabs})
      : slabs = List.unmodifiable(slabs);
 class Tube {
  bool get isFull => slabs.length == capacity;
  FruitType? get top => slabs.isNotEmpty ? slabs.last : null;

  // A tube is "Complete" only if it's full and all items match
  bool get isComplete =>
      isFull && slabs.every((s) => s == slabs.first);

  Tube copy() => Tube(capacity: capacity, slabs: List.from(slabs));
}
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