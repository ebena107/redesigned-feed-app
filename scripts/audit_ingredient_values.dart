import 'dart:convert';
import 'dart:io';

/// Quick audit script to flag out-of-range nutrient values in raw ingredient JSONs.
///
/// Run:
///   dart scripts/audit_ingredient_values.dart
///
/// Thresholds are intentionally conservative to catch obvious typos:
/// - protein/fiber/fat: 0-100 (% DM)
/// - calcium: 0-50 (% DM)
/// - phosphorus: 0-20 (% DM)
/// - lysine: 0-10 (% DM)
/// - methionine: 0-5 (% DM)
/// - energy: 0-5000 (kcal/kg)
Future<void> main() async {
  final files = [
    'assets/raw/initial_ingredients.json',
    'assets/raw/new_ingredients.json',
  ];

  for (final path in files) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('Missing file: $path');
      continue;
    }

    final jsonList = jsonDecode(file.readAsStringSync());
    if (jsonList is! List) {
      stderr.writeln('Unexpected format in $path');
      continue;
    }

    print('Auditing $path (${jsonList.length} entries)');
    var issues = 0;

    for (final raw in jsonList) {
      if (raw is! Map<String, dynamic>) continue;
      final name = raw['name'] ?? 'Unknown';

      issues += _check(raw, name, 'protein', 0, 100,
          altKeys: const ['crude_protein']);
      issues +=
          _check(raw, name, 'fiber', 0, 60, altKeys: const ['crude_fiber']);
      issues += _check(raw, name, 'fat', 0, 40, altKeys: const ['crude_fat']);
      issues += _check(raw, name, 'calcium', 0, 50);
      issues += _check(raw, name, 'phosphorus', 0, 20);
      issues += _check(raw, name, 'lysine', 0, 10);
      issues += _check(raw, name, 'methionine', 0, 5);

      issues += _check(raw, name, 'energy', 0, 5000,
          altKeys: const [
            'me_growing_pig',
            'me_adult_pig',
            'me_poultry',
            'me_ruminant',
            'me_rabbit',
            'de_salmonids'
          ],
          silent: true);
    }

    if (issues == 0) {
      print('  ✅ No out-of-range values found.');
    } else {
      print('  ⚠️  Found $issues potential issues. See details above.');
    }
    print('');
  }
}

int _check(
  Map<String, dynamic> raw,
  String name,
  String key,
  num min,
  num max, {
  List<String> altKeys = const [],
  bool silent = false,
}) {
  int count = 0;
  final keys = [key, ...altKeys];
  for (final k in keys) {
    if (!raw.containsKey(k)) continue;
    final value = raw[k];
    if (value is num) {
      if (value < min || value > max) {
        if (!silent) {
          print('  [$name] $k=$value out of range ($min-$max)');
        }
        count++;
      }
    }
  }
  return count;
}
