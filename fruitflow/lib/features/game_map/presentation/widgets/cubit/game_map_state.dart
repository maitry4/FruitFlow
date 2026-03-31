part of 'game_map_cubit.dart';

sealed class GameMapState extends Equatable {
  const GameMapState();

  @override
  List<Object?> get props => [];
}

final class GameMapLoading extends GameMapState {
  const GameMapLoading();
}

final class GameMapLoaded extends GameMapState {
  /// 1-based level number of the highest unlocked level.
  final int unlockedUpTo;

  const GameMapLoaded({required this.unlockedUpTo});

  @override
  List<Object?> get props => [unlockedUpTo];
}