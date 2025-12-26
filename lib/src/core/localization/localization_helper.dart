import 'package:feed_estimator/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Helper class for accessing localization functionality
///
/// Note: Use the context extension for convenient access to localized strings
class LocalizationHelper {
  /// Get material localizations from context
  static MaterialLocalizations getLocalizations(BuildContext context) {
    return MaterialLocalizations.of(context);
  }

  /// Fallback to English if localization fails
  static String fallback(String englishText) {
    return englishText;
  }

  /// Get current app localizations (for use in non-widget contexts)
  static AppLocalizations? currentL10n;
}

/// Extension on BuildContext for easy access to localized strings
///
/// Usage: `context.l10n.appTitle` instead of `AppLocalizations.of(context)!.appTitle`
extension LocalizationExtension on BuildContext {
  /// Get AppLocalizations instance for this context
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
