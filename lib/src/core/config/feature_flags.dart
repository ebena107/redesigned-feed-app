/// Feature flags for gradual rollout of Phase 2 features
class FeatureFlags {
  /// Enable expanded ingredient database with tropical alternatives
  static const bool ingredientDatabaseExpansion = true;

  /// Enable user-editable ingredient prices
  static const bool userPriceEditing = true;

  /// Enable inventory tracking features
  static const bool inventoryTracking = true;

  /// Enable advanced reporting features
  static const bool advancedReporting = false; // Phase 3

  /// Enable user-contributed ingredients
  static const bool userIngredientContributions = true;

  /// Enable price history visualization
  static const bool priceHistoryVisualization = true;

  /// Enable bulk price import
  static const bool bulkPriceImport = true;

  /// Enable low stock alerts
  static const bool lowStockAlerts = true;

  /// Enable inventory valuation
  static const bool inventoryValuation = true;

  /// Enable what-if analysis for formulations
  static const bool whatIfAnalysis = false; // Phase 3

  /// Get all enabled features
  static Map<String, bool> getAllFlags() {
    return {
      'ingredientDatabaseExpansion': ingredientDatabaseExpansion,
      'userPriceEditing': userPriceEditing,
      'inventoryTracking': inventoryTracking,
      'advancedReporting': advancedReporting,
      'userIngredientContributions': userIngredientContributions,
      'priceHistoryVisualization': priceHistoryVisualization,
      'bulkPriceImport': bulkPriceImport,
      'lowStockAlerts': lowStockAlerts,
      'inventoryValuation': inventoryValuation,
      'whatIfAnalysis': whatIfAnalysis,
    };
  }

  /// Check if a feature is enabled
  static bool isEnabled(String featureName) {
    return getAllFlags()[featureName] ?? false;
  }
}
