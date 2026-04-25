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

  const GamePlayLoaded({required this.level});

  @override
  List<Object?> get props => [level];
}

final class GamePlayError extends GamePlayState {
  final String message;

  const GamePlayError({required this.message});

  @override
  List<Object?> get props => [message];
}