import 'package:fruitflow/features/game_play/domain/tube.dart';

class UILevel {
  final int levelNumber;
  final List<Tube> tubes;
  final int numColors;

  UILevel({
    required this.levelNumber,
    required this.tubes,
    required this.numColors,
  });
}