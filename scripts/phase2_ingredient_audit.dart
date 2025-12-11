#!/usr/bin/env dart

/// Phase 2B: Enhanced Ingredient Audit with Category-Aware Validation
///
/// This version classifies ingredients by category and applies appropriate
/// thresholds for each type, eliminating false positives.
///
/// Usage: dart scripts/phase2b_enhanced_audit.dart > audit_results_enhanced.txt

import 'dart:convert';
import 'dart:io';

enum IngredientCategory {
  proteinConcentrate, // CP > 60%
  proteinMeal, // CP 35-50%
  wholeOilseed, // Whole seeds with high fat
  pureOil, // 99-100% fat
  mineralSupplement, // High Ca/P
  aminoAcid, // Pure amino acid supplements
  additive, // Enzymes, binders, vitamins
  energyFeed, // Grains, roots
  fiber, // Hulls, straw
  byproduct, // Pulps, molasses
  other,
}

class CategoryThresholds {
  final double crudeProteinMin;
  final double crudeProteinMax;
  final double crudeFiberMax;
  final double crudeFatMin;
  final double crudeFatMax;
  final double calciumMax;
  final double phosphorusMax;
  final double lysineMax;
  final double methionineMax;
  final bool allowZeroNutrients;

  CategoryThresholds({
    this.crudeProteinMin = 3.0,
    this.crudeProteinMax = 60.0,
    this.crudeFiberMax = 50.0,
    this.crudeFatMin = 0.5,
    this.crudeFatMax = 25.0,
    this.calciumMax = 60.0,
    this.phosphorusMax = 20.0,
    this.lysineMax = 15.0,
    this.methionineMax = 8.0,
    this.allowZeroNutrients = false,
  });
}

class EnhancedAudit {
  static final Map<IngredientCategory, CategoryThresholds> thresholds = {
    IngredientCategory.proteinConcentrate: CategoryThresholds(
      crudeProteinMax: 90.0,
      crudeFatMax: 30.0, // Increased for lower-grade poultry meals
      calciumMax: 100.0, // Increased for bone-containing proteins
      phosphorusMax:
          50.0, // Increased for bone-containing proteins (fish meals)
      lysineMax: 60.0,
      methionineMax: 25.0,
    ),
    IngredientCategory.proteinMeal: CategoryThresholds(
      calciumMax:
          120.0, // Increased for shell-containing marine proteins (shrimp meal)
      lysineMax: 25.0,
      methionineMax: 10.0,
    ),
    IngredientCategory.wholeOilseed: CategoryThresholds(
      crudeFatMax: 50.0,
    ),
    IngredientCategory.pureOil: CategoryThresholds(
      crudeProteinMin: 0.0,
      crudeFatMax: 100.0,
      allowZeroNutrients: true,
    ),
    IngredientCategory.mineralSupplement: CategoryThresholds(
      crudeProteinMin: 0.0,
      calciumMax: 400.0,
      phosphorusMax: 250.0,
      allowZeroNutrients: true,
    ),
    IngredientCategory.aminoAcid: CategoryThresholds(
      crudeProteinMax: 100.0,
      lysineMax: 1000.0,
      methionineMax: 1000.0,
      allowZeroNutrients: true,
    ),
    IngredientCategory.additive: CategoryThresholds(
      crudeProteinMin: 0.0,
      allowZeroNutrients: true,
    ),
    IngredientCategory.byproduct: CategoryThresholds(
      crudeProteinMin: 0.0,
      crudeFatMin: 0.0,
      crudeFatMax: 50.0, // Increased for oil-rich byproducts (maize germs)
    ),
  };

  static IngredientCategory categorizeIngredient(Map<String, dynamic> ing) {
    final name = (ing['name'] ?? '').toString().toLowerCase();
    final cp = ing['crude_protein'] ?? 0.0;

    // Pure oils
    if (name.contains(' oil') &&
            !name.contains('meal') &&
            !name.contains('cake') ||
        name.contains('tallow') ||
        name.contains('lard') ||
        name.contains('fat')) {
      return IngredientCategory.pureOil;
    }

    // Mineral supplements
    if (name.contains('limestone') ||
        name.contains('calcium carbonate') ||
        name.contains('phosphate') ||
        name.contains('seashell') ||
        name.contains('dolomite') ||
        name.contains('bone meal')) {
      return IngredientCategory.mineralSupplement;
    }

    // Amino acid supplements
    if (name.contains('lysine') ||
        name.contains('methionine') ||
        name.contains('l-lysine') ||
        name.contains('dl-methionine')) {
      return IngredientCategory.aminoAcid;
    }

    // Additives
    if (name.contains('enzyme') ||
        name.contains('toxin binder') ||
        name.contains('vitamin') ||
        name.contains('premix') ||
        name.contains('sodium bicarbonate') ||
        name.contains('salt') ||
        name.contains('sodium chloride')) {
      return IngredientCategory.additive;
    }

    // Protein concentrates (CP > 60%)
    if (cp > 60 ||
        name.contains('blood meal') ||
        name.contains('feather meal') ||
        name.contains('wheat gluten') ||
        name.contains('fish meal') ||
        name.contains('processed animal protein')) {
      return IngredientCategory.proteinConcentrate;
    }

    // Whole oilseeds
    if ((name.contains('seed') ||
                name.contains('soybean') ||
                name.contains('rapeseed') ||
                name.contains('sunflower') ||
                name.contains('cottonseed')) &&
            name.contains('whole') ||
        name.contains(', extruded') ||
        name.contains(', flaked') ||
        name.contains(', toasted')) {
      return IngredientCategory.wholeOilseed;
    }

    // Protein meals (CP 35-50%)
    if (cp >= 35 && cp <= 50 ||
        name.contains('meal') && !name.contains('bone')) {
      return IngredientCategory.proteinMeal;
    }

    // Byproducts (including oil-rich byproducts)
    if (name.contains('pulp') ||
        name.contains('molasses') ||
        name.contains('hulls') ||
        name.contains('bran') ||
        name.contains('maize germ')) {
      return IngredientCategory.byproduct;
    }

    return IngredientCategory.other;
  }

