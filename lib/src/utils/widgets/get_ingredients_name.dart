import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/feature_flags.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetIngredientName extends ConsumerWidget {
  final num? id;
  final Color? color;
  final bool showDetails; // Show reference code and separation notes

  const GetIngredientName({
    this.color,
    super.key,
    required this.id,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedIngredients = ref.watch(ingredientProvider).ingredients;
    Ingredient? e = feedIngredients.firstWhere((e) => e.ingredientId == id,
        orElse: () => Ingredient());

    final textStyle = color != null
        ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: color)
        : Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppConstants.appFontColor);

    // Base ingredient name
    final nameWidget = Text(
      e.name.toString(),
      maxLines: 3,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
      textAlign: TextAlign.start,
    );

    // If not showing details or feature flag disabled, return just the name
    if (!showDetails || !FeatureFlags.showStandardsIndicators) {
      return nameWidget;
    }

    // Show details: name + reference code + separation notes
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        nameWidget,
        // Standard reference badge (NRC/CVB/INRA)
        if (e.standardReference != null && e.standardReference!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue[300]!, width: 0.5),
              ),
              child: Text(
                e.standardReference!,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        // Separation notes tooltip (for variants like fish meal)
        if (e.separationNotes != null && e.separationNotes!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Tooltip(
              message: e.separationNotes!,
              preferBelow: false,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: UIConstants.iconSmall,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Variant Info',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[700],
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
