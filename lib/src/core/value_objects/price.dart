import 'package:equatable/equatable.dart';
import '../exceptions/app_exceptions.dart';

/// Represents a monetary price value with currency
///
/// This value object ensures type safety for all price-related operations
/// and provides validation for price values.
class Price extends Equatable {
  final double amount;
  final String currency;

  const Price({
    required this.amount,
    this.currency = 'NGN', // Default to Nigerian Naira
  });

  /// Creates a Price from a map (for database serialization)
  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String? ?? 'NGN',
    );
  }

  /// Converts to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }

  /// Validates and creates a Price
  static Price validated(double amount, {String currency = 'NGN'}) {
    if (amount < 0) {
      throw ValidationException(
        field: 'price',
        rule: 'non-negative',
        message: 'Price cannot be negative: $amount',
      );
    }
    if (amount > 1000000000) {
      throw ValidationException(
        field: 'price',
        rule: 'max-value',
        message: 'Price exceeds maximum allowed value: $amount',
      );
    }
    return Price(amount: amount, currency: currency);
  }

  /// Add two prices (must be same currency)
  Price operator +(Price other) {
    if (currency != other.currency) {
      throw ValidationException(
        field: 'price',
        rule: 'same-currency',
        message:
            'Cannot add prices with different currencies: $currency vs ${other.currency}',
      );
    }
    return Price(amount: amount + other.amount, currency: currency);
  }

  /// Subtract two prices (must be same currency)
  Price operator -(Price other) {
    if (currency != other.currency) {
      throw ValidationException(
        field: 'price',
        rule: 'same-currency',
        message:
            'Cannot subtract prices with different currencies: $currency vs ${other.currency}',
      );
    }
    return Price(amount: amount - other.amount, currency: currency);
  }

  /// Multiply price by a factor
  Price operator *(double factor) {
    return Price(amount: amount * factor, currency: currency);
  }

  /// Divide price by a factor
  Price operator /(double factor) {
    if (factor == 0) {
      throw ValidationException(
        field: 'price',
        rule: 'non-zero-divisor',
        message: 'Cannot divide price by zero',
      );
    }
    return Price(amount: amount / factor, currency: currency);
  }

  /// Compare prices (must be same currency)
  bool operator >(Price other) {
    if (currency != other.currency) {
      throw ValidationException(
        field: 'price',
        rule: 'same-currency',
        message:
            'Cannot compare prices with different currencies: $currency vs ${other.currency}',
      );
    }
    return amount > other.amount;
  }

  /// Compare prices (must be same currency)
  bool operator <(Price other) {
    if (currency != other.currency) {
      throw ValidationException(
        field: 'price',
        rule: 'same-currency',
        message:
            'Cannot compare prices with different currencies: $currency vs ${other.currency}',
      );
    }
    return amount < other.amount;
  }

  /// Format price for display with currency symbol
  String format() {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format price with custom decimal places
  String formatWithDecimals(int decimals) {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(decimals)}';
  }

  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'NGN':
        return '₦';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currency ';
    }
  }

  @override
  List<Object?> get props => [amount, currency];

  @override
  String toString() => format();
}
