import 'dart:async';

/// Database timeout utility for preventing hanging operations
///
/// Wraps database operations with a timeout to prevent indefinite blocking.
/// Industry standard: 30 seconds for most database operations.
class DatabaseTimeout {
  /// Default timeout for database operations
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Wrap a future with timeout handling
  ///
  /// Throws [TimeoutException] if operation exceeds [timeout]
  static Future<T> withTimeout<T>(
    Future<T> operation, {
    Duration timeout = defaultTimeout,
    String? operationName,
  }) {
    return operation.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        '${operationName ?? "Database operation"} timed out after ${timeout.inSeconds}s',
      ),
    );
  }

  /// Wrap a database insert operation with timeout
  static Future<int> insert(Future<int> operation) {
    return withTimeout(operation, operationName: 'Database insert');
  }

  /// Wrap a database query operation with timeout
  static Future<List<Map<String, Object?>>> query(
    Future<List<Map<String, Object?>>> operation,
  ) {
    return withTimeout(operation, operationName: 'Database query');
  }

  /// Wrap a database update operation with timeout
  static Future<int> update(Future<int> operation) {
    return withTimeout(operation, operationName: 'Database update');
  }

  /// Wrap a database delete operation with timeout
  static Future<int> delete(Future<int> operation) {
    return withTimeout(operation, operationName: 'Database delete');
  }
}
