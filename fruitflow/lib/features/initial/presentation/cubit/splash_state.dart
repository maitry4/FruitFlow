part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

final class SplashLoading extends SplashState {}

final class SplashReady extends SplashState {
  final String assetPath;
  final String targetRoute;

  const SplashReady({
    required this.assetPath,
    required this.targetRoute,
  });

  @override
  List<Object> get props => [assetPath, targetRoute];
}

final class SplashError extends SplashState {
  final String message;

  const SplashError({required this.message});

  @override
  List<Object> get props => [message];
}