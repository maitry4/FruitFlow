import 'package:flutter/material.dart';
import 'package:layered/features/game_play/domain/tube.dart';
import 'package:layered/features/game_play/presentation/widgets/fruit_assets.dart';
class BottleWidget extends StatelessWidget {
  final Tube tube;
  static const String _emptyBottleAsset = 'assets/play/empty_bottle_image.webp';

  const BottleWidget({required this.tube});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final slotSpacing = constraints.maxHeight * 0.02;

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                _emptyBottleAsset,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: constraints.maxWidth * 0.18,
              right: constraints.maxWidth * 0.18,
              bottom: constraints.maxHeight * 0.09,
              top: constraints.maxHeight * 0.17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(tube.capacity, (slotFromBottom) {
                  final hasSlab = slotFromBottom < tube.slabs.length;
                  final fruit = hasSlab ? tube.slabs[slotFromBottom] : null;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: slotSpacing),
                      child: fruit == null
                          ? DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            )
                          : Image.asset(
                              fruitAsset(fruit),
                              fit: BoxFit.contain,
                            ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}