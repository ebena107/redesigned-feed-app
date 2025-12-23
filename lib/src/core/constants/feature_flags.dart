import 'package:feed_estimator/src/core/utils/logger.dart';

/// Feature flags for controlling app functionality and gradual rollout
///
/// Use these flags to safely enable/disable features during development
/// and production rollout.
class FeatureFlags {
  // Prevent instantiation
  FeatureFlags._();

  /// Use standardized ingredient dataset (v9) instead of initial dataset (v8)
  ///
  /// **Status:** Ready for production testing
  ///
  /// When `true`:
  /// - Loads `assets/raw/ingredients_standardized.json` (201 items)
  /// - Uses standards-based names (NRC, CVB, INRA, FAO)
  /// - Includes separated variants (fish meal grades, wheat forms)
  /// - Per-category inclusion limits in `max_inclusion_json`
  ///
  /// When `false`:
  /// - Loads `assets/raw/initial_ingredients_.json` (165 items)
  /// - Uses original merged dataset
  /// - Single inclusion limit per ingredient
  ///
  /// **Rollback Strategy:**
  /// Set to `false` and restart app to immediately revert to v8 data
  ///
  /// **Testing Checklist:**
  /// - [ ] All 201 ingredients load successfully
  /// - [ ] Fish meal shows 3 variants (62%, 65%, 70%)
  /// - [ ] Wheat products show 3 forms (grain, bran, middlings)
  /// - [ ] Corn products show 4 forms (grain, meal, flour, silage)
  /// - [ ] Calculations use per-category limits correctly
  /// - [ ] No crashes or data corruption
  static const bool useStandardizedIngredients =
      false; // CHANGE TO true WHEN READY

  /// Enable animal category-specific inclusion limits
  ///
  /// Requires `useStandardizedIngredients = true` to be effective.
  ///
  /// When `true`:
  /// - Uses AnimalCategoryMapper for category preference lookup
  /// - Checks `max_inclusion_json` with per-category limits
  /// - Shows category-specific warnings in formulation
  ///
  /// When `false`:
  /// - Uses legacy `maxInclusionPct` field only
  /// - Single limit applies to all animal types
  static const bool usePerCategoryLimits =
      false; // CHANGE TO true WITH standardized ingredients

  /// Enable standards-based UI indicators
  ///
  /// Shows trust signals for ingredients with standard references.
  ///
  /// When `true`:
  /// - Displays "Standards-based" chip on validated ingredients
  /// - Shows NRC/CVB/INRA reference codes in ingredient details
  /// - Highlights separation notes for variant ingredients
  ///
  /// When `false`:
  /// - No special UI for standardized ingredients
  static const bool showStandardsIndicators = false; // Enable in P4

  /// Enable production stage selector in feed creation
  ///
  /// Allows users to specify animal production stage for precise limits.
  ///
  /// When `true`:
  /// - Feed form includes stage dropdown (nursery, starter, grower, etc.)
  /// - Inclusion limits use stage-specific values from `max_inclusion_json`
  /// - Results show stage-appropriate recommendations
  ///
  /// When `false`:
  /// - Generic limits used (pig, poultry, etc.)
  static const bool enableProductionStageSelector = false; // Enable in P4

  /// Enable enhanced calculation engine with v5 features
  ///
  /// Uses EnhancedCalculationEngine for comprehensive nutrient tracking.
  ///
  /// When `true`:
  /// - Calculates all 10 essential amino acids (total + SID)
  /// - Tracks phosphorus breakdown (total, available, phytate)
  /// - Includes anti-nutritional factor warnings
  /// - Proximate analysis (ash, moisture, starch)
  ///
  /// When `false`:
  /// - Legacy calculation engine (basic nutrients only)
  static const bool useEnhancedCalculationEngine =
      true; // Already enabled in Phase 3

  /// Log feature flag status on app startup
  ///
  /// Helper method for debugging and monitoring feature rollout.
  static void logStatus() {
    const tag = 'FeatureFlags';
    AppLogger.info('=== Feature Flags Status ===', tag: tag);
    AppLogger.info('useStandardizedIngredients: $useStandardizedIngredients',
        tag: tag);
    AppLogger.info('usePerCategoryLimits: $usePerCategoryLimits', tag: tag);
    AppLogger.info('showStandardsIndicators: $showStandardsIndicators',
        tag: tag);
    AppLogger.info(
        'enableProductionStageSelector: $enableProductionStageSelector',
        tag: tag);
    AppLogger.info(
        'useEnhancedCalculationEngine: $useEnhancedCalculationEngine',
        tag: tag);
    AppLogger.info('===========================', tag: tag);
  }

  /// Get current ingredient dataset path
  static String get ingredientDatasetPath {
    return useStandardizedIngredients
        ? 'assets/raw/ingredients_standardized.json'
        : 'assets/raw/initial_ingredients_.json';
  }

  /// Check if advanced features are enabled
  ///
  /// Returns `true` if both standardized ingredients and per-category limits active.
  static bool get advancedFeaturesEnabled {
    return useStandardizedIngredients && usePerCategoryLimits;
  }
}
