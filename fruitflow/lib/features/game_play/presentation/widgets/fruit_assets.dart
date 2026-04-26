import 'package:fruitflow/features/game_play/domain/fruit_type.dart';
String fruitAsset(FruitType type) {
  return switch (type) {
    FruitType.apple => 'assets/fruits/apple.webp',
    FruitType.banana => 'assets/fruits/banana.webp',
    FruitType.watermelon => 'assets/fruits/watermelon.webp',
    FruitType.lime => 'assets/fruits/lime.webp',
    FruitType.grapes => 'assets/fruits/grapes.webp',
    FruitType.mango => 'assets/fruits/mango.webp',
    FruitType.strawberry => 'assets/fruits/strawberry.webp',
    FruitType.blueberry => 'assets/fruits/blueberry.webp',
  };
}