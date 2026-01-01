import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/optimizer_feed_repository.dart';
import '../../main/model/feed.dart';

/// Screen for viewing formulation history
class FormulationHistoryScreen extends ConsumerWidget {
  const FormulationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(optimizerFeedRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulation History'),
      ),
      body: FutureBuilder<List<Feed>>(
        future: repository.getOptimizedFeeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final formulations = snapshot.data ?? [];

          if (formulations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No saved formulations yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first optimized formulation!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: formulations.length,
            itemBuilder: (context, index) {
              final feed = formulations[index];
              return _FormulationCard(feed: feed);
            },
          );
        },
      ),
    );
  }
}

class _FormulationCard extends StatelessWidget {
  final Feed feed;

  const _FormulationCard({required this.feed});

  @override
  Widget build(BuildContext context) {
    final score = feed.optimizationScore ?? 0.0;
    final objective = feed.optimizationObjective ?? 'Unknown';
    final ingredientCount = feed.feedIngredients?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          // Navigate to details or results view
          // For now, just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('View details for ${feed.feedName}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      feed.feedName ?? 'Unnamed Feed',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(score).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${score.toStringAsFixed(1)}/100',
                      style: TextStyle(
                        color: _getScoreColor(score),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _getObjectiveIcon(objective),
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatObjective(objective),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.restaurant, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '$ingredientCount ingredients',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (feed.timestampModified != null)
                Text(
                  'Created: ${_formatDate(feed.timestampModified!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getObjectiveIcon(String objective) {
    switch (objective.toLowerCase()) {
      case 'minimizecost':
        return Icons.attach_money;
      case 'maximizeprotein':
        return Icons.fitness_center;
      case 'maximizeenergy':
        return Icons.bolt;
      default:
        return Icons.help;
    }
  }

  String _formatObjective(String objective) {
    switch (objective.toLowerCase()) {
      case 'minimizecost':
        return 'Minimize Cost';
      case 'maximizeprotein':
        return 'Maximize Protein';
      case 'maximizeenergy':
        return 'Maximize Energy';
      default:
        return objective;
    }
  }

  String _formatDate(num timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
