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
///
/// IMPORTANT: This extension requires that the BuildContext is within a
/// MaterialApp/CupertinoApp that has localization delegates configured.
/// If used in a context without localization scope (e.g., dialog builder),
/// capture l10n strings before the dialog or use the widget's context directly.
extension LocalizationExtension on BuildContext {
  /// Get AppLocalizations instance for this context
  ///
  /// Throws [TypeError] if localization is not available in this context.
  /// For dialogs, capture l10n before showing the dialog:
  /// ```dart
  /// final l10n = this.context.l10n;
  /// showDialog(builder: (context) => ...) // Use l10n instead of context.l10n
  /// ```
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw TypeError();
    }
    return localizations;
  }
}
