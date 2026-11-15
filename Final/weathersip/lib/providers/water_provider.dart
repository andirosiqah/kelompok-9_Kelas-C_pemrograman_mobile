
import 'package:flutter/material.dart';
import '../models/water_intake.dart';

class WaterProvider extends ChangeNotifier {
  final List<WaterIntake> _intakes = [];

  int _dailyGoalMl = 2000;

  List<WaterIntake> get intakes =>
      List.unmodifiable(_intakes);

  int get dailyGoalMl => _dailyGoalMl;

  int get consumedMl {
    final now = DateTime.now();

    return _intakes
        .where((intake) =>
            intake.timestamp.year == now.year &&
            intake.timestamp.month == now.month &&
            intake.timestamp.day == now.day)
        .fold(0, (total, intake) => total + intake.amountMl);
  }

  int get remainingMl {
    return (dailyGoalMl - consumedMl).clamp(0, dailyGoalMl);
  }

  double get progress {
    if (dailyGoalMl <= 0) return 0;

    return (consumedMl / dailyGoalMl).clamp(0.0, 1.0);
  }

  void addWater(int amount) {
    if (amount <= 0) return;

    final intake = WaterIntake(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountMl: amount,
      timestamp: DateTime.now(),
    );

    _intakes.add(intake);

    notifyListeners();
  }

  void setDailyGoal(int amount) {
    if (amount <= 0) return;

    _dailyGoalMl = amount;

    notifyListeners();
  }

  void removeWater(String id) {
    _intakes.removeWhere((intake) => intake.id == id);

    notifyListeners();
  }

void updateWater(String id, int newAmount) {
  if (newAmount <= 0) return;

  final index = _intakes.indexWhere(
    (intake) => intake.id == id,
  );

  if (index == -1) return;

  final oldIntake = _intakes[index];

  _intakes[index] = WaterIntake(
    id: oldIntake.id,
    amountMl: newAmount,
    timestamp: oldIntake.timestamp,
  );

  notifyListeners();
}

}
