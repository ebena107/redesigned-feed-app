import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for editing nutrient constraints
class ConstraintEditor extends ConsumerStatefulWidget {
  const ConstraintEditor({super.key});

  @override
  ConsumerState<ConstraintEditor> createState() => _ConstraintEditorState();
}

class _ConstraintEditorState extends ConsumerState<ConstraintEditor> {
  late Map<NutrientKey, TextEditingController> _minControllers;
  late Map<NutrientKey, TextEditingController> _maxControllers;
  late Map<NutrientKey, String?> _errors;

  @override
  void initState() {
    super.initState();
    _minControllers = {};
    _maxControllers = {};
    _errors = {};
    _initializeControllers();
  }

  void _initializeControllers() {
    final formulator = ref.read(feedFormulatorProvider);
    for (final constraint in formulator.input.constraints) {
      _minControllers[constraint.key] = TextEditingController(
        text: constraint.min?.toStringAsFixed(2) ?? '',
      );
      _maxControllers[constraint.key] = TextEditingController(
        text: constraint.max?.toStringAsFixed(2) ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _minControllers.values) {
      controller.dispose();
    }
    for (final controller in _maxControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateAndUpdateConstraint(NutrientKey key) {
    final minText = _minControllers[key]?.text ?? '';
    final maxText = _maxControllers[key]?.text ?? '';

    final minVal = minText.isEmpty ? null : double.tryParse(minText);
    final maxVal = maxText.isEmpty ? null : double.tryParse(maxText);

    setState(() {
      _errors[key] = null;

      if (minVal != null && maxVal != null && minVal > maxVal) {
        _errors[key] = 'Min must be ≤ Max';
      }
    });

    if (_errors[key] == null) {
      ref.read(feedFormulatorProvider.notifier).updateConstraint(
            key,
            min: minVal,
            max: maxVal,
          );
    }
  }

  String _getUnit(NutrientKey key) {
    return key == NutrientKey.energy ? 'kcal/kg' : '%';
  }

  String _getLabel(NutrientKey key) {
    return switch (key) {
      NutrientKey.energy => 'Energy',
      NutrientKey.protein => 'Crude Protein',
      NutrientKey.lysine => 'Lysine',
      NutrientKey.methionine => 'Methionine',
      NutrientKey.calcium => 'Calcium',
      NutrientKey.phosphorus => 'Phosphorus',
    };
  }

  @override
  Widget build(BuildContext context) {
    final formulator = ref.watch(feedFormulatorProvider);

    return Card(
      margin: EdgeInsets.all(UIConstants.paddingNormal),
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nutrient Constraints',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () {
                    final defaults = NutrientRequirements.getDefaults(
                      formulator.input.animalTypeId,
                      formulator.input.feedType,
                    );
                    ref
                        .read(feedFormulatorProvider.notifier)
                        .setConstraints(defaults.constraints);
                    _initializeControllers();
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Defaults'),
                ),
              ],
            ),
            SizedBox(height: UIConstants.paddingMedium),
            ...formulator.input.constraints.map((constraint) {
              final minController =
                  _minControllers[constraint.key] ?? TextEditingController();
              final maxController =
                  _maxControllers[constraint.key] ?? TextEditingController();
              final error = _errors[constraint.key];
              final unit = _getUnit(constraint.key);

              return Padding(
                padding: EdgeInsets.only(
                  bottom: UIConstants.paddingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLabel(constraint.key),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    SizedBox(
                      height: UIConstants.paddingSmall,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: minController,
                            decoration: InputDecoration(
                              labelText: 'Min ($unit)',
                              errorText: error,
                              suffix: Text(unit),
                            ),
                            inputFormatters: InputValidators.numericFormatters,
                            onChanged: (_) {
                              _validateAndUpdateConstraint(
                                constraint.key,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: UIConstants.paddingMedium,
                        ),
                        Flexible(
                          child: TextField(
                            controller: maxController,
                            decoration: InputDecoration(
                              labelText: 'Max ($unit)',
                              suffix: Text(unit),
                            ),
                            inputFormatters: InputValidators.numericFormatters,
                            onChanged: (_) {
                              _validateAndUpdateConstraint(
                                constraint.key,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
