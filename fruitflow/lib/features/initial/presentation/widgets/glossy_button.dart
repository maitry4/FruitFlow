import 'package:flutter/material.dart';

class GlossyButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const GlossyButton({required this.label, required this.onPressed});

  @override
  State<GlossyButton> createState() => _GlossyButtonState();
}

class _GlossyButtonState extends State<GlossyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final base  = Theme.of(context).colorScheme.primary;
    final light = Theme.of(context).colorScheme.primaryFixed;
    final dark  = Theme.of(context).colorScheme.onPrimaryContainer;

    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); widget.onPressed(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale:    _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve:    Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: dark, width: 2.5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end:   Alignment.bottomCenter,
              colors: [light, base],
            ),
            boxShadow: [
              BoxShadow(
                color:      dark.withOpacity(0.6),
                blurRadius: 8,
                offset:     const Offset(0, 4),
              ),
              BoxShadow(
                color:        light.withOpacity(0.4),
                blurRadius:   4,
                spreadRadius: 1,
                offset:       Offset.zero,
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize:      22,
              fontWeight:    FontWeight.w900,
              color:         Theme.of(context).colorScheme.onPrimary,
              letterSpacing: 0.5,
              shadows: [
                Shadow(color: Theme.of(context).colorScheme.onPrimaryContainer, offset: Offset(0, 2), blurRadius: 4),
                Shadow(color: Theme.of(context).colorScheme.onPrimaryContainer, offset: Offset(0, 1), blurRadius: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}