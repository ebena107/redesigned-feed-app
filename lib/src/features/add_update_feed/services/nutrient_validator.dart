import 'dart:convert';
import 'package:feed_estimator/src/features/reports/model/result.dart';

/// Validates formulation against industry standards
///
/// References:
/// - NRC 2012 (Swine Nutrient Requirements)
/// - NRC 2016 (Poultry Nutrient Requirements)
/// - CVB 2021 (Dutch Feed Tables)
/// - INRA-AFZ 2018 (French Feed Tables)
class NutrientValidator {
  /// Validate pig formulation against NRC 2012
  ///
  /// Parameters:
  /// - result: Calculated feed formulation result
  /// - pigStage: 'grower' (20-50kg), 'finisher' (50-120kg), 'sow', 'piglet'
  ///
  /// Returns: ValidationResult with warnings and errors
  static ValidationResult validatePigFormulation({
    required Result result,
    required String pigStage,
  }) {
    final warnings = <String>[];
    final errors = <String>[];

    // NRC 2012 requirements for growing pigs (20-50 kg)
    if (pigStage == 'grower') {
      _validatePigGrower(result, warnings, errors);
    }
    // NRC 2012 requirements for finishing pigs (50-120 kg)
    else if (pigStage == 'finisher') {
      _validatePigFinisher(result, warnings, errors);
    }
    // NRC 2012 requirements for gestating sows
    else if (pigStage == 'sow') {
      _validateSow(result, warnings, errors);
    }
    // NRC 2012 requirements for piglets (5-20 kg)
    else if (pigStage == 'piglet') {
      _validatePiglet(result, warnings, errors);
    }

    return ValidationResult(
      warnings: warnings,
      errors: errors,
      isValid: errors.isEmpty,
      standard: 'NRC 2012',
    );
  }

