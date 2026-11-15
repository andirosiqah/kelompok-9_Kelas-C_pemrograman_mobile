
import 'package:flutter_test/flutter_test.dart';
import 'package:weathersip/providers/water_provider.dart';

void main() {
  late WaterProvider waterProvider;

  setUp(() {
    waterProvider = WaterProvider();
  });

  group('WaterProvider Tests', () {
    test('Initial daily goal should be 2000 ml', () {
      expect(waterProvider.dailyGoalMl, 2000);
    });

    test('Should add water intake correctly', () {
      waterProvider.addWater(250);

      expect(waterProvider.consumedMl, 250);
      expect(waterProvider.intakes.length, 1);
    });

    test('Should calculate daily progress correctly', () {
      waterProvider.addWater(500);

      expect(waterProvider.progress, 0.25);
      expect(waterProvider.remainingMl, 1500);
    });

    test('Should update daily goal correctly', () {
      waterProvider.setDailyGoal(2500);

      expect(waterProvider.dailyGoalMl, 2500);
    });

    test('Should update water intake correctly', () {
      waterProvider.addWater(250);

      final recordId = waterProvider.intakes.first.id;

      waterProvider.updateWater(recordId, 400);

      expect(waterProvider.consumedMl, 400);
    });

    test('Should remove water intake correctly', () {
      waterProvider.addWater(250);

      final recordId = waterProvider.intakes.first.id;

      waterProvider.removeWater(recordId);

      expect(waterProvider.consumedMl, 0);
      expect(waterProvider.intakes.length, 0);
    });

    test('Should reject zero or negative water intake', () {
      waterProvider.addWater(0);
      waterProvider.addWater(-100);

      expect(waterProvider.consumedMl, 0);
      expect(waterProvider.intakes.length, 0);
    });

    test('Should not accept invalid daily goal', () {
      waterProvider.setDailyGoal(0);
      waterProvider.setDailyGoal(-500);

      expect(waterProvider.dailyGoalMl, 2000);
    });
  });
}
