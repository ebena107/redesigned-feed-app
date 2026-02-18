import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';

/// Header widget for selecting animal type and feed type
class FeedFormulatorHeader extends ConsumerWidget {
  const FeedFormulatorHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedFormulatorProvider);
    final animalTypeId = state.input.animalTypeId;
    final feedType = state.input.feedType;

    // Animal type options
    const animalTypes = [
      (1, 'Pig'),
      (2, 'Poultry'),
      (3, 'Rabbit'),
      (4, 'Dairy Cattle'),
      (5, 'Beef Cattle'),
      (6, 'Sheep'),
      (7, 'Goat'),
      (8, 'Fish (Tilapia)'),
      (9, 'Fish (Catfish)'),
    ];

    return Card(
      margin: EdgeInsets.all(UIConstants.paddingNormal),
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Animal Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: UIConstants.paddingMedium),
            DropdownButton<int>(
              value: animalTypeId,
              isExpanded: true,
              items: animalTypes
                  .map((type) =>
                      DropdownMenuItem(value: type.$1, child: Text(type.$2)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(feedFormulatorProvider.notifier)
                      .setAnimalTypeId(value);
                }
              },
            ),
            SizedBox(height: UIConstants.paddingMedium),
            Text(
              'Feed Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: UIConstants.paddingSmall),
            Wrap(
              spacing: UIConstants.paddingSmall,
              runSpacing: UIConstants.paddingSmall,
              children: FeedType.forAnimalType(animalTypeId)
                  .map((type) => FilterChip(
                        label: Text(type.label),
                        selected: type == feedType,
                        onSelected: (selected) {
                          if (selected) {
                            ref
                                .read(feedFormulatorProvider.notifier)
                                .setFeedType(type);
                          }
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
