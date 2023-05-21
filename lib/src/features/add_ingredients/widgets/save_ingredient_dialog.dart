import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SaveIngredientDialog extends ConsumerWidget {
  final num? feedId;
  const SaveIngredientDialog({Key? key, this.feedId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(ingredientProvider).name!.value;
    return CupertinoAlertDialog(
      title: Text(
        '${name!.toUpperCase()} - added Successfully',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      content: const Text('Add another Ingredient?'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('NO'),
          onPressed: () {
            context.go('/');
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('YES'),
          onPressed: () {
            context.pop();
          },
        )
      ],
    );
  }
}
