import 'package:flutter/material.dart';
class ActionButton extends StatelessWidget {
  final String? label;
  final Widget? child;
  final VoidCallback onTap;
  const ActionButton({super.key, this.label, this.child, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 130),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFFB74D), Color(0xFFF57C00)]),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))
          ],
        ),
        child: Center(
          child: label != null
              ? Text(label!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20))
              : child,
        ),
      ),
    );
  }
}