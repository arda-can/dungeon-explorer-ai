import 'package:flutter/material.dart';
import '../models/level.dart';
import '../services/storage_service.dart';

class LevelProvider extends ChangeNotifier {
  static const int totalLevels = 20;
  late List<Level> levels;

  LevelProvider() {
    _initializeLevels();
  }

  void _initializeLevels() {
    levels = List.generate(
      totalLevels,
      (index) {
        final levelId = index + 1;
        return Level(
          id: levelId,
          starsEarned: StorageService.getLevelStars(levelId),
          isUnlocked: StorageService.isLevelUnlocked(levelId),
          isCompleted: StorageService.isLevelCompleted(levelId),
        );
      },
    );
  }

  Future<void> completeLevelWithStars(int levelId, int stars) async {
    final index = levelId - 1;
    levels[index] = levels[index].copyWith(
      starsEarned: stars,
      isCompleted: true,
    );

    if (levelId < totalLevels) {
      levels[levelId] = levels[levelId].copyWith(isUnlocked: true);
    }

    await StorageService.saveLevelProgress(levelId, stars);
    notifyListeners();
  }

  Level getLevel(int levelId) {
    return levels[levelId - 1];
  }

  List<Level> getAllLevels() {
    return levels;
  }
}
