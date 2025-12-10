import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/form_controllers.dart';

import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/widgets/save_ingredient_dialog.dart';
import 'package:feed_estimator/src/utils/widgets/message_handler.dart';
import 'package:feed_estimator/src/utils/widgets/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

const String _tag = 'FormWidgets';

Widget nameField(WidgetRef ref, int? ingId, BuildContext context) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.name;
  final nameController = ref.watch(nameFieldController(data!.value));

  return Card(
    child: ingId == null
        ? Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                final trimmed = nameController.text.trim();
                ref.read(ingredientProvider.notifier).setName(trimmed);
                AppLogger.debug('Name field updated: $trimmed', tag: _tag);
              }
            },
            child: TextFormField(
              controller: nameController,
              decoration: inputDecoration(
                hint: 'Ingredient Name (e.g., Soybean Meal)',
                errorText: data.error,
                icon: CupertinoIcons.tag,
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              inputFormatters: InputValidators.nameFormatters,
              validator: (value) => InputValidators.validateName(
                value,
                fieldName: 'Ingredient name',
              ),
              onFieldSubmitted: (value) {
                final trimmed = value.trim();
                ref.read(ingredientProvider.notifier).setName(trimmed);
              },
              onSaved: (value) {
                final trimmed = value?.trim() ?? '';
                ref.read(ingredientProvider.notifier).setName(trimmed);
              },
              onTapOutside: (_) {
                final trimmed = nameController.text.trim();
                ref.read(ingredientProvider.notifier).setName(trimmed);
              },
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
          )
        : Container(
            height: UIConstants.fieldHeight,
            padding: UIConstants.paddingHorizontalNormal,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
  );
}

class NameField extends ConsumerWidget {
  const NameField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final TextEditingController? myController;
    myController = TextEditingController(text: data.name!.value);
    return Card(
      child: TextFormField(
        controller: myController,
        initialValue: data.name!.value,
        decoration: inputDecoration(
            hint: 'Ingredient Name',
            errorText: data.name!.value,
            icon: CupertinoIcons.paw),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setName(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setName(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setName(myController!.value.text),
        // onTapOutside: () => {} ,
        //ref.read(ingredientProvider.notifier).setName(TextEditingController().value as String?),
      ),
    );
  }
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
  return Card(
    child: ingId == null
        ? DropdownButtonFormField(
            dropdownColor:
                AppConstants.appBackgroundColor.withValues(alpha: .8),
            items: categories.map((IngredientCategory cat) {
              return DropdownMenuItem<num>(
                value: cat.categoryId,
                child: Text(cat.category.toString()),
              );
            }).toList(),
            onChanged: (value) => ref
                .read(ingredientProvider.notifier)
                .setCategory(value.toString()),
            decoration: inputDecoration(
                hint: 'Category',
                errorText: data.categoryId!.error,
                icon: Icons.group_outlined),
            focusColor: AppConstants.appCarrotColor,
          )
        : SizedBox(
            height: 30,
            child: Center(
              child: Text(categories
                  .firstWhere((cat) => cat.categoryId == ingCat)
                  .category
                  .toString()),
            ),
          ),
  );
}

Widget proteinField(WidgetRef ref, context) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeProtein;
  final proteinController = ref.watch(proteinFieldController(data!.value));
  
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setProtein(proteinController.text);
        }
      },
      child: TextFormField(
        controller: proteinController,
        decoration: inputDecoration(
          hint: 'Crude Protein (%) e.g., 45.0',
          errorText: data.error,
          icon: Icons.science_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setProtein(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setProtein(value),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setProtein(proteinController.text),
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
      ),
    ),
  );
}

Widget fatField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeFat;
  final myController = ref.watch(fatFieldController(data!.value));

  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setFat(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Crude Fat (%) e.g., 3.5',
          errorText: data.error,
          icon: Icons.water_drop_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setFat(value),
        onSaved: (value) => ref.read(ingredientProvider.notifier).setFat(value),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setFat(myController.text),
      ),
    ),
  );
}

Widget fibreField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeFiber;
  final myController = ref.watch(fiberFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setFiber(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Crude Fiber (%) e.g., 7.0',
          errorText: data.error,
          icon: Icons.grass_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setFiber(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setFiber(value),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setFiber(myController.text),
      ),
    ),
  );
}

Widget energyField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meAdultPig;
  final myController = ref.watch(energyFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setAllEnergy(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Metabolizable Energy (MJ/kg) e.g., 13.5',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setAllEnergy(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setAllEnergy(value),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setAllEnergy(myController.text),
      ),
    ),
  );
}

