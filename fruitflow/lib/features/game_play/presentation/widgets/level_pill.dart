import 'package:flutter/material.dart';
class LevelPill extends StatelessWidget {
  final int levelNumber;
  const LevelPill({super.key, required this.levelNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        "Level $levelNumber",
        style: const TextStyle(
            fontWeight: FontWeight.w900, fontSize: 24, color: Color(0xFF263238)),
      ),
    );
  }
}