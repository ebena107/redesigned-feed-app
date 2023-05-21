import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredient_save_controller.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/widgets/save_ingredient_dialog.dart';
import 'package:feed_estimator/src/utils/widgets/message_handler.dart';
import 'package:feed_estimator/src/utils/widgets/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Widget nameField(WidgetRef ref, int? ingId) {
  final data = ref.watch(ingredientProvider).name;
  TextEditingController nameController =
      TextEditingController(text: data!.value);
  return Card(
      child: ingId == null
          ? Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  ref
                      .read(ingredientProvider.notifier)
                      .setName(nameController.text);
                }
              },
              child: TextFormField(
                controller: nameController,
                // initialValue: data.name!.value,
                decoration: inputDecoration(
                    hint: 'Ingredient Name',
                    errorText: data.error,
                    icon: CupertinoIcons.paw),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) =>
                    ref.read(ingredientProvider.notifier).setName(value),
                //onEditingComplete: () => ref.read(ingredientProvider.notifier).setName(myController!.value.text),
                onSaved: (value) =>
                    ref.read(ingredientProvider.notifier).setName(value!),

                onTapOutside: (value) => ref
                    .read(ingredientProvider.notifier)
                    .setName(nameController.value.text),
              ),
            )
          : SizedBox(
              height: 30, child: Center(child: Text(data.value as String))));
}

class NameField extends ConsumerWidget {
  const NameField({
    Key? key,
  }) : super(key: key);

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

Widget categoryField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider);
  final int? ingCat;

  if (data.categoryId!.value != null) {
    ingCat = int.tryParse(data.categoryId!.value as String);
  } else {
    ingCat = null;
  }

  final categories = data.categoryList;
  return Card(
    child: ingCat == null
        ? DropdownButtonFormField(
            dropdownColor: AppConstants.appBackgroundColor.withOpacity(.8),
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

Widget proteinField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).crudeProtein;
  TextEditingController proteinController =
      TextEditingController(text: data!.value);
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref
              .read(ingredientProvider.notifier)
              .setProtein(proteinController.text);
        }
      },
      child: TextFormField(
        controller: proteinController,
        decoration: inputDecoration(
            hint: 'Protein (CP)',
            errorText: data.error,
            icon: CupertinoIcons.square_favorites),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setProtein(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setProtein(value),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setProtein(proteinController.value.text),
      ),
    ),
  );
}

Widget fatField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).crudeFat;
  TextEditingController fatController =
      TextEditingController(text: data!.value);
  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          ref.read(ingredientProvider.notifier).setFat(fatController.text);
        }
      },
      child: TextFormField(
        controller: fatController,
        decoration: inputDecoration(
            hint: 'Fat',
            errorText: data.error,
            icon: CupertinoIcons.square_favorites),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setFat(value),
        onSaved: (value) => ref.read(ingredientProvider.notifier).setFat(value),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setFat(fatController.value.text),
      ),
    ),
  );
}

Widget fibreField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).crudeFiber;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Fiber',
            errorText: data.error,
            icon: CupertinoIcons.square_favorites),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setFiber(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setFiber(value),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setFiber(myController.value.text),
      ),
    ),
  );
}

Widget energyField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).meAdultPig;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'M.Energy',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setAllEnergy(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setAllEnergy(value),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setAllEnergy(myController.value.text),
      ),
    ),
  );
}

Widget energyAdultPigField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).meAdultPig;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Adult Pig (ME)',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyAdultPig(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyAdultPig(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setEnergyAdultPig(myController.value.text),
      ),
    ),
  );
}

Widget energyGrowingPigField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).meGrowingPig;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Growing Pig (ME)',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyGrowPig(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyGrowPig(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setEnergyGrowPig(myController.value.text),
      ),
    ),
  );
}

Widget energyRabbitField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).meRabbit;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Rabbit (ME)',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRabbit(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRabbit(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setEnergyRabbit(myController.value.text),
      ),
    ),
  );
}

Widget energyRuminantField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).meRuminant;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Ruminants (ME)',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRuminant(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyRuminant(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setEnergyRuminant(myController.value.text),
      ),
    ),
  );
}

Widget energyPoultryField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).mePoultry;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Poultry (ME)',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyPoultry(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyPoultry(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setEnergyPoultry(myController.value.text),
      ),
    ),
  );
}

Widget energyFishField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).deSalmonids;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Salmonids/Fish (DE)',
            errorText: data.error,
            icon: CupertinoIcons.flame),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyFish(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setEnergyFish(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setEnergyFish(myController.value.text),
      ),
    ),
  );
}

Widget lyzineField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).lysine;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Lyzine',
            errorText: data.error,
            icon: Icons.food_bank_outlined),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setLyzine(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setLyzine(value),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setLyzine(myController.value.text),
      ),
    ),
  );
}

Widget methionineField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).methionine;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Methionine',
            errorText: data.error,
            icon: Icons.food_bank_outlined),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setMeth(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setMeth(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setMeth(myController.value.text),
      ),
    ),
  );
}

Widget phosphorusField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).phosphorus;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Phosphorus',
            errorText: data.error,
            icon: Icons.food_bank_outlined),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setPhosphorous(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setPhosphorous(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setPhosphorous(myController.value.text),
      ),
    ),
  );
}

Widget calciumField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).calcium;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Calcium',
            errorText: data.error,
            icon: Icons.food_bank_outlined),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setCalcium(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setCalcium(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setCalcium(myController.value.text),
      ),
    ),
  );
}

Widget priceField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).priceKg;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Price/Unit',
            errorText: data.error,
            icon: CupertinoIcons.money_dollar_circle),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setPrice(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setPrice(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setPrice(myController.value.text),
      ),
    ),
  );
}

Widget availableQuantityField(WidgetRef ref) {
  final data = ref.watch(ingredientProvider).availableQty;
  TextEditingController myController = TextEditingController(text: data!.value);
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
            hint: 'Available Quantity',
            errorText: data.error,
            icon: Icons.food_bank_outlined),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setAvailableQuantity(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setAvailableQuantity(value!),
        onTapOutside: (value) => ref
            .read(ingredientProvider.notifier)
            .setAvailableQuantity(myController.value.text),
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

class SaveButton extends ConsumerWidget {
  final GlobalKey<FormState>? myKey;
  final int? ingId;
  const SaveButton({
    this.myKey,
    this.ingId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);

    return SizedBox(
      width: displayWidth(context) / 2,
      child: ElevatedButton.icon(
          onPressed: () {
            if (myKey!.currentState!.validate()) {
              //  ref.read(ingredientProvider.notifier).validate()
              // if (data.validate) {
              ref
                  .read(ingredientSaveControllerProvider.notifier)
                  .saveUpdateIngredient(ingId);

              if (data.status == "success") {
                messageHandlerWidget(
                    context: context, message: data.message, type: data.status);
                myKey!.currentState!.reset();
                context.pop();
                saveDialogBuilder(context, ingId);
              } else {
                messageHandlerWidget(
                    context: context, message: data.message, type: data.status);
              }
            } else {
              messageHandlerWidget(
                  context: context,
                  message: "Enter Correct Info",
                  type: "failure");
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
                  backgroundColor: AppConstants.appCarrotColor)),
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