Widget energyAdultPigField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meAdultPig;
  final myController = ref.watch(adultPigFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setEnergyAdultPig(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Adult Pig ME (MJ/kg) e.g., 13.5',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyAdultPig(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyAdultPig(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setEnergyAdultPig(myController.text),
      ),
    ),
  );
}

Widget energyGrowingPigField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meGrowingPig;
  final myController = ref.watch(growPigFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setEnergyGrowPig(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Growing Pig ME (MJ/kg) e.g., 14.2',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyGrowPig(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyGrowPig(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setEnergyGrowPig(myController.text),
      ),
    ),
  );
}

Widget energyRabbitField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meRabbit;
  final myController = ref.watch(rabbitFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setEnergyRabbit(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Rabbit ME (MJ/kg) e.g., 11.0',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRabbit(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRabbit(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setEnergyRabbit(myController.text),
      ),
    ),
  );
}

Widget energyRuminantField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.meRuminant;
  final myController = ref.watch(ruminantFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setEnergyRuminant(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Ruminant ME (MJ/kg) e.g., 12.5',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRuminant(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRuminant(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setEnergyRuminant(myController.text),
      ),
    ),
  );
}

Widget energyPoultryField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.mePoultry;
  final myController = ref.watch(poultryFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setEnergyPoultry(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Poultry ME (MJ/kg) e.g., 12.8',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyPoultry(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyPoultry(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setEnergyPoultry(myController.text),
      ),
    ),
  );
}

Widget energyFishField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.deSalmonids;
  final myController = ref.watch(fishFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setEnergyFish(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Fish/Salmonids DE (MJ/kg) e.g., 16.5',
          errorText: data.error,
          icon: CupertinoIcons.flame,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateNumeric(
          value,
          min: 0,
          max: 30,
          fieldName: 'Energy',
        ),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyFish(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyFish(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setEnergyFish(myController.text),
      ),
    ),
  );
}

Widget lyzineField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.lysine;
  final myController = ref.watch(lyzineFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setLyzine(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Lysine (%) e.g., 2.8',
          errorText: data.error,
          icon: Icons.biotech_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setLyzine(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setLyzine(value),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setLyzine(myController.text),
      ),
    ),
  );
}

Widget methionineField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.methionine;
  final myController = ref.watch(methionineFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setMeth(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Methionine (%) e.g., 0.65',
          errorText: data.error,
          icon: Icons.biotech_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setMeth(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setMeth(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setMeth(myController.text),
      ),
    ),
  );
}

Widget phosphorusField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.phosphorus;
  final myController = ref.watch(phosphorousFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setPhosphorous(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Phosphorus (%) e.g., 0.65',
          errorText: data.error,
          icon: Icons.science_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setPhosphorous(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setPhosphorous(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setPhosphorous(myController.text),
      ),
    ),
  );
}

Widget calciumField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.calcium;
  final myController = ref.watch(calciumFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setCalcium(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Calcium (%) e.g., 3.8',
          errorText: data.error,
          icon: Icons.science_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePercentage(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setCalcium(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setCalcium(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setCalcium(myController.text),
      ),
    ),
  );
}

Widget priceField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.priceKg;
  final myController = ref.watch(priceFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setPrice(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Price per kg (e.g., 150.00)',
          errorText: data.error,
          icon: CupertinoIcons.money_dollar_circle,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validatePrice(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setPrice(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setPrice(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setPrice(myController.text),
      ),
    ),
  );
}

Widget availableQuantityField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.availableQty;
  final myController = ref.watch(quantityFieldController(data!.value));
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setAvailableQuantity(myController.text);
        }
      },
      child: TextFormField(
        controller: myController,
        decoration: inputDecoration(
          hint: 'Available Quantity (kg) e.g., 1000',
          errorText: data.error,
          icon: Icons.inventory_2_outlined,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.numericFormatters,
        validator: (value) => InputValidators.validateQuantity(value),
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setAvailableQuantity(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setAvailableQuantity(value!),
        onTapOutside: (_) => ref
            .read(ingredientProvider.notifier)
            .setAvailableQuantity(myController.text),
      ),
    ),
  );
}

// Widget saveButton(
//     {required BuildContext context,
//     required GlobalKey<FormState> myKey,
//     required WidgetRef ref}) {
//   final data = ref.watch(ingredientProvider);
//   return SizedBox(
//     width: displayWidth(context) / 2,
//     child: ElevatedButton.icon(
//       onPressed: () {
//         myKey.currentState!.validate();
//         if (data.validate) {
//           ref.read(ingredientProvider.notifier).saveUpdateIngredient();
//         }
//         myKey.currentState!.reset();
//       },
//       icon: const Icon(CupertinoIcons.floppy_disk),
//       label: const Text('Save '),
//     ),
//   );
// }

