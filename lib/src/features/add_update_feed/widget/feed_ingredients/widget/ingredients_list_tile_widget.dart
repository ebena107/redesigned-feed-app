import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/price_management/provider/current_price_provider.dart';
import 'package:feed_estimator/src/features/price_management/view/price_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Ingredient list tile with price and category info.
class IngredientListTileWidget extends ConsumerWidget {
  const IngredientListTileWidget({
    super.key,
    required this.ingredient,
    required this.isSelected,
  });

  final Ingredient? ingredient;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientValue = ingredient;
    if (ingredientValue == null) return const SizedBox.shrink();

    final selectedColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: isSelected ? 4 : 0,
      color: isSelected
          ? selectedColor.withValues(alpha: 0.1)
          : Colors.transparent,
      child: ListTile(
        selected: isSelected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? selectedColor : Colors.transparent,
            width: 2,
          ),
        ),
        onTap: () => ref
            .read(ingredientProvider.notifier)
            .selectIngredient(ingredientValue),
        onLongPress: ingredientValue.ingredientId != null
            ? () => _openPriceHistory(context, ingredientValue)
            : null,
        leading: isSelected
            ? Icon(Icons.check_circle, color: selectedColor, size: 24)
            : Icon(Icons.circle_outlined, color: Colors.grey[400], size: 24),
        title: Text(
          ingredientValue.name ?? 'Unknown ingredient',
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? selectedColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: _buildSubtitle(context, ref, ingredientValue),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceInfo(context, ref, ingredientValue),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.show_chart, size: 20),
              tooltip: 'Price history',
              onPressed: ingredientValue.ingredientId != null
                  ? () => _openPriceHistory(context, ingredientValue)
                  : null,
            ),
            if (ingredientValue.favourite == 1)
              Icon(Icons.favorite, color: Colors.red[400], size: 22),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildSubtitle(
    BuildContext context,
    WidgetRef ref,
    Ingredient ingredientValue,
  ) {
    if (ingredientValue.categoryId == null) return const SizedBox.shrink();

    final data = ref.watch(ingredientProvider);
    final category = data.categoryList.firstWhere(
      (cat) => cat.categoryId == ingredientValue.categoryId,
      orElse: () => IngredientCategory(),
    );

    return Row(
      children: [
        Icon(_getCategoryIcon(category.category),
            size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            category.category ?? 'Unknown',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(
    BuildContext context,
    WidgetRef ref,
    Ingredient ingredientValue,
  ) {
    final id = ingredientValue.ingredientId;
    if (id == null) return const SizedBox.shrink();

    final priceAsync =
        ref.watch(currentPriceProvider(ingredientId: id.toInt()));
    return priceAsync.when(
      data: (price) {
        final formatter = NumberFormat.currency(symbol: '₦', decimalDigits: 2);
        return Text(
          formatter.format(price),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
        );
      },
      loading: () => const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const Icon(Icons.error, color: Colors.red, size: 18),
    );
  }

  void _openPriceHistory(BuildContext context, Ingredient ingredientValue) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PriceHistoryView(
          ingredientId: ingredientValue.ingredientId!.toInt(),
          ingredientName: ingredientValue.name,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.category;

    final lower = category.toLowerCase();

    if (lower.contains('cereal') ||
        lower.contains('grain') ||
        lower.contains('rice') ||
        lower.contains('maize') ||
        lower.contains('corn') ||
        lower.contains('wheat') ||
        lower.contains('barley') ||
        lower.contains('oats')) {
      return Icons.grain;
    } else if (lower.contains('oil') ||
        lower.contains('fat') ||
        lower.contains('lipid') ||
        lower.contains('palm') ||
        lower.contains('coconut')) {
      return Icons.opacity;
    } else if (lower.contains('vitamin') ||
        lower.contains('mineral') ||
        lower.contains('supplement') ||
        lower.contains('trace') ||
        lower.contains('premix')) {
      return Icons.healing;
    } else if (lower.contains('protein') ||
        lower.contains('meat') ||
        lower.contains('fish') ||
        lower.contains('bone') ||
        lower.contains('blood') ||
        lower.contains('poultry') ||
        lower.contains('meal')) {
      return Icons.egg;
    } else if (lower.contains('root') ||
        lower.contains('tuber') ||
        lower.contains('yam') ||
        lower.contains('cassava') ||
        lower.contains('potato') ||
        lower.contains('sweet')) {
      return Icons.agriculture;
    } else if (lower.contains('fruit') ||
        lower.contains('vegetable') ||
        lower.contains('legume') ||
        lower.contains('bean') ||
        lower.contains('pea') ||
        lower.contains('forage')) {
      return Icons.eco;
    } else if (lower.contains('water') ||
        lower.contains('liquid') ||
        lower.contains('molasses')) {
      return Icons.water_drop;
    } else if (lower.contains('salt') || lower.contains('sodium')) {
      return Icons.grain;
    } else if (lower.contains('additive') ||
        lower.contains('binder') ||
        lower.contains('probiotic') ||
        lower.contains('enzyme') ||
        lower.contains('acidifier')) {
      return Icons.science;
    }

    return Icons.category;
  }
}
