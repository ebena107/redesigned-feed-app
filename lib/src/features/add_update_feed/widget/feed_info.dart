import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/model/animal_type.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedInfo extends StatelessWidget {
  final int? feedId;
  const FeedInfo({super.key, this.feedId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 250,
          child: FeedNameField(
            feedId: feedId,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 250,
          child: AnimalTypeField(
            feedId: feedId,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 250,
          child: AddIngredientButton(
            feedId: feedId,
          ),
        ),
      ],
    );
  }
}

class FeedNameField extends ConsumerWidget {
  final int? feedId;

  const FeedNameField({
    super.key,
    this.feedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController? feedNameController;

    final newFeed = ref.watch(feedProvider);
    feedNameController = TextEditingController(text: newFeed.feedName);
    return feedId != null
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              border: Border.all(
                  color: AppConstants.appCarrotColor,
                  style: BorderStyle.solid,
                  width: 0.80),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(newFeed.feedName),
            ),
          )
        : SizedBox(
            height: 40,
            child: Focus(
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  ref
                      .read(feedProvider.notifier)
                      .setFeedName(feedNameController!.text);
                }
              },
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: feedNameController,
                onSubmitted: (name) =>
                    ref.read(feedProvider.notifier).setFeedName(name),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0.8,
                      style: BorderStyle.solid,
                      color: AppConstants.appBlueColor,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: newFeed.feedName != ""
                      ? newFeed.feedName
                      : 'Enter  Feed Name',

                  hintText: 'Enter Feed Name',
                  suffixIcon: const Icon(
                    CupertinoIcons.paw,
                    color: AppConstants.appIconGreyColor,
                  ),
                  // prefixText: 'Feed Name',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}

///Type of Animal Field
///
///
class AnimalTypeField extends ConsumerWidget {
  final int? feedId;
  const AnimalTypeField({
    super.key,
    this.feedId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final newFeed = ref.watch(feedProvider);
    final feed = newFeed.newFeed;
    final animalTypes = newFeed.animalTypes;

    //  List<AnimalTypeModel> animalTypes = data.animalTypes;
    List<DropdownMenuItem<int>> items = [];
    for (var t in animalTypes) {
      items.add(
        DropdownMenuItem(
          value: t.typeId as int,
          child: Text(t.type.toString()),
        ),
      );
    }

    // animalTypes.map((AnimalTypes t) {
    //   return DropdownMenuItem(value: t.typeId, child: Text(t.type.toString()));
    // }).toList();
    String? animalType;

    feedId != null
        ? animalType = animalTypes
            .firstWhere((e) => e.typeId == feed!.animalId,
                orElse: () => AnimalTypes())
            .type
        : animalType = '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        border: Border.all(
            color: feedId != null
                ? AppConstants.appCarrotColor
                : AppConstants.appBlueColor,
            style: BorderStyle.solid,
            width: 0.80),
      ),
      child: feedId != null
          ? Align(
              alignment: Alignment.center,
              child: Text('$animalType'),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                alignment: AlignmentDirectional.center,
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                dropdownColor:
                    AppConstants.appBackgroundColor.withValues(alpha: .8),
                value: newFeed.animalTypeId as int,

                items: animalTypes.map((AnimalTypes t) {
                  return DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: t.typeId as int,
                      child: Text(t.type.toString()));
                }).toList(),
                onChanged: (id) => {
                  ref.read(feedProvider.notifier).setAnimalId(id as int),
                  ref.read(resultProvider.notifier).estimatedResult(
                      animal: ref.watch(feedProvider).animalTypeId,
                      ingList: ref.watch(feedProvider).feedIngredients)
                },

                hint: const Text("Select Animal Type"),
                // disabledHint:Text("Disabled"),
                elevation: 8,
                //style:                     const TextStyle(color: Commons.appHintColor, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down_circle),
                //       iconDisabledColor: Colors.red,
                //      iconEnabledColor: Colors.green,
                isExpanded: true,
                isDense: true,
                //dropdownColor: AppConstants.appBackgroundColor,
              ),
            ),
    );
  }
}

///Add Ingredient Buttons
///
///
//
class AddIngredientButton extends ConsumerWidget {
  final int? feedId;
  const AddIngredientButton({super.key, required this.feedId});

  @override
  Widget build(BuildContext context, ref) {
    return feedId == null
        ? Consumer(builder: (context, ref, child) {
            final count = ref.watch(ingredientProvider).count;
            return count <= 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                      border: Border.all(
                          //     color: Commons.appCarrotColor,
                          style: BorderStyle.solid,
                          width: 0.80),
                      // color: Commons.appCarrotColor,
                    ),
                    child: TextButton(
                      //  style: raisedButtonStyle,
                      onPressed: () {
                        feedId != null
                            ? ref
                                .read(ingredientProvider.notifier)
                                .loadFeedExistingIngredients()
                            : null;
                        feedId != null
                            ? FeedIngredientsRoute(feedId as int).go(context)
                            : NewFeedIngredientsRoute(feedId).go(context);
                        //    const IngredientList(),
                      },
                      child: const Text(
                        "Add Ingredients",
                        textAlign: TextAlign.center,
                        //   style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ))
                : const SizedBox();
          })
        : const SizedBox();
  }
}