class SaveButton extends ConsumerStatefulWidget {
  final GlobalKey<FormState>? myKey;
  final int? ingId;
  const SaveButton({
    this.myKey,
    this.ingId,
    super.key,
  });

  @override
  ConsumerState<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<SaveButton> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (_isSaving) return;

    try {
      setState(() => _isSaving = true);
      
      ref.read(ingredientProvider.notifier).validate();
      final data = ref.read(ingredientProvider);
      
      if (!data.validate || !(widget.myKey?.currentState?.validate() ?? false)) {
        AppLogger.warning('Form validation failed', tag: _tag);
        if (mounted) {
          messageHandlerWidget(
            context: context,
            message: "Please enter valid information",
            type: "failure",
          );
        }
        return;
      }

      if (widget.ingId != null) {
        AppLogger.info('Updating ingredient ID: ${widget.ingId}', tag: _tag);
        await ref.read(ingredientProvider.notifier).updateIngredient(
          widget.ingId,
          onSuccess: () {
            AppLogger.info('Ingredient updated successfully', tag: _tag);
            if (mounted) {
              context.go('/');
              showAlert(
                context,
                QuickAlertType.success,
                'Ingredient Updated Successfully',
              );
            }
          },
          onFailure: () {
            AppLogger.error('Failed to update ingredient', tag: _tag);
            if (mounted) {
              showAlert(context, QuickAlertType.error, 'Failed to update ingredient');
            }
          },
        );
      } else {
        AppLogger.info('Creating new ingredient', tag: _tag);
        ref.read(ingredientProvider.notifier).createIngredient();
        await ref.read(ingredientProvider.notifier).saveIngredient(
          onSuccess: () {
            AppLogger.info('Ingredient created successfully', tag: _tag);
            if (mounted) {
              context.go('/');
              showAlert(
                context,
                QuickAlertType.success,
                'Ingredient Created Successfully',
              );
            }
          },
          onFailure: () {
            AppLogger.error('Failed to save ingredient', tag: _tag);
            if (mounted) {
              showAlert(context, QuickAlertType.error, 'Failed to save ingredient');
            }
          },
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error saving ingredient: $e', tag: _tag, error: e, stackTrace: stackTrace);
      if (mounted) {
        showAlert(context, QuickAlertType.error, 'An error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: displayWidth(context),
      height: UIConstants.fieldHeight,
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _handleSave,
        icon: _isSaving
            ? const SizedBox(
                width: UIConstants.iconMedium,
                height: UIConstants.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                widget.ingId == null
                    ? CupertinoIcons.floppy_disk
                    : Icons.update,
                size: UIConstants.iconMedium,
              ),
        label: Text(
          _isSaving
              ? (widget.ingId == null ? 'Saving...' : 'Updating...')
              : (widget.ingId == null ? 'Save Ingredient' : 'Update Ingredient'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.ingId == null
              ? AppConstants.appBlueColor
              : AppConstants.appCarrotColor,
          foregroundColor: Colors.white,
          elevation: UIConstants.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
        ),
      ),
    );
  }
}

Route<Object?> saveDialogBuilder(
  BuildContext context,
  Object? arguments,
) {
  return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const SaveIngredientDialog());
}
//
// Widget _saveButton(IngredientProvider data, key, BuildContext context) {
//   return SizedBox(
//     width: displayWidth(context) / 2,
//     child: ElevatedButton.icon(
//       onPressed: () {
//         key.currentState.validate();
//         if (data.validate) data.saveIngredient();
//         key.currentState.reset();
//       },
//       icon: const Icon(CupertinoIcons.floppy_disk),
//       label: const Text('Save '),
//     ),
//   );
// }

showAlert(context, QuickAlertType type, String message) {
  QuickAlert.show(
    context: context,
    type: type,
    text: message,
    autoCloseDuration: const Duration(seconds: 2),
  );
}

/// Standard input decoration for ingredient form fields
InputDecoration inputDecoration({
  String? hint,
  String? errorText,
  IconData? icon,
  bool filled = true,
}) {
  return InputDecoration(
    hintText: hint,
    errorText: errorText,
    border: UIConstants.inputBorder(),
    focusedBorder: UIConstants.focusedBorder(),
    errorBorder: UIConstants.errorBorder,
    enabledBorder: UIConstants.inputBorder(
      color: AppConstants.appIconGreyColor.withValues(alpha: 0.5),
    ),
    prefixIcon: icon != null ? Icon(icon, size: UIConstants.iconMedium) : null,
    filled: filled,
    fillColor: filled ? Colors.white : null,
    contentPadding: UIConstants.paddingHorizontalNormal
        .add(const EdgeInsets.symmetric(vertical: UIConstants.paddingMedium)),
  );
}
