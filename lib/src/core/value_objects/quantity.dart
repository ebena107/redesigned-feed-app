import 'package:equatable/equatable.dart';
import '../exceptions/app_exceptions.dart';

/// Represents a quantity measurement with unit
///
/// Used for ingredient quantities in formulations
class Quantity extends Equatable {
  final double value;
  final String unit;

  const Quantity({
    required this.value,
    required this.unit,
  });

  /// Creates a Quantity from a map (for database serialization)
  factory Quantity.fromMap(Map<String, dynamic> map) {
    return Quantity(
      value: (map['value'] as num).toDouble(),
      unit: map['unit'] as String,
    );
  }

  /// Converts to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'unit': unit,
    };
  }

  /// Validates and creates a Quantity
  static Quantity validated(double value, String unit) {
    if (value < 0) {
      throw ValidationException(
        field: 'quantity',
        rule: 'non-negative',
        message: 'Quantity cannot be negative: $value',
      );
    }
    if (value > 1000000) {
      throw ValidationException(
        field: 'quantity',
        rule: 'max-value',
        message: 'Quantity exceeds maximum allowed value: $value',
      );
    }
    if (unit.trim().isEmpty) {
      throw ValidationException(
        field: 'quantity',
        rule: 'non-empty-unit',
        message: 'Unit cannot be empty',
      );
    }
    return Quantity(value: value, unit: unit);
  }

  /// Add two quantities (must have same unit)
  Quantity operator +(Quantity other) {
    if (unit != other.unit) {
      throw ValidationException(
        field: 'quantity',
        rule: 'same-unit',
        message:
            'Cannot add quantities with different units: $unit vs ${other.unit}',
      );
    }
    return Quantity(value: value + other.value, unit: unit);
  }

  /// Subtract two quantities (must have same unit)
  Quantity operator -(Quantity other) {
    if (unit != other.unit) {
      throw ValidationException(
        field: 'quantity',
        rule: 'same-unit',
        message:
            'Cannot subtract quantities with different units: $unit vs ${other.unit}',
      );
    }
    return Quantity(value: value - other.value, unit: unit);
  }

  /// Multiply quantity by a factor
  Quantity operator *(double factor) {
    return Quantity(value: value * factor, unit: unit);
  }

  /// Divide quantity by a factor
  Quantity operator /(double factor) {
    if (factor == 0) {
      throw ValidationException(
        field: 'quantity',
        rule: 'non-zero-divisor',
        message: 'Cannot divide quantity by zero',
      );
    }
    return Quantity(value: value / factor, unit: unit);
  }

  /// Compare quantities (must have same unit)
  bool operator >(Quantity other) {
    if (unit != other.unit) {
      throw ValidationException(
        field: 'quantity',
        rule: 'same-unit',
        message:
            'Cannot compare quantities with different units: $unit vs ${other.unit}',
      );
    }
    return value > other.value;
  }

  /// Compare quantities (must have same unit)
  bool operator <(Quantity other) {
    if (unit != other.unit) {
      throw ValidationException(
        field: 'quantity',
        rule: 'same-unit',
        message:
            'Cannot compare quantities with different units: $unit vs ${other.unit}',
      );
    }
    return value < other.value;
  }

  /// Format quantity for display
  String format() {
    return '${value.toStringAsFixed(2)} $unit';
  }

  /// Format with custom decimal places
  String formatWithDecimals(int decimals) {
    return '${value.toStringAsFixed(decimals)} $unit';
  }

  /// Create a percentage representation
  String formatAsPercentage() {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [value, unit];

  @override
  String toString() => format();
}
