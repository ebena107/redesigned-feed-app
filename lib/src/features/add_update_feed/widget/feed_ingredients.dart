import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/constants/feature_flags.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/async_feed_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/utils/widgets/get_ingredients_name.dart';
import 'package:feed_estimator/src/utils/widgets/modern_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';

const String _tag = 'FeedIngredients';

class FeedIngredientsField extends ConsumerWidget {
  const FeedIngredientsField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(feedProvider);
    ref.watch(ingredientProvider);
    final feedIngredients = data.feedIngredients;

    double? width = displayWidth(context);

    return feedIngredients.isNotEmpty
        ? CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(
                      thickness: 1,
                      color: AppConstants.appIconGreyColor,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * .32,
                          child: Text(
                            context.l10n.navIngredients,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: width * .2,
                          child: Text(
                            "${context.l10n.labelPrice}/${context.l10n.unitKg}",
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.labelQuantity,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppConstants.appIconGreyColor,
                    ),
                  ],
                ),
              ),
              SliverFixedExtentList(
                itemExtent: 48.0,
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final ingredient = feedIngredients[index];
                  final allIngredients =
                      ref.read(ingredientProvider).ingredients;
                  final ingData = allIngredients.firstWhere(
                    (f) => f.ingredientId == ingredient.ingredientId,
                    orElse: () => Ingredient(),
                  );
                  final isStandardsBased = (ingData.isStandardsBased ?? 0) == 1;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showUpdateDialog(
                        context,
                        ref,
                        ingredient.ingredientId,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacing8,
                          vertical: AppConstants.spacing4,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Ingredient name - horizontally scrollable
                            SizedBox(
                              width: width * 0.32,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GetIngredientName(
                                            id: ingredient.ingredientId,
                                            showDetails: true,
                                          ),
                                          // Region badge
                                          if (ingData.region != null &&
                                              ingData.region!.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: Text(
                                                ingData.region!
                                                    .split(',')
                                                    .first
                                                    .trim(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (FeatureFlags.showStandardsIndicators &&
                                      isStandardsBased)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Colors.green[600],
                                        semanticLabel:
                                            'Standards-based ingredient',
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Price
                            Expanded(
                              child: Text(
                                ingredient.priceUnitKg.toString(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            // Quantity and percentage
                            SizedBox(
                              width: width * .3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ingredient.quantity?.toString() ?? '0',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    data.totalQuantity > 0
                                        ? "${ref.watch(feedProvider.notifier).calcPercent(ingredient.quantity).toStringAsFixed(1)}%"
                                        : "0.0%",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppConstants.appIconGreyColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Delete button with better tap target
                            SizedBox(
                              width: UIConstants.minTapTarget,
                              height: UIConstants.minTapTarget,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: UIConstants.minTapTarget,
                                  minHeight: UIConstants.minTapTarget,
                                ),
                                onPressed: () => _showDeleteDialog(
                                  context,
                                  ref,
                                  ingredient.ingredientId,
                                ),
                                tooltip:
                                    "${context.l10n.actionRemove} ${context.l10n.navIngredients}",
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  size: UIConstants.iconMedium,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: data.feedIngredients.length),
              ),
            ],
          )
        : const SizedBox();
  }
}

/// Show error message with proper styling
void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: context.l10n.actionClose,
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ),
  );
}

/// Show delete confirmation dialog
void _showDeleteDialog(BuildContext context, WidgetRef ref, num? ingredientId) {
  showDialog<void>(
    context: context,
    builder: (context) => _DeleteIngredientDialog(ingredientId: ingredientId),
  );
}

/// Show update dialog for ingredient
void _showUpdateDialog(BuildContext context, WidgetRef ref, num? ingredientId) {
  showDialog<void>(
    context: context,
    builder: (context) => _UpdateIngredientDialog(ingredientId: ingredientId),
  );
}

class _DeleteIngredientDialog extends ConsumerStatefulWidget {
  final num? ingredientId;
  const _DeleteIngredientDialog({this.ingredientId});

  @override
  ConsumerState<_DeleteIngredientDialog> createState() =>
      _DeleteIngredientDialogState();
}

class _DeleteIngredientDialogState
    extends ConsumerState<_DeleteIngredientDialog> {
  bool _isDeleting = false;

  Future<void> _handleDelete() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);

    try {
      await ref
          .read(asyncFeedProvider.notifier)
          .deleteIngredient(widget.ingredientId);
      AppLogger.info('Ingredient ${widget.ingredientId} deleted', tag: _tag);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete ingredient: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() => _isDeleting = false);
        _showErrorSnackBar(context, context.l10n.errorDatabaseOperation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredient = ref.watch(ingredientProvider).ingredients.firstWhere(
          (f) => f.ingredientId == widget.ingredientId,
          orElse: () => Ingredient(),
        );

    final ingredientName = ingredient.name ?? 'this ingredient';

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange[600], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${context.l10n.actionRemove} $ingredientName?",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      content: Text(
        "${context.l10n.actionRemove} $ingredientName. ${context.l10n.confirmDeletionWarning}",
      ),
      actions: [
        OutlinedButton(
          onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.actionCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red[600]),
          onPressed: _isDeleting ? null : _handleDelete,
          child: _isDeleting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(context.l10n.actionRemove),
        ),
      ],
    );
  }
}

