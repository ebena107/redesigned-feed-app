import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported locales in the app
enum AppLocale {
  en('English', Locale('en', 'US')),
  pt('Português', Locale('pt', 'PT')),
  es('Español', Locale('es', 'ES')),
  yo('Yorùbá', Locale('yo', 'NG')),
  fr('Français', Locale('fr', 'FR')),
  sw('Kiswahili', Locale('sw', 'KE')),
  fil('Filipino', Locale('fil', 'PH')),
  tl('Tagalog', Locale('tl', 'PH'));

  const AppLocale(this.displayName, this.locale);

  final String displayName;
  final Locale locale;

  /// Get AppLocale from locale code (e.g., 'en' → AppLocale.en)
  static AppLocale fromLocale(Locale locale) {
    for (final al in AppLocale.values) {
      if (al.locale.languageCode == locale.languageCode) {
        return al;
      }
    }
    return AppLocale.en; // Default to English
  }

  /// Get AppLocale from language code string
  static AppLocale fromLanguageCode(String code) {
    try {
      return AppLocale.values.firstWhere(
        (al) => al.locale.languageCode == code,
        orElse: () => AppLocale.en,
      );
    } catch (_) {
      return AppLocale.en;
    }
  }
}

/// Notifier for managing app localization
class LocalizationNotifier extends StateNotifier<AppLocale> {
  LocalizationNotifier(this._prefs) : super(AppLocale.en) {
    _loadSavedLocale();
  }

  final SharedPreferences _prefs;
  static const String _localePrefKey = 'app_locale';

  /// Load the previously saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final savedCode = _prefs.getString(_localePrefKey);
    if (savedCode != null) {
      state = AppLocale.fromLanguageCode(savedCode);
    }
  }

  /// Set the app locale and persist the choice
  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    await _prefs.setString(_localePrefKey, locale.locale.languageCode);
  }

  /// Set locale from system default (if supported)
  Future<void> setLocaleFromSystem(Locale systemLocale) async {
    final appLocale = AppLocale.fromLocale(systemLocale);
    await setLocale(appLocale);
  }
}

/// Provider for localization state management
final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, AppLocale>((ref) {
  // This will be initialized properly in main.dart with SharedPreferences
  throw UnimplementedError(
    'localizationProvider must be overridden in main.dart',
  );
});

/// Helper provider to get supported locales for MaterialApp
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  // Return ALL app locales - we have translations for them
  // Framework support is only needed for system UI elements
  return AppLocale.values.map((al) => al.locale).toList(growable: false);
});

/// Helper provider to get all available app locales
final availableLocalesProvider = Provider<List<AppLocale>>((ref) {
  return AppLocale.values;
});
