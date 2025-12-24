import 'dart:convert';

import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/price_management/provider/price_update_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// const String _tag = 'PriceBulkImportDialog';

// /// CSV bulk import dialog for price history
// /// Expected columns (header optional):
// /// ingredient_id, price, currency, effective_date (yyyy-MM-dd), source, notes
// class PriceBulkImportDialog extends ConsumerStatefulWidget {
//   final int ingredientId;
//   final VoidCallback? onImported;

//   const PriceBulkImportDialog({
//     required this.ingredientId,
//     this.onImported,
//     super.key,
//   });

//   @override
//   ConsumerState<PriceBulkImportDialog> createState() =>
//       _PriceBulkImportDialogState();
// }

// class _PriceBulkImportDialogState
//     extends ConsumerState<PriceBulkImportDialog> {
//   bool _isImporting = false;
//   String? _status;
//   String? _error;
//   int _imported = 0;
//   int _failed = 0;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Import Prices (CSV)'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Columns: ingredient_id, price, currency, effective_date (yyyy-MM-dd), source, notes',
//           ),
//           const SizedBox(height: UIConstants.paddingSmall),
//           if (_status != null)
//             Text(
//               _status!,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall
//                   ?.copyWith(color: Colors.blueGrey),
//             ),
//           if (_error != null)
//             Text(
//               _error!,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall
//                   ?.copyWith(color: Colors.red),
//             ),
//         ],
//       ),
//       actions: [
//         OutlinedButton(
//           onPressed: _isImporting ? null : () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         FilledButton.icon(
//           onPressed: _isImporting ? null : _pickAndImport,
//           icon: _isImporting
//               ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : const Icon(Icons.file_upload),
//           label: const Text('Import CSV'),
//         ),
//       ],
//     );
//   }

//   Future<void> _pickAndImport() async {
//     setState(() {
//       _isImporting = true;
//       _status = 'Reading file...';
//       _error = null;
//       _imported = 0;
//       _failed = 0;
//     });

//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['csv'],
//         withData: true,
//       );

//       if (result == null || result.files.isEmpty) {
//         setState(() {
//           _isImporting = false;
//           _status = 'No file selected';
//         });
//         return;
//       }

//       final file = result.files.first;
//       final content = utf8.decode(file.bytes!);
//       final lines = LineSplitter.split(content).toList();
//       if (lines.isEmpty) {
//         setState(() {
//           _isImporting = false;
//           _error = 'File is empty';
//         });
//         return;
//       }

//       // Skip header if present
//       int startIndex = 0;
//       if (lines.first.toLowerCase().contains('ingredient') &&
//           lines.first.toLowerCase().contains('price')) {
//         startIndex = 1;
//       }

//       final repo = ref.read(priceHistoryRepository);

//       for (int i = startIndex; i < lines.length; i++) {
//         final row = _parseCsvLine(lines[i]);
//         if (row == null || row.length < 2) {
//           _failed++;
//           continue;
//         }

//         try {
//           final ingredientId = row.isNotEmpty && row[0].isNotEmpty
//               ? int.parse(row[0])
//               : widget.ingredientId;
//           final price = double.parse(row[1]);
//           final currency = row.length > 2 && row[2].isNotEmpty
//               ? row[2]
//               : 'NGN';
//           final dateStr = row.length > 3 && row[3].isNotEmpty
//               ? row[3]
//               : '';
//           final source = row.length > 4 && row[4].isNotEmpty
//               ? row[4]
//               : 'user';
//           final notes = row.length > 5 ? row[5] : null;

//           final effectiveDate = dateStr.isNotEmpty
//               ? DateTime.parse(dateStr)
//               : DateTime.now();

//           await repo.recordPrice(
//             ingredientId: ingredientId,
//             price: price,
//             currency: currency,
//             effectiveDate: effectiveDate,
//             source: source,
//             notes: notes,
//           );
//           _imported++;
//         } catch (e) {
//           _failed++;
//           AppLogger.warning('Failed to import row ${i + 1}: $e', tag: _tag);
//         }
//       }

//       setState(() {
//         _status = 'Imported $_imported rows, $_failed failed';
//         _isImporting = false;
//       });

//       widget.onImported?.call();
//     } catch (e, stackTrace) {
//       AppLogger.error('Bulk import failed: $e',
//           tag: _tag, error: e, stackTrace: stackTrace);
//       setState(() {
//         _error = 'Import failed. Please check the file and try again.';
//         _isImporting = false;
//       });
//     }
//   }

//   List<String>? _parseCsvLine(String line) {
//     // Very small CSV parser for simple comma-separated values without quotes
//     // Accepts commas inside quotes
//     final values = <String>[];
//     final buffer = StringBuffer();
//     bool inQuotes = false;

