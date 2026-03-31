// map_content.dart

import 'package:flutter/material.dart';
import 'package:fruitflow/core/responsive/responsive_config.dart';
import 'package:fruitflow/features/game_map/presentation/constants/map_slot_positions.dart';
import 'package:fruitflow/features/game_map/presentation/widgets/level_bottle.dart';

class MapContent extends StatefulWidget {
  final int unlockedUpTo;

  const MapContent({super.key, required this.unlockedUpTo});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  late final PageController _pageController;

  static const int _total = 50; // change to AppConstants.totalLevels when ready
  static const int _perPage = 5;

  @override
  void initState() {
    super.initState();
    final initialPage = ((widget.unlockedUpTo - 1) / _perPage).floor();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _bgAsset(BuildContext context) => Responsive.isMobile(context)
      ? 'assets/game_map_background_mobile.webp'
      : 'assets/game_map_background_desktop.webp';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenW = constraints.maxWidth;
      final screenH = constraints.maxHeight;
      final slots =
          Responsive.isMobile(context) ? kSlotsMobile : kSlotsDesktop;

      return Stack(
        children: [
          _MapBackground(asset: _bgAsset(context)),
          _BottleCanvas(
            pageController: _pageController,
            total: _total,
            perPage: _perPage,
            screenW: screenW,
            screenH: screenH,
            slots: slots,
            unlockedUpTo: widget.unlockedUpTo,
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MapBackground extends StatelessWidget {
  final String asset;
  const _MapBackground({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(asset, fit: BoxFit.cover),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _BottleCanvas extends StatelessWidget {
  final PageController pageController;
  final int total;
  final int perPage;
  final double screenW;
  final double screenH;
  final List<Offset> slots;
  final int unlockedUpTo;

  const _BottleCanvas({
    required this.pageController,
    required this.total,
    required this.perPage,
    required this.screenW,
    required this.screenH,
    required this.slots,
    required this.unlockedUpTo,
  });

  @override
  Widget build(BuildContext context) {
    final bottleSize = (screenW * 0.17).clamp(50.0, 92.0);
    final pageCount = (total / perPage).ceil();

    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemCount: pageCount,
      itemBuilder: (context, pageIndex) {
        return Stack(
          children: List.generate(perPage, (slotIndex) {
            final levelNumber = pageIndex * perPage + slotIndex + 1;
            if (levelNumber > total) return const SizedBox.shrink();

            final slot = slots[slotIndex];
            final dx = screenW * slot.dx;
            final dy = screenH * slot.dy;

            return Positioned(
              left: dx - bottleSize / 2,
              top: dy - (bottleSize * 1.55) / 2,
              child: LevelBottle(
                levelNumber: levelNumber,
                isUnlocked: levelNumber <= unlockedUpTo,
                size: bottleSize,
              ),
            );
          }),
        );
      },
    );
  }
}