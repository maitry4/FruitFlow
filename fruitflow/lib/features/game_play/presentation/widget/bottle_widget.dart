import 'package:flutter/material.dart';
import 'package:layered/features/game_play/domain/tube.dart';
import 'package:layered/features/game_play/presentation/widgets/fruit_assets.dart';

class BottleWidget extends StatelessWidget {
  final Tube tube;
  final bool isSelected;
  static const String _emptyBottleAsset = 'assets/play/empty_bottle_image.webp';

  const BottleWidget({required this.tube});
  const BottleWidget({
    super.key, 
    required this.tube, 
    this.isSelected = false,
  });

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
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          // Lift the bottle up if selected
          transform: Matrix4.translationValues(0, isSelected ? -20 : 0, 0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _emptyBottleAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
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
                children: List.generate(tube.capacity, (index) {
                  // 'index' 0 is the top of the Column visually.
                  // We need to map it so the highest possible slot (capacity - 1) is at the top.
                  final slotIndex = (tube.capacity - 1) - index;
                  
                  final hasSlab = slotIndex < tube.slabs.length;
                  final fruit = hasSlab ? tube.slabs[slotIndex] : null;

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
                          ? const SizedBox.shrink()
                          : Image.asset(
                              fruitAsset(fruit),
                              fit: BoxFit.contain,
@@ -52,8 +60,8 @@ class BottleWidget extends StatelessWidget {
                  );
                }),
              ),
            ),
          ],
            ),],
          ),
        );
      },
    );