//     for (int i = 0; i < line.length; i++) {
//       final char = line[i];
//       if (char == '"') {
//         inQuotes = !inQuotes;
//         continue;
//       }
//       if (char == ',' && !inQuotes) {
//         values.add(buffer.toString().trim());
//         buffer.clear();
//       } else {
//         buffer.write(char);
//       }
//     }
//     values.add(buffer.toString().trim());

//     return values;
//   }
// }

const String _tag = 'PriceBulkImportDialog';

/// Dialog for bulk importing prices via CSV.
/// Expected CSV columns (header required):
/// ingredient_id,price,currency,effective_date,source,notes
/// - effective_date format: ISO8601 (e.g., 2024-12-31) or epoch millis
/// - currency optional (defaults to NGN)
/// - source optional (defaults to 'user')
class PriceBulkImportDialog extends ConsumerStatefulWidget {
  final int ingredientId;
  final VoidCallback? onImported;

  const PriceBulkImportDialog({
    required this.ingredientId,
    this.onImported,
    super.key,
  });

  @override
  ConsumerState<PriceBulkImportDialog> createState() =>
      _PriceBulkImportDialogState();
}

class _PriceBulkImportDialogState extends ConsumerState<PriceBulkImportDialog> {
  bool _isLoading = false;
  String? _error;
  int _importedCount = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import Prices (CSV)'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a CSV file with header: \n'
              'ingredient_id,price,currency,effective_date,source,notes',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red[700]),
              ),
            if (_importedCount > 0)
              Text(
                'Imported $_importedCount record(s).',
                style: TextStyle(color: Colors.green[700]),
              ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _handleImport,
          icon: const Icon(Icons.file_upload, size: UIConstants.iconSmall),
          label: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Choose CSV'),
        ),
      ],
    );
  }

  Future<void> _handleImport() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _importedCount = 0;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        throw Exception('Unable to read file data');
      }

      final content = utf8.decode(bytes);
      final lines = content
          .split(RegExp(r'\r?\n'))
          .where((l) => l.trim().isNotEmpty)
          .toList();
      if (lines.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Parse header
      final header =
          lines.first.split(',').map((h) => h.trim().toLowerCase()).toList();
      final requiredColumns = [
        'ingredient_id',
        'price',
        'currency',
        'effective_date'
      ];
      for (final col in requiredColumns) {
        if (!header.contains(col)) {
          throw Exception('Missing required column: $col');
        }
      }

      final idx = {
        for (var i = 0; i < header.length; i++) header[i]: i,
      };

      int success = 0;
      for (var i = 1; i < lines.length; i++) {
        final cells = lines[i].split(',');
        if (cells.length < header.length) continue;

        final ingredientIdStr = cells[idx['ingredient_id']!].trim();
        final priceStr = cells[idx['price']!].trim();
        final currency = cells[idx['currency']!].trim().isEmpty
            ? 'NGN'
            : cells[idx['currency']!].trim();
        final effectiveStr = cells[idx['effective_date']!].trim();
        final source = idx.containsKey('source')
            ? cells[idx['source']!].trim().isEmpty
                ? 'user'
                : cells[idx['source']!].trim()
            : 'user';
        final notes = idx.containsKey('notes') && cells.length > idx['notes']!
            ? (cells[idx['notes']!].trim().isEmpty
                ? null
                : cells[idx['notes']!].trim())
            : null;

        final ingredientId = int.tryParse(ingredientIdStr);
        final price = double.tryParse(priceStr.replaceAll(',', '.'));
        if (ingredientId == null || price == null) {
          AppLogger.warning('Skipping row $i: invalid ingredientId/price',
              tag: _tag);
          continue;
        }

        DateTime? effectiveDate;
        // Try ISO8601 first, then epoch millis
        effectiveDate = DateTime.tryParse(effectiveStr);
        if (effectiveDate == null) {
          final millis = int.tryParse(effectiveStr);
          if (millis != null) {
            effectiveDate = DateTime.fromMillisecondsSinceEpoch(millis);
          }
        }
        effectiveDate ??= DateTime.now();

        await ref.read(priceUpdateNotifier.notifier).recordPrice(
              ingredientId: ingredientId,
              price: price,
              currency: currency,
              effectiveDate: effectiveDate,
              source: source,
              notes: notes,
            );

        success += 1;
      }

      if (success == 0) {
        throw Exception('No valid rows imported.');
      }

      setState(() {
        _importedCount = success;
        _isLoading = false;
      });

      AppLogger.info('Imported $success price records', tag: _tag);
      widget.onImported?.call();
    } catch (e, stackTrace) {
      AppLogger.error('Bulk import failed: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      setState(() {
        _error = 'Import failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
}
