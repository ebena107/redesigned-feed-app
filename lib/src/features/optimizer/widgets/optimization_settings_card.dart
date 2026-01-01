import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimizer_provider.dart';
import '../model/optimization_request.dart';

/// Card widget for optimization settings (objective function)
class OptimizationSettingsCard extends ConsumerWidget {
  const OptimizationSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optimizerState = ref.watch(optimizerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Optimization Objective',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ObjectiveFunction>(
              initialValue: optimizerState.objective,
              decoration: const InputDecoration(
                labelText: 'Objective',
                border: OutlineInputBorder(),
                helperText: 'What should the optimizer prioritize?',
              ),
              items: const [
                DropdownMenuItem(
                  value: ObjectiveFunction.minimizeCost,
                  child: Text('Minimize Cost'),
                ),
                DropdownMenuItem(
                  value: ObjectiveFunction.maximizeProtein,
                  child: Text('Maximize Protein'),
                ),
                DropdownMenuItem(
                  value: ObjectiveFunction.maximizeEnergy,
                  child: Text('Maximize Energy'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(optimizerProvider.notifier).setObjective(value);
                }
              },
            ),
            const SizedBox(height: 8),
            _buildObjectiveDescription(optimizerState.objective),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveDescription(ObjectiveFunction objective) {
    String description;
    IconData icon;
    Color color;

    switch (objective) {
      case ObjectiveFunction.minimizeCost:
        description =
            'Find the cheapest formulation that meets all constraints';
        icon = Icons.attach_money;
        color = Colors.green;
        break;
      case ObjectiveFunction.maximizeProtein:
        description = 'Maximize protein content while meeting constraints';
        icon = Icons.fitness_center;
        color = Colors.blue;
        break;
      case ObjectiveFunction.maximizeEnergy:
        description = 'Maximize energy content while meeting constraints';
        icon = Icons.bolt;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: color.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
