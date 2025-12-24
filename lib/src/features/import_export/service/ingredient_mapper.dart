import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/import_export/model/csv_row.dart';

/// Maps CSV row data to Ingredient model
class IngredientMapper {
  static const String _tag = 'IngredientMapper';

  /// Standard field names that CSV can map to
  static const List<String> standardFields = [
    'name',
    'standardizedName',
    'standardReference',
    'crudeProtein',
    'crudeFiber',
    'crudeFat',
    'calcium',
    'phosphorus',
    'totalPhosphorus',
    'availablePhosphorus',
    'phytatePhosphorus',
    'lysine',
    'methionine',
    'ash',
    'moisture',
    'starch',
    'bulkDensity',
    'meGrowingPig',
    'meAdultPig',
    'meFinishingPig',
    'mePoultry',
    'meRuminant',
    'meRabbit',
    'deSalmonids',
    'priceKg',
    'categoryId',
    'notes',
    'warning',
    'regulatoryNote',
    'maxInclusionPct',
  ];

  /// Map CSV row to Ingredient using column mapping
  static Ingredient mapRowToIngredient({
    required CSVRow row,
    required List<String> headers,
    required Map<String, String> columnMapping, // csvHeader -> ingredientField
  }) {
    try {
      final values = <String, String>{};

      // Build value map from CSV row using headers
      for (int i = 0; i < headers.length && i < row.values.length; i++) {
        final header = headers[i];
        final value = row.values[i];

        // Map CSV column to ingredient field
        final ingredientField = columnMapping[header];
        if (ingredientField != null && value.trim().isNotEmpty) {
          values[ingredientField] = value.trim();
        }
      }

      // Validate required fields
      if (values['name'] == null || values['name']!.isEmpty) {
        throw ValidationException(
          message: 'Ingredient name is required',
          field: 'name',
        );
      }

      if (values['crudeProtein'] == null || values['crudeProtein']!.isEmpty) {
        throw ValidationException(
          message: 'Crude protein is required for ${values['name']}',
          field: 'crudeProtein',
        );
      }

      // Parse numeric fields
      final ingredient = Ingredient(
        name: values['name'],
        standardizedName: values['standardizedName'],
        standardReference: values['standardReference'],
        crudeProtein: _parseNumeric(values['crudeProtein']),
        crudeFiber: _parseNumeric(values['crudeFiber']),
        crudeFat: _parseNumeric(values['crudeFat']),
        calcium: _parseNumeric(values['calcium']),
        phosphorus: _parseNumeric(values['phosphorus']),
        totalPhosphorus: _parseNumeric(values['totalPhosphorus']),
        availablePhosphorus: _parseNumeric(values['availablePhosphorus']),
        phytatePhosphorus: _parseNumeric(values['phytatePhosphorus']),
        lysine: _parseNumeric(values['lysine']),
        methionine: _parseNumeric(values['methionine']),
        ash: _parseNumeric(values['ash']),
        moisture: _parseNumeric(values['moisture']),
        starch: _parseNumeric(values['starch']),
        bulkDensity: _parseNumeric(values['bulkDensity']),
        meGrowingPig: _parseNumeric(values['meGrowingPig']),
        meAdultPig: _parseNumeric(values['meAdultPig']),
        meFinishingPig: _parseNumeric(values['meFinishingPig']),
        mePoultry: _parseNumeric(values['mePoultry']),
        meRuminant: _parseNumeric(values['meRuminant']),
        meRabbit: _parseNumeric(values['meRabbit']),
        deSalmonids: _parseNumeric(values['deSalmonids']),
        priceKg: _parseNumeric(values['priceKg']),
        categoryId: _parseNumeric(values['categoryId']),
        notes: values['notes'],
        warning: values['warning'],
        regulatoryNote: values['regulatoryNote'],
        maxInclusionPct: _parseNumeric(values['maxInclusionPct']),
        isCustom: 1, // Mark imported ingredients as custom
        createdDate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      AppLogger.info(
        'Mapped CSV row to ingredient: ${ingredient.name}',
        tag: _tag,
      );

      return ingredient;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to map CSV row to ingredient: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Parse numeric value handling commas and periods
  static num? _parseNumeric(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      // Normalize: replace comma with period
      final normalized = value.trim().replaceAll(',', '.');
      final parsed = double.parse(normalized);
      return parsed;
    } catch (_) {
      AppLogger.warning('Could not parse numeric value: $value', tag: _tag);
      return null;
    }
  }

  /// Get suggested column mapping based on CSV headers
  /// Uses fuzzy matching against standard field names
  static Map<String, String> suggestMapping(List<String> csvHeaders) {
    final mapping = <String, String>{};

    for (final header in csvHeaders) {
      final normalized = header.toLowerCase().trim();

      // Direct matches
      if (normalized.contains('name') && !normalized.contains('standard')) {
        mapping[header] = 'name';
      } else if (normalized.contains('protein')) {
        mapping[header] = 'crudeProtein';
      } else if (normalized.contains('fiber') || normalized.contains('fibre')) {
        mapping[header] = 'crudeFiber';
      } else if (normalized.contains('fat')) {
        mapping[header] = 'crudeFat';
      } else if (normalized.contains('calcium')) {
        mapping[header] = 'calcium';
      } else if (normalized.contains('phosphor')) {
        // Prefer totalPhosphorus if not specified
        mapping[header] = 'totalPhosphorus';
      } else if (normalized.contains('lysine')) {
        mapping[header] = 'lysine';
      } else if (normalized.contains('methionine') ||
          normalized.contains('met')) {
        mapping[header] = 'methionine';
      } else if (normalized.contains('energy') || normalized.contains('me')) {
        mapping[header] = 'meGrowingPig'; // Default energy type
      } else if (normalized.contains('price') || normalized.contains('cost')) {
        mapping[header] = 'priceKg';
      } else if (normalized.contains('category')) {
        mapping[header] = 'categoryId';
      } else if (normalized.contains('note')) {
        mapping[header] = 'notes';
      }
    }

    return mapping;
  }
}
