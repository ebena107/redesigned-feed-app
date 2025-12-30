import 'package:feed_estimator/src/features/add_ingredients/provider/form_controllers.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Field for ingredient creator name (custom ingredient attribution)
Widget createdByField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.createdBy;
  final controller =
      ref.watch(createdByFieldController(data?.value?.toString()));

  return Focus(
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xff87643E),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: const Color(0xff87643E).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xff87643E),
            width: 2,
          ),
        ),
        prefixIcon: const Icon(CupertinoIcons.person_fill),
        prefixIconColor: const Color(0xff87643E),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
  );
}

/// Field for ingredient notes/description (optional)
Widget notesField(WidgetRef ref) {
  final myRef = ref.watch(ingredientProvider);
  final data = myRef.notes;
  final controller = ref.watch(notesFieldController(data?.value?.toString()));

  return Focus(
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xff87643E),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: const Color(0xff87643E).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xff87643E),
            width: 2,
          ),
        ),
        prefixIcon: const Icon(CupertinoIcons.pencil),
        prefixIconColor: const Color(0xff87643E),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 4,
      textInputAction: TextInputAction.newline,
      onFieldSubmitted: (value) =>
          ref.read(ingredientProvider.notifier).setNotes(value),
      onSaved: (value) => ref.read(ingredientProvider.notifier).setNotes(value),
      onTapOutside: (value) =>
          ref.read(ingredientProvider.notifier).setNotes(controller.text),
    ),
  );
}

/// Header card indicating custom ingredient creation with Material Design 3 styling
Widget customIngredientHeader(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xff87643E).withValues(alpha: 0.1),
          const Color(0xff87643E).withValues(alpha: 0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xff87643E).withValues(alpha: 0.2),
        width: 1.5,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff87643E).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.star_fill,
              color: Color(0xff87643E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.customIngredientHeader,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff87643E),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.customIngredientDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff87643E).withValues(alpha: 0.7),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
