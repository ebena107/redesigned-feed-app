import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/widgets/user_ingredients_widget.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/async_stored_ingredient.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';
import 'package:feed_estimator/src/features/store_ingredients/widget/ingredient_select_widget.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

class StoredIngredients extends ConsumerWidget {
  const StoredIngredients({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(storeIngredientProvider);
    final ingredient = data.selectedIngredient;
    final hasIngredient = ingredient != null && ingredient != Ingredient();

    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar with cleaner design
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xff87643E),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            pinned: true,
            expandedHeight: 140,
            backgroundColor: const Color(0xff87643E),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: const Text(
                'Ingredient Library',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff87643E),
                      Color(0xff6B4F31),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  // Search and filter section
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Ingredients',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff87643E),
                                  ),
                        ),
                        const SizedBox(height: 12),
                        const IngredientSSelectWidget(),
                      ],
                    ),
                  ),

                  // Form and Actions (shown only if ingredient selected)
                  if (hasIngredient) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const StoredIngredientForm(),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _ActionButtonsRow(),
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(48),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.archivebox,
                            size: 64,
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select an ingredient to manage',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xff87643E)
                                          .withValues(alpha: 0.6),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),

          // Divider
          SliverToBoxAdapter(
            child: Container(
              height: 8,
              color: Colors.grey[50],
            ),
          ),

          // User Ingredients List Section
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.science,
                          color: Color(0xff87643E),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Custom Ingredients Library',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff87643E),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: UserIngredientsWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoredIngredientForm extends ConsumerWidget {
  const StoredIngredientForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(storeIngredientProvider);
    final ingredient = data.selectedIngredient;

    if (ingredient == null || ingredient == Ingredient()) {
      return const SizedBox.shrink();
    }

    final priceController = TextEditingController(
      text: ingredient.priceKg == null ? "" : ingredient.priceKg.toString(),
    );
    final quantityController = TextEditingController(
      text: ingredient.availableQty == null
          ? ""
          : ingredient.availableQty.toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'Update Inventory',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xff87643E),
              ),
        ),
        const SizedBox(height: 12),

        // Divider
        Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff87643E).withValues(alpha: 0.3),
                const Color(0xff87643E).withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Price and Quantity Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price per Unit',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xff87643E).withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 8),
                  _StoredIngredientTextField(
                    controller: priceController,
                    hint: 'Price/Unit',
                    icon: CupertinoIcons.money_dollar_circle,
                    onChanged: (value) => ref
                        .read(storeIngredientProvider.notifier)
                        .setPrice(value),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Quantity',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xff87643E).withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 8),
                  _StoredIngredientTextField(
                    controller: quantityController,
                    hint: 'Available Qty',
                    icon: Icons.inventory_2_outlined,
                    onChanged: (value) => ref
                        .read(storeIngredientProvider.notifier)
                        .setAvailableQuantity(value),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Favorite Toggle
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff87643E).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xff87643E).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xff87643E).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  ingredient.favourite == 1
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: const Color(0xff87643E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Favorite Ingredient',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      'Mark this ingredient as frequently used',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: ingredient.favourite == 1,
                onChanged: (value) => ref
                    .read(storeIngredientProvider.notifier)
                    .setFavourite(value),
                fillColor: WidgetStateColor.resolveWith(
                  (states) => const Color(0xff87643E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Reusable text field for stored ingredient form
class _StoredIngredientTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Function(String) onChanged;

  const _StoredIngredientTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          onChanged(controller.text);
        }
      },
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          prefixIconColor: const Color(0xff87643E),
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
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: onChanged,
        onTapOutside: (event) => onChanged(controller.text),
      ),
    );
  }
}

/// Action buttons row for Save and Delete
class _ActionButtonsRow extends ConsumerWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredient = ref.watch(storeIngredientProvider).selectedIngredient;

    return Row(
      children: [
        // Save Changes Button (consolidated Save + Update)
        Expanded(
          flex: 3,
          child: FilledButton.icon(
            onPressed: () async {
              // Save or update based on whether ingredient exists
              await ref
                  .read(asyncStoredIngredientsProvider.notifier)
                  .saveIngredient(
                onSuccess: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Ingredient saved successfully!',
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                },
              );

              // Also update the current ingredient
              ref.read(storeIngredientProvider.notifier).update();
            },
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xff87643E),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Delete Button
        IconButton.filled(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _DeleteIngredientDialog(
                ingredient: ingredient!,
              ),
            );
          },
          icon: const Icon(Icons.delete_outline),
          style: IconButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(14),
            minimumSize: const Size(56, 56),
          ),
          tooltip: 'Delete ingredient',
        ),
      ],
    );
  }
}

/// Modern Material delete confirmation dialog
class _DeleteIngredientDialog extends ConsumerWidget {
  final Ingredient ingredient;

  const _DeleteIngredientDialog({required this.ingredient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        'Delete "${ingredient.name}"?',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: const Text(
        'This action cannot be undone. The ingredient will be permanently removed from your stored ingredients.',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            ref
                .read(asyncStoredIngredientsProvider.notifier)
                .deleteIngredient(ingredient.ingredientId);
            Navigator.pop(context);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Ingredient deleted successfully!',
              autoCloseDuration: const Duration(seconds: 2),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
