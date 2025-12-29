import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:feed_estimator/src/features/price_management/provider/price_update_notifier.dart';
import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const String _tag = 'PriceEditDialog';

/// Dialog for adding/editing ingredient prices
class PriceEditDialog extends ConsumerStatefulWidget {
  final int ingredientId;
  final PriceHistory? priceHistory;
  final VoidCallback? onSaved;
  final BuildContext? parentContext;

  const PriceEditDialog({
    required this.ingredientId,
    this.priceHistory,
    this.onSaved,
    this.parentContext,
    super.key,
  });

  @override
  ConsumerState<PriceEditDialog> createState() => _PriceEditDialogState();
}

class _PriceEditDialogState extends ConsumerState<PriceEditDialog> {
  late TextEditingController _priceController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;
  late String _selectedCurrency;
  late String _selectedSource;
  bool _isLoading = false;
  String? _priceError;

  final _formKey = GlobalKey<FormState>();

  static const List<String> _currencies = ['NGN', 'USD', 'EUR', 'GBP'];
  static const List<String> _sources = ['user', 'system', 'market'];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.priceHistory != null) {
      // Editing existing price
      _priceController = TextEditingController(
        text: widget.priceHistory!.price.toStringAsFixed(2),
      );
      _notesController = TextEditingController(
        text: widget.priceHistory!.notes ?? '',
      );
      _selectedDate = widget.priceHistory!.effectiveDate;
      _selectedCurrency = widget.priceHistory!.currency;
      _selectedSource = widget.priceHistory!.source ?? 'user';
    } else {
      // Adding new price
      _priceController = TextEditingController();
      _notesController = TextEditingController();
      _selectedDate = DateTime.now();
      _selectedCurrency = 'NGN';
      _selectedSource = 'user';
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _validatePrice(String value) {
    setState(() {
      _priceError = InputValidators.validatePrice(value);
    });
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;

    _validatePrice(_priceController.text);

    if (_priceError != null) {
      AppLogger.warning('Invalid price input', tag: _tag);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final price = double.parse(_priceController.text.replaceAll(',', '.'));

      if (widget.priceHistory != null) {
        // Update existing
        final repository = ref.read(priceHistoryRepository);
        await repository.update(
          {
            'price': price,
            'notes': _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          },
          widget.priceHistory!.id!,
        );

        AppLogger.info(
          'Updated price history record ${widget.priceHistory!.id}: $price $_selectedCurrency',
          tag: _tag,
        );
      } else {
        // Record new
        await ref.read(priceUpdateNotifier.notifier).recordPrice(
              ingredientId: widget.ingredientId,
              price: price,
              currency: _selectedCurrency,
              effectiveDate: _selectedDate,
              source: _selectedSource,
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            );

        AppLogger.info(
          'Recorded new price for ingredient ${widget.ingredientId}: $price $_selectedCurrency',
          tag: _tag,
        );
      }

      if (mounted) {
        // Close dialog first
        Navigator.of(context).pop();
        // Notify parent (parent will show SnackBar)
        widget.onSaved?.call();
        // Parent handles provider invalidation and SnackBar
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error saving price: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        // Let parent decide how to notify on errors; dialog logs the error.
      }
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.priceHistory != null ? 'Edit Price' : 'Record Price',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Field
              Text(
                'Price',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _priceController,
                enabled: !_isLoading,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: InputValidators.numericFormatters,
                decoration: InputDecoration(
                  hintText: '0.00',
                  errorText: _priceError,
                  suffixIcon: Icon(
                    _priceError == null ? Icons.check_circle : Icons.error,
                    color: _priceError == null ? Colors.green : Colors.red,
                    size: UIConstants.iconSmall,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _validatePrice,
              ),

              const SizedBox(height: UIConstants.paddingNormal),

              // Currency Dropdown
              Text(
                'Currency',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                initialValue: _selectedCurrency,
                items: _currencies
                    .map(
                      (currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(
                          currency,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                isExpanded: true,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _selectedCurrency = value);
                        }
                      },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: UIConstants.paddingNormal),

              // Date Picker
              Text(
                'Effective Date',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading ? null : _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy').format(_selectedDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: UIConstants.iconSmall,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: UIConstants.paddingNormal),

              // Source Dropdown
              Text(
                'Source',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                initialValue: _selectedSource,
                items: _sources
                    .map(
                      (source) => DropdownMenuItem(
                        value: source,
                        child: Text(
                          _formatSourceLabel(source),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                isExpanded: true,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _selectedSource = value);
                        }
                      },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: UIConstants.paddingNormal),

              // Notes Field
              Text(
                'Notes (Optional)',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _notesController,
                enabled: !_isLoading,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Add notes (e.g., "Market price", "Negotiated rate")',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading || _priceError != null ? null : _handleSave,
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Text(widget.priceHistory != null ? 'Update' : 'Record'),
        ),
      ],
    );
  }

  String _formatSourceLabel(String source) {
    return source[0].toUpperCase() + source.substring(1);
  }
}
