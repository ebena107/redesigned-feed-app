import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/form_controllers.dart';

import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/utils/widgets/message_handler.dart';
import 'package:feed_estimator/src/utils/widgets/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

Widget nameField(WidgetRef ref, int? ingId, BuildContext context) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.name;
  final nameController = ref.watch(nameFieldController(data!.value));

  return ingId == null
      ? _FormTextField(
          controller: nameController,
          decoration: inputDecoration(
            hint: 'Ingredient Name',
            errorText: data.error,
            icon: CupertinoIcons.paw,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) =>
              ref.read(ingredientProvider.notifier).setName(value),
          onSaved: (value) =>
              ref.read(ingredientProvider.notifier).setName(value!),
          onFocusOut: (value) =>
              ref.read(ingredientProvider.notifier).setName(value),
          context: context,
        )
      : Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            data.value as String,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
}

Widget categoryField(
  WidgetRef ref,
  int? ingId,
) {
  final data = ref.watch(ingredientProvider);
  final int? ingCat;

  if (data.categoryId!.value != null) {
    ingCat = int.tryParse(data.categoryId!.value as String);
  } else {
    ingCat = null;
  }

  final categories = data.categoryList;
  return ingId == null
      ? DropdownButtonFormField(
          dropdownColor: AppConstants.appBackgroundColor.withValues(alpha: .8),
          items: categories.map((IngredientCategory cat) {
            return DropdownMenuItem<num>(
              value: cat.categoryId,
              child: Text(
                cat.category.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          isExpanded: true,
          onChanged: (value) => ref
              .read(ingredientProvider.notifier)
              .setCategory(value.toString()),
          decoration: inputDecoration(
            hint: 'Category',
            errorText: data.categoryId!.error,
            icon: Icons.group_outlined,
          ),
          focusColor: AppConstants.appCarrotColor,
        )
      : Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            categories
                .firstWhere((cat) => cat.categoryId == ingCat)
                .category
                .toString(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
}

Widget proteinField(WidgetRef ref, context) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeProtein;
  final proteinController = ref.watch(proteinFieldController(data!.value));

  return _FormTextField(
    controller: proteinController,
    decoration: inputDecoration(
      hint: 'Protein (CP)',
      errorText: data.error,
      icon: CupertinoIcons.square_favorites,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setProtein(value),
    onSaved: (value) => ref.read(ingredientProvider.notifier).setProtein(value),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setProtein(value),
    context: context,
  );
}

Widget fatField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeFat;
  final myController = ref.watch(fatFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Fat',
      errorText: data.error,
      icon: CupertinoIcons.square_favorites,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setFat(value),
    onSaved: (value) => ref.read(ingredientProvider.notifier).setFat(value),
    onFocusOut: (value) => ref.read(ingredientProvider.notifier).setFat(value),
    context: null,
  );
}

Widget fibreField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeFiber;
  final myController = ref.watch(fiberFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Fiber',
      errorText: data.error,
      icon: CupertinoIcons.square_favorites,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setFiber(value),
    onSaved: (value) => ref.read(ingredientProvider.notifier).setFiber(value),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setFiber(value),
    context: null,
  );
}

Widget energyField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meAdultPig;
  final myController = ref.watch(energyFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'M.Energy',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setAllEnergy(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setAllEnergy(value),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setAllEnergy(value),
    context: null,
  );
}

Widget energyAdultPigField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meAdultPig;
  final myController = ref.watch(adultPigFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Adult Pig (ME)',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyAdultPig(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyAdultPig(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyAdultPig(value),
    context: null,
  );
}

Widget energyGrowingPigField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meGrowingPig;
  final myController = ref.watch(growPigFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Growing Pig (ME)',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyGrowPig(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyGrowPig(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyGrowPig(value),
    context: null,
  );
}

Widget energyRabbitField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meRabbit;
  final myController = ref.watch(rabbitFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Rabbit (ME)',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyRabbit(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyRabbit(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyRabbit(value),
    context: null,
  );
}

Widget energyRuminantField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meRuminant;
  final myController = ref.watch(ruminantFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Ruminants (ME)',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyRuminant(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyRuminant(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyRuminant(value),
    context: null,
  );
}

Widget energyPoultryField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.mePoultry;
  final myController = ref.watch(poultryFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Poultry (ME)',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyPoultry(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyPoultry(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyPoultry(value),
    context: null,
  );
}

Widget energyFishField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.deSalmonids;
  final myController = ref.watch(fishFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Salmonids/Fish (DE)',
      errorText: data.error,
      icon: CupertinoIcons.flame,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyFish(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyFish(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setEnergyFish(value),
    context: null,
  );
}

Widget lyzineField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.lysine;
  final myController = ref.watch(lyzineFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Lyzine',
      errorText: data.error,
      icon: Icons.food_bank_outlined,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setLyzine(value),
    onSaved: (value) => ref.read(ingredientProvider.notifier).setLyzine(value),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setLyzine(value),
    context: null,
  );
}

