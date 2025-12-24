// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_parser_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$csvParserHash() => r'3170d82caaa8682c58a6850496a666574d429d43';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```
///
/// Copied from [csvParser].
@ProviderFor(csvParser)
const csvParserProvider = CsvParserFamily();

/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```
///
/// Copied from [csvParser].
class CsvParserFamily extends Family<AsyncValue<List<Ingredient>>> {
  /// Async provider for parsing CSV rows into Ingredient objects
  ///
  /// Usage:
  /// ```dart
  /// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
  /// ```
  ///
  /// Copied from [csvParser].
  const CsvParserFamily();

  /// Async provider for parsing CSV rows into Ingredient objects
  ///
  /// Usage:
  /// ```dart
  /// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
  /// ```
  ///
  /// Copied from [csvParser].
  CsvParserProvider call({
    required List<CSVRow> rows,
    required List<String> headers,
    required Map<String, String> columnMapping,
  }) {
    return CsvParserProvider(
      rows: rows,
      headers: headers,
      columnMapping: columnMapping,
    );
  }

  @override
  CsvParserProvider getProviderOverride(
    covariant CsvParserProvider provider,
  ) {
    return call(
      rows: provider.rows,
      headers: provider.headers,
      columnMapping: provider.columnMapping,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'csvParserProvider';
}

/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```
///
/// Copied from [csvParser].
class CsvParserProvider extends AutoDisposeFutureProvider<List<Ingredient>> {
  /// Async provider for parsing CSV rows into Ingredient objects
  ///
  /// Usage:
  /// ```dart
  /// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
  /// ```
  ///
  /// Copied from [csvParser].
  CsvParserProvider({
    required List<CSVRow> rows,
    required List<String> headers,
    required Map<String, String> columnMapping,
  }) : this._internal(
          (ref) => csvParser(
            ref as CsvParserRef,
            rows: rows,
            headers: headers,
            columnMapping: columnMapping,
          ),
          from: csvParserProvider,
          name: r'csvParserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$csvParserHash,
          dependencies: CsvParserFamily._dependencies,
          allTransitiveDependencies: CsvParserFamily._allTransitiveDependencies,
          rows: rows,
          headers: headers,
          columnMapping: columnMapping,
        );

  CsvParserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rows,
    required this.headers,
    required this.columnMapping,
  }) : super.internal();

  final List<CSVRow> rows;
  final List<String> headers;
  final Map<String, String> columnMapping;

  @override
  Override overrideWith(
    FutureOr<List<Ingredient>> Function(CsvParserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CsvParserProvider._internal(
        (ref) => create(ref as CsvParserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rows: rows,
        headers: headers,
        columnMapping: columnMapping,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Ingredient>> createElement() {
    return _CsvParserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CsvParserProvider &&
        other.rows == rows &&
        other.headers == headers &&
        other.columnMapping == columnMapping;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rows.hashCode);
    hash = _SystemHash.combine(hash, headers.hashCode);
    hash = _SystemHash.combine(hash, columnMapping.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CsvParserRef on AutoDisposeFutureProviderRef<List<Ingredient>> {
  /// The parameter `rows` of this provider.
  List<CSVRow> get rows;

  /// The parameter `headers` of this provider.
  List<String> get headers;

  /// The parameter `columnMapping` of this provider.
  Map<String, String> get columnMapping;
}

class _CsvParserProviderElement
    extends AutoDisposeFutureProviderElement<List<Ingredient>>
    with CsvParserRef {
  _CsvParserProviderElement(super.provider);

  @override
  List<CSVRow> get rows => (origin as CsvParserProvider).rows;
  @override
  List<String> get headers => (origin as CsvParserProvider).headers;
  @override
  Map<String, String> get columnMapping =>
      (origin as CsvParserProvider).columnMapping;
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
///
/// Copied from [conflictResolver].
@ProviderFor(conflictResolver)
const conflictResolverProvider = ConflictResolverFamily();

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
///
/// Copied from [conflictResolver].
class ConflictResolverFamily extends Family<AsyncValue<List<ConflictPair>>> {
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
  ///
  /// Copied from [conflictResolver].
  const ConflictResolverFamily();

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
  ///
  /// Copied from [conflictResolver].
  ConflictResolverProvider call({
    required List<Ingredient> importedIngredients,
    double similarityThreshold = 0.85,
  }) {
    return ConflictResolverProvider(
      importedIngredients: importedIngredients,
      similarityThreshold: similarityThreshold,
    );
  }

  @override
  ConflictResolverProvider getProviderOverride(
    covariant ConflictResolverProvider provider,
  ) {
    return call(
      importedIngredients: provider.importedIngredients,
      similarityThreshold: provider.similarityThreshold,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conflictResolverProvider';
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
///
/// Copied from [conflictResolver].
class ConflictResolverProvider
    extends AutoDisposeFutureProvider<List<ConflictPair>> {
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
  ///
  /// Copied from [conflictResolver].
  ConflictResolverProvider({
    required List<Ingredient> importedIngredients,
    double similarityThreshold = 0.85,
  }) : this._internal(
          (ref) => conflictResolver(
            ref as ConflictResolverRef,
            importedIngredients: importedIngredients,
            similarityThreshold: similarityThreshold,
          ),
          from: conflictResolverProvider,
          name: r'conflictResolverProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conflictResolverHash,
          dependencies: ConflictResolverFamily._dependencies,
          allTransitiveDependencies:
              ConflictResolverFamily._allTransitiveDependencies,
          importedIngredients: importedIngredients,
          similarityThreshold: similarityThreshold,
        );

  ConflictResolverProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.importedIngredients,
    required this.similarityThreshold,
  }) : super.internal();

  final List<Ingredient> importedIngredients;
  final double similarityThreshold;

  @override
  Override overrideWith(
    FutureOr<List<ConflictPair>> Function(ConflictResolverRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConflictResolverProvider._internal(
        (ref) => create(ref as ConflictResolverRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        importedIngredients: importedIngredients,
        similarityThreshold: similarityThreshold,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ConflictPair>> createElement() {
    return _ConflictResolverProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConflictResolverProvider &&
        other.importedIngredients == importedIngredients &&
        other.similarityThreshold == similarityThreshold;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, importedIngredients.hashCode);
    hash = _SystemHash.combine(hash, similarityThreshold.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConflictResolverRef on AutoDisposeFutureProviderRef<List<ConflictPair>> {
  /// The parameter `importedIngredients` of this provider.
  List<Ingredient> get importedIngredients;

  /// The parameter `similarityThreshold` of this provider.
  double get similarityThreshold;
}

class _ConflictResolverProviderElement
    extends AutoDisposeFutureProviderElement<List<ConflictPair>>
    with ConflictResolverRef {
  _ConflictResolverProviderElement(super.provider);

  @override
  List<Ingredient> get importedIngredients =>
      (origin as ConflictResolverProvider).importedIngredients;
  @override
  double get similarityThreshold =>
      (origin as ConflictResolverProvider).similarityThreshold;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
