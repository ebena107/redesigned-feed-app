import 'package:feed_estimator/src/core/constants/common.dart';
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

Widget nameField(WidgetRef ref, int? ingId, BuildContext context) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.name;
  final nameController = ref.watch(nameFieldController(data!.value));

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
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
            )
          : SizedBox(
              height: 30, child: Center(child: Text(data.value as String))));
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

Widget proteinField(WidgetRef ref, context) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.crudeProtein;
  final proteinController = ref.watch(proteinFieldController(data!.value));
  // TextEditingController proteinController =
  //     TextEditingController(text: data!.value);
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
            .setFat(myController.value.text),
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
           //  debugPrint('form === ${myKey!.currentState!.validate().toString()}');
            if (data.validate && myKey!.currentState!.validate()) {
              ingId != null
                  ? ref.read(ingredientProvider.notifier).updateIngredient(
                      ingId,
                      onSuccess: () {
                        context.pop();
                        showAlert(context, QuickAlertType.success,
                            'Ingredient Updated Successfully');
                      },
                      onFailure: () => showAlert(
                          context, QuickAlertType.error, 'Failed to save'))
                  : {
                      ref.read(ingredientProvider.notifier).createIngredient(),
                      await ref
                          .read(ingredientProvider.notifier)
                          .saveIngredient(
                              onSuccess: () {
                                context.pop();
                                showAlert(context, QuickAlertType.success,
                                    'Ingredient Created Successfully');
                              },
                              onFailure: () => showAlert(context,
                                  QuickAlertType.error, 'Failed to save'))
                    };


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

showAlert(context, QuickAlertType type, String message) {
  QuickAlert.show(
    context: context,
    type: type,
    text: message,
    autoCloseDuration: const Duration(seconds: 2),
  );
}
