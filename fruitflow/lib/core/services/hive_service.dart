import 'package:hive_flutter/hive_flutter.dart';

/// Central service for all local database operations.
///
/// All Hive boxes are opened once in [init] (called from main before runApp).
/// No other file in the codebase should import hive directly.
class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  static const _kOnboardingBox = 'onboarding';
  static const _kProgressBox   = 'progress';

  static const _kSeenOnboardingKey = 'has_seen_onboarding';
  static const _kUnlockedUpToKey   = 'unlocked_up_to';

  late final Box<bool> _onboardingBox;
  late final Box<int>  _progressBox;


  /// Must be called once in [main] before [runApp].
  static Future<void> init() async {
    await Hive.initFlutter();
    final self = HiveService.instance;
    self._onboardingBox = await Hive.openBox<bool>(_kOnboardingBox);
    self._progressBox   = await Hive.openBox<int>(_kProgressBox);
  }


  bool get hasSeenOnboarding =>
      _onboardingBox.get(_kSeenOnboardingKey, defaultValue: false) ?? false;

  Future<void> markOnboardingSeen() =>
      _onboardingBox.put(_kSeenOnboardingKey, true);


  /// Returns the highest level the player has unlocked (1-based).
  /// Defaults to 1 so the first level is always available.
  int get unlockedUpTo =>
      _progressBox.get(_kUnlockedUpToKey, defaultValue: 1) ?? 1;

  /// Call after a level is completed to unlock the next one.
  Future<void> unlockNextLevel(int completedLevel) async {
    if (completedLevel >= unlockedUpTo) {
      await _progressBox.put(_kUnlockedUpToKey, completedLevel + 1);
    }
  }

  /// Wipes all progress. Used for dev / reset flows.
  Future<void> resetProgress() =>
      _progressBox.put(_kUnlockedUpToKey, 1);
}