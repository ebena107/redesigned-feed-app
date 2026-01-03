import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import '../providers/optimizer_provider.dart';
import '../model/optimization_constraint.dart';
import '../widgets/constraint_input_card.dart';
import '../widgets/ingredient_selection_card.dart';
import '../widgets/optimization_settings_card.dart';
import '../widgets/animal_category_card.dart';
import '../../main/repository/feed_repository.dart';
import '../../main/repository/feed_ingredient_repository.dart';
import '../../main/model/feed.dart';
import 'optimization_results_screen.dart';

/// Main screen for setting up and running feed formulation optimization
class OptimizerSetupScreen extends ConsumerStatefulWidget {
  const OptimizerSetupScreen({super.key, this.existingFeedId});

  final int? existingFeedId;

  @override
  ConsumerState<OptimizerSetupScreen> createState() =>
      _OptimizerSetupScreenState();
}

class _OptimizerSetupScreenState extends ConsumerState<OptimizerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  Feed? _existingFeed; // Store the loaded feed for Quick Optimize

  @override
  void initState() {
    super.initState();
    // Load existing feed data if feedId is provided
    if (widget.existingFeedId != null) {
      AppLogger.info(
          'OptimizerSetupScreen initiated with feedId: ${widget.existingFeedId}',
          tag: 'OptimizerSetupScreen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingFeed(widget.existingFeedId!);
      });
    }
  }

  Future<void> _loadExistingFeed(int feedId) async {
    try {
      AppLogger.info(
          '[OPTIMIZER-UI] Starting _loadExistingFeed for feedId: $feedId',
          tag: 'OptimizerSetupScreen');

      // Load feed and ingredients from database
      final feedRepo = ref.read(feedRepository);
      final feedIngredientRepo = ref.read(feedIngredientRepository);

      final allFeeds = await feedRepo.getAll();
      final allIngredients = await feedIngredientRepo.getAll();

      // Find the feed
      var feed = allFeeds.where((f) => f.feedId == feedId).firstOrNull;

      if (feed != null) {
        // Merge ingredients into the feed
        final feedIngredients =
            allIngredients.where((i) => i.feedId == feedId).toList();
        feed = feed.copyWith(feedIngredients: feedIngredients);

        AppLogger.info(
            '[OPTIMIZER-UI] Feed loaded and merged: ${feed.feedName}, animalId: ${feed.animalId}, ingredientCount: ${feed.feedIngredients?.length ?? 0}',
            tag: 'OptimizerSetupScreen');
      } else {
        AppLogger.info(
            '[OPTIMIZER-UI] Feed loaded (direct): feedId=$feedId, ingredientCount: ${feed?.feedIngredients?.length ?? 0}',
            tag: 'OptimizerSetupScreen');
      }

      if (feed == null || !mounted) {
        AppLogger.warning('[OPTIMIZER-UI] Feed is null or widget unmounted',
            tag: 'OptimizerSetupScreen');
        return;
      }

      // Store the feed for Quick Optimize
      setState(() {
        _existingFeed = feed;
      });
      AppLogger.info('[OPTIMIZER-UI] Stored _existingFeed in state',
          tag: 'OptimizerSetupScreen');

      // Pre-populate optimizer with feed ingredients
      final feedIngredients = feed.feedIngredients ?? [];
      AppLogger.info(
          '[OPTIMIZER-UI] Pre-populating ${feedIngredients.length} ingredients',
          tag: 'OptimizerSetupScreen');

      for (final feedIngredient in feedIngredients) {
        final ingredientId = feedIngredient.ingredientId;
        final price = feedIngredient.priceUnitKg ?? 0.0;

        if (ingredientId != null) {
          ref.read(optimizerProvider.notifier).addIngredient(
                ingredientId.toInt(),
                price.toDouble(),
              );
          AppLogger.debug(
              '[OPTIMIZER-UI] Added ingredient $ingredientId with price $price',
              tag: 'OptimizerSetupScreen');
        }
      }

      // Start Quick Optimize flow with the loaded feed
      AppLogger.info(
          '[OPTIMIZER-UI] Starting Quick Optimize with feed: ${feed.feedName}',
          tag: 'OptimizerSetupScreen');
      await ref
          .read(optimizerProvider.notifier)
          .startQuickOptimize(existingFeed: feed);
      AppLogger.info('[OPTIMIZER-UI] Quick Optimize initialized',
          tag: 'OptimizerSetupScreen');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(context.l10n.optimizerLoadedFeed(feed.feedName ?? '')),
            backgroundColor: Colors.green,
          ),
        );
        AppLogger.info(
            '[OPTIMIZER-UI] Showed success snackbar for ${feed.feedName}',
            tag: 'OptimizerSetupScreen');
      }
    } catch (e, stackTrace) {
      AppLogger.error('[OPTIMIZER-UI] Error in _loadExistingFeed: $e',
          tag: 'OptimizerSetupScreen', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.optimizerErrorLoadingFeed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final optimizerState = ref.watch(optimizerProvider);
    final canOptimize = ref.watch(canOptimizeProvider);

    AppLogger.info(
        '[OPTIMIZER-UI] Build: constraints=${optimizerState.constraints.length}, ingredients=${optimizerState.selectedIngredientIds.length}, category=${optimizerState.selectedCategory}, existingFeed=$_existingFeed',
        tag: 'OptimizerSetupScreen');

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.optimizerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(optimizerProvider.notifier).reset();
            },
            tooltip: context.l10n.optimizerActionReset,
          ),
        ],
      ),
      body: _buildOptimizeChoice(context, ref, optimizerState, canOptimize),
    );
  }

  /// Build the choice between Quick Optimize and Custom Optimize
  Widget _buildOptimizeChoice(
    BuildContext context,
    WidgetRef ref,
    OptimizerState optimizerState,
    bool canOptimize,
  ) {
    // If quick optimize was started (has constraints and ingredients loaded), show simplified quick optimize flow
    if (optimizerState.constraints.isNotEmpty &&
        optimizerState.selectedIngredientIds.isNotEmpty) {
      AppLogger.info(
          '[OPTIMIZER-UI] Entering _buildQuickOptimizeFlow: ${optimizerState.constraints.length} constraints, ${optimizerState.selectedIngredientIds.length} ingredients, category=${optimizerState.selectedCategory}',
          tag: 'OptimizerSetupScreen');
      return _buildQuickOptimizeFlow(context, ref, optimizerState, canOptimize);
    }

    // If we're already in the custom optimization flow, show the custom setup
    if (optimizerState.hasStartedCustom) {
      return _buildCustomOptimizeFlow(
          context, ref, optimizerState, canOptimize);
    }

    // Show choice screen
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 24),
        Text(
          context.l10n.optimizerTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose your optimization approach',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        const SizedBox(height: 32),

        // Quick Optimize Card
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.orange[700], size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.quickOptimizeTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.quickOptimizeDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _setupQuickOptimize(context, ref),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(context.l10n.quickOptimizeButton),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Custom Optimize Card
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.tune, color: Colors.blue[700], size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.customOptimizeTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Set up your own constraints and ingredients for complete control.',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(optimizerProvider.notifier).startCustomFlow();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Start Custom'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Tooltip with farmer-friendly explanation
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border.all(color: Colors.blue[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.quickOptimizeTooltip,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the quick optimize flow (simplified UI)
  /// Shows only: constraints (pre-loaded), ingredients (pre-loaded), optimization button
  Widget _buildQuickOptimizeFlow(
    BuildContext context,
    WidgetRef ref,
    OptimizerState optimizerState,
    bool canOptimize,
  ) {
    AppLogger.info(
        '[OPTIMIZER-UI] _buildQuickOptimizeFlow: building widget tree',
        tag: 'OptimizerSetupScreen');

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Back button + title
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                ref.read(optimizerProvider.notifier).reset();
              },
              tooltip: 'Back to options',
            ),
            Expanded(
              child: Text(
                context.l10n.quickOptimizeTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Summary Card showing what's loaded
        Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Quick Optimize Ready',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.green[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  optimizerState.selectedCategory ?? 'Broiler Chicken Starter',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${optimizerState.requirementSource ?? ''} · ${optimizerState.constraints.length} constraints · ${optimizerState.selectedIngredientIds.length} ingredients${optimizerState.ingredientLimits != null ? ' · ${optimizerState.ingredientLimits!.length} limits' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Constraints Card (read-only display)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.optimizerConstraintsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (optimizerState.constraints.isEmpty)
                  Text(
                    'No constraints loaded',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Column(
                    children:
                        optimizerState.constraints.asMap().entries.map((entry) {
                      final constraint = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                constraint.nutrientName,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Text(
                              '${constraint.type.name}: ${constraint.value} ${constraint.unit}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Ingredients Card (read-only display)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.navIngredients,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (optimizerState.selectedIngredientIds.isEmpty)
                  Text(
                    'No ingredients selected',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                else
                  Text(
                    '${optimizerState.selectedIngredientIds.length} ingredients selected',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Run Optimization Button
        FilledButton.icon(
          onPressed: canOptimize ? () => _runOptimization(context) : null,
          icon: optimizerState.isOptimizing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.play_arrow),
          label: Text(
            optimizerState.isOptimizing
                ? context.l10n.optimizerOptimizing
                : context.l10n.optimizerRunOptimization,
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCustomOptimizeFlow(
    BuildContext context,
    WidgetRef ref,
    OptimizerState optimizerState,
    bool canOptimize,
  ) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Back button + title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(optimizerProvider.notifier).goBackToChoice();
                },
                tooltip: 'Back to options',
              ),
              Expanded(
                child: Text(
                  context.l10n.customOptimizeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Animal Category Card
          const AnimalCategoryCard(),
          const SizedBox(height: 16),

          // Optimization Settings Card
          const OptimizationSettingsCard(),
          const SizedBox(height: 16),

          // Ingredient Selection Card
          const IngredientSelectionCard(),
          const SizedBox(height: 16),

          // Constraints Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.optimizerConstraintsTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () => _showAddConstraintDialog(context),
                        tooltip: context.l10n.optimizerAddConstraintTooltip,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (optimizerState.constraints.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          context.l10n.optimizerNoConstraints,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...optimizerState.constraints.asMap().entries.map((entry) {
                      return ConstraintInputCard(
                        constraint: entry.value,
                        index: entry.key,
                        onDelete: () {
                          ref
                              .read(optimizerProvider.notifier)
                              .removeConstraint(entry.key);
                        },
                        onEdit: () => _showEditConstraintDialog(
                            context, entry.key, entry.value),
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Error Message
          if (optimizerState.errorMessage != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        optimizerState.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Optimize Button
          ElevatedButton.icon(
            onPressed: canOptimize && !optimizerState.isOptimizing
                ? () => _runOptimization(context)
                : null,
            icon: optimizerState.isOptimizing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(
              optimizerState.isOptimizing
                  ? context.l10n.optimizerOptimizing
                  : context.l10n.optimizerRunOptimization,
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// Setup quick optimize with feed data or default values
  void _setupQuickOptimize(BuildContext context, WidgetRef ref) async {
    AppLogger.info(
        '[OPTIMIZER-UI] _setupQuickOptimize called: existingFeed=${_existingFeed?.feedName}, animalId=${_existingFeed?.animalId}',
        tag: 'OptimizerSetupScreen');

    // Start loading quick optimize - pass existing feed if available
    await ref.read(optimizerProvider.notifier).startQuickOptimize(
          existingFeed: _existingFeed,
        );

    AppLogger.info(
        '[OPTIMIZER-UI] After startQuickOptimize, notifier completed',
        tag: 'OptimizerSetupScreen');
    // The UI will automatically update via the ref.watch(optimizerProvider)
  }

  Future<void> _runOptimization(BuildContext context) async {
    // Only validate if form key is attached (custom flow only)
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    await ref.read(optimizerProvider.notifier).optimize();

    final result = ref.read(optimizationResultProvider);
    if (result != null && result.success && context.mounted) {
      // Navigate to results screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OptimizationResultsScreen(),
        ),
      );
    }
  }

  Future<void> _showAddConstraintDialog(BuildContext context) async {
    String nutrientName = 'crudeProtein';
    ConstraintType type = ConstraintType.min;
    double value = 16.0;
    String unit = '%';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.optimizerAddConstraint),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: nutrientName,
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelNutrient),
                  items: [
                    DropdownMenuItem(
                        value: 'crudeProtein',
                        child: Text(context.l10n.nutrientCrudeProtein)),
                    DropdownMenuItem(
                        value: 'crudeFat',
                        child: Text(context.l10n.nutrientCrudeFat)),
                    DropdownMenuItem(
                        value: 'crudeFiber',
                        child: Text(context.l10n.nutrientCrudeFiber)),
                    DropdownMenuItem(
                        value: 'calcium',
                        child: Text(context.l10n.nutrientCalcium)),
                    DropdownMenuItem(
                        value: 'phosphorus',
                        child: Text(context.l10n.nutrientPhosphorus)),
                    DropdownMenuItem(
                        value: 'energy',
                        child: Text(context.l10n.nutrientEnergy)),
                  ],
                  onChanged: (val) => setState(() => nutrientName = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ConstraintType>(
                  initialValue: type,
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelType),
                  items: [
                    DropdownMenuItem(
                        value: ConstraintType.min,
                        child: Text(context.l10n.optimizerConstraintMinimum)),
                    DropdownMenuItem(
                        value: ConstraintType.max,
                        child: Text(context.l10n.optimizerConstraintMaximum)),
                    DropdownMenuItem(
                        value: ConstraintType.exact,
                        child: Text(context.l10n.optimizerConstraintExact)),
                  ],
                  onChanged: (val) => setState(() => type = val!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: value.toString(),
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelValue),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => value = double.tryParse(val) ?? value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: unit,
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelUnit),
                  onChanged: (val) => unit = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.actionCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.optimizerActionAdd),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      final constraint = OptimizationConstraint(
        nutrientName: nutrientName,
        type: type,
        value: value,
        unit: unit,
      );
      ref.read(optimizerProvider.notifier).addConstraint(constraint);
    }
  }

  Future<void> _showEditConstraintDialog(
    BuildContext context,
    int index,
    OptimizationConstraint current,
  ) async {
    String nutrientName = current.nutrientName;
    ConstraintType type = current.type;
    double value = current.value;
    String unit = current.unit;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.optimizerEditConstraint),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: nutrientName,
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelNutrient),
                  items: [
                    DropdownMenuItem(
                        value: 'crudeProtein',
                        child: Text(context.l10n.nutrientCrudeProtein)),
                    DropdownMenuItem(
                        value: 'crudeFat',
                        child: Text(context.l10n.nutrientCrudeFat)),
                    DropdownMenuItem(
                        value: 'crudeFiber',
                        child: Text(context.l10n.nutrientCrudeFiber)),
                    DropdownMenuItem(
                        value: 'calcium',
                        child: Text(context.l10n.nutrientCalcium)),
                    DropdownMenuItem(
                        value: 'phosphorus',
                        child: Text(context.l10n.nutrientPhosphorus)),
                    DropdownMenuItem(
                        value: 'energy',
                        child: Text(context.l10n.nutrientEnergy)),
                  ],
                  onChanged: (val) => setState(() => nutrientName = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ConstraintType>(
                  initialValue: type,
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelType),
                  items: [
                    DropdownMenuItem(
                        value: ConstraintType.min,
                        child: Text(context.l10n.optimizerConstraintMinimum)),
                    DropdownMenuItem(
                        value: ConstraintType.max,
                        child: Text(context.l10n.optimizerConstraintMaximum)),
                    DropdownMenuItem(
                        value: ConstraintType.exact,
                        child: Text(context.l10n.optimizerConstraintExact)),
                  ],
                  onChanged: (val) => setState(() => type = val!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: value.toString(),
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelValue),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => value = double.tryParse(val) ?? value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: unit,
                  decoration: InputDecoration(
                      labelText: context.l10n.optimizerLabelUnit),
                  onChanged: (val) => unit = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.actionCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.actionSave),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      final constraint = OptimizationConstraint(
        nutrientName: nutrientName,
        type: type,
        value: value,
        unit: unit,
      );
      ref.read(optimizerProvider.notifier).updateConstraint(index, constraint);
    }
  }
}
