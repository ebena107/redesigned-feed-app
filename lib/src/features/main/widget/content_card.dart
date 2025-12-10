import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:flutter/material.dart';

/// Compact nutrient display card for list tiles
class ContentCard extends StatelessWidget {
  final String? title;
  final num? value;

  const ContentCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.paddingSmall),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.paddingSmall,
            vertical: UIConstants.paddingTiny,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value!.toStringAsFixed(2),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
