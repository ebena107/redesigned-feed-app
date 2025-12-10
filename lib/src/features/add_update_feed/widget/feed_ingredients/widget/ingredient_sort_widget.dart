import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSortingWidget extends StatefulWidget {
  const IngredientSortingWidget({
    super.key,
  });

  @override
  State<IngredientSortingWidget> createState() =>
      _IngredientSortingWidgetState();
}

class _IngredientSortingWidgetState extends State<IngredientSortingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _collapseWidget() {
    setState(() {
      _isExpanded = false;
    });
    _animationController.forward();
  }

  void _expandWidget() {
    setState(() {
      _isExpanded = true;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _heightAnimation,
          axis: Axis.vertical,
          child: CategorySortField(
            onSelectionMade: _collapseWidget,
            onToggleSort: _expandWidget,
            isExpanded: _isExpanded,
          ),
        );
      },
    );
  }
}

class CategorySortField extends ConsumerWidget {
  final VoidCallback onSelectionMade;
  final VoidCallback onToggleSort;
  final bool isExpanded;

  const CategorySortField({
    super.key,
    required this.onSelectionMade,
    required this.onToggleSort,
    this.isExpanded = true,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with collapse button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter By:',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (!isExpanded)
                IconButton(
                  icon: const Icon(Icons.expand_more, color: Colors.white70),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onToggleSort,
                )
            ],
          ),
          if (isExpanded) ...[
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
                  onTap: () {
                    ref
                        .read(ingredientProvider.notifier)
                        .sortIngredientByCat(null);
                    onSelectionMade();
                  },
                ),
                _FilterChip(
                  label: 'Favorites',
                  icon: Icons.favorite,
                  isSelected: data.sortByCategory == -1,
                  onTap: () {
                    ref
                        .read(ingredientProvider.notifier)
                        .sortIngredientByCat(-1);
                    onSelectionMade();
                  },
                ),
                ...categories.map((IngredientCategory cat) {
                  return _FilterChip(
                    label: cat.category ?? 'Unknown',
                    icon: _getCategoryIcon(cat.category),
                    isSelected: data.sortByCategory == cat.categoryId,
                    onTap: () {
                      ref
                          .read(ingredientProvider.notifier)
                          .sortIngredientByCat(cat.categoryId);
                      onSelectionMade();
                    },
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.category;

    final lower = category.toLowerCase();

    // Grain categories
    if (lower.contains('cereal') ||
        lower.contains('grain') ||
        lower.contains('rice') ||
        lower.contains('maize') ||
        lower.contains('corn') ||
        lower.contains('wheat') ||
        lower.contains('barley') ||
        lower.contains('oats')) {
      return Icons.grain;
    }
    // Oil/Fat categories
    else if (lower.contains('oil') ||
        lower.contains('fat') ||
        lower.contains('lipid') ||
        lower.contains('palm') ||
        lower.contains('coconut')) {
      return Icons.opacity;
    }
    // Vitamin/Mineral categories
    else if (lower.contains('vitamin') ||
        lower.contains('mineral') ||
        lower.contains('supplement') ||
        lower.contains('trace') ||
        lower.contains('premix')) {
      return Icons.healing;
    }
    // Protein/Meat categories
    else if (lower.contains('protein') ||
        lower.contains('meat') ||
        lower.contains('fish') ||
        lower.contains('bone') ||
        lower.contains('blood') ||
        lower.contains('poultry') ||
        lower.contains('meal')) {
      return Icons.egg;
    }
    // Root/Tuber categories
    else if (lower.contains('root') ||
        lower.contains('tuber') ||
        lower.contains('yam') ||
        lower.contains('cassava') ||
        lower.contains('potato') ||
        lower.contains('sweet')) {
      return Icons.agriculture;
    }
    // Fruit/Vegetable categories
    else if (lower.contains('fruit') ||
        lower.contains('vegetable') ||
        lower.contains('legume') ||
        lower.contains('bean') ||
        lower.contains('pea') ||
        lower.contains('forage')) {
      return Icons.eco;
    }
    // Water/Liquid categories
    else if (lower.contains('water') ||
        lower.contains('liquid') ||
        lower.contains('molasses')) {
      return Icons.water_drop;
    }
    // Salt/Mineral categories
    else if (lower.contains('salt') || lower.contains('sodium')) {
      return Icons.grain;
    }
    // Feed additive categories
    else if (lower.contains('additive') ||
        lower.contains('binder') ||
        lower.contains('probiotic') ||
        lower.contains('enzyme')) {
      return Icons.science;
    }
    // Default
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
