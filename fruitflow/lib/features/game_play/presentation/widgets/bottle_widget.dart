import 'package:flutter/material.dart';
import 'package:fruitflow/features/game_play/domain/fruit_type.dart';
import 'package:fruitflow/features/game_play/domain/tube.dart';
import 'package:fruitflow/features/game_play/presentation/widgets/fruit_assets.dart';

class BottleWidget extends StatelessWidget {
  final Tube tube;
  final bool isSelected;

  static const String _emptyBottleAsset = 'assets/play/empty_bottle_image.webp';

  const BottleWidget({super.key, required this.tube, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final slotSpacing = constraints.maxHeight * 0.01;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          transform: Matrix4.identity()
            ..translate(0.0, isSelected ? -40.0 : 0.0)
            ..scale(isSelected ? 1.05 : 1.0),

          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.75, // 1.0 = fully solid, 0.0 = invisible
                  child: Image.asset(_emptyBottleAsset, fit: BoxFit.contain),
                ),
              ),

              Positioned(
                left: constraints.maxWidth * 0.10,
                right: constraints.maxWidth * 0.10,
                bottom: constraints.maxHeight * 0.05,
                top: constraints.maxHeight * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(tube.capacity, (index) {
                    final slotIndex = (tube.capacity - 1) - index;

                    final hasSlab = slotIndex < tube.slabs.length;
                    final fruit = hasSlab ? tube.slabs[slotIndex] : null;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: slotSpacing),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.8,
                                  end: 1.2,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: fruit == null
                              ? const SizedBox(key: ValueKey('empty'))
                              : Transform.scale(
                                  scale: _fruitScale(fruit), // increase size
                                  child: Image.asset(
                                    fruitAsset(fruit),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  double _fruitScale(FruitType fruit) {
  switch (fruit) {
    case FruitType.grapes:
    case FruitType.mango:
      return 1.6; // slightly smaller
    default:
      return 2.0; // normal fruits
  }
}
}
