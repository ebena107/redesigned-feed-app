# Upgrade & Modernization Plan

## Goals

- Achieve Play Store compliance (targetSdk 34+, privacy/data safety, shrink/obfuscate).
- Modernize dependencies and tooling for stability and performance.
- Deliver user-requested features (tropical ingredients, price updates, custom ingredients).
- Improve reliability, observability, and release cadence.

## Immediate Actions (P0)

1. Android build compliance
   - Set compileSdkVersion/targetSdkVersion 34, minSdkVersion 21.
   - Enable R8/proguard and resource shrinking; add `proguard-rules.pro` scaffold.
   - Build as App Bundle with obfuscation and split-debug-info.

2. Privacy & Store listing
   - Add privacy policy URL and align Data Safety form; audit `INTERNET` permission necessity.
   - Update Play Store "What's New" to announce ingredient expansion and price updates.

3. Dependency health
   - Upgrade Flutter/Dart constraint to current stable; bump Riverpod 3.x, GoRouter 17.x, Flutter Lints 6.x, Freezed 3.x, json_serializable latest, path_provider/sqflite/package_info_plus/in_app_review, etc.
   - Remove discontinued build_resolvers/build_runner_core pins; rerun build_runner.

4. Quick product wins
   - Add high-demand tropical/alternative ingredients (azolla, lemna, wolffia, cassava leaves, corn variants) into assets and migration.
   - Allow users to edit ingredient prices (with region/currency) and show freshness badges.
   - Enable custom ingredient contributions (flagged as user-added; optional moderation).

## Near Term (P1)

- Localization: add Yoruba/Hausa/Igbo (plus Swahili/French optional) for ingredient names and key UI strings.
- Offline-first polish: keep SQLite; add queued sync for contributed data when online.
- Observability: add Crashlytics/Sentry + minimal event logging (ingredient add, price update, formulation save).
- Performance: run size analysis; convert heavy images to WebP; prefer system fonts or subset fonts.

## Medium Term (P2)

- Community sharing: optional sharing of custom ingredients, popularity counts.
- Pricing intelligence: regional averages, alerts on price drift, simple charts.
- CI/CD: monthly releases with changelog; automated lint/test gates.

## Testing Focus

- Flows: add/edit feed, add ingredients, generate report/PDF, price edit, custom ingredient submit.
- DB migrations: new ingredient fields and seed data.
- Routing: GoRouter typed routes (add/edit/report/pdf) happy-path tests.

## Release Checklist (summary)

- `flutter clean && flutter pub get`
- `flutter pub upgrade --major-versions` (then resolve)
- `flutter test` (add smoke/widget tests)
- `flutter build appbundle --release --obfuscate --split-debug-info=build/symbols`
- Play Console: update Data Safety, privacy policy URL, What's New, respond to reviews.
