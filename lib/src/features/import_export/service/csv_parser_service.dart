import 'dart:io';
import 'package:csv/csv.dart' as csv_pkg;
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

const String _tag = 'CsvParserService';

enum CSVFormat {
  nrc, // NRC (National Research Council) - USA standard
  cvb, // CVB (Centraal Veevoeder Bureau) - Netherlands
  inra, // INRA (Institut National de Recherche Agronomique) - France
  unknown
}

class CSVParsingException implements Exception {
  final String message;
  CSVParsingException(this.message);

  @override
  String toString() => 'CSVParsingException: $message';
}

/// Parses CSV files with auto-format detection
class CsvParserService {
  /// Parse CSV file and detect format from headers
  ///
  /// Returns: ParsedCSVFile with headers, rows, and detected format
  /// Throws: CSVParsingException if file invalid or empty
  static Future<ParsedCSVFile> parseCSVFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw CSVParsingException('File not found: $filePath');
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        throw CSVParsingException('CSV file is empty');
      }

      // Parse CSV
      final rows = const csv_pkg.CsvToListConverter().convert(content);
      if (rows.isEmpty) {
        throw CSVParsingException('No rows found in CSV');
      }

      // Extract headers from first row
      final headers =
          rows[0].map((h) => h.toString().trim().toLowerCase()).toList();
      final dataRows = rows.skip(1).toList();

      if (dataRows.isEmpty) {
        throw CSVParsingException('CSV has headers but no data rows');
      }

      // Detect format
      final format = detectFormat(headers);

      // Normalize headers to standard names
      final normalizedHeaders = normalizeHeaders(headers, format);

      AppLogger.info(
        'Parsed CSV: ${dataRows.length} rows, format=$format',
        tag: _tag,
      );

      return ParsedCSVFile(
        headers: normalizedHeaders,
        dataRows: dataRows,
        detectedFormat: format,
        rawRowCount: dataRows.length,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to parse CSV: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw CSVParsingException('Failed to parse CSV: $e');
    }
  }

  /// Detect CSV format from header row
  ///
  /// NRC: "Ingredient Name", "Crude Protein", "ME (Growing Pig)"
  /// CVB: "Name", "Crude protein", "Net Energy"
  /// INRA: "Name", "Crude protein %", "NE pig (kcal/kg)"
  static CSVFormat detectFormat(List<String> headers) {
    final headerString = headers.join('|').toLowerCase();

    if (headerString.contains('crude protein') &&
        headerString.contains('growing pig')) {
      return CSVFormat.nrc;
    }

    if (headerString.contains('net energy') && headerString.contains('cvb')) {
      return CSVFormat.cvb;
    }

    if (headerString.contains('ne pig') || headerString.contains('inra')) {
      return CSVFormat.inra;
    }

    return CSVFormat.unknown;
  }

  /// Normalize headers to standard field names
  /// Maps: "Crude Protein %" → "crude_protein"
  static List<String> normalizeHeaders(
    List<String> headers,
    CSVFormat format,
  ) {
    const normalizationMap = {
      // Name variants
      'ingredient name': 'name',
      'ingredient_name': 'name',
      'name': 'name',
      'product': 'name',

      // Crude Protein
      'crude protein': 'crude_protein',
      'crude protein %': 'crude_protein',
      'crude protein (%dm)': 'crude_protein',
      'protein %': 'crude_protein',
      'cp %': 'crude_protein',

      // Crude Fiber
      'crude fiber': 'crude_fiber',
      'crude fiber %': 'crude_fiber',
      'fiber %': 'crude_fiber',
      'cf %': 'crude_fiber',

      // Crude Fat
      'crude fat': 'crude_fat',
      'ether extract': 'crude_fat',

      // Calcium
      'calcium': 'calcium',
      'ca': 'calcium',
      'ca %': 'calcium',

      // Phosphorus
      'phosphorus': 'phosphorus',
      'p': 'phosphorus',
      'p %': 'phosphorus',

      // Lysine
      'lysine': 'lysine',
      'lys': 'lysine',
      'lysine (%)': 'lysine',

      // Methionine
      'methionine': 'methionine',
      'met': 'methionine',

      // Energy (pig growing)
      'me (growing pig)': 'me_growing_pig',
      'me growing pig': 'me_growing_pig',
      'me pig': 'me_growing_pig',
      'metabolizable energy': 'me_growing_pig',

      // Energy (poultry)
      'me (poultry)': 'me_poultry',
      'me poultry': 'me_poultry',

      // Price
      'price': 'price_kg',
      'price/kg': 'price_kg',
      'price per kg': 'price_kg',
      'cost': 'price_kg',
      'unit price': 'price_kg',
    };

    return headers.map((h) {
      final normalized = normalizationMap[h] ?? h;
      return normalized;
    }).toList();
  }

  /// Validate required fields are present
  /// For basic import: name, crude_protein required
  /// Returns: List\<ValidationError\> (empty if valid)
  static List<ValidationError> validateHeaders(List<String> headers) {
    final errors = <ValidationError>[];

    if (!headers.contains('name')) {
      errors.add(ValidationError(
        column: 'name',
        message: 'Required field "name" (ingredient name) not found',
      ));
    }

    if (!headers.any((h) => h.contains('protein'))) {
      errors.add(ValidationError(
        column: 'crude_protein',
        message: 'No protein field found (try "Crude Protein", "CP %")',
      ));
    }

    return errors;
  }

  /// Parse and validate data rows
  /// Returns: List\<CSVRow\> with parsed values
  /// Rows with critical errors are marked as invalid
  static List<CSVRow> parseDataRows(
    List<String> headers,
    List<List<dynamic>> dataRows,
  ) {
    final parsedRows = <CSVRow>[];

    for (int i = 0; i < dataRows.length; i++) {
      final row = dataRows[i];
      final errors = <String>[];

      // Ensure row has enough columns
      if (row.length < headers.length) {
        errors.add('Row has ${row.length} columns, expected ${headers.length}');
      }

      // Extract data with proper types
      final rowData = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < row.length; j++) {
        final header = headers[j];
        final value = row[j].toString().trim();
        rowData[header] = value;
      }

      parsedRows.add(CSVRow(
        rowNumber:
            i + 2, // +2 because row 1 is headers, +1 for 1-based indexing
        data: rowData,
        errors: errors,
      ));
    }

    return parsedRows;
  }

  /// Convert CSV row to Ingredient model
  /// Returns: Ingredient object with mapped fields
  /// Throws: ValidationException if required fields invalid
  static Ingredient csvRowToIngredient(CSVRow row) {
    final data = row.data;

    // Extract required fields
    final name = (data['name'] as String?)?.trim();
    if (name == null || name.isEmpty) {
      throw CSVParsingException('Row ${row.rowNumber}: name field required');
    }

    // Parse numeric fields with safety
    num? asNum(String? value) {
      if (value == null || value.isEmpty) return null;
      final trimmed = value.replaceAll(',', '.').trim();
      try {
        return double.parse(trimmed);
      } catch (_) {
        return null;
      }
    }

    return Ingredient(
      name: name,
      crudeProtein: asNum(data['crude_protein'] as String?),
      crudeFiber: asNum(data['crude_fiber'] as String?),
      crudeFat: asNum(data['crude_fat'] as String?),
      calcium: asNum(data['calcium'] as String?),
      phosphorus: asNum(data['phosphorus'] as String?),
      lysine: asNum(data['lysine'] as String?),
      methionine: asNum(data['methionine'] as String?),
      meGrowingPig: asNum(data['me_growing_pig'] as String?)?.toInt(),
      mePoultry: asNum(data['me_poultry'] as String?)?.toInt(),
      priceKg: asNum(data['price_kg'] as String?),
      isCustom: 1, // All imported ingredients are custom
      createdDate: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class ParsedCSVFile {
  final List<String> headers;
  final List<List<dynamic>> dataRows;
  final CSVFormat detectedFormat;
  final int rawRowCount;

  const ParsedCSVFile({
    required this.headers,
    required this.dataRows,
    required this.detectedFormat,
    required this.rawRowCount,
  });

  /// Get data rows as CSVRow objects
  List<CSVRow> get parsedRows =>
      CsvParserService.parseDataRows(headers, dataRows);
}

class CSVRow {
  final int rowNumber;
  final Map<String, dynamic> data;
  final List<String> errors;

  const CSVRow({
    required this.rowNumber,
    required this.data,
    this.errors = const [],
  });

  bool get isValid => errors.isEmpty;
  String get displayName => data['name']?.toString() ?? 'Unknown';
}

class ValidationError {
  final String column;
  final String message;

  const ValidationError({
    required this.column,
    required this.message,
  });
}
