import 'package:equatable/equatable.dart';
import 'package:feed_estimator/src/features/reports/providers/enhanced_calculation_engine.dart';

/// Result of ingredient inclusion limit validation
class InclusionValidationResult extends Equatable {
  final List<InclusionViolation> violations;
  final List<InclusionWarning> warnings;

  const InclusionValidationResult({
    this.violations = const [],
    this.warnings = const [],
  });

  bool get hasViolations => violations.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasIssues => hasViolations || hasWarnings;

  String get violationSummary {
    if (violations.isEmpty) return '';
    return '⚠️ VIOLATIONS: ${violations.map((v) => v.ingredientName).join(", ")}';
  }

  String get warningSummary {
    if (warnings.isEmpty) return '';
    return '⚠️ WARNINGS: ${warnings.map((w) => w.ingredientName).join(", ")}';
  }

  @override
  List<Object?> get props => [violations, warnings];
}

/// Represents a hard violation of inclusion limits (exceeds maximum)
class InclusionViolation extends Equatable {
  final String ingredientName;
  final num maxAllowedPct;
  final num actualPct;
  final String? reason;

  const InclusionViolation({
    required this.ingredientName,
    required this.maxAllowedPct,
    required this.actualPct,
    this.reason,
  });

  String get exceededBy => (actualPct - maxAllowedPct).toStringAsFixed(2);

  String get description =>
      '$ingredientName exceeds limit: ${actualPct.toStringAsFixed(1)}% > ${maxAllowedPct.toStringAsFixed(1)}%${reason != null ? ' ($reason)' : ''}';

  @override
  List<Object?> get props => [ingredientName, maxAllowedPct, actualPct, reason];
}

/// Represents a warning about approaching inclusion limits
class InclusionWarning extends Equatable {
  final String ingredientName;
  final num maxAllowedPct;
  final num actualPct;
  final num warningThresholdPct; // e.g., 80% of max triggers warning

  const InclusionWarning({
    required this.ingredientName,
    required this.maxAllowedPct,
    required this.actualPct,
    this.warningThresholdPct = 0.8,
  });

  num get percentageOfLimit =>
      EnhancedCalculationEngine.roundToDouble(actualPct / maxAllowedPct * 100);

  String get description =>
      '$ingredientName is at ${percentageOfLimit.toStringAsFixed(1)}% of maximum: ${actualPct.toStringAsFixed(1)}% of ${maxAllowedPct.toStringAsFixed(1)}% limit';

  @override
  List<Object?> get props =>
      [ingredientName, maxAllowedPct, actualPct, warningThresholdPct];
}

/// Enhanced calculation warning (regulatory, safety, etc.)
class CalculationWarning extends Equatable {
  final String type; // 'regulatory', 'safety', 'nutritional', 'cost'
  final String message;
  final String? ingredientName;
  final WarningLevel level;

  const CalculationWarning({
    required this.type,
    required this.message,
    this.ingredientName,
    this.level = WarningLevel.info,
  });

  @override
  List<Object?> get props => [type, message, ingredientName, level];
}

enum WarningLevel {
  info,
  warning,
  critical,
}
