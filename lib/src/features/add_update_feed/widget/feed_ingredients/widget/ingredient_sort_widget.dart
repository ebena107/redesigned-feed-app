import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSortingWidget extends StatelessWidget {
  const IngredientSortingWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return const CategorySortField();
  }
}

class CategorySortField extends ConsumerWidget {
  const CategorySortField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final categories = data.categoryList;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort header
          Text(
            'Filter By:',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),

          // Filter chips
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _FilterChip(
                label: 'All',
                icon: Icons.apps,
                isSelected: data.sortByCategory == null,
                onTap: () => ref
                    .read(ingredientProvider.notifier)
                    .sortIngredientByCat(null),
              ),
              _FilterChip(
                label: 'Favorites',
                icon: Icons.favorite,
                isSelected: false,
                onTap: () {
                  // Filter favorites
                  ref.read(ingredientProvider.notifier).sortIngredientByCat(-1);
                },
              ),
              ...categories.map((IngredientCategory cat) {
                return _FilterChip(
                  label: cat.category ?? 'Unknown',
                  icon: _getCategoryIcon(cat.category),
                  isSelected: data.sortByCategory == cat.categoryId,
                  onTap: () => ref
                      .read(ingredientProvider.notifier)
                      .sortIngredientByCat(cat.categoryId),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.category;

    final lower = category.toLowerCase();
    if (lower.contains('cereal') || lower.contains('grain')) {
      return Icons.grass;
    } else if (lower.contains('oil') || lower.contains('fat')) {
      return Icons.opacity;
    } else if (lower.contains('vitamin') || lower.contains('mineral')) {
      return Icons.local_pharmacy;
    } else if (lower.contains('protein') || lower.contains('meat')) {
      return Icons.egg;
    } else if (lower.contains('root') || lower.contains('tuber')) {
      return Icons.agriculture;
    } else if (lower.contains('fruit') || lower.contains('vegetable')) {
      return Icons.eco;
    } else if (lower.contains('water') || lower.contains('liquid')) {
      return Icons.water_drop;
    }
    return Icons.category;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppConstants.appCarrotColor.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppConstants.appCarrotColor
                  : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
