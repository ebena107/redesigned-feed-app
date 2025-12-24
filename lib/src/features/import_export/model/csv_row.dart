import 'package:equatable/equatable.dart';

/// Raw CSV row data
class CSVRow extends Equatable {
  final int rowNumber;
  final List<String> values;
  final List<String>? errors; // Validation errors for this row

  const CSVRow({
    required this.rowNumber,
    required this.values,
    this.errors,
  });

  bool get isValid => errors == null || errors!.isEmpty;

  @override
  List<Object?> get props => [rowNumber, values, errors];
}

/// Parsed CSV data with headers and rows
class ParsedCSVFile extends Equatable {
  final List<String> headers;
  final List<CSVRow> rows;
  final String detectedFormat; // 'nrc', 'cvb', 'inra', or 'unknown'
  final String fileName;
  final int rowCount;

  const ParsedCSVFile({
    required this.headers,
    required this.rows,
    required this.detectedFormat,
    required this.fileName,
    required this.rowCount,
  });

  /// Get total valid rows
  int get validRowCount => rows.where((r) => r.isValid).length;

  /// Get total invalid rows
  int get invalidRowCount => rows.where((r) => !r.isValid).length;

  @override
  List<Object?> get props =>
      [headers, rows, detectedFormat, fileName, rowCount];
}

/// Column mapping configuration for user customization
class ColumnMapping extends Equatable {
  final Map<String, String> mapping; // csvHeader -> ingredientField
  final List<String> requiredFields;

  const ColumnMapping({
    required this.mapping,
    this.requiredFields = const [
      'name',
      'crudeProtein',
    ],
  });

  /// Check if all required fields are mapped
  bool get isComplete {
    return requiredFields.every((field) => mapping.containsValue(field));
  }

  /// Get unmapped required fields
  List<String> get missingFields {
    return requiredFields
        .where((field) => !mapping.containsValue(field))
        .toList();
  }

  ColumnMapping copyWith({
    Map<String, String>? mapping,
    List<String>? requiredFields,
  }) {
    return ColumnMapping(
      mapping: mapping ?? this.mapping,
      requiredFields: requiredFields ?? this.requiredFields,
    );
  }

  @override
  List<Object?> get props => [mapping, requiredFields];
}
