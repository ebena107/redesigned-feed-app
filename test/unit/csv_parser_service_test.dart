import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/import_export/service/csv_parser_service.dart';

void main() {
  group('CsvParserService Tests', () {
    group('Format Detection', () {
      test('detects NRC format correctly', () {
        final headers = [
          'ingredient name',
          'crude protein %',
          'me (growing pig)',
          'calcium'
        ];
        final format = CsvParserService.detectFormat(headers);
        expect(format, CSVFormat.nrc);
      });

      test('detects CVB format correctly', () {
        final headers = ['name', 'crude protein', 'net energy', 'cvb'];
        final format = CsvParserService.detectFormat(headers);
        expect(format, CSVFormat.cvb);
      });

      test('detects INRA format correctly', () {
        final headers = ['name', 'crude protein %', 'ne pig (kcal/kg)'];
        final format = CsvParserService.detectFormat(headers);
        expect(format, CSVFormat.inra);
      });

      test('returns unknown for unrecognized format', () {
        final headers = ['column1', 'column2', 'column3'];
        final format = CsvParserService.detectFormat(headers);
        expect(format, CSVFormat.unknown);
      });

      test('detects format case-insensitive', () {
        final headers = [
          'INGREDIENT NAME',
          'CRUDE PROTEIN %',
          'ME (GROWING PIG)'
        ];
        final format = CsvParserService.detectFormat(headers);
        expect(format, CSVFormat.nrc);
      });
    });

    group('Header Normalization', () {
      test('normalizes common name variants', () {
        final headers = ['ingredient name', 'product', 'ingredient_name'];
        final normalized = CsvParserService.normalizeHeaders(
          headers,
          CSVFormat.nrc,
        );
        expect(normalized, ['name', 'name', 'name']);
      });

      test('normalizes protein field variants', () {
        final headers = ['crude protein', 'protein %', 'cp %'];
        final normalized = CsvParserService.normalizeHeaders(
          headers,
          CSVFormat.nrc,
        );
        expect(
          normalized,
          ['crude_protein', 'crude_protein', 'crude_protein'],
        );
      });

      test('normalizes energy field variants', () {
        final headers = ['me (growing pig)', 'me pig', 'metabolizable energy'];
        final normalized = CsvParserService.normalizeHeaders(
          headers,
          CSVFormat.nrc,
        );
        expect(
          normalized,
          ['me_growing_pig', 'me_growing_pig', 'me_growing_pig'],
        );
      });

      test('preserves unknown headers', () {
        final headers = ['name', 'unknown_column', 'crude_protein'];
        final normalized = CsvParserService.normalizeHeaders(
          headers,
          CSVFormat.nrc,
        );
        expect(normalized[1], 'unknown_column');
      });
    });

    group('Header Validation', () {
      test('accepts valid headers with name and protein', () {
        final headers = ['name', 'crude_protein', 'calcium'];
        final errors = CsvParserService.validateHeaders(headers);
        expect(errors, isEmpty);
      });

      test('rejects missing name field', () {
        final headers = ['crude_protein', 'calcium'];
        final errors = CsvParserService.validateHeaders(headers);
        expect(errors.length, greaterThan(0));
        expect(errors.first.column, 'name');
      });

      test('rejects missing protein field', () {
        final headers = ['name', 'calcium'];
        final errors = CsvParserService.validateHeaders(headers);
        expect(errors.length, greaterThan(0));
        expect(errors.first.column, 'crude_protein');
      });

      test('accepts partial protein field variants', () {
        final headers = ['name', 'protein_value'];
        final errors = CsvParserService.validateHeaders(headers);
        expect(errors.length,
            0); // 'protein_value' contains 'protein' so validation passes
      });
    });

    group('Data Row Parsing', () {
      test('parses valid data rows correctly', () {
        final headers = ['name', 'crude_protein', 'calcium'];
        final dataRows = [
          ['Corn', '8.5', '0.03'],
          ['Soybean', '47.5', '0.29'],
        ];
        final parsed = CsvParserService.parseDataRows(headers, dataRows);

        expect(parsed.length, 2);
        expect(parsed[0].displayName, 'Corn');
        expect(parsed[0].data['crude_protein'], '8.5');
        expect(parsed[1].displayName, 'Soybean');
        expect(parsed[1].isValid, true);
      });

      test('marks rows with missing columns as invalid', () {
        final headers = ['name', 'crude_protein', 'calcium'];
        final dataRows = [
          ['Corn', '8.5'], // Missing calcium
        ];
        final parsed = CsvParserService.parseDataRows(headers, dataRows);

        expect(parsed[0].isValid, false);
        expect(parsed[0].errors.length, greaterThan(0));
      });

      test('assigns correct row numbers (1-indexed, +2 for headers)', () {
        final headers = ['name', 'crude_protein'];
        final dataRows = [
          ['Corn', '8.5'],
          ['Soybean', '47.5'],
        ];
        final parsed = CsvParserService.parseDataRows(headers, dataRows);

        expect(parsed[0].rowNumber, 2); // Row 1 is headers
        expect(parsed[1].rowNumber, 3);
      });

      test('handles mixed types in data rows', () {
        final headers = ['name', 'crude_protein', 'price'];
        final dataRows = [
          ['Corn', 8.5, 0.25], // Numeric types instead of strings
          ['Soybean', '47.5', '0.45'], // String types
        ];
        final parsed = CsvParserService.parseDataRows(headers, dataRows);

        expect(parsed[0].data['crude_protein'], '8.5');
        expect(parsed[1].data['crude_protein'], '47.5');
      });

      test('trims whitespace from all values', () {
        final headers = ['name', 'crude_protein'];
        final dataRows = [
          ['  Corn  ', '  8.5  '],
        ];
        final parsed = CsvParserService.parseDataRows(headers, dataRows);

        expect(parsed[0].data['name'], 'Corn');
        expect(parsed[0].data['crude_protein'], '8.5');
      });
    });

    group('CSV Row to Ingredient Conversion', () {
      test('converts valid CSV row to Ingredient', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn Grain',
            'crude_protein': '8.5',
            'calcium': '0.03',
            'lysine': '0.26',
            'price_kg': '0.25',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.name, 'Corn Grain');
        expect(ingredient.crudeProtein, 8.5);
        expect(ingredient.calcium, 0.03);
        expect(ingredient.lysine, 0.26);
        expect(ingredient.priceKg, 0.25);
        expect(ingredient.isCustom, 1);
      });

      test('rejects row with missing name field', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'crude_protein': '8.5',
            'calcium': '0.03',
          },
        );

        expect(
          () => CsvParserService.csvRowToIngredient(row),
          throwsA(isA<CSVParsingException>()),
        );
      });

      test('handles empty name gracefully', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': '',
            'crude_protein': '8.5',
          },
        );

        expect(
          () => CsvParserService.csvRowToIngredient(row),
          throwsA(isA<CSVParsingException>()),
        );
      });

      test('handles malformed numeric values gracefully', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn Grain',
            'crude_protein': 'abc', // Invalid numeric
            'calcium': '0.03',
            'lysine': 'not_a_number',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.name, 'Corn Grain');
        expect(ingredient.crudeProtein, isNull);
        expect(ingredient.calcium, 0.03);
        expect(ingredient.lysine, isNull);
      });

      test('converts comma decimal separator to period', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn Grain',
            'crude_protein': '8,5', // Comma separator
            'calcium': '0,03',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.crudeProtein, 8.5);
        expect(ingredient.calcium, 0.03);
      });

      test('sets isCustom to 1 for imported ingredients', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Imported Ingredient',
            'crude_protein': '8.5',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.isCustom, 1);
      });

      test('converts energy values to integers', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn',
            'crude_protein': '8.5',
            'me_growing_pig': '3350.5',
            'me_poultry': '3300.7',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.meGrowingPig, 3350);
        expect(ingredient.mePoultry, 3300);
      });
    });

    group('Edge Cases', () {
      test('handles empty data values', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn',
            'crude_protein': '', // Empty value
            'calcium': '',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.crudeProtein, isNull);
        expect(ingredient.calcium, isNull);
      });

      test('handles null data values', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn',
            'crude_protein': null, // Null value
            'calcium': null,
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.crudeProtein, isNull);
        expect(ingredient.calcium, isNull);
      });

      test('handles very large numeric values', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Ingredient',
            'crude_protein': '999999.99',
            'price_kg': '10000.50',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.crudeProtein, 999999.99);
        expect(ingredient.priceKg, 10000.50);
      });

      test('handles negative numeric values', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Ingredient',
            'crude_protein':
                '-5.5', // Negative (technically invalid but should parse)
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.crudeProtein, -5.5);
      });

      test('handles leading/trailing whitespace in numeric values', () {
        final row = CSVRow(
          rowNumber: 2,
          data: {
            'name': 'Corn',
            'crude_protein': '  8.5  ',
            'calcium': '  0.03  ',
          },
        );

        final ingredient = CsvParserService.csvRowToIngredient(row);

        expect(ingredient.crudeProtein, 8.5);
        expect(ingredient.calcium, 0.03);
      });
    });
  });
}
