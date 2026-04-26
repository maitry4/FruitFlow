import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Level badge — small pill showing the level number on a bottle.
// ─────────────────────────────────────────────────────────────────────────────

class LevelBadge extends StatelessWidget {
  final int number;
  final double fontSize;

  const LevelBadge({
    super.key,
    required this.number,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.6,
        vertical: fontSize * 0.2,
      ),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.92),
        borderRadius: BorderRadius.circular(fontSize),
        boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.45),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color:  cs.onPrimary,
          height: 1.0,
        ),
      ),
    );
  }
}