import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered/features/game_map/presentation/cubit/game_map_cubit.dart';
import 'package:layered/features/game_map/presentation/widgets/game_map_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GameMapScreen — route entry point; provides GameMapCubit to the tree.
// ─────────────────────────────────────────────────────────────────────────────

class GameMapScreen extends StatelessWidget {
  const GameMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameMapCubit()..load(),
      child: const GameMapView(),
    );
  }
}