Widget methionineField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.methionine;
  final myController = ref.watch(methionineFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Methionine',
      errorText: data.error,
      icon: Icons.food_bank_outlined,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setMeth(value),
    onSaved: (value) => ref.read(ingredientProvider.notifier).setMeth(value!),
    onFocusOut: (value) => ref.read(ingredientProvider.notifier).setMeth(value),
    context: null,
  );
}

Widget phosphorusField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.phosphorus;
  final myController = ref.watch(phosphorousFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Phosphorus',
      errorText: data.error,
      icon: Icons.food_bank_outlined,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setPhosphorous(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setPhosphorous(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setPhosphorous(value),
    context: null,
  );
}

Widget calciumField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.calcium;
  final myController = ref.watch(calciumFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Calcium',
      errorText: data.error,
      icon: Icons.food_bank_outlined,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setCalcium(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setCalcium(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setCalcium(value),
    context: null,
  );
}

Widget priceField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.priceKg;
  final myController = ref.watch(priceFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Price/Unit',
      errorText: data.error,
      icon: CupertinoIcons.money_dollar_circle,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setPrice(value),
    onSaved: (value) => ref.read(ingredientProvider.notifier).setPrice(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setPrice(value),
    context: null,
  );
}

Widget availableQuantityField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.availableQty;
  final myController = ref.watch(quantityFieldController(data!.value));

  return _FormTextField(
    controller: myController,
    decoration: inputDecoration(
      hint: 'Available Quantity',
      errorText: data.error,
      icon: Icons.food_bank_outlined,
    ),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) =>
        ref.read(ingredientProvider.notifier).setAvailableQuantity(value),
    onSaved: (value) =>
        ref.read(ingredientProvider.notifier).setAvailableQuantity(value!),
    onFocusOut: (value) =>
        ref.read(ingredientProvider.notifier).setAvailableQuantity(value),
    context: null,
  );
}

class SaveButton extends ConsumerWidget {
  final GlobalKey<FormState>? myKey;
  final int? ingId;
  const SaveButton({
    this.myKey,
    this.ingId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);

    return SizedBox(
      width: displayWidth(context),
      child: ElevatedButton.icon(
        onPressed: () async {
          ref.read(ingredientProvider.notifier).validate();
          if (data.validate && myKey!.currentState!.validate()) {
            if (ingId != null) {
              ref.read(ingredientProvider.notifier).updateIngredient(
                    ingId,
                    onSuccess: () {
                      context.go('/');
                      showAlert(context, QuickAlertType.success,
                          'Ingredient Updated Successfully');
                    },
                    onFailure: () => showAlert(
                        context, QuickAlertType.error, 'Failed to save'),
                  );
            } else {
              ref.read(ingredientProvider.notifier).createIngredient();
              await ref.read(ingredientProvider.notifier).saveIngredient(
                    onSuccess: () {
                      context.go('/');
                      showAlert(context, QuickAlertType.success,
                          'Ingredient Created Successfully');
                    },
                    onFailure: () => showAlert(
                        context, QuickAlertType.error, 'Failed to save'),
                  );
            }
          } else {
            messageHandlerWidget(
              context: context,
              message: "Enter Correct Info",
              type: "failure",
            );
          }
        },
        icon: ingId == null
            ? const Icon(CupertinoIcons.floppy_disk)
            : const Icon(Icons.update),
        label: Text(ingId == null ? 'Save' : 'Update'),
        style: ingId == null
            ? ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appBlueColor)
            : ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appCarrotColor),
      ),
    );
  }
}

void showAlert(context, QuickAlertType type, String message) {
  QuickAlert.show(
    context: context,
    type: type,
    text: message,
    autoCloseDuration: const Duration(seconds: 2),
  );
}

/// Consolidated text form field widget with modern styling
class _FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final Function(String?) onSaved;
  final Function(String) onFocusOut;
  final BuildContext? context;

  const _FormTextField({
    required this.controller,
    required this.decoration,
    required this.keyboardType,
    required this.textInputAction,
    required this.onFieldSubmitted,
    required this.onSaved,
    required this.onFocusOut,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          onFocusOut(controller.text);
        }
      },
      child: TextFormField(
        controller: controller,
        decoration: decoration,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        onTapOutside: (event) => onFocusOut(controller.text),
        onEditingComplete: () {
          if (this.context != null) {
            FocusScope.of(this.context!).nextFocus();
          }
        },
      ),
    );
  }
}
