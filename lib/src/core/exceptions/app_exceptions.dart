/// Base exception for all feed estimator app exceptions
///
/// All custom exceptions should extend this class for consistent
/// error handling throughout the application.
abstract class AppException implements Exception {
  /// The error message
  final String message;

  /// The original error/exception that caused this
  final Object? originalError;

  /// Stack trace of the original error
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown by repository operations
///
/// Indicates an issue with data access, storage, or retrieval operations.
/// This includes database errors, file system errors, etc.
class RepositoryException extends AppException {
  /// The operation that failed (e.g., 'create', 'read', 'update', 'delete')
  final String operation;

  RepositoryException({
    required this.operation,
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() => 'RepositoryException ($operation): $message';
}

/// Exception thrown when data validation fails
///
/// Indicates that input data did not pass validation rules.
class ValidationException extends AppException {
  /// The field that failed validation
  final String? field;

  /// The validation rule that was violated
  final String? rule;

  ValidationException({
    required super.message,
    this.field,
    this.rule,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() =>
      'ValidationException: $message (field: $field, rule: $rule)';
}

/// Exception thrown when synchronization fails
///
/// Indicates an issue with syncing data between local and remote storage,
/// or handling offline/online transitions.
class SyncException extends AppException {
  /// The resource being synced
  final String resource;

  /// Whether this is a conflict that requires manual resolution
  final bool isConflict;

  SyncException({
    required this.resource,
    required super.message,
    this.isConflict = false,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() =>
      'SyncException ($resource)${isConflict ? ' [CONFLICT]' : ''}: $message';
}

/// Exception thrown for date/time related errors
///
/// Indicates an issue with date/time calculations, parsing, or validation.
class DateTimeException extends AppException {
  /// The date/time value that caused the issue
  final String? value;

  DateTimeException({
    required super.message,
    this.value,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() => 'DateTimeException: $message (value: $value)';
}

/// Exception for calculation/computation errors
///
/// Indicates an issue with mathematical calculations or numerical computations.
class CalculationException extends AppException {
  /// The operation that failed
  final String operation;

  /// The values involved in the calculation
  final Map<String, dynamic>? values;

  CalculationException({
    required this.operation,
    required super.message,
    this.values,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() => 'CalculationException ($operation): $message';
}

/// Exception for business logic violations
///
/// Indicates that an operation violates a business rule.
class BusinessLogicException extends AppException {
  /// The business rule that was violated
  final String rule;

  BusinessLogicException({
    required this.rule,
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() => 'BusinessLogicException: $message (rule: $rule)';
}

/// Exception for state-related errors
///
/// Indicates an invalid state transition or operation on invalid state.
class StateException extends AppException {
  /// The current state
  final String currentState;

  /// The invalid operation attempted
  final String operation;

  StateException({
    required this.currentState,
    required this.operation,
    required super.message,
    super.originalError,
    super.stackTrace,
  });
  @override
  String toString() =>
      'StateException: $message (state: $currentState, operation: $operation)';
}
