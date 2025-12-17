/// Utility class for formatting nutrient values with correct units
///
/// Industry Standards:
/// - Energy: kcal/kg (no conversion needed)
/// - Proximate nutrients (CP, CF, Fat, Ash, Moisture, Starch): % DM
/// - Amino acids: % (converted from g/kg storage format)
/// - Minerals (Ca, P): % (converted from g/kg storage format)
class NutrientFormatter {
  /// Format energy value (always in kcal/kg)
  ///
  /// Input: Energy value in kcal/kg
  /// Output: "2,350 kcal/kg" or "2,350" (without unit if specified)
  static String formatEnergy(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';

    final formatted = value.toStringAsFixed(0);
    return includeUnit ? '$formatted kcal/kg' : formatted;
  }

  /// Format proximate nutrient (CP, CF, Fat, Ash, Moisture, Starch)
  ///
  /// Input: Value already in % DM
  /// Output: "16.5%" or "16.5" (without unit if specified)
  static String formatProximateNutrient(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';

    final formatted = value.toStringAsFixed(1);
    return includeUnit ? '$formatted%' : formatted;
  }

  /// Format amino acid value (convert from g/kg to %)
  ///
  /// Input: Value in g/kg (storage format)
  /// Output: "0.95%" or "0.95" (without unit if specified)
  ///
  /// Example: Lysine = 9.5 g/kg → Display as 0.95%
  static String formatAminoAcid(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';

    // Convert g/kg to % (divide by 10)
    final percentage = value / 10;
    final formatted = percentage.toStringAsFixed(2);
    return includeUnit ? '$formatted%' : formatted;
  }

  /// Format mineral value (convert from g/kg to %)
  ///
  /// Input: Value in g/kg (storage format)
  /// Output: "0.65%" or "0.65" (without unit if specified)
  ///
  /// Example: Calcium = 6.5 g/kg → Display as 0.65%
  static String formatMineral(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';

    // Convert g/kg to % (divide by 10)
    final percentage = value / 10;
    final formatted = percentage.toStringAsFixed(2);
    return includeUnit ? '$formatted%' : formatted;
  }

  /// Format phosphorus value (convert from g/kg to %)
  ///
  /// Input: Value in g/kg (storage format)
  /// Output: "0.35%" or "0.35" (without unit if specified)
  static String formatPhosphorus(num? value, {bool includeUnit = true}) {
    return formatMineral(value, includeUnit: includeUnit);
  }

  /// Get unit label for nutrient type
  static String getUnitLabel(NutrientType type) {
    switch (type) {
      case NutrientType.energy:
        return 'kcal/kg';
      case NutrientType.proximateNutrient:
      case NutrientType.aminoAcid:
      case NutrientType.mineral:
        return '%';
      case NutrientType.bulkDensity:
        return 'kg/m³';
      case NutrientType.antiNutritionalFactor:
        return 'varies'; // Depends on specific ANF
    }
  }

  /// Format result card value with appropriate unit
  static String formatResultValue(num? value, NutrientType type) {
    switch (type) {
      case NutrientType.energy:
        return formatEnergy(value);
      case NutrientType.proximateNutrient:
        return formatProximateNutrient(value);
      case NutrientType.aminoAcid:
        return formatAminoAcid(value);
      case NutrientType.mineral:
        return formatMineral(value);
      default:
        return value?.toStringAsFixed(2) ?? '--';
    }
  }
}

enum NutrientType {
  energy,
  proximateNutrient,
  aminoAcid,
  mineral,
  bulkDensity,
  antiNutritionalFactor,
}
