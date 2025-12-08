import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'form_widgets.dart';
import 'custom_ingredient_fields.dart';

class IngredientForm extends ConsumerWidget {
  final int? ingId;
  const IngredientForm({super.key, this.ingId});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final isCustom = ingId == null; // New ingredients are custom

    return Form(
      key: _formKey,
      child: Card(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isCustom) customIngredientHeader(),
            nameField(ref, ingId, context),
            Card(
              child: Row(
                children: [
                  Flexible(child: categoryField(ref, ingId)),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  const Text('Energy Values of the Ingredient'),
                  const Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                                'Enter Energy Values for each specific Group of Animals?'),
                            Checkbox(
                                value: data.singleEnergyValue,
                                onChanged: (bool? value) => ref
                                    .read(ingredientProvider.notifier)
                                    .selectEnergyMode(value!))
                          ],
                        ),
                      ),
                      if (!data.singleEnergyValue)
                        Expanded(child: energyField(ref)),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  if (data.singleEnergyValue)
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: energyAdultPigField(ref)),
                              Expanded(child: energyGrowingPigField(ref)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: energyFishField(ref)),
                              Expanded(child: energyPoultryField(ref))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: energyRabbitField(ref)),
                              Expanded(child: energyRuminantField(ref))
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Expanded(
                    child: proteinField(ref, context),
                  ),
                  Expanded(child: fatField(ref)),
                  Expanded(child: fibreField(ref)),
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Expanded(child: calciumField(ref)),
                  Expanded(child: phosphorusField(ref))
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Expanded(child: lyzineField(ref)),
                  Expanded(child: methionineField(ref)),
                ],
              ),
            ),
            Card(
              child: Row(
                children: [
                  Expanded(child: priceField(ref)),
                  Expanded(child: availableQuantityField(ref)),
                ],
              ),
            ),
            if (isCustom) ...[
              const SizedBox(height: 8),
              createdByField(ref),
              const SizedBox(height: 8),
              notesField(ref),
            ],
            const SizedBox(
              height: 8,
            ),
            SaveButton(myKey: _formKey, ingId: ingId)
          ],
        ),
      ),
    );
  }
}
