import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/formulator_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for FormulatorExportService
final formularExportServiceProvider = Provider<FormulatorExportService>((ref) {
  final ingredientState = ref.watch(ingredientProvider);
  return FormulatorExportService(
    ingredients: ingredientState.ingredients,
  );
});
