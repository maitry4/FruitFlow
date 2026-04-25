sealed class GamePlayState extends Equatable {
  const GamePlayState();

  @override
  List<Object?> get props => [];
}
@@ -13,18 +12,40 @@ final class GamePlayLoading extends GamePlayState {

final class GamePlayLoaded extends GamePlayState {
  final UILevel level;
  final int? selectedTubeIndex;

  const GamePlayLoaded({
    required this.level,
    this.selectedTubeIndex,
  });

  GamePlayLoaded copyWith({
    UILevel? level,
    int? selectedTubeIndex,
    bool clearSelection = false,
  }) {
    return GamePlayLoaded(
      level: level ?? this.level,
      selectedTubeIndex: clearSelection ? null : (selectedTubeIndex ?? this.selectedTubeIndex),
    );
  }const GamePlayLoaded({required this.level});
  @override
  List<Object?> get props => [level, selectedTubeIndex];
}

final class GamePlayVictory extends GamePlayState {
  final int levelNumber;
  const GamePlayVictory({required this.levelNumber});
  
  @override
  List<Object?> get props => [level];
  List<Object?> get props => [levelNumber];
}

final class GamePlayError extends GamePlayState {
  final String message;

  const GamePlayError({required this.message});

  @override
  List<Object?> get props => [message];
}
}