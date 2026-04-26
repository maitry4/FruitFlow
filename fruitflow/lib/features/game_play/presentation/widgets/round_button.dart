import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const RoundButton({super.key, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE082),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Icon(icon, color: Colors.brown[700], size: 28),
      ),
    );
  }
}