  /// Validate grower pig formulation (20-50 kg)
  static void _validatePigGrower(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 16-18% (NRC 2012, Table 6-1)
    if (result.cProtein != null) {
      if (result.cProtein! < 14) {
        errors.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC minimum (16%)');
      } else if (result.cProtein! < 16) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC recommended (16-18%)');
      } else if (result.cProtein! > 20) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'above NRC recommended (16-18%). May increase cost.');
      }
    }

    // SID Lysine: 0.95-1.05% (NRC 2012)
    final sidLysine = _extractSidLysine(result);
    if (sidLysine != null) {
      if (sidLysine < 0.85) {
        errors.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'below NRC minimum (0.95%)');
      } else if (sidLysine < 0.95) {
        warnings.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'below NRC recommended (0.95-1.05%)');
      } else if (sidLysine > 1.15) {
        warnings.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'above NRC recommended. May increase cost.');
      }
    }

    // Net Energy: 2,300-2,450 kcal/kg (NRC 2012)
    if (result.mEnergy != null) {
      if (result.mEnergy! < 2100) {
        warnings
            .add('Net Energy (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
                'below NRC recommended (2,300-2,450 kcal/kg)');
      } else if (result.mEnergy! > 2600) {
        warnings
            .add('Net Energy (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
                'above NRC recommended. May increase cost.');
      }
    }

    // Available Phosphorus: 0.23-0.33% (NRC 2012)
    if (result.availablePhosphorus != null) {
      final availP = result.availablePhosphorus! / 10; // Convert g/kg to %
      if (availP < 0.20) {
        warnings.add('Available P (${availP.toStringAsFixed(2)}%) '
            'below NRC recommended (0.23-0.33%)');
      } else if (availP > 0.40) {
        warnings.add('Available P (${availP.toStringAsFixed(2)}%) '
            'above NRC recommended. Environmental concern.');
      }
    }

    // Calcium: 0.50-0.70% (NRC 2012)
    if (result.calcium != null) {
      final ca = result.calcium! / 10; // Convert g/kg to %
      if (ca < 0.45) {
        warnings.add('Calcium (${ca.toStringAsFixed(2)}%) '
            'below NRC recommended (0.50-0.70%)');
      } else if (ca > 0.85) {
        warnings.add('Calcium (${ca.toStringAsFixed(2)}%) '
            'above NRC recommended. May affect palatability.');
      }
    }

    // Ca:P ratio: 1.2:1 to 2:1 (NRC 2012)
    if (result.calcium != null && result.availablePhosphorus != null) {
      final capRatio = result.calcium! / result.availablePhosphorus!;
      if (capRatio < 1.0 || capRatio > 2.5) {
        warnings.add('Ca:P ratio (${capRatio.toStringAsFixed(1)}:1) '
            'outside NRC recommended range (1.2:1 to 2:1)');
      }
    }

    // Crude Fiber: <5% for optimal growth (NRC 2012)
    if (result.cFibre != null && result.cFibre! > 6) {
      warnings.add('Crude Fiber (${result.cFibre!.toStringAsFixed(1)}%) '
          'above recommended (<5%). May reduce digestibility.');
    }
  }

  /// Validate finisher pig formulation (50-120 kg)
  static void _validatePigFinisher(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 14-16% (NRC 2012)
    if (result.cProtein != null) {
      if (result.cProtein! < 12) {
        errors.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC minimum (14%)');
      } else if (result.cProtein! < 14) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC recommended (14-16%)');
      } else if (result.cProtein! > 18) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'above NRC recommended (14-16%). May increase cost.');
      }
    }

    // SID Lysine: 0.75-0.85% (NRC 2012)
    final sidLysine = _extractSidLysine(result);
    if (sidLysine != null) {
      if (sidLysine < 0.65) {
        errors.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'below NRC minimum (0.75%)');
      } else if (sidLysine < 0.75) {
        warnings.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'below NRC recommended (0.75-0.85%)');
      }
    }

    // Net Energy: 2,400-2,550 kcal/kg (NRC 2012)
    if (result.mEnergy != null) {
      if (result.mEnergy! < 2200) {
        warnings
            .add('Net Energy (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
                'below NRC recommended (2,400-2,550 kcal/kg)');
      }
    }
  }

  /// Validate sow formulation
  static void _validateSow(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 13-15% (NRC 2012)
    if (result.cProtein != null) {
      if (result.cProtein! < 12) {
        errors.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC minimum (13%)');
      } else if (result.cProtein! < 13) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC recommended (13-15%)');
      }
    }

    // SID Lysine: 0.60-0.70% (NRC 2012)
    final sidLysine = _extractSidLysine(result);
    if (sidLysine != null && sidLysine < 0.55) {
      warnings.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
          'below NRC recommended (0.60-0.70%)');
    }
  }

  /// Validate piglet formulation (5-20 kg)
  static void _validatePiglet(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 18-22% (NRC 2012)
    if (result.cProtein != null) {
      if (result.cProtein! < 16) {
        errors.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC minimum (18%)');
      } else if (result.cProtein! < 18) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC recommended (18-22%)');
      }
    }

    // SID Lysine: 1.15-1.35% (NRC 2012)
    final sidLysine = _extractSidLysine(result);
    if (sidLysine != null) {
      if (sidLysine < 1.05) {
        errors.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'below NRC minimum (1.15%)');
      } else if (sidLysine < 1.15) {
        warnings.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
            'below NRC recommended (1.15-1.35%)');
      }
    }
  }

  /// Validate poultry formulation against NRC 2016
  static ValidationResult validatePoultryFormulation({
    required Result result,
    required String poultryType, // 'broiler_starter', 'broiler_grower', 'layer'
  }) {
    final warnings = <String>[];
    final errors = <String>[];

    if (poultryType == 'broiler_starter') {
      _validateBroilerStarter(result, warnings, errors);
    } else if (poultryType == 'broiler_grower') {
      _validateBroilerGrower(result, warnings, errors);
    } else if (poultryType == 'layer') {
      _validateLayer(result, warnings, errors);
    }

    return ValidationResult(
      warnings: warnings,
      errors: errors,
      isValid: errors.isEmpty,
      standard: 'NRC 2016',
    );
  }

  /// Validate broiler starter formulation (0-10 days)
  static void _validateBroilerStarter(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 21-23% (NRC 2016)
    if (result.cProtein != null) {
      if (result.cProtein! < 20) {
        errors.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC minimum (21%)');
      } else if (result.cProtein! < 21) {
        warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
            'below NRC recommended (21-23%)');
      }
    }

    // ME: 3,000-3,100 kcal/kg (NRC 2016)
    if (result.mEnergy != null) {
      if (result.mEnergy! < 2900) {
        warnings.add('ME (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
            'below NRC recommended (3,000-3,100 kcal/kg)');
      }
    }

    // Lysine: 1.20-1.35% (NRC 2016)
    final lysine = _extractLysine(result);
    if (lysine != null && lysine < 1.15) {
      warnings.add('Lysine (${lysine.toStringAsFixed(2)}%) '
          'below NRC recommended (1.20-1.35%)');
    }
  }

  /// Validate broiler grower formulation (11-24 days)
  static void _validateBroilerGrower(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 19-21% (NRC 2016)
    if (result.cProtein != null && result.cProtein! < 18) {
      warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
          'below NRC recommended (19-21%)');
    }

    // ME: 3,100-3,200 kcal/kg (NRC 2016)
    if (result.mEnergy != null && result.mEnergy! < 3000) {
      warnings.add('ME (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
          'below NRC recommended (3,100-3,200 kcal/kg)');
    }
  }

  /// Validate layer formulation
  static void _validateLayer(
    Result result,
    List<String> warnings,
    List<String> errors,
  ) {
    // Crude Protein: 16-18% (NRC 2016)
    if (result.cProtein != null && result.cProtein! < 15) {
      warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
          'below NRC recommended (16-18%)');
    }

    // Calcium: 3.5-4.0% for layers (NRC 2016)
    if (result.calcium != null) {
      final ca = result.calcium! / 10; // Convert g/kg to %
      if (ca < 3.2) {
        errors.add('Calcium (${ca.toStringAsFixed(2)}%) '
            'below NRC minimum (3.5%) for egg production');
      } else if (ca < 3.5) {
        warnings.add('Calcium (${ca.toStringAsFixed(2)}%) '
            'below NRC recommended (3.5-4.0%)');
      }
    }
  }

  /// Extract SID lysine from result JSON
  static double? _extractSidLysine(Result result) {
    if (result.aminoAcidsSidJson == null) return null;

    try {
      final Map<String, dynamic> sidMap =
          json.decode(result.aminoAcidsSidJson!);
      final lysine = sidMap['lysine'] as num?;
      return lysine != null ? lysine.toDouble() / 10 : null; // g/kg to %
    } catch (e) {
      return null;
    }
  }

  /// Extract total lysine (fallback)
  static double? _extractLysine(Result result) {
    // Try SID first
    final sidLysine = _extractSidLysine(result);
    if (sidLysine != null) return sidLysine;

    // Fallback to legacy field
    if (result.lysine != null) {
      return result.lysine! / 10; // g/kg to %
    }

    return null;
  }
}

/// Result of nutrient validation
class ValidationResult {
  final List<String> warnings;
  final List<String> errors;
  final bool isValid;
  final String standard;

  const ValidationResult({
    required this.warnings,
    required this.errors,
    required this.isValid,
    required this.standard,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
  bool get hasIssues => hasWarnings || hasErrors;

  String get summary {
    if (!hasIssues) return 'Formulation meets $standard standards ✓';

    final parts = <String>[];
    if (hasErrors) parts.add('${errors.length} error(s)');
    if (hasWarnings) parts.add('${warnings.length} warning(s)');

    return 'Validation ($standard): ${parts.join(", ")}';
  }
}
