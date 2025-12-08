import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/form_controllers.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          ref.read(ingredientProvider.notifier).setCreatedBy(controller.text);
        }
      },
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Created By (Your Name)',
          errorText: data?.error,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(CupertinoIcons.person_fill),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setCreatedBy(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setCreatedBy(value),
        onTapOutside: (value) =>
            ref.read(ingredientProvider.notifier).setCreatedBy(controller.text),
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
          ref.read(ingredientProvider.notifier).setNotes(controller.text);
        }
      },
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText:
              'Notes (Optional - e.g., local source, processing method, seasonal)',
          errorText: data?.error,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(CupertinoIcons.pencil),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        keyboardType: TextInputType.multiline,
        minLines: 2,
        maxLines: 4,
        textInputAction: TextInputAction.newline,
        onFieldSubmitted: (value) =>
            ref.read(ingredientProvider.notifier).setNotes(value),
        onSaved: (value) =>
            ref.read(ingredientProvider.notifier).setNotes(value),
        onTapOutside: (value) =>
            ref.read(ingredientProvider.notifier).setNotes(controller.text),
      ),
    ),
  );
}

/// Header card indicating custom ingredient creation
Widget customIngredientHeader() {
  return Card(
    color: Colors.blue.shade50,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const Icon(CupertinoIcons.star_fill, color: Colors.blue),
          const SizedBox(width: 8),
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

InputDecoration inputDecoration({
  String? hint,
  String? errorText,
  IconData? icon,
}) {
  return InputDecoration(
    hintText: hint,
    errorText: errorText,
    border: const OutlineInputBorder(),
    prefixIcon: icon != null ? Icon(icon) : null,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );
}
