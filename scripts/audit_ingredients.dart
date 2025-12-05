import 'dart:convert';
import 'dart:io';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/core/database/data_validator.dart';

// ignore_for_file: avoid_print

void main() async {
  // Load ingredients from JSON
  final file = File('assets/raw/initial_ingredients.json');
  final jsonString = await file.readAsString();
  final List<dynamic> jsonData = json.decode(jsonString);

  print('=== INGREDIENT NUTRITIONAL DATA AUDIT ===\n');
  print('Total ingredients to check: ${jsonData.length}\n');

  int totalIssues = 0;
  int ingredientsWithIssues = 0;
  final List<Map<String, dynamic>> issueReport = [];

  for (var i = 0; i < jsonData.length; i++) {
    final ingredientData = jsonData[i];
    final ingredient = Ingredient.fromJson(ingredientData);

    // Validate the ingredient
    final result = NutritionalDataValidator.validate(ingredient);

    if (!result.isValid) {
      ingredientsWithIssues++;
      totalIssues += result.errors.length;

      issueReport.add({
        'index': i + 1,
        'name': ingredient.name ?? 'Unknown',
        'errors': result.errors,
        'data': {
          'protein': ingredient.crudeProtein,
          'fiber': ingredient.crudeFiber,
          'fat': ingredient.crudeFat,
          'calcium': ingredient.calcium,
          'phosphorus': ingredient.phosphorus,
        }
      });

      print('❌ Issue #$ingredientsWithIssues: ${ingredient.name}');
      for (var error in result.errors) {
        print('   - $error');
      }
      print('');
    }
  }

  // Summary
  print('\n=== AUDIT SUMMARY ===');
  print('Total ingredients checked: ${jsonData.length}');
  print('Ingredients with issues: $ingredientsWithIssues');
  print('Total validation errors: $totalIssues');
  print(
      'Pass rate: ${((jsonData.length - ingredientsWithIssues) / jsonData.length * 100).toStringAsFixed(1)}%');

  // Specific checks
  print('\n=== SPECIFIC CHECKS ===');

  // Check for rice bran fiber issue
  print('\n1. Rice Bran Fiber Check:');
  for (var data in jsonData) {
    final ingredient = Ingredient.fromJson(data);
    if (ingredient.name != null &&
        ingredient.name!.toLowerCase().contains('rice') &&
        ingredient.name!.toLowerCase().contains('bran')) {
      print('   ${ingredient.name}: fiber = ${ingredient.crudeFiber}');
    }
  }

  // Check for zero/null values in bran products
  print('\n2. All Bran Products Fiber Check:');
  for (var data in jsonData) {
    final ingredient = Ingredient.fromJson(data);
    if (ingredient.name != null &&
        ingredient.name!.toLowerCase().contains('bran')) {
      final fiberValue = ingredient.crudeFiber ?? 0;
      final status = fiberValue > 0 ? '✅' : '❌';
      print('   $status ${ingredient.name}: fiber = $fiberValue');
    }
  }

  // Check for unusually high values
  print('\n3. Unusually High Calcium Values (>100):');
  for (var data in jsonData) {
    final ingredient = Ingredient.fromJson(data);
    if (ingredient.calcium != null && ingredient.calcium! > 100) {
      print('   ${ingredient.name}: calcium = ${ingredient.calcium}');
    }
  }

  // Check for total > 100%
  print('\n4. Total Nutritional Content > 100%:');
  for (var data in jsonData) {
    final ingredient = Ingredient.fromJson(data);
    final total = (ingredient.crudeProtein ?? 0) +
        (ingredient.crudeFiber ?? 0) +
        (ingredient.crudeFat ?? 0);
    if (total > 100) {
      print(
          '   ${ingredient.name}: total = $total% (P:${ingredient.crudeProtein}, F:${ingredient.crudeFiber}, Fat:${ingredient.crudeFat})');
    }
  }

  print('\n=== AUDIT COMPLETE ===');
}
