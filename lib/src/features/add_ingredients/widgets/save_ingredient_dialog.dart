import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const String _tag = 'SaveIngredientDialog';

class SaveIngredientDialog extends ConsumerWidget {
  final num? feedId;
  const SaveIngredientDialog({super.key, this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(ingredientProvider).name!.value;
    
    return CupertinoAlertDialog(
      title: Text(
        '${name!.toUpperCase()} - Added Successfully',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      content: const Text('Would you like to add another ingredient?'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('NO'),
          onPressed: () {
            AppLogger.info('User chose not to add another ingredient', tag: _tag);
            context.pop(); // Close dialog using go_router
            context.go('/'); // Navigate to home
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('YES'),
          onPressed: () {
            AppLogger.info('User chose to add another ingredient', tag: _tag);
            context.pop(); // Close dialog using go_router
            context.go('/newIngredient'); // Navigate to new ingredient form
          },
        )
      ],
    );
  }
}
