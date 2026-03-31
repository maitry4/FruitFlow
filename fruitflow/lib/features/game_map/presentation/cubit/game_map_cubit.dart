import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruitflow/core/services/hive_service.dart';

part 'game_map_state.dart';

class GameMapCubit extends Cubit<GameMapState> {
  GameMapCubit() : super(const GameMapLoading());

  /// Call once when the map screen mounts.
  void load() {
    final unlocked = HiveService.instance.unlockedUpTo;
    emit(GameMapLoaded(unlockedUpTo: unlocked));
  }
}