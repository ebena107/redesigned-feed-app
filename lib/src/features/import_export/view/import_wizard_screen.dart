import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/import_export/provider/import_wizard_provider.dart';
import 'package:feed_estimator/src/features/import_export/service/conflict_detector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ImportWizardScreen extends ConsumerWidget {
  const ImportWizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importWizardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Ingredients'),
        actions: [
          if (state.currentStep != ImportWizardStep.fileSelection &&
              state.currentStep != ImportWizardStep.importing)
            TextButton(
              onPressed: () {
                ref.read(importWizardProvider.notifier).reset();
              },
              child: const Text('Start Over'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(state.currentStep),
          // Step content
          Expanded(
            child: _buildStepContent(state, context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ImportWizardStep currentStep) {
    final steps = [
      ImportWizardStep.fileSelection,
      ImportWizardStep.dataPreview,
      ImportWizardStep.conflictResolution,
    ];
    final currentIndex = steps.indexOf(currentStep);

    return Container(
      padding: UIConstants.paddingNormal,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _buildStepIndicator(
              stepNumber: i + 1,
              label: _getStepLabel(steps[i]),
              isActive: i <= currentIndex,
              isCompleted: i < currentIndex,
            ),
            if (i < steps.length - 1)
              Expanded(
                child: Container(
                  height: 2,
                  color: i < currentIndex
                      ? AppConstants.mainAppColor
                      : Colors.grey[300],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppConstants.mainAppColor
                : isActive
                    ? AppConstants.mainAppColor.withOpacity(0.2)
                    : Colors.grey[300],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isActive ? AppConstants.mainAppColor : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppConstants.mainAppColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  String _getStepLabel(ImportWizardStep step) {
    switch (step) {
      case ImportWizardStep.fileSelection:
        return 'Select File';
      case ImportWizardStep.dataPreview:
        return 'Preview Data';
      case ImportWizardStep.conflictResolution:
        return 'Resolve Conflicts';
      case ImportWizardStep.importing:
        return 'Importing';
    }
  }

  Widget _buildStepContent(
    ImportWizardState state,
    BuildContext context,
    WidgetRef ref,
  ) {
    // Show error if present
    if (state.error != null) {
      return _buildErrorView(state.error!, context, ref);
    }

    switch (state.currentStep) {
      case ImportWizardStep.fileSelection:
        return _FileSelectionStep();
      case ImportWizardStep.dataPreview:
        return _DataPreviewStep(
          ingredients: state.importedIngredients!,
          parsedCSV: state.parsedCSV!,
        );
      case ImportWizardStep.conflictResolution:
        return _ConflictResolutionStep(
          conflicts: state.conflicts!,
          userDecisions: state.userDecisions!,
        );
      case ImportWizardStep.importing:
        return _buildImportingView(state, context);
    }
  }

  Widget _buildErrorView(String error, BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: UIConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(importWizardProvider.notifier).reset();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportingView(ImportWizardState state, BuildContext context) {
    if (state.isImporting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Importing ingredients...'),
          ],
        ),
      );
    }

    // Import complete
    return Center(
      child: Padding(
        padding: UIConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Import Complete!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              '${state.importedCount} ingredients added',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${state.updatedCount} ingredients updated',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileSelectionStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: UIConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              size: 64,
              color: AppConstants.mainAppColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Select CSV File',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a CSV file containing ingredient data.\nSupported formats: NRC, CVB, INRA',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                );

                if (result != null && result.files.single.path != null) {
                  final filePath = result.files.single.path!;
                  await ref
                      .read(importWizardProvider.notifier)
                      .selectAndParseFile(filePath);
                }
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse Files'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataPreviewStep extends ConsumerWidget {
  final List<dynamic> ingredients;
  final dynamic parsedCSV;

  const _DataPreviewStep({
    required this.ingredients,
    required this.parsedCSV,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: UIConstants.paddingNormal,
          child: Card(
            child: Padding(
              padding: UIConstants.paddingNormal,
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppConstants.mainAppColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview: ${ingredients.length} ingredients found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Format: ${parsedCSV.detectedFormat.toString().split('.').last.toUpperCase()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: UIConstants.paddingNormal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ing = ingredients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppConstants.mainAppColor.withOpacity(0.2),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppConstants.mainAppColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(ing.name ?? 'Unknown'),
                  subtitle: Text(
                    'Protein: ${ing.crudeProtein?.toStringAsFixed(1) ?? '--'}% | '
                    'Fiber: ${ing.crudeFiber?.toStringAsFixed(1) ?? '--'}%',
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: UIConstants.paddingNormal,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [UIConstants.lightShadow],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(importWizardProvider.notifier).reset();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(importWizardProvider.notifier)
                        .proceedToConflictResolution();
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConflictResolutionStep extends ConsumerWidget {
  final List<ConflictPair> conflicts;
  final Map<String, MergeStrategy> userDecisions;

  const _ConflictResolutionStep({
    required this.conflicts,
    required this.userDecisions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (conflicts.isEmpty) {
      // No conflicts - proceed directly
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Conflicts Found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All ingredients are new and can be imported.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          _buildActionButtons(context, ref),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: UIConstants.paddingNormal,
          child: Card(
            color: Colors.orange[50],
            child: Padding(
              padding: UIConstants.paddingNormal,
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${conflicts.length} potential duplicate${conflicts.length > 1 ? 's' : ''} found. '
                      'Choose how to handle each conflict.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: UIConstants.paddingNormal,
            itemCount: conflicts.length,
            itemBuilder: (context, index) {
              final conflict = conflicts[index];
              final currentStrategy =
                  userDecisions[conflict.displayName] ?? MergeStrategy.skip;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: UIConstants.paddingNormal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conflict.displayName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Chip(
                            label: Text(conflict.similarityText),
                            backgroundColor:
                                AppConstants.mainAppColor.withOpacity(0.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStrategySelector(
                        context,
                        ref,
                        conflict,
                        currentStrategy,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _buildActionButtons(context, ref),
      ],
    );
  }

  Widget _buildStrategySelector(
    BuildContext context,
    WidgetRef ref,
    ConflictPair conflict,
    MergeStrategy currentStrategy,
  ) {
    return Column(
      children: [
        RadioListTile<MergeStrategy>(
          title: const Text('Skip'),
          subtitle: const Text('Keep existing, discard imported'),
          value: MergeStrategy.skip,
          groupValue: currentStrategy,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(importWizardProvider.notifier)
                  .setConflictDecision(conflict, value);
            }
          },
        ),
        RadioListTile<MergeStrategy>(
          title: const Text('Replace'),
          subtitle: const Text('Replace existing with imported data'),
          value: MergeStrategy.replace,
          groupValue: currentStrategy,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(importWizardProvider.notifier)
                  .setConflictDecision(conflict, value);
            }
          },
        ),
        RadioListTile<MergeStrategy>(
          title: const Text('Merge'),
          subtitle: const Text('Combine best values from both'),
          value: MergeStrategy.merge,
          groupValue: currentStrategy,
          onChanged: (value) {
            if (value != null) {
              ref
                  .read(importWizardProvider.notifier)
                  .setConflictDecision(conflict, value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Container(
      padding: UIConstants.paddingNormal,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [UIConstants.lightShadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ref.read(importWizardProvider.notifier).reset();
              },
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(importWizardProvider.notifier).executeImport();
              },
              child: const Text('Import'),
            ),
          ),
        ],
      ),
    );
  }
}
