import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/form_controllers.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _tag = 'CustomIngredientFields';

/// Field for ingredient creator name (custom ingredient attribution)
Widget createdByField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.createdBy;
  final controller =
      ref.watch(createdByFieldController(data?.value?.toString()));

  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          final trimmed = controller.text.trim();
          ref.read(ingredientProvider.notifier).setCreatedBy(trimmed);
          AppLogger.debug('CreatedBy field updated: $trimmed', tag: _tag);
        }
      },
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Created By (Your Name) e.g., John Farmer',
          errorText: data?.error,
          border: UIConstants.inputBorder(),
          focusedBorder: UIConstants.focusedBorder(),
          errorBorder: UIConstants.errorBorder,
          enabledBorder: UIConstants.inputBorder(
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            CupertinoIcons.person_fill,
            size: UIConstants.iconMedium,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: UIConstants.paddingHorizontalNormal
              .add(const EdgeInsets.symmetric(vertical: UIConstants.paddingMedium)),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        inputFormatters: InputValidators.alphanumericFormatters(maxLength: 50),
        validator: (value) => InputValidators.validateName(
          value,
          fieldName: 'Creator name',
        ),
        onFieldSubmitted: (value) {
          final trimmed = value.trim();
          ref.read(ingredientProvider.notifier).setCreatedBy(trimmed);
        },
        onSaved: (value) {
          final trimmed = value?.trim() ?? '';
          ref.read(ingredientProvider.notifier).setCreatedBy(trimmed);
        },
        onTapOutside: (_) {
          final trimmed = controller.text.trim();
          ref.read(ingredientProvider.notifier).setCreatedBy(trimmed);
        },
      ),
    ),
  );
}

/// Field for ingredient notes/description (optional)
Widget notesField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.notes;
  final controller = ref.watch(notesFieldController(data?.value?.toString()));

  return Card(
    child: Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          final trimmed = controller.text.trim();
          ref.read(ingredientProvider.notifier).setNotes(trimmed);
          AppLogger.debug('Notes field updated: ${trimmed.length} chars', tag: _tag);
        }
      },
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText:
              'Notes (Optional - e.g., local source, processing method, seasonal)',
          errorText: data?.error,
          border: UIConstants.inputBorder(),
          focusedBorder: UIConstants.focusedBorder(),
          enabledBorder: UIConstants.inputBorder(
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            CupertinoIcons.pencil,
            size: UIConstants.iconMedium,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: UIConstants.paddingAllNormal,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 2,
        maxLines: 4,
        maxLength: 200,
        textInputAction: TextInputAction.newline,
        onFieldSubmitted: (value) {
          final trimmed = value.trim();
          ref.read(ingredientProvider.notifier).setNotes(trimmed);
        },
        onSaved: (value) {
          final trimmed = value?.trim() ?? '';
          ref.read(ingredientProvider.notifier).setNotes(trimmed);
        },
        onTapOutside: (_) {
          final trimmed = controller.text.trim();
          ref.read(ingredientProvider.notifier).setNotes(trimmed);
        },
      ),
    ),
  );
}

/// Header card indicating custom ingredient creation
Widget customIngredientHeader() {
  return Card(
    color: Colors.blue.shade50,
    elevation: UIConstants.cardElevation,
    child: Padding(
      padding: UIConstants.paddingAllMedium,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.star_fill,
            color: Colors.blue,
            size: UIConstants.iconLarge,
          ),
          const SizedBox(width: UIConstants.paddingSmall),
          Expanded(
            child: Text(
              'Creating Custom Ingredient',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Removed - using inputDecoration from form_widgets.dart