/// Update ingredient dialog with proper lifecycle management
class _UpdateIngredientDialog extends ConsumerStatefulWidget {
  final num? ingredientId;
  const _UpdateIngredientDialog({this.ingredientId});

  @override
  ConsumerState<_UpdateIngredientDialog> createState() =>
      _UpdateIngredientDialogState();
}

class _UpdateIngredientDialogState
    extends ConsumerState<_UpdateIngredientDialog> {
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  final _formKey = GlobalKey<FormState>();
  bool _isUpdating = false;
  String? _priceError;
  String? _quantityError;

  @override
  void initState() {
    super.initState();
    final ingredient = _getIngredient();
    _priceController = TextEditingController(
      text: ingredient.priceUnitKg?.toString() ?? '',
    );
    _quantityController = TextEditingController(
      text: ingredient.quantity?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  FeedIngredients _getIngredient() {
    final data = ref.read(feedProvider);
    return data.feedIngredients.firstWhere(
      (f) => f.ingredientId == widget.ingredientId,
      orElse: () => FeedIngredients(),
    );
  }

  void _validatePrice(String value) {
    setState(() {
      _priceError = InputValidators.validatePrice(value);
    });
  }

  void _validateQuantity(String value) {
    setState(() {
      _quantityError = InputValidators.validateQuantity(value);
    });
  }

  Future<void> _handleUpdate() async {
    if (_isUpdating) return;

    // Validate inputs
    _validatePrice(_priceController.text);
    _validateQuantity(_quantityController.text);

    // Only use Ingredient for name validation, not FeedIngredients
    final ingredient = ref.read(ingredientProvider).ingredients.firstWhere(
          (f) => f.ingredientId == widget.ingredientId,
          orElse: () => Ingredient(),
        );
    final name = ingredient.name?.trim() ?? '';
    if (name.isEmpty) {
      final fieldName = context.l10n.labelName;
      await ErrorDialog.show(
        context,
        title: context.l10n.errorRequired(fieldName),
        message: context.l10n.errorRequired(fieldName),
      );
      return;
    }

    if (_priceError != null || _quantityError != null) {
      AppLogger.warning('Invalid input in update dialog', tag: _tag);
      return;
    }

    setState(() => _isUpdating = true);

    try {
      // Update price and quantity
      ref
          .read(feedProvider.notifier)
          .setPrice(widget.ingredientId!, _priceController.text);
      ref
          .read(feedProvider.notifier)
          .setQuantity(widget.ingredientId!, _quantityController.text);

      // Recalculate results
      ref.read(resultProvider.notifier).estimatedResult(
            animal: ref.read(feedProvider).animalTypeId,
            ingList: ref.read(feedProvider).feedIngredients,
          );

      AppLogger.info(
        'Updated ingredient ${widget.ingredientId}: price=${_priceController.text}, qty=${_quantityController.text}',
        tag: _tag,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update ingredient: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() => _isUpdating = false);
        _showErrorSnackBar(context, context.l10n.errorDatabaseOperation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: GetIngredientName(id: widget.ingredientId, showDetails: true),
      content: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price field
                  TextField(
                    controller: _priceController,
                    enabled: !_isUpdating,
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: InputValidators.numericFormatters,
                    decoration: InputDecoration(
                      labelText:
                          "${context.l10n.labelPrice} ${context.l10n.unitKg}",
                      hintText: context.l10n.hintEnterPrice,
                      errorText: _priceError,
                      filled: false,
                      border: const UnderlineInputBorder(),
                    ),
                    onChanged: _validatePrice,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  // Quantity field
                  TextField(
                    controller: _quantityController,
                    enabled: !_isUpdating,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: InputValidators.numericFormatters,
                    decoration: InputDecoration(
                      labelText:
                          "${context.l10n.labelQuantity} (${context.l10n.unitKg})",
                      hintText: context.l10n.hintEnterQuantity,
                      errorText: _quantityError,
                      filled: false,
                      border: const UnderlineInputBorder(),
                    ),
                    onChanged: _validateQuantity,
                    onSubmitted: (_) => _handleUpdate(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _isUpdating
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: Text(context.l10n.actionCancel),
        ),
        FilledButton(
          onPressed: _isUpdating ? null : _handleUpdate,
          child: _isUpdating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(context.l10n.actionUpdate),
        ),
      ],
    );
  }
}
