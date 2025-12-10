import 'package:flutter/services.dart';

/// Centralized input validators for consistent validation across the app
///
/// Usage:
/// ```dart
/// TextField(
///   inputFormatters: InputValidators.numericFormatters,
///   decoration: InputDecoration(
///     errorText: InputValidators.validatePrice(value),
///   ),
/// );
/// ```
class InputValidators {
  InputValidators._(); // Private constructor to prevent instantiation

  // ==================== REGEX PATTERNS ====================

  /// Allows numbers with optional decimal point (both comma and period)
  static final RegExp numericRegex = RegExp(r'[0-9]+[.,]{0,1}[0-9]*');

  /// Allows only letters and spaces (for names)
  static final RegExp nameRegex = RegExp(r'[a-zA-Z\s]');

  /// Allows alphanumeric with spaces and common punctuation
  static final RegExp alphanumericRegex = RegExp(r'[a-zA-Z0-9\s\-_.]');

  // ==================== INPUT FORMATTERS ====================

  /// Input formatter for numeric fields (price, quantity, weight)
  /// Normalizes comma to period for decimal consistency
  static List<TextInputFormatter> get numericFormatters => [
        FilteringTextInputFormatter.allow(numericRegex),
        TextInputFormatter.withFunction((oldValue, newValue) {
          // Replace comma with period for consistent decimal handling
          final text = newValue.text.replaceAll(',', '.');
          return newValue.copyWith(text: text);
        }),
      ];

  /// Input formatter for name fields (feed name, ingredient name)
  static List<TextInputFormatter> get nameFormatters => [
        FilteringTextInputFormatter.allow(nameRegex),
        LengthLimitingTextInputFormatter(50), // Max 50 characters
      ];

  /// Input formatter for alphanumeric fields with length limit
  static List<TextInputFormatter> alphanumericFormatters(
          {int maxLength = 100}) =>
      [
        FilteringTextInputFormatter.allow(alphanumericRegex),
        LengthLimitingTextInputFormatter(maxLength),
      ];

  // ==================== VALIDATORS ====================

  /// Validates price input
  /// Returns error message if invalid, null if valid
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));

    if (parsed == null) {
      return 'Enter valid price (e.g., 10.50)';
    }

    if (parsed < 0) {
      return 'Price cannot be negative';
    }

    if (parsed > 1000000) {
      return 'Price exceeds maximum value (1,000,000)';
    }

    return null;
  }

  /// Validates quantity/weight input
  /// Returns error message if invalid, null if valid
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));

    if (parsed == null) {
      return 'Enter valid quantity (e.g., 10.50)';
    }

    if (parsed <= 0) {
      return 'Quantity must be greater than 0';
    }

    if (parsed > 100000) {
      return 'Quantity exceeds maximum value (100,000)';
    }

    return null;
  }

  /// Validates feed/ingredient name
  /// Returns error message if invalid, null if valid
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return '$fieldName cannot be only whitespace';
    }

    if (trimmed.length < 3) {
      return '$fieldName must be at least 3 characters';
    }

    if (trimmed.length > 50) {
      return '$fieldName must be less than 50 characters';
    }

    return null;
  }

  /// Validates email format (if needed for user accounts)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Validates percentage (0-100)
  static String? validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Percentage is required';
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));

    if (parsed == null) {
      return 'Enter valid percentage (e.g., 25.5)';
    }

    if (parsed < 0 || parsed > 100) {
      return 'Percentage must be between 0 and 100';
    }

    return null;
  }

  /// Validates generic numeric input with custom range
  static String? validateNumeric(
    String? value, {
    required double min,
    required double max,
    String? fieldName,
  }) {
    final field = fieldName ?? 'Value';

    if (value == null || value.isEmpty) {
      return '$field is required';
    }

    final parsed = double.tryParse(value.replaceAll(',', '.'));

    if (parsed == null) {
      return 'Enter valid $field';
    }

    if (parsed < min) {
      return '$field must be at least $min';
    }

    if (parsed > max) {
      return '$field must be at most $max';
    }

    return null;
  }

  /// Validates that a value is not empty/null
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates phone number (basic format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and common separators
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleaned.length < 10 || cleaned.length > 15) {
      return 'Enter a valid phone number';
    }

    if (!RegExp(r'^[0-9+]+$').hasMatch(cleaned)) {
      return 'Phone number can only contain digits and +';
    }

    return null;
  }
}
