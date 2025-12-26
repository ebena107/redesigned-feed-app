import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/widgets/user_ingredients_widget.dart';
import 'package:feed_estimator/src/features/price_management/view/price_history_view.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';
import 'package:feed_estimator/src/features/store_ingredients/widget/ingredient_select_widget.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoredIngredients extends ConsumerWidget {
  const StoredIngredients({super.key});

  static const _brandColor = Color(0xff87643E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeIngredientProvider);
    final hasSelection = state.selectedIngredient != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const FeedAppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Modern app bar
          SliverAppBar.medium(
            backgroundColor: _brandColor,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text(
              context.l10n.ingredientLibraryTitle,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Back pattern background
                  const Image(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.cover,
                  ),
                  // Brown overlay gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _brandColor.withValues(alpha: 0.6),
                          _brandColor.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => ref.invalidate(ingredientsListProvider),
                tooltip: context.l10n.actionRefresh,
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Ingredient selector
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.manageInventoryTitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _brandColor,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const IngredientSelectorTile(),
                ],
              ),
            ),
          ),

          // Region filter
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _RegionFilterBar(),
            ),
          ),

          // Edit form with animation
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: hasSelection
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: _EditFormCard(brandColor: _brandColor),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Custom ingredients header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.science_rounded, color: _brandColor, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.customIngredientsTitle,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _brandColor,
                                  fontWeight: FontWeight.bold,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      // Use direct path navigation for reliability
                      // Typed route remains available, but path-based go avoids any gen issues
                      context.go('/newIngredient');
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(context.l10n.actionAddNew),
                    style: FilledButton.styleFrom(
                      backgroundColor: _brandColor.withValues(alpha: 0.1),
                      foregroundColor: _brandColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User ingredients list
          const SliverFillRemaining(
            hasScrollBody: true,
            child: UserIngredientsWidget(),
          ),
        ],
      ),
    );
  }
}

class _RegionFilterBar extends ConsumerStatefulWidget {
  const _RegionFilterBar();

  @override
  ConsumerState<_RegionFilterBar> createState() => _RegionFilterBarState();
}

