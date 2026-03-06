abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashReady extends SplashState {
  final String assetPath;

  SplashReady({required this.assetPath});
}

class SplashError extends SplashState {
  final String message;

  SplashError({required this.message});
}