import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'form_widgets.dart';
import 'custom_ingredient_fields.dart';

class IngredientForm extends ConsumerWidget {
  final int? ingId;
  const IngredientForm({super.key, this.ingId});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final isCustom = ingId == null; // New ingredients are custom

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Custom ingredient header
          if (isCustom) ...[
            customIngredientHeader(),
            const SizedBox(height: 24),
          ],

          // Basic Information Section
          _FormSection(
            title: 'Basic Information',
            children: [
              nameField(ref, ingId, context),
              const SizedBox(height: 16),
              categoryField(ref, ingId),
            ],
          ),
          const SizedBox(height: 24),

          // Energy Values Section
          _FormSection(
            title: 'Energy Values',
            children: [
              _EnergyModeSelector(ref: ref),
              const SizedBox(height: 16),
              if (data.singleEnergyValue) _AnimalSpecificEnergyFields(ref: ref),
              if (!data.singleEnergyValue) ...[
                const SizedBox(height: 8),
                energyField(ref),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Macronutrient Section
          _FormSection(
            title: 'Macronutrients',
            children: [
              Row(
                children: [
                  Expanded(child: proteinField(ref, context)),
                  const SizedBox(width: 12),
                  Expanded(child: fatField(ref)),
                  const SizedBox(width: 12),
                  Expanded(child: fibreField(ref)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Micronutrient Section
          _FormSection(
            title: 'Micronutrients',
            children: [
              Row(
                children: [
                  Expanded(child: calciumField(ref)),
                  const SizedBox(width: 12),
                  Expanded(child: phosphorusField(ref))
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: lyzineField(ref)),
                  const SizedBox(width: 12),
                  Expanded(child: methionineField(ref)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Cost & Availability Section
          _FormSection(
            title: 'Cost & Availability',
            children: [
              Row(
                children: [
                  Expanded(child: priceField(ref)),
                  const SizedBox(width: 12),
                  Expanded(child: availableQuantityField(ref)),
                ],
              ),
            ],
          ),

          // Custom Fields Section
          if (isCustom) ...[
            const SizedBox(height: 24),
            _FormSection(
              title: 'Additional Information',
              children: [
                createdByField(ref),
                const SizedBox(height: 16),
                notesField(ref),
              ],
            ),
          ],

          const SizedBox(height: 24),
          SaveButton(myKey: _formKey, ingId: ingId),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Visual section wrapper with header and children
class _FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FormSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff87643E),
                ),
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
        const SizedBox(height: 12),
        // Children
        ...children,
      ],
    );
  }
}

/// Energy mode selector widget
class _EnergyModeSelector extends StatelessWidget {
  final WidgetRef ref;

  const _EnergyModeSelector({required this.ref});

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(ingredientProvider);

    return Container(
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
          Expanded(
            child: Text(
              'Enter Energy Values for each specific Group of Animals?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 16),
          Checkbox(
            value: data.singleEnergyValue,
            onChanged: (bool? value) =>
                ref.read(ingredientProvider.notifier).selectEnergyMode(value!),
            fillColor: WidgetStateColor.resolveWith(
              (states) => const Color(0xff87643E),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animal-specific energy fields
class _AnimalSpecificEnergyFields extends StatelessWidget {
  final WidgetRef ref;

  const _AnimalSpecificEnergyFields({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'Adult Pigs',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  energyAdultPigField(ref),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'Growing Pigs',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  energyGrowingPigField(ref),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'Fish',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  energyFishField(ref),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'Poultry',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  energyPoultryField(ref),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'Rabbit',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  energyRabbitField(ref),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text(
                      'Ruminant',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                const Color(0xff87643E).withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  energyRuminantField(ref),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
