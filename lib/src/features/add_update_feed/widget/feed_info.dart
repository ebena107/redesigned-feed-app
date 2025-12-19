import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/core/utils/widget_builders.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/model/animal_type.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const String _tag = 'FeedInfo';

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
          width: UIConstants.fieldWidth,
          child: FeedNameField(feedId: feedId),
        ),
        const SizedBox(height: UIConstants.paddingMedium),
        SizedBox(
          width: UIConstants.fieldWidth,
          child: AnimalTypeField(feedId: feedId),
        ),
        const SizedBox(height: UIConstants.paddingMedium),
        SizedBox(
          width: UIConstants.fieldWidth,
          child: AddIngredientButton(feedId: feedId),
        ),
      ],
    );
  }
}

class FeedNameField extends ConsumerStatefulWidget {
  final int? feedId;

  const FeedNameField({
    super.key,
    this.feedId,
  });

  @override
  ConsumerState<FeedNameField> createState() => _FeedNameFieldState();
}

class _FeedNameFieldState extends ConsumerState<FeedNameField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final feedName = ref.read(feedProvider).feedName;
    _controller = TextEditingController(text: feedName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndSave(String value) {
    final error = InputValidators.validateName(value);

    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    setState(() => _errorText = null);
    ref.read(feedProvider.notifier).setFeedName(value.trim());
    AppLogger.debug('Feed name updated: ${value.trim()}', tag: _tag);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.feedId != null;

    if (isEdit) {
      // Show read-only display for edit mode
      final feedName = ref.watch(feedProvider).feedName;
      return WidgetBuilders.buildReadOnlyField(
        value: feedName,
        borderColor: AppConstants.appCarrotColor,
        icon: const Icon(
          CupertinoIcons.paw,
          color: AppConstants.appIconGreyColor,
          size: UIConstants.iconMedium,
        ),
      );
    }

    // Editable field for new feed
    return SizedBox(
      height: UIConstants.fieldHeight,
      child: WidgetBuilders.buildTextField(
        label: 'Feed Name',
        hint: 'e.g., Broiler Starter Feed',
        controller: _controller,
        errorText: _errorText,
        inputFormatters: InputValidators.nameFormatters,
        textAlign: TextAlign.center,
        onChanged: (value) {
          // Clear error as user types
          if (_errorText != null) {
            setState(() => _errorText = null);
          }
        },
        onSubmitted: _validateAndSave,
        suffixIcon: const Icon(
          CupertinoIcons.paw,
          color: AppConstants.appIconGreyColor,
          size: UIConstants.iconMedium,
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
    final feedState = ref.watch(feedProvider);
    final animalTypes = feedState.animalTypes;
    final isEdit = feedId != null;

    if (animalTypes.isEmpty) {
      AppLogger.warning('No animal types available', tag: _tag);
      return Container(
        height: UIConstants.fieldHeight,
        padding: UIConstants.paddingAllMedium,
        decoration: UIConstants.cardDecoration(
          borderColor: Colors.redAccent,
        ),
        child: const Center(
          child: Text('No animal types available'),
        ),
      );
    }

    if (isEdit) {
      // Show read-only display for edit mode
      final animalType = animalTypes
          .firstWhere(
            (e) => e.typeId == feedState.newFeed?.animalId,
            orElse: () => AnimalTypes(),
          )
          .type;

      return WidgetBuilders.buildReadOnlyField(
        value: animalType ?? 'Unknown',
        borderColor: AppConstants.appCarrotColor,
        icon: const Icon(
          Icons.pets,
          color: AppConstants.appIconGreyColor,
          size: UIConstants.iconMedium,
        ),
      );
    }

    // Editable dropdown for new feed
    return Container(
      padding: UIConstants.paddingHorizontalMedium,
      height: UIConstants.fieldHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: AppConstants.appBlueColor,
          width: UIConstants.borderWidthThick,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: feedState.animalTypeId as int?,
          isExpanded: true,
          isDense: false,
          hint: const Text('Select Animal Type'),
          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color: AppConstants.appBlueColor,
            size: UIConstants.iconLarge,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          dropdownColor: AppConstants.appBackgroundColor,
          elevation: UIConstants.cardElevation.toInt(),
          items: animalTypes.map((AnimalTypes type) {
            return DropdownMenuItem<int>(
              value: type.typeId as int,
              child: Text(
                type.type ?? 'Unknown',
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) {
              ref.read(feedProvider.notifier).setAnimalId(id);
              ref.read(resultProvider.notifier).estimatedResult(
                    animal: id,
                    ingList: feedState.feedIngredients,
                  );
              AppLogger.debug('Animal type changed to: $id', tag: _tag);
            }
          },
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

  void _navigateToIngredients(BuildContext context, WidgetRef ref) {
    if (feedId != null) {
      ref.read(ingredientProvider.notifier).loadFeedExistingIngredients();
      context.go('/feed/$feedId/feedIngredient');
    } else {
      context.go(
          '/newFeed/ingredientList${feedId != null ? '?feed-id=$feedId' : ''}');
    }
    AppLogger.debug('Navigating to ingredients, feedId: $feedId', tag: _tag);
  }

  @override
  Widget build(BuildContext context, ref) {
    // Only show button for new feeds with no ingredients yet
    if (feedId != null) return const SizedBox.shrink();

    final ingredientCount = ref.watch(ingredientProvider).count;
    if (ingredientCount > 0) return const SizedBox.shrink();

    return WidgetBuilders.buildOutlinedButton(
      label: 'Add Ingredients',
      onPressed: () => _navigateToIngredients(context, ref),
      icon: const Icon(
        CupertinoIcons.add_circled,
        size: UIConstants.iconMedium,
      ),
      width: double.infinity,
    );
  }
}
