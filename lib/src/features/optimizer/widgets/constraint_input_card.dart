import 'package:flutter/material.dart';
import '../model/optimization_constraint.dart';

/// Card widget for displaying a single constraint
class ConstraintInputCard extends StatelessWidget {
  final OptimizationConstraint constraint;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ConstraintInputCard({
    super.key,
    required this.constraint,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(_formatNutrientName(constraint.nutrientName)),
        subtitle: Text(
          '${_formatConstraintType(constraint.type)} ${constraint.value} ${constraint.unit}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  String _formatNutrientName(String name) {
    // Convert camelCase to Title Case
    final formatted = name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim();
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String _formatConstraintType(ConstraintType type) {
    switch (type) {
      case ConstraintType.min:
        return 'Min:';
      case ConstraintType.max:
        return 'Max:';
      case ConstraintType.exact:
        return 'Exact:';
    }
  }
}