  static String evaluateValue(
    String field,
    num value,
    IngredientCategory category,
  ) {
    final threshold = thresholds[category] ?? CategoryThresholds();

    // Allow zero values for certain categories
    if (threshold.allowZeroNutrients && value == 0) {
      return '✅ EXPECTED (zero for this category)';
    }

    switch (field) {
      case 'crude_protein':
        if (value < threshold.crudeProteinMin) {
          return '🟡 WARNING: Below minimum (${threshold.crudeProteinMin})';
        }
        if (value > threshold.crudeProteinMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.crudeProteinMax})';
        }
        break;

      case 'crude_fiber':
        if (value > threshold.crudeFiberMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.crudeFiberMax})';
        }
        break;

      case 'crude_fat':
        if (value > threshold.crudeFatMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.crudeFatMax})';
        }
        break;

      case 'calcium':
        if (value > threshold.calciumMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.calciumMax})';
        }
        break;

      case 'phosphorus':
        if (value > threshold.phosphorusMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.phosphorusMax})';
        }
        break;

      case 'lysine':
        if (value > threshold.lysineMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.lysineMax})';
        }
        break;

      case 'methionine':
        if (value > threshold.methionineMax) {
          return '🔴 CRITICAL: Above maximum (${threshold.methionineMax})';
        }
        break;
    }

    return '✅ NORMAL RANGE';
  }

  static Future<void> runAudit(List<String> args) async {
    try {
      final file = File('assets/raw/initial_ingredients.json');
      final jsonString = await file.readAsString();
      final ingredients = jsonDecode(jsonString) as List<dynamic>;

      print('═' * 100);
      print('PHASE 2B: ENHANCED INGREDIENT AUDIT (Category-Aware)');
      print('═' * 100);
      print('');
      print('Date: ${DateTime.now()}');
      print('Total Ingredients: ${ingredients.length}');
      print('');

      // Category distribution
      Map<IngredientCategory, int> categoryCount = {};
      Map<IngredientCategory, List<dynamic>> criticalByCategory = {};
      int totalCritical = 0;
      int totalNormal = 0;

      for (final ing in ingredients) {
        final name = ing['name'] ?? 'UNKNOWN';
        final category = categorizeIngredient(ing);
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;

        bool hasCritical = false;
        final fields = [
          'crude_protein',
          'crude_fiber',
          'crude_fat',
          'calcium',
          'phosphorus',
          'lysine',
          'methionine'
        ];

        for (final field in fields) {
          final value = ing[field];
          if (value == null) continue;

          final result = evaluateValue(field, value, category);
          if (result.contains('CRITICAL')) {
            hasCritical = true;
            criticalByCategory.putIfAbsent(category, () => []);
            criticalByCategory[category]!.add({
              'name': name,
              'field': field,
              'value': value,
              'result': result,
            });
          }
        }

        if (hasCritical) {
          totalCritical++;
        } else {
          totalNormal++;
        }
      }

      // Summary
      print('CATEGORY DISTRIBUTION');
      print('─' * 100);
      categoryCount.forEach((cat, count) {
        print('${cat.toString().split('.').last}: $count ingredients');
      });
      print('');

      print('SUMMARY');
      print('─' * 100);
      print('✅ Normal Range: $totalNormal ingredients');
      print('🔴 Critical Issues: $totalCritical ingredients');
      print('');

      // Critical issues by category
      if (criticalByCategory.isNotEmpty) {
        print('CRITICAL ISSUES BY CATEGORY 🔴');
        print('─' * 100);
        criticalByCategory.forEach((category, issues) {
          print('');
          print('${category.toString().split('.').last.toUpperCase()}:');

          // Group by ingredient
          Map<String, List<dynamic>> byIngredient = {};
          for (final issue in issues) {
            byIngredient.putIfAbsent(issue['name'], () => []);
            byIngredient[issue['name']]!.add(issue);
          }

          byIngredient.forEach((ingName, ingIssues) {
            print('  • $ingName');
            for (final issue in ingIssues) {
              print(
                  '    - ${issue['field']}: ${issue['value']} - ${issue['result']}');
            }
          });
        });
        print('');
      }

      print('═' * 100);
      print('END OF ENHANCED AUDIT');
      print('═' * 100);
    } catch (e) {
      print('ERROR: $e');
      exit(1);
    }
  }
}

void main(List<String> args) async {
  await EnhancedAudit.runAudit(args);
}
