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
          // Modern SliverAppBar with back.png background
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xff87643E),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  const Image(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xff87643E).withValues(alpha: 0.4),
                          const Color(0xff87643E).withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      'Stored Ingredients',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff87643E).withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.98),
                  ],
                  stops: const [0.0, 0.2],
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      // Ingredient Selection Widget
                      const IngredientSSelectWidget(),
                      const SizedBox(height: 24),

                      // Form and Actions (shown only if ingredient selected)
                      if (hasIngredient) ...[
                        const StoredIngredientForm(),
                        const SizedBox(height: 20),
                        const _ActionButtonsRow(),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(
                                CupertinoIcons.archivebox,
                                size: 64,
                                color: const Color(0xff87643E)
                                    .withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Select an ingredient to manage',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: const Color(0xff87643E)
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Divider
          SliverToBoxAdapter(
            child: Container(
              height: 1,
              color: const Color(0xff87643E).withValues(alpha: 0.2),
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          // User Ingredients List Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 600,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Custom Ingredients Library',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff87643E),
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
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

/// Action buttons row for Save, Delete, Update
class _ActionButtonsRow extends ConsumerWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredient = ref.watch(storeIngredientProvider).selectedIngredient;

    return Row(
      children: [
        // Save Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(asyncStoredIngredientsProvider.notifier).saveIngredient(
                onSuccess: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: 'Ingredient saved successfully!',
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                },
              );
            },
            icon: const Icon(CupertinoIcons.floppy_disk),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff87643E),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Delete Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _DeleteIngredientDialog(
                  ingredient: ingredient!,
                ),
              );
            },
            icon: const Icon(CupertinoIcons.delete),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Update Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(storeIngredientProvider.notifier).update();
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Ingredient updated successfully!',
                autoCloseDuration: const Duration(seconds: 2),
              );
            },
            icon: const Icon(Icons.update),
            label: const Text('Update'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff87643E),
              side: const BorderSide(color: Color(0xff87643E)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
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
