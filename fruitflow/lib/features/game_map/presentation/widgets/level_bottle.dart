import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/router/app_routes.dart';
import 'package:fruitflow/features/game_map/presentation/widgets/level_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LevelBottle — tappable bottle with a press-scale animation.
// ─────────────────────────────────────────────────────────────────────────────

class LevelBottle extends StatefulWidget {
  final int levelNumber;
  final bool isUnlocked;
  final double size;

  const LevelBottle({
    super.key,
    required this.levelNumber,
    required this.isUnlocked,
    required this.size,
  });

  @override
  State<LevelBottle> createState() => _LevelBottleState();
}

class _LevelBottleState extends State<LevelBottle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap(BuildContext context) async {
    if (!widget.isUnlocked) return;
    await _ctrl.forward();
    await _ctrl.reverse();
    if (context.mounted) {
      context.goNamed(
        AppRoutes.gamePlay,
        queryParameters: {'level': widget.levelNumber.toString()},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return GestureDetector(
      onTap: () => _onTap(context),
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          width: s,
          height: s * 1.55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: _BottleImage(isUnlocked: widget.isUnlocked)),
              if(widget.isUnlocked)
                Positioned(
                  bottom: s * 0.04,
                  child: LevelBadge(
                    number: widget.levelNumber,
                    fontSize: s * 0.18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BottleImage — locked / unlocked asset with tint for locked state.
// ─────────────────────────────────────────────────────────────────────────────

class _BottleImage extends StatelessWidget {
  final bool isUnlocked;
  const _BottleImage({required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isUnlocked ? 'assets/map/unlocked_bottle.webp' : 'assets/map/locked_bottle.webp',
      fit: BoxFit.contain,
      color: isUnlocked ? null : Colors.white.withOpacity(0.65),
      colorBlendMode: isUnlocked ? null : BlendMode.modulate,
    );
  }
}