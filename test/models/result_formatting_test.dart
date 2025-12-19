import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';

void main() {
  group('Result Formatted Display Tests', () {
    test('Energy should display in kcal/kg without conversion', () {
      final result = Result(mEnergy: 2350);

      expect(result.formattedEnergy, '2350 kcal/kg');
    });

    test('Crude protein should display as percentage', () {
      final result = Result(cProtein: 16.5);

      expect(result.formattedCrudeProtein, '16.5%');
    });

    test('Total phosphorus should convert from g/kg to %', () {
      // Storage: 4.5 g/kg → Display: 0.45%
      final result = Result(totalPhosphorus: 4.5);

      expect(result.formattedTotalPhosphorus, '0.45%');
    });

    test('Available phosphorus should convert from g/kg to %', () {
      // Storage: 2.8 g/kg → Display: 0.28%
      final result = Result(availablePhosphorus: 2.8);

      expect(result.formattedAvailablePhosphorus, '0.28%');
    });

    test('Calcium should convert from g/kg to %', () {
      // Storage: 6.5 g/kg → Display: 0.65%
      final result = Result(calcium: 6.5);

      expect(result.formattedCalcium, '0.65%');
    });

    test('Lysine should convert from g/kg to %', () {
      // Storage: 9.5 g/kg → Display: 0.95%
      final result = Result(lysine: 9.5);

      expect(result.formattedLysine, '0.95%');
    });

    test('Methionine should convert from g/kg to %', () {
      // Storage: 3.2 g/kg → Display: 0.32%
      final result = Result(methionine: 3.2);

      expect(result.formattedMethionine, '0.32%');
    });

    test('Null values should display as --', () {
      final result = Result();

      expect(result.formattedEnergy, '--');
      expect(result.formattedCrudeProtein, '--');
      expect(result.formattedTotalPhosphorus, '--');
      expect(result.formattedLysine, '--');
    });

    test('Ash should display as percentage', () {
      final result = Result(ash: 5.5);

      expect(result.formattedAsh, '5.5%');
    });

    test('Moisture should display as percentage', () {
      final result = Result(moisture: 10.0);

      expect(result.formattedMoisture, '10.0%');
    });
  });
}
