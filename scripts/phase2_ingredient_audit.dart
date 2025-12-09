#!/usr/bin/env dart

/// Phase 2: Comprehensive Ingredient Nutrient Values Audit
/// Validates all 165 ingredients against industry standards (NRC, ASABE, CVB, INRA)
///
/// Usage: dart scripts/audit_ingredient_values.dart > audit_results.txt

import 'dart:convert';
import 'dart:io';

class NutrientStandard {
  final String name;
  final String unit;
  final double minNormal;
  final double maxNormal;
  final double? minAbsolute;
  final double? maxAbsolute;
  final String notes;

  NutrientStandard({
    required this.name,
    required this.unit,
    required this.minNormal,
    required this.maxNormal,
    this.minAbsolute,
    this.maxAbsolute,
    required this.notes,
  });
}

class IngredientAudit {
  // Industry standards based on:
  // - NRC (National Research Council) Nutrient Requirements
  // - ASABE (American Society of Agricultural Engineers)
  // - CVB (Centraal Bureau voor Veevoederonderzoek - Netherlands)
  // - INRA (Institut National de Recherche pour l'Agriculture - France)
  // - FEEDBASE (South Africa)

  static final Map<String, NutrientStandard> standards = {
    'crude_protein': NutrientStandard(
      name: 'Crude Protein (CP)',
      unit: '% DM',
      minNormal: 3.0,
      maxNormal: 50.0,
      minAbsolute: 0.0,
      maxAbsolute: 60.0,
      notes:
          'Typical range 5-45% for feed ingredients. Values >50% rare (e.g., pure protein supplements).',
    ),
    'crude_fiber': NutrientStandard(
      name: 'Crude Fiber (CF)',
      unit: '% DM',
      minNormal: 0.1,
      maxNormal: 40.0,
      minAbsolute: 0.0,
      maxAbsolute: 50.0,
      notes:
          'High-fiber ingredients (straw, hulls) reach 40-50%. Grains/concentrates <10%.',
    ),
    'crude_fat': NutrientStandard(
      name: 'Crude Fat (EE)',
      unit: '% DM',
      minNormal: 0.5,
      maxNormal: 15.0,
      minAbsolute: 0.0,
      maxAbsolute: 25.0,
      notes: 'Most ingredients 1-8%. High-fat ingredients (oil seeds) 6-20%.',
    ),
    'calcium': NutrientStandard(
      name: 'Calcium (Ca)',
      unit: 'g/kg DM',
      minNormal: 0.5,
      maxNormal: 50.0,
      minAbsolute: 0.0,
      maxAbsolute: 60.0,
      notes:
          'Most ingredients 0.5-20 g/kg. Limestone/shells can exceed 400 g/kg (not typical feed).',
    ),
    'phosphorus': NutrientStandard(
      name: 'Phosphorus (P)',
      unit: 'g/kg DM',
      minNormal: 0.5,
      maxNormal: 15.0,
      minAbsolute: 0.0,
      maxAbsolute: 20.0,
      notes:
          'Most ingredients 1-8 g/kg. Bone meal/phosphate can exceed 100 g/kg (mineral supplements).',
    ),
    'lysine': NutrientStandard(
      name: 'Lysine',
      unit: 'g/kg DM',
      minNormal: 0.5,
      maxNormal: 10.0,
      minAbsolute: 0.0,
      maxAbsolute: 15.0,
      notes: 'Most ingredients 0.5-8 g/kg. Soy products 5-7 g/kg.',
    ),
    'methionine': NutrientStandard(
      name: 'Methionine',
      unit: 'g/kg DM',
      minNormal: 0.1,
      maxNormal: 5.0,
      minAbsolute: 0.0,
      maxAbsolute: 8.0,
      notes:
          'Most ingredients 0.2-3 g/kg. Amino acid supplements can reach 5-8 g/kg.',
    ),
  };

  static String evaluateValue(String field, num value) {
    final std = standards[field];
    if (std == null) return '⚠️  UNKNOWN FIELD';

    if (std.minAbsolute != null && value < std.minAbsolute!) {
      return '🔴 CRITICAL: Below absolute minimum (${std.minAbsolute})';
    }
    if (std.maxAbsolute != null && value > std.maxAbsolute!) {
      return '🔴 CRITICAL: Above absolute maximum (${std.maxAbsolute})';
    }
    if (value < std.minNormal) {
      return '🟡 WARNING: Below normal range (${std.minNormal})';
    }
    if (value > std.maxNormal) {
      return '🟡 WARNING: Above normal range (${std.maxNormal})';
    }
    return '✅ NORMAL RANGE';
  }

