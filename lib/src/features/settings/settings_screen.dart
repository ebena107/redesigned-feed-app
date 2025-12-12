import 'dart:io';

import 'package:feed_estimator/src/core/services/data_management_service.dart';
import 'package:feed_estimator/src/features/privacy/privacy_consent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

// ignore_for_file: use_build_context_synchronously

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
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final consentState = ref.watch(privacyConsentProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Privacy & Data Section
                _buildSectionHeader('Privacy & Data'),
                _buildCard(
                  children: [
                    SwitchListTile(
                      title: const Text('Data Collection Consent'),
                      subtitle: Text(
                        consentState.hasConsented
                            ? 'You have consented to data collection'
                            : 'You have not consented',
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
                        title: const Text('Consent Date'),
                        subtitle: Text(_formatDate(consentState.consentDate!)),
                      ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.policy),
                      title: const Text('Privacy Policy'),
                      subtitle: const Text('View our privacy policy'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: _launchPrivacyPolicy,
                    ),
                  ],
                ),

                // Data Management Section
                _buildSectionHeader('Data Management'),
                _buildCard(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Feed Formulations'),
                      trailing: Text(
                        '${_statistics['feeds'] ?? 0}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add_circle),
                      title: const Text('Custom Ingredients'),
                      trailing: Text(
                        '${_statistics['custom_ingredients'] ?? 0}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.storage),
                      title: const Text('Database Size'),
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
                      title: const Text('Export Data'),
                      subtitle: const Text('Backup all your data'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _exportData,
                    ),
                    ListTile(
                      leading: const Icon(Icons.upload, color: Colors.green),
                      title: const Text('Import Data'),
                      subtitle: const Text('Restore from backup'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _importData,
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Delete All Data'),
                      subtitle: const Text('Permanently delete everything'),
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
                      title: const Text('Version'),
                      trailing: Text(
                        _appVersion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.star_rate, color: Colors.amber),
                      title: const Text('Rate the App'),
                      subtitle: const Text('Share your feedback'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _rateApp,
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('Open Source Licenses'),
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
                _buildSectionHeader('Legal'),
                _buildCard(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.gavel),
                      title: Text('Terms of Service'),
                      subtitle: Text('Coming soon'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.security),
                      title: Text('Data Safety'),
                      subtitle: Text('Your data is stored locally'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Footer
                Center(
                  child: Text(
                    'Made with ❤️ for livestock farmers',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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

  Future<void> _launchPrivacyPolicy() async {
    // TODO: Replace with actual privacy policy URL
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Privacy policy URL: https://yourdomain.com/privacy-policy\nPlease update with your actual URL'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showRevokeConsentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Consent'),
        content: const Text(
          'Are you sure you want to revoke your consent? '
          'This will not delete your data, but you acknowledge that '
          'you no longer consent to data collection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(privacyConsentProvider.notifier).revokeConsent();
              Navigator.of(context).pop();
            },
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    try {
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
                  Text('Exporting data...'),
                ],
              ),
            ),
          ),
        ),
      );

      final file = await _dataService.exportDataToFile();

      // CRITICAL: Close loading dialog FIRST
      if (mounted) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Close loading dialog

        // Longer delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // THEN show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 28),
                const SizedBox(width: 12),
                const Text('Export Successful'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your backup has been created successfully!',
                  style: TextStyle(fontWeight: FontWeight.w500),
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
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      text: 'Feed Estimator Backup',
                    );
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Share failed: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
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
          SnackBar(content: Text('Export failed: $e')),
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
        Navigator.of(context).pop(); // Close loading

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data imported successfully'),
            backgroundColor: Colors.green,
          ),
        );

        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAllData();
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllData() async {
    try {
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
                  Text('Deleting data...'),
                ],
              ),
            ),
          ),
        ),
      );

      await _dataService.deleteAllUserData();

      if (mounted) {
        Navigator.of(context).pop(); // Close loading

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: $e'),
            backgroundColor: Colors.red,
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
          SnackBar(content: Text('Could not open store: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
