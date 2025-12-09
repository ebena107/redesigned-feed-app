import 'dart:convert';
import 'dart:io';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Utility class for importing and exporting custom ingredients
class IngredientImportExportService {
  /// Export ingredients to JSON format
  static Future<String> exportToJson(List<Ingredient> ingredients) async {
    try {
      final jsonList = ingredients.map((ing) => ing.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
      return jsonString;
    } catch (e) {
      if (kDebugMode) print('Error exporting to JSON: $e');
      rethrow;
    }
  }

  /// Export ingredients to CSV format
  static Future<String> exportToCsv(List<Ingredient> ingredients) async {
    try {
      final buffer = StringBuffer();

      // CSV Header
      buffer.writeln(
          'name,crude_protein,crude_fiber,crude_fat,calcium,phosphorus,lysine,methionine,'
          'me_growing_pig,me_adult_pig,me_poultry,me_ruminant,me_rabbit,de_salmonids,'
          'price_kg,available_qty,category_id,favourite,is_custom,created_by,created_date,notes');

      // CSV Rows
      for (final ing in ingredients) {
        buffer.writeln(
          '${_escapeCsv(ing.name)},'
          '${ing.crudeProtein ?? ''},'
          '${ing.crudeFiber ?? ''},'
          '${ing.crudeFat ?? ''},'
          '${ing.calcium ?? ''},'
          '${ing.phosphorus ?? ''},'
          '${ing.lysine ?? ''},'
          '${ing.methionine ?? ''},'
          '${ing.meGrowingPig ?? ''},'
          '${ing.meAdultPig ?? ''},'
          '${ing.mePoultry ?? ''},'
          '${ing.meRuminant ?? ''},'
          '${ing.meRabbit ?? ''},'
          '${ing.deSalmonids ?? ''},'
          '${ing.priceKg ?? ''},'
          '${ing.availableQty ?? ''},'
          '${ing.categoryId ?? ''},'
          '${ing.favourite ?? 0},'
          '${ing.isCustom ?? 1},'
          '${_escapeCsv(ing.createdBy)},'
          '${ing.createdDate ?? ''},'
          '${_escapeCsv(ing.notes)}',
        );
      }

      return buffer.toString();
    } catch (e) {
      if (kDebugMode) print('Error exporting to CSV: $e');
      rethrow;
    }
  }

  /// Save string content to file in app documents directory
  static Future<File> saveToFile(String content, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
      if (kDebugMode) print('File saved: ${file.path}');
      return file;
    } catch (e) {
      if (kDebugMode) print('Error saving file: $e');
      rethrow;
    }
  }

  /// Import ingredients from JSON string
  static Future<List<Ingredient>> importFromJson(String jsonString) async {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final ingredients = jsonList
          .map((json) => Ingredient.fromJson(json as Map<String, dynamic>))
          .toList();
      return ingredients;
    } catch (e) {
      if (kDebugMode) print('Error importing from JSON: $e');
      rethrow;
    }
  }

  /// Import ingredients from CSV string
  static Future<List<Ingredient>> importFromCsv(String csvString) async {
    try {
      final lines = csvString
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      if (lines.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Skip header row
      final dataLines = lines.skip(1);
      final ingredients = <Ingredient>[];

      for (final line in dataLines) {
        final values = _parseCsvLine(line);
        if (values.length < 17) continue; // Minimum required fields

        final ingredient = Ingredient(
          name: values[0],
          crudeProtein: _parseDouble(values[1]),
          crudeFiber: _parseDouble(values[2]),
          crudeFat: _parseDouble(values[3]),
          calcium: _parseDouble(values[4]),
          phosphorus: _parseDouble(values[5]),
          lysine: _parseDouble(values[6]),
          methionine: _parseDouble(values[7]),
          meGrowingPig: _parseInt(values[8]),
          meAdultPig: _parseInt(values[9]),
          mePoultry: _parseInt(values[10]),
          meRuminant: _parseInt(values[11]),
          meRabbit: _parseInt(values[12]),
          deSalmonids: _parseInt(values[13]),
          priceKg: _parseDouble(values[14]),
          availableQty: _parseDouble(values[15]),
          categoryId: _parseInt(values[16]),
          favourite: values.length > 17 ? _parseInt(values[17]) : 0,
          isCustom: values.length > 18 ? _parseInt(values[18]) : 1,
          createdBy: values.length > 19 ? values[19] : null,
          createdDate: values.length > 20 ? _parseInt(values[20]) : null,
          notes: values.length > 21 ? values[21] : null,
        );

        ingredients.add(ingredient);
      }

      return ingredients;
    } catch (e) {
      if (kDebugMode) print('Error importing from CSV: $e');
      rethrow;
    }
  }

  /// Read file content from app documents directory
  static Future<String> readFile(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      final content = await file.readAsString();
      return content;
    } catch (e) {
      if (kDebugMode) print('Error reading file: $e');
      rethrow;
    }
  }

  // Helper methods
  static String _escapeCsv(String? value) {
    if (value == null || value.isEmpty) return '';
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static List<String> _parseCsvLine(String line) {
    final values = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        values.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    values.add(buffer.toString());

    return values;
  }

  static double? _parseDouble(String value) {
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }

  static int? _parseInt(String value) {
    if (value.isEmpty) return null;
    return int.tryParse(value);
  }
}
