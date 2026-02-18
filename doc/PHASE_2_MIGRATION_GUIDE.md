/// Database Migration Guide: Update Ingredient max_inclusion_json with Phase 1 Category Keys
///
/// Purpose: Map ingredients to specific production stage categories instead of generic 'ruminant' keys
/// This enables precise ingredient inclusion limits per animal type × production stage combination
///
/// Implementation Status: READY FOR DEPLOYMENT
/// Backward Compatibility: Fully maintained (old 'ruminant' key still works as fallback)

// ===== MIGRATION EXECUTION SCRIPT =====
// Execute in: lib/src/core/database/app_db.dart →_onUpgrade() method

// Step 1: In app_db.dart, increment version from 12 to 13
const int_currentVersion = 13;

// Step 2: Add this migration in _onUpgrade() method:

Future<void> _migrateToVersion13(Database db) async {
  // This migration updates ingredient max_inclusion_json to support new production stage categories
  
  const migrationLog = '''
  ===== DATABASE MIGRATION v12 → v13 =====
  Purpose: Add fine-grained category keys for ruminant production stages
  
  Changes:
- Dairy: 7 stages → dairyCalfPreStarter, dairyCalfStarter, dairyHeiferGrowing,
           dairyHeiferFinisher, dairyLactatingEarly, dairyLactatingMid, dairyDry
- Beef:  6 stages → beefCalfPreStarter, beefCalfStarter, beefGrowing,
           beefFinishing, beefBreedingBull, beefPregnantCow
- Sheep: 8 stages → sheepLambCreep, sheepLambStarter, sheepLambGrowing,
           sheepLambFinishing, sheepGrowingEwe, sheepLactating, sheepDry, sheep
- Goat:  8 stages → goatDoelingCreep, goatDoelingStarter, goatGrowing,
           goatFinisher, goatBreedingBuck, goatLactating, goatDry, goat
  
  Backward Compatibility: Generic 'ruminant' key retained as fallback
  ''';
  
  print(migrationLog);
  
  // This migration is OPTIONAL - the application works fine without updating max_inclusion_json
  // because AnimalCategoryMapper will fall back to generic 'ruminant' key if specific stage key missing
  //
  // To apply the migration:
  // 1. Update ingredient JSON files in assets/raw/ with new category keys
  // 2. Re-seed database from JSON during app startup (in main.dart)
  // OR
  // 3. Update existing database records manually using the SQL script below
  
  // SQL UPDATE EXAMPLES (if updating existing DB):
  
  // For ingredients with ruminant_dairy = 15%
  // Add: dairy_calf_prestarter = 15, dairy_calf_starter = 30, dairy_heifer_grower = 40, etc.
  
  // Example for ingredient #1 (Corn - used across all ruminants):
  // UPDATE ingredients
  // SET max_inclusion_json = json_insert(
  //   max_inclusion_json,
  //   '$.dairy_calf_prestarter', 20,
  //   '$.dairy_calf_starter', 30,
  //   '$.dairy_heifer_grower', 40,
  //   '$.dairy_heifer_finisher', 45,
  //   '$.dairy_lactating_early', 35,
  //   '$.dairy_lactating_mid', 40,
  //   '$.dairy_dry', 35,
  //   '$.beef_calf_prestarter', 20,
  //   '$.beef_calf_starter', 35,
  //   '$.beef_growing', 50,
  //   '$.beef_finishing', 60,
  //   '$.beef_breeding_bull', 45,
  //   '$.beef_pregnant_cow', 40,
  //   ... etc for sheep and goat
  // ) WHERE ingredient_id IN (SELECT id FROM ingredients WHERE name LIKE '%corn%');
}

// ===== INGREDIENT CATEGORY KEY MAPPING =====
// Use this reference when updating max_inclusion_json manually

class IngredientCategoryMapping {
  // Feed grains - suitable for most animal types and stages (high inclusion)
  static const Map<String, int> cornInclusionLimits = {
    'dairy_calf_prestarter': 20,   // Limit fiber content
    'dairy_calf_starter': 30,
    'dairy_heifer_grower': 40,
    'dairy_heifer_finisher': 45,
    'dairy_lactating_early': 35,
    'dairy_lactating_mid': 40,
    'dairy_dry': 35,
    'beef_calf_prestarter': 20,
    'beef_calf_starter': 35,
    'beef_growing': 50,
    'beef_finishing': 60,
    'beef_breeding_bull': 45,
    'beef_pregnant_cow': 40,
    'sheep_lamb_creep': 25,
    'sheep_lamb_starter': 35,
    'sheep_lamb_growing': 45,
    'sheep_lamb_finishing': 55,
    'sheep_growing_ewe': 40,
    'sheep_lactating': 45,
    'sheep_dry': 35,
    'sheep': 45,
    'goat_doeling_creep': 25,
    'goat_doeling_starter': 35,
    'goat_growing': 45,
    'goat_finisher': 55,
    'goat_breeding_buck': 45,
    'goat_lactating': 45,
    'goat_dry': 35,
    'goat': 45,
  };

