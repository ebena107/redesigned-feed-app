import 'package:flutter/foundation.dart';

/// Enumeration for log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Centralized logging utility for consistent logging throughout the app
///
/// This logger provides:
/// - Consistent log formatting
/// - Log level filtering
/// - Optional stack trace capture for errors
/// - Environment-aware logging (disabled in production)
///
/// Usage:
/// ```dart
/// AppLogger.debug('Debug message');
/// AppLogger.info('Info message');
/// AppLogger.warning('Warning message');
/// AppLogger.error('Error message', stackTrace: stackTrace);
/// ```
class AppLogger {
  /// Prefix for all log messages
  static const String _logPrefix = '[FeedEstimator]';

  /// Whether logging is enabled (disabled in production)
  static bool _isEnabled = kDebugMode;

  /// Set whether logging is enabled
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Log a debug message
  /// Use for detailed diagnostic information
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Log an info message
  /// Use for general informational messages
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Log a warning message
  /// Use for potentially problematic situations
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Log an error message
  /// Use for error conditions
  static void error(
    String message, {
    String? tag,
    StackTrace? stackTrace,
    Object? error,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      stackTrace: stackTrace,
      error: error,
    );
  }

  /// Internal logging implementation
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    StackTrace? stackTrace,
    Object? error,
  }) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now();
    final levelStr = level.name.toUpperCase();
    final tagStr = tag != null ? '[$tag]' : '';
    final timeStr = '${timestamp.hour}:${timestamp.minute}:${timestamp.second}';

    final logMessage = '$_logPrefix $timeStr [$levelStr] $tagStr $message';

    // In debug mode, use debugPrint for better IDE integration
    debugPrint(logMessage);

    // Log stack trace if provided
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    // Log error details if provided
    if (error != null) {
      debugPrint('Error: $error');
    }
  }
}

/// Extension on String to provide tag convenience
extension LoggerExtension on Type {
  /// Get the class name for use as a tag
  String get tagName => toString();
}
