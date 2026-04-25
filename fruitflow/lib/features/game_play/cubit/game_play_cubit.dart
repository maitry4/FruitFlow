import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layered/features/game_play/domain/ui_level.dart';
import 'package:layered/features/game_play/presentation/cubit/level_generator.dart';

part 'game_play_state.dart';

class GamePlayCubit extends Cubit<GamePlayState> {
  GamePlayCubit() : super(const GamePlayLoading());

  Future<void> loadLevel(int levelNumber) async {
    emit(const GamePlayLoading());

    try {
      final level = LevelGenerator.generate(levelNumber);
      emit(GamePlayLoaded(level: level));
    } catch (e) {
      emit(GamePlayError(message: e.toString()));
    }
  }
}