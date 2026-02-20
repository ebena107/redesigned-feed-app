import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/core/utils/widget_builders.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/model/animal_type.dart';
import 'package:feed_estimator/src/features/add_update_feed/repository/animal_type_repository.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/utils/widgets/unified_gradient_header.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/formulator_export_provider.dart';
import 'package:feed_estimator/src/utils/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class FeedFormulatorScreen extends ConsumerStatefulWidget {
  const FeedFormulatorScreen({super.key});

  @override
  ConsumerState<FeedFormulatorScreen> createState() =>
      _FeedFormulatorScreenState();
}

class _FeedFormulatorScreenState extends ConsumerState<FeedFormulatorScreen> {
  static const int _totalSteps = 4;

  int _stepIndex = 0;
  late final TextEditingController _searchController;

  final Map<NutrientKey, TextEditingController> _minControllers = {};
  final Map<NutrientKey, TextEditingController> _maxControllers = {};

  @override
  void initState() {
    super.initState();
    final constraints = ref.read(feedFormulatorProvider).input.constraints;
    _ensureControllers(constraints);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (final controller in _minControllers.values) {
      controller.dispose();
    }
    for (final controller in _maxControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _ensureControllers(List<NutrientConstraint> constraints) {
    for (final constraint in constraints) {
      _minControllers.putIfAbsent(
        constraint.key,
        () => TextEditingController(
          text: constraint.min != null ? constraint.min.toString() : '',
        ),
      );
      _maxControllers.putIfAbsent(
        constraint.key,
        () => TextEditingController(
          text: constraint.max != null ? constraint.max.toString() : '',
        ),
      );
    }
  }

  String _stepTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.l10n.formulatorStepAnimal; // 'Animal & Feed Stage'
      case 1:
        return context.l10n.formulatorStepIngredients;
      case 2:
        return 'Customize'; // Optional customization
      case 3:
        return context.l10n.formulatorStepResults;
      default:
        return '';
    }
  }

  String _nutrientLabel(BuildContext context, NutrientKey key) {
    switch (key) {
      case NutrientKey.energy:
        return context.l10n.labelEnergy;
      case NutrientKey.protein:
        return context.l10n.labelProtein;
      case NutrientKey.lysine:
        return context.l10n.nutrientLysine;
      case NutrientKey.methionine:
        return context.l10n.nutrientMethionine;
      case NutrientKey.calcium:
        return context.l10n.labelCalcium;
      case NutrientKey.phosphorus:
        return context.l10n.labelPhosphorus;
    }
  }

