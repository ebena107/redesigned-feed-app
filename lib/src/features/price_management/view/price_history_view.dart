import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/core/utils/widget_builders.dart';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:feed_estimator/src/features/price_management/provider/current_price_provider.dart';
import 'package:feed_estimator/src/features/price_management/provider/price_history_provider.dart';
import 'package:feed_estimator/src/features/price_management/widget/price_bulk_import_dialog.dart';
import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:feed_estimator/src/features/price_management/widget/price_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const String _tag = 'PriceHistoryView';

/// Displays price history for an ingredient with add/edit/delete capabilities
class PriceHistoryView extends ConsumerStatefulWidget {
  final int ingredientId;
  final String? ingredientName;

  const PriceHistoryView({
    required this.ingredientId,
    this.ingredientName,
    super.key,
  });

  @override
  ConsumerState<PriceHistoryView> createState() => _PriceHistoryViewState();
}

class _PriceHistoryViewState extends ConsumerState<PriceHistoryView> {
  @override
  Widget build(BuildContext context) {
    final priceHistoryAsync =
        ref.watch(priceHistoryProvider(widget.ingredientId));
    final currentPriceAsync =
        ref.watch(currentPriceProvider(ingredientId: widget.ingredientId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingredientName ?? 'Price History'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Price Card
            _buildCurrentPriceCard(currentPriceAsync),
            const SizedBox(height: UIConstants.paddingNormal),

            // Price History Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price History',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showImportDialog(context),
                            icon: const Icon(Icons.file_upload,
                                size: UIConstants.iconSmall),
                            label: const Text('Import CSV'),
                          ),
                          const SizedBox(width: UIConstants.paddingSmall),
                          FilledButton.icon(
                            onPressed: () => _showAddPriceDialog(context),
                            label: const Text('Add Price'),
                            icon: const Icon(Icons.add,
                                size: UIConstants.iconSmall),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.paddingNormal),
                ],
              ),
            ),

            // Price History List
            priceHistoryAsync.when(
              loading: () => WidgetBuilders.buildLoadingIndicator(),
              error: (error, stackTrace) {
                AppLogger.error(
                  'Error loading price history: $error',
                  tag: _tag,
                  error: error,
                  stackTrace: stackTrace,
                );
                return WidgetBuilders.buildErrorState(
                  message: 'Failed to load price history',
                  onRetry: () =>
                      ref.refresh(priceHistoryProvider(widget.ingredientId)),
                );
              },
              data: (priceHistory) {
                if (priceHistory.isEmpty) {
                  return WidgetBuilders.buildEmptyState(
                    message: 'No price history recorded yet',
                    action: WidgetBuilders.buildPrimaryButton(
                      label: 'Record First Price',
                      onPressed: () => _showAddPriceDialog(context),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCard(priceHistory),
                      const SizedBox(height: UIConstants.paddingNormal),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: priceHistory.length,
                        itemBuilder: (context, index) {
                          final price = priceHistory[index];
                          return _buildPriceHistoryCard(
                            price,
                            priceHistory.length > 1 && index > 0
                                ? priceHistory[index - 1]
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build quick stats card (min, max, averages)
  Widget _buildStatsCard(List<PriceHistory> history) {
    final now = DateTime.now();
    final prices = history.map((e) => e.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final overallAvg =
        prices.isEmpty ? 0 : prices.reduce((a, b) => a + b) / prices.length;

    double avgInDays(int days) {
      final cutoff = now.subtract(Duration(days: days));
      final window =
          history.where((p) => p.effectiveDate.isAfter(cutoff)).toList();
      if (window.isEmpty) return 0;
      final sum = window.fold<double>(0, (prev, curr) => prev + curr.price);
      return sum / window.length;
    }

    final avg30 = avgInDays(30);
    final avg90 = avgInDays(90);
    final avg365 = avgInDays(365);

    return Container(
      width: double.infinity,
      decoration: UIConstants.cardDecoration(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Analytics',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UIConstants.paddingSmall),
          Wrap(
            spacing: UIConstants.paddingNormal,
            runSpacing: UIConstants.paddingSmall,
            children: [
              _buildStatChip('Min', minPrice),
              _buildStatChip('Max', maxPrice),
              _buildStatChip('Avg (all)', overallAvg.toDouble()),
              _buildStatChip('Avg 30d', avg30),
              _buildStatChip('Avg 90d', avg90),
              _buildStatChip('Avg 365d', avg365),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, double value) {
    return Chip(
      label: Text('$label: ${value.toStringAsFixed(2)} NGN'),
      backgroundColor: Colors.grey[100],
      side: BorderSide(color: Colors.grey[300] ?? Colors.grey),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => PriceBulkImportDialog(
        ingredientId: widget.ingredientId,
        onImported: () {
          ref.invalidate(priceHistoryProvider(widget.ingredientId));
        },
      ),
    );
  }

  /// Build card showing current price with change indicator
  Widget _buildCurrentPriceCard(AsyncValue<double> currentPriceAsync) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: UIConstants.cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Price',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            currentPriceAsync.when(
              loading: () => const SizedBox(
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (error, _) => Text(
                'Error: Unable to load',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
              ),
              data: (price) {
                // Format price with currency
                final formatted = NumberFormat.currency(
                  symbol: '',
                  decimalDigits: 2,
                ).format(price);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$formatted NGN',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                    ),
                    Text(
                      'Updated today',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual price history card with change indicator
  Widget _buildPriceHistoryCard(
    PriceHistory price,
    PriceHistory? previousPrice,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final priceDate = DateTime.fromMillisecondsSinceEpoch(
        price.effectiveDate.millisecondsSinceEpoch);

    // Calculate price change from previous
    final priceChange =
        previousPrice != null ? price.price - previousPrice.price : null;
    final isIncrease = priceChange != null && priceChange > 0;
    final percentChange = priceChange != null && previousPrice != null
        ? ((priceChange / previousPrice.price) * 100)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: UIConstants.paddingNormal),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEditPriceDialog(context, price),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price and Change
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${price.price.toStringAsFixed(2)} ${price.currency}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (priceChange != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isIncrease ? Colors.red[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${isIncrease ? '+' : ''}${priceChange.toStringAsFixed(2)} (${isIncrease ? '+' : ''}${percentChange?.toStringAsFixed(1)}%)',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isIncrease
                                        ? Colors.red[700]
                                        : Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )
                    else
                      const SizedBox(width: 0),
                  ],
                ),

                const SizedBox(height: UIConstants.paddingSmall),

                // Date and Source
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormat.format(priceDate),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getSourceColor(price.source),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        price.source ?? 'user',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ],
                ),

                // Notes if available
                if (price.notes != null && price.notes!.isNotEmpty) ...[
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    'Note: ${price.notes}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Actions
                const SizedBox(height: UIConstants.paddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showEditPriceDialog(context, price),
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit, size: UIConstants.iconSmall),
                    ),
                    const SizedBox(width: UIConstants.paddingSmall),
                    TextButton.icon(
                      onPressed: () => _showDeleteConfirmation(context, price),
                      label: const Text('Delete'),
                      icon:
                          const Icon(Icons.delete, size: UIConstants.iconSmall),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get color for source badge
  Color _getSourceColor(String? source) {
    switch (source?.toLowerCase()) {
      case 'user':
        return Colors.blue;
      case 'system':
        return Colors.green;
      case 'market':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Show dialog to add new price
  void _showAddPriceDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => PriceEditDialog(
        ingredientId: widget.ingredientId,
        onSaved: () {
          if (mounted) {
            ref.invalidate(priceHistoryProvider(widget.ingredientId));
            ref.invalidate(
                currentPriceProvider(ingredientId: widget.ingredientId));
          }
        },
      ),
    );
  }

  /// Show dialog to edit existing price
  void _showEditPriceDialog(BuildContext context, PriceHistory priceHistory) {
    showDialog<void>(
      context: context,
      builder: (context) => PriceEditDialog(
        ingredientId: widget.ingredientId,
        priceHistory: priceHistory,
        onSaved: () {
          if (mounted) {
            ref.invalidate(priceHistoryProvider(widget.ingredientId));
            ref.invalidate(
                currentPriceProvider(ingredientId: widget.ingredientId));
          }
        },
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(
      BuildContext context, PriceHistory priceHistory) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Price Record?'),
        content: Text(
          'Delete price record of ${priceHistory.price} ${priceHistory.currency} '
          'from ${DateFormat('MMM dd, yyyy').format(priceHistory.effectiveDate)}?',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              try {
                final repository = ref.read(priceHistoryRepository);
                await repository.delete(priceHistory.id!);
                AppLogger.info(
                  'Deleted price history record ${priceHistory.id}',
                  tag: _tag,
                );
                if (!mounted) return;

                navigator.pop();
                ref.invalidate(priceHistoryProvider(widget.ingredientId));
                ref.invalidate(
                  currentPriceProvider(ingredientId: widget.ingredientId),
                );

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Price record deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                AppLogger.error(
                  'Error deleting price history: $e',
                  tag: _tag,
                  error: e,
                );
                if (!mounted) return;

                navigator.pop();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete price record'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
