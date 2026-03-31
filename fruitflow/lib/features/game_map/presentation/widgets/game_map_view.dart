import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/features/game_map/presentation/cubit/game_map_cubit.dart';
import 'package:fruitflow/features/game_map/presentation/widgets/map_content.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GameMapView — listens to GameMapCubit and switches between states.
// ─────────────────────────────────────────────────────────────────────────────

class GameMapView extends StatelessWidget {
  const GameMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameMapCubit, GameMapState>(
      builder: (context, state) => Scaffold(
        body: switch (state) {
          GameMapLoading() => const _LoadingView(),
          GameMapLoaded(:final unlockedUpTo) =>
            MapContent(unlockedUpTo: unlockedUpTo),
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LoadingView — shown while the cubit fetches progress data.
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}