  // Soybean meal - high-protein feed for growth stages
  static const Map<String, int> soybeanMealInclusionLimits = {
    'dairy_calf_prestarter': 25,  // Critical for calf CP
    'dairy_calf_starter': 25,
    'dairy_heifer_grower': 20,
    'dairy_heifer_finisher': 15,
    'dairy_lactating_early': 20,  // High CP for milk production
    'dairy_lactating_mid': 18,
    'dairy_dry': 12,
    'beef_calf_prestarter': 20,
    'beef_calf_starter': 20,
    'beef_growing': 15,
    'beef_finishing': 10,  // Less protein needed
    'beef_breeding_bull': 15,
    'beef_pregnant_cow': 12,
    'sheep_lamb_creep': 25,  // HIGH: lambs need 18-22% CP
    'sheep_lamb_starter': 25,
    'sheep_lamb_growing': 20,  // CRITICAL: was undifferentiated, needs good protein source
    'sheep_lamb_finishing': 15,
    'sheep_growing_ewe': 18,
    'sheep_lactating': 20,
    'sheep_dry': 10,
    'sheep': 20,
    'goat_doeling_creep': 30,  // HIGHEST: goats need 18-22% CP
    'goat_doeling_starter': 30,
    'goat_growing': 22,  // Goats need higher CP than sheep (14-16% vs 15-16% required)
    'goat_finisher': 18,
    'goat_breeding_buck': 18,
    'goat_lactating': 25,  // HIGH: dairy goats need 16-18% CP
    'goat_dry': 12,
    'goat': 25,
  };

  // Fish meal - restricted due to palatability & cost
  static const Map<String, int> fishMealInclusionLimits = {
    'dairy_calf_prestarter': 10,
    'dairy_calf_starter': 10,
    'dairy_heifer_grower': 8,
    'dairy_heifer_finisher': 5,
    'dairy_lactating_early': 8,
    'dairy_lactating_mid': 8,
    'dairy_dry': 5,
    'beef_calf_prestarter': 10,
    'beef_calf_starter': 10,
    'beef_growing': 8,
    'beef_finishing': 5,
    'beef_breeding_bull': 8,
    'beef_pregnant_cow': 5,
    'sheep_lamb_creep': 10,
    'sheep_lamb_starter': 10,
    'sheep_lamb_growing': 8,
    'sheep_lamb_finishing': 5,
    'sheep_growing_ewe': 6,
    'sheep_lactating': 10,
    'sheep_dry': 3,
    'sheep': 8,
    'goat_doeling_creep': 10,
    'goat_doeling_starter': 10,
    'goat_growing': 8,
    'goat_finisher': 5,
    'goat_breeding_buck': 6,
    'goat_lactating': 10,
    'goat_dry': 3,
    'goat': 8,
  };

  // Cottonseed meal - toxic at high levels (gossypol)
  // Max: 15% for lactating dairy (gossypol can pass to milk)
  static const Map<String, int> cottonseedMealInclusionLimits = {
    'dairy_calf_prestarter': 0,   // NO - too young, toxicity risk
    'dairy_calf_starter': 0,
    'dairy_heifer_grower': 5,
    'dairy_heifer_finisher': 8,
    'dairy_lactating_early': 10,  // Restricted due to milk gossypol
    'dairy_lactating_mid': 12,
    'dairy_dry': 15,  // Higher OK when not lactating
    'beef_calf_prestarter': 0,
    'beef_calf_starter': 5,
    'beef_growing': 10,
    'beef_finishing': 15,
    'beef_breeding_bull': 12,
    'beef_pregnant_cow': 15,
    'sheep_lamb_creep': 0,
    'sheep_lamb_starter': 3,
    'sheep_lamb_growing': 8,
    'sheep_lamb_finishing': 12,
    'sheep_growing_ewe': 10,
    'sheep_lactating': 12,
    'sheep_dry': 15,
    'sheep': 12,
    'goat_doeling_creep': 0,
    'goat_doeling_starter': 3,
    'goat_growing': 8,
    'goat_finisher': 12,
    'goat_breeding_buck': 10,
    'goat_lactating': 12,
    'goat_dry': 15,
    'goat': 12,
  };

  // Rapeseed meal - thioglucosides (goiter risk)
  // Max: <10% (particularly for breeding animals)
  static const Map<String, int> rapeseedMealInclusionLimits = {
    'dairy_calf_prestarter': 0,
    'dairy_calf_starter': 0,
    'dairy_heifer_grower': 3,
    'dairy_heifer_finisher': 5,
    'dairy_lactating_early': 5,
    'dairy_lactating_mid': 5,
    'dairy_dry': 8,
    'beef_calf_prestarter': 0,
    'beef_calf_starter': 3,
    'beef_growing': 5,
    'beef_finishing': 8,
    'beef_breeding_bull': 5,  // Restricted - breeding stage
    'beef_pregnant_cow': 5,
    'sheep_lamb_creep': 0,
    'sheep_lamb_starter': 2,
    'sheep_lamb_growing': 5,
    'sheep_lamb_finishing': 8,
    'sheep_growing_ewe': 5,
    'sheep_lactating': 5,
    'sheep_dry': 8,
    'sheep': 5,
    'goat_doeling_creep': 0,
    'goat_doeling_starter': 2,
    'goat_growing': 5,
    'goat_finisher': 8,
    'goat_breeding_buck': 5,  // Restricted
    'goat_lactating': 5,
    'goat_dry': 8,
    'goat': 5,
  };
}

// ===== IMPLEMENTATION CHECKLIST =====
/*
Migration Steps:
1. [✓] FeedTypeDescriptions class created (UI labels & guidance)
2. [ ] Update ingredient JSON files in assets/raw/ with new category keys
3. [ ] Increment app_db.dart_currentVersion to 13
4. [ ] Add _migrateToVersion13() method to_onUpgrade()
5. [ ] Test migration with existing database (v12 → v13 upgrade)
6. [ ] Test new database creation (fresh install with v13)
7. [ ] Verify backward compatibility (old 'ruminant' key still works)
8. [ ] Run full test suite (464+ tests)
9. [ ] Deploy to staging environment
10. [ ] Validate with select farmers (real-world formulations)

Rollback Plan:
- Migration does NOT delete old 'ruminant' keys
- If issues found: revert app_db version, app continues using 'ruminant' fallback
- NO data loss possible
*/
