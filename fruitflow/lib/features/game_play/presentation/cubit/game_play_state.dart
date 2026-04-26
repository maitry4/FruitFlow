part of 'game_play_cubit.dart';

sealed class GamePlayState extends Equatable {
  const GamePlayState();
  @override
  List<Object?> get props => [];
}

final class GamePlayLoading extends GamePlayState {
  const GamePlayLoading();
}

final class GamePlayLoaded extends GamePlayState {
  final UILevel level;
  final int? selectedTubeIndex;
  final List<List<Tube>> history; // Stores tube layouts for undo

  const GamePlayLoaded({
    required this.level,
    this.selectedTubeIndex,
    this.history = const [],
  });

  GamePlayLoaded copyWith({
    UILevel? level,
    int? selectedTubeIndex,
    bool clearSelection = false,
    List<List<Tube>>? history,
  }) {
    return GamePlayLoaded(
      level: level ?? this.level,
      selectedTubeIndex: clearSelection ? null : (selectedTubeIndex ?? this.selectedTubeIndex),
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [level, selectedTubeIndex, history];
}

final class GamePlayVictory extends GamePlayState {
  final int levelNumber;
  const GamePlayVictory({required this.levelNumber});
  @override
  List<Object?> get props => [levelNumber];
}

final class GamePlayError extends GamePlayState {
  final String message;
  const GamePlayError({required this.message});
  @override
  List<Object?> get props => [message];
}