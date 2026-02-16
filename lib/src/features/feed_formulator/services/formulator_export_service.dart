import 'dart:io';
import 'package:csv/csv.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Service for exporting Feed Formulator results to various formats (PDF, CSV, text)
class FormulatorExportService {
  FormulatorExportService({
    required this.ingredients,
  });

  final List<Ingredient> ingredients;

  /// Generate PDF report from formulation result
  Future<File> exportToPdf(
    FormulatorResult result, {
    String? animalTypeName,
  }) async {
    try {
      final pdf = pw.Document();

      // Get ingredient names mapped from IDs
      final ingredientNames = <num, String>{};
      for (final ing in ingredients) {
        if (ing.ingredientId != null) {
          ingredientNames[ing.ingredientId!] = ing.name ?? 'Unknown';
        }
      }

      // Build content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [
            _buildPdfHeader(animalTypeName),
            pw.SizedBox(height: 10),
            _buildPdfSummary(result),
            pw.SizedBox(height: 15),
            _buildPdfIngredientMix(result, ingredientNames),
            pw.SizedBox(height: 15),
            _buildPdfNutrientsSummary(result),
            if (result.warnings.isNotEmpty) ...[
              pw.SizedBox(height: 15),
              _buildPdfWarnings(result),
            ],
            pw.SizedBox(height: 20),
            _buildPdfFooter(),
          ],
        ),
      );

      // Save to temporary file
      final outputFile = await _getSaveFile('Formulation_Report.pdf');
      await outputFile.writeAsBytes(await pdf.save());

      AppLogger.info(
        'PDF exported successfully to: ${outputFile.path}',
        tag: 'FormulatorExportService',
      );
      return outputFile;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export PDF',
        tag: 'FormulatorExportService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Generate CSV export from formulation result
  Future<File> exportToCsv(
    FormulatorResult result,
  ) async {
    try {
      // Get ingredient names mapped from IDs
      final ingredientNames = <num, String>{};
      for (final ing in ingredients) {
        if (ing.ingredientId != null) {
          ingredientNames[ing.ingredientId!] = ing.name ?? 'Unknown';
        }
      }

      // Build CSV rows
      final rows = <List<String>>[
        ['Feed Formulation Report'],
        [],
        ['Ingredient Mix'],
        ['Ingredient', 'Percentage (%)', 'Cost/kg', 'Total Cost'],
      ];

      double totalCost = 0;
      for (final entry in result.ingredientPercents.entries) {
        final ingId = entry.key;
        final percentage = entry.value;
        final ingName = ingredientNames[ingId] ?? 'Unknown';

        // Find ingredient to get price
        final ing = ingredients.firstWhere(
          (i) => i.ingredientId == ingId,
          orElse: () => Ingredient(),
        );
        final pricePerKg = ing.priceKg ?? 0.0;
        final costForIngredient = (percentage / 100.0) * pricePerKg;
        totalCost += costForIngredient;

        rows.add([
          ingName,
          percentage.toStringAsFixed(2),
          pricePerKg.toStringAsFixed(2),
          costForIngredient.toStringAsFixed(2),
        ]);
      }

      rows.add([]);
      rows.add(['Total Cost per kg', '', '', totalCost.toStringAsFixed(2)]);

      // Add nutrients section
      rows.add([]);
      rows.add(['Nutrients Summary']);
      rows.add(['Nutrient', 'Value', 'Unit']);

      for (final entry in result.nutrients.entries) {
        rows.add([
          entry.key.toString().split('.').last, // Convert enum to string
          entry.value.toStringAsFixed(2),
          _getUnit(entry.key.toString()),
        ]);
      }

      // Convert to CSV string
      final csv = const ListToCsvConverter().convert(rows);

      // Save to file
      final outputFile = await _getSaveFile('Formulation_Report.csv');
      await outputFile.writeAsString(csv);

      AppLogger.info(
        'CSV exported successfully to: ${outputFile.path}',
        tag: 'FormulatorExportService',
      );
      return outputFile;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export CSV',
        tag: 'FormulatorExportService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Generate shareable text format
  String generateShareText(
    FormulatorResult result, {
    String? animalTypeName,
  }) {
    try {
      // Get ingredient names mapped from IDs
      final ingredientNames = <num, String>{};
      for (final ing in ingredients) {
        if (ing.ingredientId != null) {
          ingredientNames[ing.ingredientId!] = ing.name ?? 'Unknown';
        }
      }

      final buffer = StringBuffer();

      buffer.writeln('📊 Feed Formulation Report');
      if (animalTypeName != null) {
        buffer.writeln('Animal Type: $animalTypeName');
      }
      buffer.writeln('Generated: ${DateTime.now().toString().split('.')[0]}');
      buffer.writeln('');

      buffer.writeln('💰 Cost Summary');
      buffer.writeln('Total Cost/kg: ₦${result.costPerKg.toStringAsFixed(2)}');
      buffer.writeln('');

      buffer.writeln('🥕 Ingredient Mix');
      for (final entry in result.ingredientPercents.entries) {
        final ingId = entry.key;
        final percentage = entry.value;
        final ingName = ingredientNames[ingId] ?? 'Unknown';
        buffer.writeln('• $ingName: ${percentage.toStringAsFixed(1)}%');
      }
      buffer.writeln('');

      buffer.writeln('🔬 Nutrients');
      for (final entry in result.nutrients.entries) {
        final value = entry.value.toStringAsFixed(1);
        final unit = _getUnit(entry.key.toString());
        final nutrientName = entry.key.toString().split('.').last;
        buffer.writeln('• $nutrientName: $value $unit');
      }

      if (result.warnings.isNotEmpty) {
        buffer.writeln('');
        buffer.writeln('⚠️ Warnings');
        for (final warning in result.warnings) {
          buffer.writeln('• $warning');
        }
      }

      return buffer.toString();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to generate share text',
        tag: 'FormulatorExportService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Private helpers

  pw.Widget _buildPdfHeader(String? animalTypeName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Feed Formulation Report',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (animalTypeName != null)
          pw.Text(
            'Animal Type: $animalTypeName',
            style: const pw.TextStyle(fontSize: 12),
          ),
        pw.Text(
          'Generated: ${DateTime.now().toString().split('.')[0]}',
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  pw.Widget _buildPdfSummary(FormulatorResult result) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Cost Summary',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text('Total Cost/kg: ₦${result.costPerKg.toStringAsFixed(2)}'),
          pw.Text('Status: ${result.status}'),
        ],
      ),
    );
  }

  pw.Widget _buildPdfIngredientMix(
    FormulatorResult result,
    Map<num, String> ingredientNames,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Ingredient Mix',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text('Ingredient',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text('Percentage',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            for (final entry in result.ingredientPercents.entries)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      ingredientNames[entry.key] ?? 'Unknown',
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      '${entry.value.toStringAsFixed(1)}%',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfNutrientsSummary(FormulatorResult result) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Nutrients Summary',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text('Nutrient',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text('Value',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text('Unit',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            for (final entry in result.nutrients.entries)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(entry.key.toString().split('.').last),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(entry.value.toStringAsFixed(2)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(_getUnit(entry.key.toString())),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfWarnings(FormulatorResult result) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Warnings',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        for (final warning in result.warnings)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child:
                pw.Text('• $warning', style: const pw.TextStyle(fontSize: 10)),
          ),
      ],
    );
  }

  pw.Widget _buildPdfFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide()),
      ),
      child: pw.Text(
        'Generated by Feed Estimator App',
        style: const pw.TextStyle(fontSize: 9),
      ),
    );
  }

  String _getUnit(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'metabolic_energy':
      case 'digestive_energy':
        return 'kcal/kg';
      case 'crude_protein':
      case 'crude_fat':
      case 'crude_fiber':
      case 'ash':
      case 'moisture':
        return '%';
      case 'calcium':
      case 'phosphorus':
      case 'lysine':
      case 'methionine':
        return 'g/kg';
      default:
        return '';
    }
  }

  Future<File> _getSaveFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$filename');
  }
}
