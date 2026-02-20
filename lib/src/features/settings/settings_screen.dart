import 'dart:io';

import 'package:feed_estimator/src/core/services/data_management_service.dart';
import 'package:feed_estimator/src/core/localization/localization_provider.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:feed_estimator/src/features/privacy/privacy_consent.dart';
import 'package:feed_estimator/src/utils/widgets/modern_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/utils/widgets/responsive_scaffold.dart';
import 'package:feed_estimator/src/utils/widgets/unified_gradient_header.dart';

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

/// Comprehensive settings screen with privacy, about, and app management
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final DataManagementService _dataService = DataManagementService();
  final InAppReview _inAppReview = InAppReview.instance;

  Map<String, int> _statistics = {};
  int _databaseSize = 0;
  bool _isLoading = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _dataService.getDataStatistics();
      final dbSize = await _dataService.getDatabaseSize();
      final packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        _statistics = stats;
        _databaseSize = dbSize;
        _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final consentState = ref.watch(privacyConsentProvider);
    final theme = Theme.of(context);

    return ResponsiveScaffold(
      appBar: null,
      body: CustomScrollView(
        slivers: [
          UnifiedGradientHeader(
            title: context.l10n.settingsTitle,
            gradientColors: [
              Colors.blueGrey.shade800,
              Colors.blueGrey.shade600,
            ],
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate([
                // Language Section
                _buildSectionHeader(context.l10n.settingsSectionLanguage),
                _buildLanguageSelector(ref),

                // Privacy & Data Section
                _buildSectionHeader(context.l10n.settingsSectionPrivacy),
                _buildCard(
                  children: [
                    SwitchListTile(
                      title: Text(context.l10n.settingsDataConsent),
                      subtitle: Text(
                        consentState.hasConsented
                            ? context.l10n.settingsConsentGranted
                            : context.l10n.settingsConsentNotGranted,
                      ),
                      value: consentState.hasConsented,
                      onChanged: (value) {
                        if (value) {
                          ref
                              .read(privacyConsentProvider.notifier)
                              .grantConsent();
                        } else {
                          _showRevokeConsentDialog();
                        }
                      },
                    ),
                    if (consentState.consentDate != null)
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(context.l10n.settingsConsentDate),
                        subtitle: Text(_formatDate(consentState.consentDate!)),
                      ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.policy),
                      title: Text(context.l10n.settingsPrivacyPolicy),
                      subtitle:
                          Text(context.l10n.settingsPrivacyPolicySubtitle),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: _launchPrivacyPolicy,
                    ),
                  ],
                ),

                // Data Management Section
                _buildSectionHeader(context.l10n.settingsSectionDataManagement),
                _buildCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(context.l10n.settingsFeedFormulations),
                      trailing: Text(
                        '${_statistics['feeds'] ?? 0}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_circle),
                      title: Text(context.l10n.settingsCustomIngredients),
                      trailing: Text(
                        '${_statistics['custom_ingredients'] ?? 0}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.storage),
                      title: Text(context.l10n.settingsDatabaseSize),
                      trailing: Text(
                        _dataService.formatBytes(_databaseSize),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.download, color: Colors.blue),
                      title: Text(context.l10n.settingsExportData),
                      subtitle: Text(context.l10n.settingsExportDataSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _exportData,
                    ),
                    ListTile(
                      leading: const Icon(Icons.upload, color: Colors.green),
                      title: Text(context.l10n.settingsImportData),
                      subtitle: Text(context.l10n.settingsImportDataSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _importData,
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.delete_forever, color: Colors.red),
                      title: Text(context.l10n.settingsDeleteData),
                      subtitle: Text(context.l10n.settingsDeleteDataSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _showDeleteDataDialog,
                    ),
                  ],
                ),

                // App Information Section
                _buildSectionHeader('About'),
                _buildCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(context.l10n.settingsVersion),
                      trailing: Text(
                        _appVersion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.star_rate, color: Colors.amber),
                      title: Text(context.l10n.settingsRateApp),
                      subtitle: Text(context.l10n.settingsRateAppSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _rateApp,
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: Text(context.l10n.settingsLicenses),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: 'Feed Estimator',
                        applicationVersion: _appVersion,
                      ),
                    ),
                  ],
                ),

                // Legal Section
                _buildSectionHeader(context.l10n.settingsSectionLegal),
                _buildCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.gavel),
                      title: Text(context.l10n.settingsTermsOfService),
                      subtitle: Text(context.l10n.settingsTermsComingSoon),
                    ),
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: Text(context.l10n.settingsDataSafety),
                      subtitle: Text(context.l10n.settingsDataSafetySubtitle),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Footer
                Center(
                  child: Text(
                    context.l10n.settingsFooter,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  /// Build language selector dropdown
  Widget _buildLanguageSelector(WidgetRef ref) {
    final currentLocale = ref.watch(localizationProvider);
    final availableLocales = ref.watch(availableLocalesProvider);

    // Check if Flutter framework has full support (Material/Cupertino widgets)
    bool hasFrameworkSupport(AppLocale al) {
      return GlobalMaterialLocalizations.delegate.isSupported(al.locale) &&
          GlobalCupertinoLocalizations.delegate.isSupported(al.locale);
    }

    return _buildCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<AppLocale>(
              value: currentLocale,
              isExpanded: true,
              onChanged: (AppLocale? newLocale) {
                if (newLocale != null) {
                  ref.read(localizationProvider.notifier).setLocale(newLocale);

                  // Show success message with selected language
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n
                            .settingsLanguageUpdated(newLocale.displayName),
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.fixed,
                    ),
                  );
                }
              },
              items: availableLocales.map((al) {
                final hasFramework = hasFrameworkSupport(al);
                // Show all locales as enabled, with note about framework support
                final label = hasFramework
                    ? al.displayName
                    : context.l10n.settingsLanguageLimitedUI(al.displayName);
                return DropdownMenuItem<AppLocale>(
                  value: al,
                  child: Text(label, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: context.l10n.settingsSelectLanguage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchPrivacyPolicy() async {
    // Privacy policy URL - hosted on GitHub
    const url =
        'https://raw.githubusercontent.com/ebena107/redesigned-feed-app/modernization-v2/PRIVACY_POLICY.md';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open privacy policy'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  void _showRevokeConsentDialog() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.settingsRevokeConsentTitle,
      message: context.l10n.settingsRevokeConsentMessage,
      confirmText: 'Revoke',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (confirmed && mounted) {
      ref.read(privacyConsentProvider.notifier).revokeConsent();
    }
  }

  Future<void> _exportData() async {
    try {
      LoadingDialog.show(context, message: context.l10n.settingsExporting);

      final file = await _dataService.exportDataToFile();

      // CRITICAL: Close loading dialog FIRST
      if (mounted) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Close loading dialog

        // Longer delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // THEN show success dialog - capture localization BEFORE showing dialog
      if (mounted) {
        final l10n =
            context.l10n; // Capture from widget context, not dialog context
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l10n.settingsExportSuccess),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsExportSuccessMessage,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.folder, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SelectableText(
                          file.path,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    // Capture navigator before closing dialog
                    final navigator = Navigator.of(dialogContext);

                    // Close dialog first
                    navigator.pop();

                    // Share the file
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      subject: 'Feed Estimator Backup',
                      text: 'Feed Estimator data backup file',
                    );
                  } catch (e) {
                    // Error handled silently or can show a toast
                  }
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
              FilledButton(
                onPressed: () {
                  try {
                    Navigator.of(dialogContext, rootNavigator: true).pop();
                  } catch (e) {
                    // Fallback: try without rootNavigator
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close loading dialog on error
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading

        // Longer delay
        await Future.delayed(const Duration(milliseconds: 500));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  Future<void> _importData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) return;

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Importing data...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      final file = File(result.files.single.path!);
      await _dataService.importDataFromFile(file);

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading

        // Delay to ensure dialog is fully closed before reloading
        await Future.delayed(const Duration(milliseconds: 500));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data imported successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.fixed,
          ),
        );

        // Invalidate all providers to refresh the app
        ref.invalidate(asyncMainProvider);

        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading

        // Delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 500));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  void _showDeleteDataDialog() async {
    // First confirmation - warning dialog
    final firstConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[600], size: 28),
            const SizedBox(width: 12),
            const Text('Delete All Data'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete all your data?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('This will permanently delete:'),
            SizedBox(height: 8),
            Text('• All feed formulations'),
            Text('• All custom ingredients'),
            Text('• All calculation results'),
            Text('• All app preferences'),
            SizedBox(height: 12),
            Text(
              'This action cannot be undone!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange[600],
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    // If first confirmation is cancelled, return
    if (firstConfirmed != true || !mounted) return;

    // Second confirmation - final warning
    final secondConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red[600], size: 28),
            const SizedBox(width: 12),
            const Text('Final Warning'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is your last chance!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'All your data will be permanently deleted and cannot be recovered.',
            ),
            SizedBox(height: 16),
            Text(
              'Are you absolutely sure you want to proceed?',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[600],
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Delete Everything'),
          ),
        ],
      ),
    );

    if (secondConfirmed == true && mounted) {
      await _deleteAllData();
    }
  }

  Future<void> _deleteAllData() async {
    try {
      LoadingDialog.show(context, message: 'Deleting data...');

      await _dataService.deleteAllUserData();

      if (mounted) {
        LoadingDialog.hide(context); // Close loading with rootNavigator

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.fixed,
          ),
        );

        // Invalidate all providers to refresh the app
        ref.invalidate(asyncMainProvider);

        // Reload statistics
        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        LoadingDialog.hide(context); // Close loading with rootNavigator

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  Future<void> _rateApp() async {
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open store: $e'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