  static Future<void> runAudit(List<String> args) async {
    try {
      final file = File('assets/raw/initial_ingredients.json');
      final jsonString = await file.readAsString();
      final ingredients = jsonDecode(jsonString) as List<dynamic>;

      print('═' * 100);
      print('PHASE 2: INGREDIENT NUTRIENT VALUES AUDIT');
      print('═' * 100);
      print('');
      print('Date: ${DateTime.now()}');
      print('Total Ingredients: ${ingredients.length}');
      print('Standards Used: NRC, ASABE, CVB, INRA');
      print('');

      // Analysis summary
      Map<String, List<dynamic>> criticalIssues = {};
      Map<String, List<dynamic>> warnings = {};
      int normalCount = 0;

      for (final ing in ingredients) {
        final name = ing['name'] ?? 'UNKNOWN';
        bool hasIssue = false;

        for (final field in standards.keys) {
          final value = ing[field];
          if (value == null) continue;

          final result = evaluateValue(field, value);
          if (result.contains('CRITICAL')) {
            criticalIssues.putIfAbsent(field, () => []);
            criticalIssues[field]!
                .add({'name': name, 'value': value, 'result': result});
            hasIssue = true;
          } else if (result.contains('WARNING')) {
            warnings.putIfAbsent(field, () => []);
            warnings[field]!
                .add({'name': name, 'value': value, 'result': result});
            hasIssue = true;
          }
        }

        if (!hasIssue) normalCount++;
      }

      // Report summary
      print('SUMMARY');
      print('─' * 100);
      print('✅ Normal Range: $normalCount ingredients');
      print(
          '🟡 Warnings: ${warnings.values.fold(0, (sum, list) => sum + list.length)} issues');
      print(
          '🔴 Critical: ${criticalIssues.values.fold(0, (sum, list) => sum + list.length)} issues');
      print('');

      // Critical issues
      if (criticalIssues.isNotEmpty) {
        print('CRITICAL ISSUES 🔴');
        print('─' * 100);
        for (final field in standards.keys) {
          if (criticalIssues.containsKey(field)) {
            final std = standards[field]!;
            print('\n${std.name} (${std.unit})');
            print(
                'Expected Range: ${std.minNormal}-${std.maxNormal} | Absolute: ${std.minAbsolute}-${std.maxAbsolute}');
            print(std.notes);
            print('Issues:');
            for (final issue in criticalIssues[field]!) {
              print(
                  '  • ${issue['name']}: ${issue['value']} - ${issue['result']}');
            }
          }
        }
        print('');
      }

      // Warnings
      if (warnings.isNotEmpty) {
        print('WARNINGS 🟡');
        print('─' * 100);
        for (final field in standards.keys) {
          if (warnings.containsKey(field)) {
            final std = standards[field]!;
            print('\n${std.name} (${std.unit})');
            print('Expected Range: ${std.minNormal}-${std.maxNormal}');
            print(std.notes);
            print('Issues (showing first 5):');
            final issues = warnings[field]!;
            for (int i = 0; i < (issues.length > 5 ? 5 : issues.length); i++) {
              final issue = issues[i];
              print(
                  '  • ${issue['name']}: ${issue['value']} - ${issue['result']}');
            }
            if (issues.length > 5) {
              print('  ... and ${issues.length - 5} more');
            }
          }
        }
        print('');
      }

      // Detailed ingredient report
      print('DETAILED INGREDIENT REPORT');
      print('─' * 100);
      for (int i = 0; i < ingredients.length; i++) {
        final ing = ingredients[i];
        final name = ing['name'] ?? 'UNKNOWN';
        final hasWarning = warnings.values
            .any((list) => list.any((issue) => issue['name'] == name));
        final hasCritical = criticalIssues.values
            .any((list) => list.any((issue) => issue['name'] == name));

        if (hasCritical || hasWarning) {
          print('\n${i + 1}. $name ${hasCritical ? '🔴' : '🟡'}');
          for (final field in standards.keys) {
            final value = ing[field];
            if (value == null) continue;
            final result = evaluateValue(field, value);
            if (!result.contains('NORMAL')) {
              print(
                  '   ${standards[field]!.name}: $value ${standards[field]!.unit} - $result');
            }
          }
        }
      }

      print('\n${'═' * 100}');
      print('END OF AUDIT');
      print('═' * 100);
    } catch (e) {
      print('ERROR: $e');
      exit(1);
    }
  }
}

void main(List<String> args) async {
  await IngredientAudit.runAudit(args);
}
