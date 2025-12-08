import 'package:equatable/equatable.dart';
import '../exceptions/app_exceptions.dart';

/// Represents a weight measurement with unit
///
/// Supports conversion between kg, g, lbs, oz
class Weight extends Equatable {
  final double value;
  final WeightUnit unit;

  const Weight({
    required this.value,
    required this.unit,
  });

  /// Creates a Weight from a map (for database serialization)
  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      value: (map['value'] as num).toDouble(),
      unit: WeightUnit.values.firstWhere(
        (u) => u.toString() == 'WeightUnit.${map['unit']}',
        orElse: () => WeightUnit.kg,
      ),
    );
  }

  /// Converts to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'unit': unit.name,
    };
  }

  /// Validates and creates a Weight
  static Weight validated(double value, WeightUnit unit) {
    if (value < 0) {
      throw ValidationException(
        field: 'weight',
        rule: 'non-negative',
        message: 'Weight cannot be negative: $value',
      );
    }
    if (value > 1000000) {
      throw ValidationException(
        field: 'weight',
        rule: 'max-value',
        message: 'Weight exceeds maximum allowed value: $value',
      );
    }
    return Weight(value: value, unit: unit);
  }

  /// Convert to kilograms
  double toKg() {
    switch (unit) {
      case WeightUnit.kg:
        return value;
      case WeightUnit.g:
        return value / 1000;
      case WeightUnit.lbs:
        return value * 0.453592;
      case WeightUnit.oz:
        return value * 0.0283495;
      case WeightUnit.ton:
        return value * 1000;
    }
  }

  /// Convert to grams
  double toG() {
    return toKg() * 1000;
  }

  /// Convert to pounds
  double toLbs() {
    return toKg() / 0.453592;
  }

  /// Convert to ounces
  double toOz() {
    return toKg() / 0.0283495;
  }

  /// Convert to tons
  double toTon() {
    return toKg() / 1000;
  }

  /// Convert to a different unit
  Weight convertTo(WeightUnit targetUnit) {
    final kg = toKg();
    double targetValue;

    switch (targetUnit) {
      case WeightUnit.kg:
        targetValue = kg;
        break;
      case WeightUnit.g:
        targetValue = kg * 1000;
        break;
      case WeightUnit.lbs:
        targetValue = kg / 0.453592;
        break;
      case WeightUnit.oz:
        targetValue = kg / 0.0283495;
        break;
      case WeightUnit.ton:
        targetValue = kg / 1000;
        break;
    }

    return Weight(value: targetValue, unit: targetUnit);
  }

  /// Add two weights (auto-converts to same unit)
  Weight operator +(Weight other) {
    final thisKg = toKg();
    final otherKg = other.toKg();
    final totalKg = thisKg + otherKg;

    // Return in original unit
    return Weight(value: totalKg, unit: WeightUnit.kg).convertTo(unit);
  }

  /// Subtract two weights (auto-converts to same unit)
  Weight operator -(Weight other) {
    final thisKg = toKg();
    final otherKg = other.toKg();
    final diffKg = thisKg - otherKg;

    return Weight(value: diffKg, unit: WeightUnit.kg).convertTo(unit);
  }

  /// Multiply weight by a factor
  Weight operator *(double factor) {
    return Weight(value: value * factor, unit: unit);
  }

  /// Divide weight by a factor
  Weight operator /(double factor) {
    if (factor == 0) {
      throw ValidationException(
        field: 'weight',
        rule: 'non-zero-divisor',
        message: 'Cannot divide weight by zero',
      );
    }
    return Weight(value: value / factor, unit: unit);
  }

  /// Compare weights (auto-converts to kg)
  bool operator >(Weight other) {
    return toKg() > other.toKg();
  }

  /// Compare weights (auto-converts to kg)
  bool operator <(Weight other) {
    return toKg() < other.toKg();
  }

  /// Format weight for display
  String format() {
    return '${value.toStringAsFixed(2)} ${unit.symbol}';
  }

  /// Format with custom decimal places
  String formatWithDecimals(int decimals) {
    return '${value.toStringAsFixed(decimals)} ${unit.symbol}';
  }

  @override
  List<Object?> get props => [value, unit];

  @override
  String toString() => format();
}

/// Weight units supported by the app
enum WeightUnit {
  kg,
  g,
  lbs,
  oz,
  ton;

  String get symbol {
    switch (this) {
      case WeightUnit.kg:
        return 'kg';
      case WeightUnit.g:
        return 'g';
      case WeightUnit.lbs:
        return 'lbs';
      case WeightUnit.oz:
        return 'oz';
      case WeightUnit.ton:
        return 'ton';
    }
  }

  String get name {
    switch (this) {
      case WeightUnit.kg:
        return 'Kilograms';
      case WeightUnit.g:
        return 'Grams';
      case WeightUnit.lbs:
        return 'Pounds';
      case WeightUnit.oz:
        return 'Ounces';
      case WeightUnit.ton:
        return 'Tons';
    }
  }
}
