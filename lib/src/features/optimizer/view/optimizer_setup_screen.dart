import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimizer_provider.dart';
import '../model/optimization_constraint.dart';
import '../widgets/constraint_input_card.dart';
import '../widgets/ingredient_selection_card.dart';
import '../widgets/optimization_settings_card.dart';
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

  @override
  void initState() {
    super.initState();
    // Load existing feed data if feedId is provided
    if (widget.existingFeedId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingFeed(widget.existingFeedId!);
      });
    }
  }

  Future<void> _loadExistingFeed(int feedId) async {
    // TODO: Load feed from database and pre-populate optimizer
    // This will be implemented when we integrate with feed repository
    // For now, show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading feed #$feedId for optimization...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final optimizerState = ref.watch(optimizerProvider);
    final canOptimize = ref.watch(canOptimizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Formulation Optimizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(optimizerProvider.notifier).reset();
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
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
                          'Nutritional Constraints',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () => _showAddConstraintDialog(context),
                          tooltip: 'Add Constraint',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (optimizerState.constraints.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No constraints added yet.\nTap + to add nutritional constraints.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...optimizerState.constraints
                          .asMap()
                          .entries
                          .map((entry) {
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
                    ? 'Optimizing...'
                    : 'Run Optimization',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runOptimization(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
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
          title: const Text('Add Constraint'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: nutrientName,
                  decoration: const InputDecoration(labelText: 'Nutrient'),
                  items: const [
                    DropdownMenuItem(
                        value: 'crudeProtein', child: Text('Crude Protein')),
                    DropdownMenuItem(
                        value: 'crudeFat', child: Text('Crude Fat')),
                    DropdownMenuItem(
                        value: 'crudeFiber', child: Text('Crude Fiber')),
                    DropdownMenuItem(value: 'calcium', child: Text('Calcium')),
                    DropdownMenuItem(
                        value: 'phosphorus', child: Text('Phosphorus')),
                    DropdownMenuItem(value: 'energy', child: Text('Energy')),
                  ],
                  onChanged: (val) => setState(() => nutrientName = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ConstraintType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(
                        value: ConstraintType.min, child: Text('Minimum')),
                    DropdownMenuItem(
                        value: ConstraintType.max, child: Text('Maximum')),
                    DropdownMenuItem(
                        value: ConstraintType.exact, child: Text('Exact')),
                  ],
                  onChanged: (val) => setState(() => type = val!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: value.toString(),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => value = double.tryParse(val) ?? value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  onChanged: (val) => unit = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add'),
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
          title: const Text('Edit Constraint'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: nutrientName,
                  decoration: const InputDecoration(labelText: 'Nutrient'),
                  items: const [
                    DropdownMenuItem(
                        value: 'crudeProtein', child: Text('Crude Protein')),
                    DropdownMenuItem(
                        value: 'crudeFat', child: Text('Crude Fat')),
                    DropdownMenuItem(
                        value: 'crudeFiber', child: Text('Crude Fiber')),
                    DropdownMenuItem(value: 'calcium', child: Text('Calcium')),
                    DropdownMenuItem(
                        value: 'phosphorus', child: Text('Phosphorus')),
                    DropdownMenuItem(value: 'energy', child: Text('Energy')),
                  ],
                  onChanged: (val) => setState(() => nutrientName = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ConstraintType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(
                        value: ConstraintType.min, child: Text('Minimum')),
                    DropdownMenuItem(
                        value: ConstraintType.max, child: Text('Maximum')),
                    DropdownMenuItem(
                        value: ConstraintType.exact, child: Text('Exact')),
                  ],
                  onChanged: (val) => setState(() => type = val!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: value.toString(),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => value = double.tryParse(val) ?? value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  onChanged: (val) => unit = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save'),
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