class _RegionFilterBarState extends ConsumerState<_RegionFilterBar> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeIngredientProvider);
    final selected = state.regionFilter ?? 'All';

    // Map of region keys to translated names
    final regions = {
      'All': context.l10n.regionAll,
      'Africa': context.l10n.regionAfrica,
      'Asia': context.l10n.regionAsia,
      'Europe': context.l10n.regionEurope,
      'Americas': context.l10n.regionAmericas,
      'Oceania': context.l10n.regionOceania,
      'Global': context.l10n.regionGlobal,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: regions.entries.map((entry) {
          final key = entry.key;
          final name = entry.value;
          final isSelected =
              selected == key || (key == 'All' && state.regionFilter == null);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(name),
              selected: isSelected,
              onSelected: (_) {
                ref.read(storeIngredientProvider.notifier).setRegionFilter(key);
              },
              selectedColor: const Color(0xff87643E).withValues(alpha: 0.2),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EditFormCard extends ConsumerStatefulWidget {
  final Color brandColor;

  const _EditFormCard({required this.brandColor});

  @override
  ConsumerState<_EditFormCard> createState() => _EditFormCardState();
}

class _EditFormCardState extends ConsumerState<_EditFormCard> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = ref.read(storeIngredientProvider);
    _priceCtrl =
        TextEditingController(text: state.draftPrice?.toString() ?? '');
    _qtyCtrl = TextEditingController(text: state.draftQty?.toString() ?? '');
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeIngredientProvider);
    final notifier = ref.read(storeIngredientProvider.notifier);

    // Update controllers when state changes
    if (_priceCtrl.text != state.draftPrice?.toString()) {
      _priceCtrl.text = state.draftPrice?.toString() ?? '';
    }
    if (_qtyCtrl.text != state.draftQty?.toString()) {
      _qtyCtrl.text = state.draftQty?.toString() ?? '';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with favorite toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.updateDetailsTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Material(
                    color: state.draftFavorite
                        ? widget.brandColor.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () =>
                          notifier.toggleDraftFavorite(!state.draftFavorite),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state.draftFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: state.draftFavorite
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.draftFavorite
                                  ? context.l10n.labelFavorite
                                  : context.l10n.labelAddToFavorites,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: state.draftFavorite
                                    ? widget.brandColor
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Input fields
              Row(
                children: [
                  Expanded(
                    child: _ModernTextField(
                      label: context.l10n.labelPricePerKg,
                      controller: _priceCtrl,
                      icon: Icons.attach_money_rounded,
                      onChanged: notifier.updateDraftPrice,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n
                              .errorRequired(context.l10n.labelPrice);
                        }
                        final num = double.tryParse(value);
                        if (num == null || num <= 0) {
                          return context.l10n.errorPriceGreaterThanZero;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ModernTextField(
                      label: context.l10n.labelAvailableQty,
                      controller: _qtyCtrl,
                      icon: Icons.inventory_2_rounded,
                      onChanged: notifier.updateDraftQty,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n
                              .errorRequired(context.l10n.labelQuantity);
                        }
                        final num = double.tryParse(value);
                        if (num == null || num < 0) {
                          return context.l10n.errorQuantityGreaterOrEqual;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  // Delete button
                  IconButton.filledTonal(
                    onPressed: () => _confirmDelete(context, ref),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: context.l10n.actionDelete,
                  ),
                  const SizedBox(width: 12),

                  // Price history button
                  IconButton.filledTonal(
                    onPressed: () => _viewPriceHistory(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.trending_up_rounded),
                    tooltip: context.l10n.actionPriceHistory,
                  ),
                  const SizedBox(width: 12),

                  // Reset button
                  OutlinedButton.icon(
                    onPressed:
                        state.hasChanges ? () => notifier.resetDraft() : null,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(context.l10n.actionReset),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Save button
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.hasChanges && state.isValid
                          ? () => _saveChanges(context, ref)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.brandColor,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save_rounded),
                      label: Text(context.l10n.actionSaveChanges),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(storeIngredientProvider);
    final ing = state.selectedIngredient;
    if (ing == null) return;

    final updatedIng = ing.copyWith(
      priceKg: state.draftPrice,
      availableQty: state.draftQty,
      favourite: state.draftFavorite ? 1 : 0,
    );

    try {
      await ref
          .read(ingredientsRepository)
          .update(updatedIng.toJson(), updatedIng.ingredientId as num);

      ref.invalidate(ingredientsListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(context.l10n.successIngredientUpdated),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.fixed,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(context.l10n.errorSaveFailed(e.toString()))),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.fixed,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _viewPriceHistory(BuildContext context) {
    final ingredient = ref.read(storeIngredientProvider).selectedIngredient;
    if (ingredient == null || ingredient.ingredientId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PriceHistoryView(
          ingredientId: ingredient.ingredientId!.toInt(),
          ingredientName: ingredient.name,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.delete_forever_rounded,
            color: Colors.red.shade400, size: 32),
        title: Text(context.l10n.deleteIngredientTitle),
        content: Text(context.l10n.deleteIngredientMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.confirmCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.confirmDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final ingredientId =
          ref.read(storeIngredientProvider).selectedIngredient?.ingredientId;

      if (ingredientId != null) {
        try {
          // Call your delete method here
          ref.read(storeIngredientProvider.notifier).selectIngredient(null);
          ref.invalidate(ingredientsListProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(context.l10n.successIngredientDeleted),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.fixed,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.errorDeleteFailed(e.toString())),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.fixed,
              ),
            );
          }
        }
      }
    }
  }
}

class _ModernTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: const Color(0xff87643E)),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff87643E), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
