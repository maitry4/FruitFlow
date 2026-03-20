import 'package:flutter/material.dart';

/// Single source of truth for all raw color values.
/// Never reference these directly in widgets — always go through [ThemeData]
/// or [ColorScheme] so dark mode works for free when you add it.
abstract final class AppColors {
  // ── Brand: Green ────────────────────────────────────────────────────────────
  static const Color green900 = Color(0xFF0D3320); // deepest, text on light bg
  static const Color green800 = Color(0xFF1A5C38);
  static const Color green700 = Color(0xFF237A49); // primary action
  static const Color green600 = Color(0xFF2E9E5E);
  static const Color green500 = Color(0xFF3DBE74); // primary light variant
  static const Color green200 = Color(0xFFB2EDCC);
  static const Color green100 = Color(0xFFDDF5E8);
  static const Color green50  = Color(0xFFF2FBF5); // scaffold background

  // ── Brand: Orange ───────────────────────────────────────────────────────────
  static const Color orange900 = Color(0xFF4D1C00);
  static const Color orange700 = Color(0xFFBF4D00); // secondary action
  static const Color orange500 = Color(0xFFE87020); // secondary light variant
  static const Color orange300 = Color(0xFFF5A466);
  static const Color orange100 = Color(0xFFFFEBD6);

  // ── Neutrals ────────────────────────────────────────────────────────────────
  static const Color grey900 = Color(0xFF1A1A1A); // primary text
  static const Color grey700 = Color(0xFF3D3D3D);
  static const Color grey500 = Color(0xFF737373); // secondary text / hints
  static const Color grey300 = Color(0xFFB8B8B8); // dividers
  static const Color grey100 = Color(0xFFF0F0F0); // card backgrounds
  static const Color white   = Color(0xFFFFFFFF);

  // ── Semantic ─────────────────────────────────────────────────────────────────
  static const Color error   = Color(0xFFD32F2F);
  static const Color success = green700;
  static const Color warning = orange500;
}