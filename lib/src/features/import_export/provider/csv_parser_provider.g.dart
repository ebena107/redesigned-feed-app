// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_parser_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```

@ProviderFor(csvParser)
final csvParserProvider = CsvParserFamily._();

/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```

final class CsvParserProvider extends $FunctionalProvider<
        AsyncValue<List<Ingredient>>,
        List<Ingredient>,
        FutureOr<List<Ingredient>>>
    with $FutureModifier<List<Ingredient>>, $FutureProvider<List<Ingredient>> {
  /// Async provider for parsing CSV rows into Ingredient objects
  ///
  /// Usage:
  /// ```dart
  /// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
  /// ```
  CsvParserProvider._(
      {required CsvParserFamily super.from,
      required ({
        List<CSVRow> rows,
        List<String> headers,
        Map<String, String> columnMapping,
      })
          super.argument})
      : super(
          retry: null,
          name: r'csvParserProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$csvParserHash();

  @override
  String toString() {
    return r'csvParserProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Ingredient>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Ingredient>> create(Ref ref) {
    final argument = this.argument as ({
      List<CSVRow> rows,
      List<String> headers,
      Map<String, String> columnMapping,
    });
    return csvParser(
      ref,
      rows: argument.rows,
      headers: argument.headers,
      columnMapping: argument.columnMapping,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CsvParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$csvParserHash() => r'3170d82caaa8682c58a6850496a666574d429d43';

/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```

final class CsvParserFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<Ingredient>>,
            ({
              List<CSVRow> rows,
              List<String> headers,
              Map<String, String> columnMapping,
            })> {
  CsvParserFamily._()
      : super(
          retry: null,
          name: r'csvParserProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Async provider for parsing CSV rows into Ingredient objects
  ///
  /// Usage:
  /// ```dart
  /// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
  /// ```

  CsvParserProvider call({
    required List<CSVRow> rows,
    required List<String> headers,
    required Map<String, String> columnMapping,
  }) =>
      CsvParserProvider._(argument: (
        rows: rows,
        headers: headers,
        columnMapping: columnMapping,
      ), from: this);

  @override
  String toString() => r'csvParserProvider';
}

/// Async provider for detecting conflicts between imported and existing ingredients
///
/// Uses Levenshtein distance to find similar ingredient names
///
/// Usage:
/// ```dart
/// final conflicts = await ref.read(conflictResolverProvider(
///   importedIngredients: imported,
///   similarityThreshold: 0.85,
/// ).future);
/// ```

@ProviderFor(conflictResolver)
final conflictResolverProvider = ConflictResolverFamily._();

/// Async provider for detecting conflicts between imported and existing ingredients
///
/// Uses Levenshtein distance to find similar ingredient names
///
/// Usage:
/// ```dart
/// final conflicts = await ref.read(conflictResolverProvider(
///   importedIngredients: imported,
///   similarityThreshold: 0.85,
/// ).future);
/// ```

final class ConflictResolverProvider extends $FunctionalProvider<
        AsyncValue<List<ConflictPair>>,
        List<ConflictPair>,
        FutureOr<List<ConflictPair>>>
    with
        $FutureModifier<List<ConflictPair>>,
        $FutureProvider<List<ConflictPair>> {
  /// Async provider for detecting conflicts between imported and existing ingredients
  ///
  /// Uses Levenshtein distance to find similar ingredient names
  ///
  /// Usage:
  /// ```dart
  /// final conflicts = await ref.read(conflictResolverProvider(
  ///   importedIngredients: imported,
  ///   similarityThreshold: 0.85,
  /// ).future);
  /// ```
  ConflictResolverProvider._(
      {required ConflictResolverFamily super.from,
      required ({
        List<Ingredient> importedIngredients,
        double similarityThreshold,
      })
          super.argument})
      : super(
          retry: null,
          name: r'conflictResolverProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$conflictResolverHash();

  @override
  String toString() {
    return r'conflictResolverProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ConflictPair>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ConflictPair>> create(Ref ref) {
    final argument = this.argument as ({
      List<Ingredient> importedIngredients,
      double similarityThreshold,
    });
    return conflictResolver(
      ref,
      importedIngredients: argument.importedIngredients,
      similarityThreshold: argument.similarityThreshold,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConflictResolverProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conflictResolverHash() => r'e3d0896f96f10bddf75413c7490d84acdca8c5ea';

/// Async provider for detecting conflicts between imported and existing ingredients
///
/// Uses Levenshtein distance to find similar ingredient names
///
/// Usage:
/// ```dart
/// final conflicts = await ref.read(conflictResolverProvider(
///   importedIngredients: imported,
///   similarityThreshold: 0.85,
/// ).future);
/// ```

final class ConflictResolverFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<ConflictPair>>,
            ({
              List<Ingredient> importedIngredients,
              double similarityThreshold,
            })> {
  ConflictResolverFamily._()
      : super(
          retry: null,
          name: r'conflictResolverProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Async provider for detecting conflicts between imported and existing ingredients
  ///
  /// Uses Levenshtein distance to find similar ingredient names
  ///
  /// Usage:
  /// ```dart
  /// final conflicts = await ref.read(conflictResolverProvider(
  ///   importedIngredients: imported,
  ///   similarityThreshold: 0.85,
  /// ).future);
  /// ```

  ConflictResolverProvider call({
    required List<Ingredient> importedIngredients,
    double similarityThreshold = 0.85,
  }) =>
      ConflictResolverProvider._(argument: (
        importedIngredients: importedIngredients,
        similarityThreshold: similarityThreshold,
      ), from: this);

  @override
  String toString() => r'conflictResolverProvider';
}