  double? _parseNullable(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  void _updateConstraint(NutrientKey key) {
    final min = _parseNullable(_minControllers[key]?.text ?? '');
    final max = _parseNullable(_maxControllers[key]?.text ?? '');
    ref.read(feedFormulatorProvider.notifier).updateConstraint(
          key,
          min: min,
          max: max,
        );
  }

  Widget _buildBottomBar(BuildContext context) {
    final formState = ref.watch(feedFormulatorProvider);

    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingNormal),
      decoration: BoxDecoration(
        color: AppConstants.appBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            WidgetBuilders.buildOutlinedButton(
              label: context.l10n.actionBack,
              onPressed: _stepIndex == 0
                  ? null
                  : () {
                      setState(() {
                        _stepIndex -= 1;
                      });
                    },
            ),
            const SizedBox(width: UIConstants.paddingSmall),
            if (_stepIndex == 2)
              Expanded(
                child: WidgetBuilders.buildPrimaryButton(
                  label: context.l10n.formulatorActionSolve,
                  onPressed: formState.status == FormulatorStatus.solving
                      ? null
                      : () async {
                          AppLogger.debug(
                            'Solve button pressed - Status: ${formState.status}, Selected ingredients: ${formState.input.selectedIngredientIds.length}',
                            tag: 'FeedFormulatorScreen',
                          );

                          await ref
                              .read(feedFormulatorProvider.notifier)
                              .solve();

                          if (!mounted) {
                            AppLogger.debug('Widget unmounted after solve',
                                tag: 'FeedFormulatorScreen');
                            return;
                          }

                          final updatedStatus =
                              ref.read(feedFormulatorProvider).status;
                          AppLogger.debug(
                            'Solve completed - Status: $updatedStatus',
                            tag: 'FeedFormulatorScreen',
                          );

                          if (updatedStatus == FormulatorStatus.success) {
                            AppLogger.debug(
                                'Formulation successful, navigating to results',
                                tag: 'FeedFormulatorScreen');
                            setState(() {
                              _stepIndex = 3;
                            });
                          } else {
                            final errorState = ref.read(feedFormulatorProvider);
                            final errorMessage = errorState.message.isNotEmpty
                                ? errorState.message
                                : 'Formulation failed. Please check your ingredient selection and constraints.';

                            AppLogger.warning(
                              'Formulation failed with message: "$errorMessage"',
                              tag: 'FeedFormulatorScreen',
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.redAccent,
                                  duration: const Duration(seconds: 5),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  isLoading: formState.status == FormulatorStatus.solving,
                ),
              )
            else
              Expanded(
                child: WidgetBuilders.buildPrimaryButton(
                  label: context.l10n.actionNext,
                  onPressed: _stepIndex >= _totalSteps - 1
                      ? null
                      : () {
                          if (_stepIndex == 1 &&
                              formState.input.selectedIngredientIds.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n.formulatorEmptySelection,
                                ),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _stepIndex += 1;
                          });
                        },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(feedFormulatorProvider);
    _ensureControllers(formState.input.constraints);

    return ResponsiveScaffold(
      appBar: null,
      backgroundColor: AppConstants.appBackgroundColor,
      bottomNavigationBar: _buildBottomBar(context),
      body: CustomScrollView(
        slivers: [
          UnifiedGradientHeader(
            title: context.l10n.screenTitleFeedFormulator,
            gradientColors: [
              AppConstants.mainAppColor,
              AppConstants.mainAppColor.withValues(alpha: 0.7),
            ],
            actions: [
              IconButton(
                tooltip: context.l10n.actionReset,
                onPressed: () {
                  ref.read(feedFormulatorProvider.notifier).resetResult();
                  setState(() {
                    _stepIndex = 0;
                  });
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: UIConstants.paddingAllNormal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.formulatorStepIndicator(
                      _stepIndex + 1,
                      _totalSteps,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.appIconGreyColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    _stepTitle(context, _stepIndex),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: UIConstants.paddingNormal),
                  IndexedStack(
                    index: _stepIndex,
                    children: [
                      _AnimalAndFeedTypeStep(
                        animalTypeId: formState.input.animalTypeId,
                        feedType: formState.input.feedType,
                        onAnimalTypeChanged: (value) => ref
                            .read(feedFormulatorProvider.notifier)
                            .setAnimalTypeId(value),
                        onFeedTypeChanged: (value) => ref
                            .read(feedFormulatorProvider.notifier)
                            .setFeedType(value),
                        constraints: formState.input.constraints,
                        nutrientLabel: _nutrientLabel,
                      ),
                      _IngredientStep(
                        controller: _searchController,
                        selectedIds: formState.input.selectedIngredientIds,
                        onToggle: (id) => ref
                            .read(feedFormulatorProvider.notifier)
                            .toggleIngredientId(id),
                        onSelectAll: (ids) => ref
                            .read(feedFormulatorProvider.notifier)
                            .setSelectedIngredientIds(ids),
                        onClearSelection: () => ref
                            .read(feedFormulatorProvider.notifier)
                            .setSelectedIngredientIds({}),
                        constraints: formState.input.constraints,
                        nutrientLabel: _nutrientLabel,
                      ),
                      _CustomizationStep(
                        constraints: formState.input.constraints,
                        minControllers: _minControllers,
                        maxControllers: _maxControllers,
                        onChanged: _updateConstraint,
                        labelBuilder: _nutrientLabel,
                      ),
                      _ResultsStep(
                        state: formState,
                        nutrientLabel: _nutrientLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.paddingNormal),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimalAndFeedTypeStep extends ConsumerWidget {
  const _AnimalAndFeedTypeStep({
    required this.animalTypeId,
    required this.feedType,
    required this.onAnimalTypeChanged,
    required this.onFeedTypeChanged,
    required this.constraints,
    required this.nutrientLabel,
  });

  final int animalTypeId;
  final FeedType feedType;
  final ValueChanged<int> onAnimalTypeChanged;
  final ValueChanged<FeedType> onFeedTypeChanged;
  final List<NutrientConstraint> constraints;
  final String Function(BuildContext, NutrientKey) nutrientLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animalTypes = ref.watch(animalTypeProvider);
    final feedTypes = FeedType.forAnimalType(animalTypeId);

    return animalTypes.when(
      data: (items) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetBuilders.buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Animal Type',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  _buildAnimalTypeDropdown(context, items),
                  const SizedBox(height: UIConstants.paddingNormal),
                  Text(
                    'Feed Stage',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  _buildFeedTypeDropdown(context, feedTypes),
                ],
              ),
            ),
            const SizedBox(height: UIConstants.paddingNormal),
            Text(
              'Default Nutrient Requirements',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            ...constraints.map((constraint) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: UIConstants.paddingTiny),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          nutrientLabel(context, constraint.key),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          constraint.min != null
                              ? constraint.min!.toStringAsFixed(2)
                              : '-',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppConstants.appIconGreyColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text('-',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppConstants.appIconGreyColor)),
                      Expanded(
                        child: Text(
                          constraint.max != null
                              ? constraint.max!.toStringAsFixed(2)
                              : '-',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppConstants.appIconGreyColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      loading: () => WidgetBuilders.buildLoadingIndicator(
        message: context.l10n.homeLoadingFeeds,
      ),
      error: (error, _) => Text(
        context.l10n.homeLoadFailed(error.toString()),
      ),
    );
  }

  Widget _buildAnimalTypeDropdown(
      BuildContext context, List<AnimalTypes> items) {
    final values = items
        .where((e) => e.typeId != null)
        .map((e) => DropdownMenuItem<int>(
              value: e.typeId!.toInt(),
              child: Text(e.type ?? ''),
            ))
        .toList();

    return DropdownButtonFormField<int>(
      initialValue: animalTypeId,
      decoration: InputDecoration(
        border: UIConstants.inputBorder(),
        focusedBorder: UIConstants.focusedBorder(),
      ),
      items: values,
      onChanged: (value) {
        if (value != null) {
          onAnimalTypeChanged(value);
        }
      },
    );
  }

  Widget _buildFeedTypeDropdown(
      BuildContext context, List<FeedType> feedTypes) {
    final values = feedTypes
        .map((e) => DropdownMenuItem<FeedType>(
              value: e,
              child: Text(e.label),
            ))
        .toList();

    return DropdownButtonFormField<FeedType>(
      initialValue: feedType,
      decoration: InputDecoration(
        border: UIConstants.inputBorder(),
        focusedBorder: UIConstants.focusedBorder(),
      ),
      items: values,
      onChanged: (value) {
        if (value != null) {
          onFeedTypeChanged(value);
        }
      },
    );
  }
}

class _IngredientStep extends ConsumerStatefulWidget {
  const _IngredientStep({
    required this.controller,
    required this.selectedIds,
    required this.onToggle,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.constraints,
    required this.nutrientLabel,
  });

  final TextEditingController controller;
  final Set<num> selectedIds;
  final ValueChanged<num> onToggle;
  final ValueChanged<Set<num>> onSelectAll;
  final VoidCallback onClearSelection;
  final List<NutrientConstraint> constraints;
  final String Function(BuildContext, NutrientKey) nutrientLabel;

  @override
  ConsumerState<_IngredientStep> createState() => _IngredientStepState();
}

class _IngredientStepState extends ConsumerState<_IngredientStep> {
  @override
  void initState() {
    super.initState();
    // Listen to controller changes and rebuild when text changes
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingredientState = ref.watch(ingredientProvider);
    final filtered =
        _filterIngredients(ingredientState.ingredients, widget.controller.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Nutrient Requirements',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.appIconGreyColor,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        WidgetBuilders.buildCard(
          child: Wrap(
            spacing: UIConstants.paddingSmall,
            runSpacing: UIConstants.paddingSmall,
            children: widget.constraints
                .where((c) => c.min != null && c.max != null)
                .map((constraint) => Chip(
                      label: Text(
                        '${widget.nutrientLabel(context, constraint.key)}: ${constraint.min!.toStringAsFixed(1)}-${constraint.max!.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: UIConstants.paddingNormal),
        WidgetBuilders.buildTextField(
          label: context.l10n.formulatorSearchIngredients,
          hint: context.l10n.formulatorIngredientSearchHint,
          controller: widget.controller,
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.formulatorSelectedCount(widget.selectedIds.length),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.appIconGreyColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            TextButton(
              onPressed: filtered.isEmpty
                  ? null
                  : () => widget.onSelectAll({
                        for (final ing in filtered)
                          if (ing.ingredientId != null) ing.ingredientId!
                      }),
              child: Text(context.l10n.formulatorSelectAll),
            ),
            TextButton(
              onPressed:
                  widget.selectedIds.isEmpty ? null : widget.onClearSelection,
              child: Text(context.l10n.formulatorResetSelection),
            ),
          ],
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        filtered.isEmpty
            ? Center(
                child: Text(
                  context.l10n.formulatorSelectIngredientsHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.appIconGreyColor,
                      ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemExtent: 56,
                itemBuilder: (context, index) {
                  final ingredient = filtered[index];
                  final id = ingredient.ingredientId;
                  final isSelected =
                      id != null && widget.selectedIds.contains(id);
                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: id == null ? null : (_) => widget.onToggle(id),
                    ),
                    title: Text(ingredient.name ?? ''),
                    subtitle: Text(ingredient.standardReference ?? ''),
                    onTap: id == null ? null : () => widget.onToggle(id),
                  );
                },
              ),
      ],
    );
  }

  List<Ingredient> _filterIngredients(
    List<Ingredient> ingredients,
    String query,
  ) {
    if (query.trim().isEmpty) return ingredients;
    final lower = query.toLowerCase();
    return ingredients
        .where((ingredient) =>
            (ingredient.name ?? '').toLowerCase().contains(lower))
        .toList();
  }
}

class _CustomizationStep extends StatelessWidget {
  const _CustomizationStep({
    required this.constraints,
    required this.minControllers,
    required this.maxControllers,
    required this.onChanged,
    required this.labelBuilder,
  });

  final List<NutrientConstraint> constraints;
  final Map<NutrientKey, TextEditingController> minControllers;
  final Map<NutrientKey, TextEditingController> maxControllers;
  final ValueChanged<NutrientKey> onChanged;
  final String Function(BuildContext, NutrientKey) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Optional: Customize Nutrient Ranges',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.appIconGreyColor,
              ),
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        Text(
          'Modify the default nutrient requirements or ingredient inclusion limits below',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.appIconGreyColor,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        ListView.separated(
          itemCount: constraints.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: UIConstants.paddingSmall),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final constraint = constraints[index];
            final minController = minControllers[constraint.key]!;
            final maxController = maxControllers[constraint.key]!;

            return WidgetBuilders.buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelBuilder(context, constraint.key),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetBuilders.buildTextField(
                          label: context.l10n.formulatorConstraintMin,
                          controller: minController,
                          keyboardType: TextInputType.number,
                          inputFormatters: InputValidators.numericFormatters,
                          onChanged: (_) => onChanged(constraint.key),
                        ),
                      ),
                      const SizedBox(width: UIConstants.paddingSmall),
                      Expanded(
                        child: WidgetBuilders.buildTextField(
                          label: context.l10n.formulatorConstraintMax,
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          inputFormatters: InputValidators.numericFormatters,
                          onChanged: (_) => onChanged(constraint.key),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ResultsStep extends ConsumerWidget {
  const _ResultsStep({
    required this.state,
    required this.nutrientLabel,
  });

  final FeedFormulatorState state;
  final String Function(BuildContext, NutrientKey) nutrientLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.status == FormulatorStatus.solving) {
      return WidgetBuilders.buildLoadingIndicator(
        message: context.l10n.formulatorStatusSolving,
      );
    }

    if (state.result == null) {
      return Center(
        child: Text(
          context.l10n.formulatorNoResults,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.appIconGreyColor,
              ),
        ),
      );
    }

    final result = state.result!;
    final ingredientState = ref.watch(ingredientProvider);
    final ingredientNames = {
      for (final ingredient in ingredientState.ingredients)
        if (ingredient.ingredientId != null)
          ingredient.ingredientId!: ingredient.name ?? ''
    };

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Export buttons
        Padding(
          padding: const EdgeInsets.all(UIConstants.paddingNormal),
          child: _buildExportButtons(context, ref, result),
        ),
        WidgetBuilders.buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.formulatorCostPerKg,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  _buildStatusBadge(context, state, result) ??
                      const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              Text(
                result.costPerKg.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppConstants.mainAppColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        WidgetBuilders.buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.formulatorIngredientMix,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              ...result.ingredientPercents.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: UIConstants.paddingTiny),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ingredientNames[entry.key] ?? entry.key.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: UIConstants.paddingSmall),
                      Text('${entry.value.toStringAsFixed(2)}%'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: UIConstants.paddingSmall),
        WidgetBuilders.buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.formulatorNutrientsSummary,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              ...result.nutrients.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: UIConstants.paddingTiny),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(nutrientLabel(context, entry.key)),
                      Text(entry.value.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (result.warnings.isNotEmpty) ...[
          const SizedBox(height: UIConstants.paddingSmall),
          WidgetBuilders.buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.formulatorWarnings,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: UIConstants.paddingSmall),
                ...result.warnings.map((warning) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: UIConstants.paddingTiny,
                      ),
                      child: Text(warning),
                    )),
              ],
            ),
          ),
        ],
        if (state.status == FormulatorStatus.failure) ...[
          const SizedBox(height: UIConstants.paddingSmall),
          Text(
            context.l10n.formulatorStatusFailed,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent,
                ),
          ),
        ],
        if (result.status == 'infeasible') ...[
          const SizedBox(height: UIConstants.paddingSmall),
          Text(
            context.l10n.formulatorStatusInfeasible,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent,
                ),
          ),
        ],
        if (result.status == 'unbounded') ...[
          const SizedBox(height: UIConstants.paddingSmall),
          Text(
            context.l10n.formulatorStatusUnbounded,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent,
                ),
          ),
        ],
      ],
    );
  }

  Widget? _buildStatusBadge(
    BuildContext context,
    FeedFormulatorState state,
    FormulatorResult result,
  ) {
    String? label;
    Color? background;

    if (result.status == 'infeasible') {
      label = context.l10n.formulatorStatusInfeasible;
      background = Colors.redAccent.withValues(alpha: 0.12);
    } else if (result.status == 'unbounded') {
      label = context.l10n.formulatorStatusUnbounded;
      background = Colors.redAccent.withValues(alpha: 0.12);
    } else if (state.status == FormulatorStatus.failure) {
      label = context.l10n.formulatorStatusFailed;
      background = Colors.redAccent.withValues(alpha: 0.12);
    }

    if (label == null) return null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.paddingSmall,
        vertical: UIConstants.paddingTiny,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildExportButtons(
    BuildContext context,
    WidgetRef ref,
    FormulatorResult result,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: WidgetBuilders.buildPrimaryButton(
              label: context.l10n.actionExport,
              onPressed: () => _showExportMenu(context, ref, result),
              icon: const Icon(Icons.download),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: WidgetBuilders.buildOutlinedButton(
              label: context.l10n.actionShare,
              onPressed: () => _handleShare(context, ref, result),
              icon: const Icon(Icons.share),
            ),
          ),
        ),
      ],
    );
  }

  void _showExportMenu(
    BuildContext context,
    WidgetRef ref,
    FormulatorResult result,
  ) {
    // Capture localized strings BEFORE showing dialog
    final exportTitle = context.l10n.exportFormatTitle;
    final exportMessage = context.l10n.exportFormatMessage;
    final cancelLabel = context.l10n.actionCancel;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(exportTitle),
        content: Text(exportMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _handleExportPdf(context, ref, result);
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _handleExportCsv(context, ref, result);
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(cancelLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExportPdf(
    BuildContext context,
    WidgetRef ref,
    FormulatorResult result,
  ) async {
    if (!context.mounted) return;

    final scaffold = ScaffoldMessenger.of(context);
    try {
      scaffold.showSnackBar(
        SnackBar(content: Text(context.l10n.exportingToPdf)),
      );

      final exportService = ref.read(formularExportServiceProvider);
      final file = await exportService.exportToPdf(result);

      if (!context.mounted) return;
      scaffold.showSnackBar(
        SnackBar(
          content: Text('PDF saved to ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      scaffold.showSnackBar(
        SnackBar(
          content: Text('${context.l10n.exportFailed}: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _handleExportCsv(
    BuildContext context,
    WidgetRef ref,
    FormulatorResult result,
  ) async {
    if (!context.mounted) return;

    final scaffold = ScaffoldMessenger.of(context);
    try {
      scaffold.showSnackBar(
        SnackBar(content: Text(context.l10n.exportingToCsv)),
      );

      final exportService = ref.read(formularExportServiceProvider);
      final file = await exportService.exportToCsv(result);

      if (!context.mounted) return;
      scaffold.showSnackBar(
        SnackBar(
          content: Text('CSV saved to ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      scaffold.showSnackBar(
        SnackBar(
          content: Text('${context.l10n.exportFailed}: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _handleShare(
    BuildContext context,
    WidgetRef ref,
    FormulatorResult result,
  ) async {
    try {
      final exportService = ref.read(formularExportServiceProvider);
      final shareText = exportService.generateShareText(result);

      if (!context.mounted) return;
      // Share results using SharePlus
      await SharePlus.instance.share(
        ShareParams(text: shareText),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
