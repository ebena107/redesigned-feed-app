import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSelectorTile extends ConsumerWidget {
  const IngredientSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeIngredientProvider);
    final selectedName =
        state.selectedIngredient?.name ?? context.l10n.hintSelectIngredient;
    final isSelected = state.selectedIngredient != null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? const Color(0xff87643E).withValues(alpha: 0.3)
              : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showSelectionSheet(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff87643E)
                      : const Color(0xff87643E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.search_rounded,
                  color: isSelected ? Colors.white : const Color(0xff87643E),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (isSelected
                              ? context.l10n.ingredientSelectedLabel
                              : context.l10n.ingredientSelectLabel)
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selectedName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.black87
                                : Colors.grey.shade500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSelectionSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _IngredientSearchSheet(),
    );
  }
}

class _IngredientSearchSheet extends ConsumerStatefulWidget {
  const _IngredientSearchSheet();

  @override
  ConsumerState<_IngredientSearchSheet> createState() =>
      _IngredientSearchSheetState();
}

class _IngredientSearchSheetState
    extends ConsumerState<_IngredientSearchSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientsListProvider);
    final notifier = ref.read(storeIngredientProvider.notifier);
    final state = ref.watch(storeIngredientProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.ingredientSelectTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                          tooltip: context.l10n.actionClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search field
                    TextField(
                      controller: _searchCtrl,
                      focusNode: _searchFocus,
                      decoration: InputDecoration(
                        hintText: context.l10n.ingredientSearchHint,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  notifier.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (val) {
                        notifier.setSearchQuery(val);
                        setState(() {}); // Rebuild to show/hide clear button
                      },
                    ),
                  ],
                ),
              ),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(context.l10n.filterFavorites),
                      selected: state.showFavoritesOnly,
                      onSelected: (_) => notifier.toggleFavorites(),
                      avatar: Icon(
                        state.showFavoritesOnly
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 18,
                      ),
                      showCheckmark: false,
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.amber.shade100,
                      side: BorderSide(
                        color: state.showFavoritesOnly
                            ? Colors.amber
                            : Colors.transparent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(context.l10n.filterCustom),
                      selected: state.showCustomOnly,
                      onSelected: (_) => notifier.toggleCustom(),
                      avatar: Icon(
                        state.showCustomOnly
                            ? Icons.science_rounded
                            : Icons.science_outlined,
                        size: 18,
                      ),
                      showCheckmark: false,
                      backgroundColor: Colors.grey.shade100,
                      selectedColor:
                          const Color(0xff87643E).withValues(alpha: 0.15),
                      side: BorderSide(
                        color: state.showCustomOnly
                            ? const Color(0xff87643E)
                            : Colors.transparent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (state.regionFilter != null)
                      FilterChip(
                        label: Text(
                          context.l10n.filterRegionLabel(
                            state.regionFilter ?? '',
                          ),
                        ),
                        selected: true,
                        onSelected: (_) => notifier.setRegionFilter('All'),
                        avatar: const Icon(Icons.public_rounded, size: 18),
                        showCheckmark: false,
                        backgroundColor:
                            const Color(0xff87643E).withValues(alpha: 0.15),
                        side: const BorderSide(
                          color: Color(0xff87643E),
                        ),
                      ),
                    if (state.showFavoritesOnly ||
                        state.showCustomOnly ||
                        state.searchQuery.isNotEmpty ||
                        state.regionFilter != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextButton.icon(
                          onPressed: () {
                            notifier.clearFilters();
                            _searchCtrl.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear_all_rounded, size: 18),
                          label: Text(context.l10n.actionClear),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Divider(height: 1, color: Colors.grey.shade200),

              // Ingredients list
              Expanded(
                child: ingredientsAsync.when(
                  data: (allIngredients) {
                    final filtered = notifier.filterList(allIngredients);

                    if (filtered.isEmpty) {
                      return _EmptyState(
                        hasFilters: state.showFavoritesOnly ||
                            state.showCustomOnly ||
                            state.searchQuery.isNotEmpty ||
                            state.regionFilter != null,
                        onClearFilters: () {
                          notifier.clearFilters();
                          _searchCtrl.clear();
                          setState(() {});
                        },
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 72,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final ing = filtered[index];
                        final isSelected =
                            state.selectedIngredient?.ingredientId ==
                                ing.ingredientId;

                        return _IngredientListTile(
                          ingredient: ing,
                          isSelected: isSelected,
                          onTap: () {
                            notifier.selectIngredient(ing);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 48, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.ingredientsLoadFailed,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            err.toString(),
                            style: TextStyle(color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () =>
                                ref.invalidate(ingredientsListProvider),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(context.l10n.actionRetry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IngredientListTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool isSelected;
  final VoidCallback onTap;

  const _IngredientListTile({
    required this.ingredient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: isSelected
            ? const Color(0xff87643E)
            : const Color(0xff87643E).withValues(alpha: 0.1),
        child: Text(
          ingredient.name?.isNotEmpty == true
              ? ingredient.name![0].toUpperCase()
              : context.l10n.fallbackUnknownSymbol,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xff87643E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ingredient.name ?? 'Unknown',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (ingredient.favourite == 1)
                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber.shade600,
                        size: 18,
                      ),
                    if (ingredient.isCustom == 1) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.science_rounded,
                        color: const Color(0xff87643E),
                        size: 18,
                      ),
                    ],
                  ],
                ),
                // Region badge
                if (ingredient.region != null && ingredient.region!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      children: ingredient.region!
                          .split(',')
                          .map((r) => r.trim())
                          .where((r) => r.isNotEmpty)
                          .map((region) => _buildRegionBadge(region))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              context.l10n.ingredientAvailableQty(
                ingredient.availableQty?.toStringAsFixed(1) ?? '0',
              ),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            if (ingredient.priceKg != null) ...[
              const SizedBox(width: 12),
              Icon(Icons.attach_money_rounded,
                  size: 14, color: Colors.grey.shade600),
              Text(
                context.l10n.ingredientPricePerKg(
                  ingredient.priceKg?.toStringAsFixed(2) ?? '0',
                ),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: Color(0xff87643E))
          : Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  /// Build a styled region badge
  Widget _buildRegionBadge(String region) {
    final regionColors = {
      'Africa': Color(0xffD4A574),
      'Asia': Color(0xff9CCC65),
      'Europe': Color(0xff64B5F6),
      'Americas': Color(0xffEF9A9A),
      'Oceania': Color(0xff81C784),
      'Global': Color(0xff90CAF9),
    };

    final bgColor = regionColors[region] ?? Color(0xffBDBDBD);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor, width: 0.5),
      ),
      child: Text(
        region,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: bgColor,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const _EmptyState({
    required this.hasFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters
                  ? Icons.filter_alt_off_rounded
                  : Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              hasFilters
                  ? context.l10n.ingredientsEmptyFilteredTitle
                  : context.l10n.ingredientsEmptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              hasFilters
                  ? context.l10n.ingredientsEmptyFilteredSubtitle
                  : context.l10n.ingredientsEmptySubtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all_rounded),
                label: Text(context.l10n.actionClearFilters),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xff87643E),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
