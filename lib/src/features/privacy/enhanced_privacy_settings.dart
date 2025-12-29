import 'package:feed_estimator/src/core/services/data_management_service.dart';
import 'package:feed_estimator/src/features/privacy/privacy_consent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced privacy settings screen with full data management
class EnhancedPrivacySettingsScreen extends ConsumerStatefulWidget {
  const EnhancedPrivacySettingsScreen({super.key});

  @override
  ConsumerState<EnhancedPrivacySettingsScreen> createState() =>
      _EnhancedPrivacySettingsScreenState();
}

class _EnhancedPrivacySettingsScreenState
    extends ConsumerState<EnhancedPrivacySettingsScreen> {
  final DataManagementService _dataService = DataManagementService();
  Map<String, int> _statistics = {};
  int _databaseSize = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _dataService.getDataStatistics();
      final dbSize = await _dataService.getDatabaseSize();
      setState(() {
        _statistics = stats;
        _databaseSize = dbSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading statistics: $e'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final consentState = ref.watch(privacyConsentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Data'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Privacy Policy Section
                _buildSection(
                  title: 'Privacy Policy',
                  children: [
                    ListTile(
                      title: const Text('View Privacy Policy'),
                      subtitle: const Text('Read our privacy policy'),
                      leading: const Icon(Icons.policy),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchPrivacyPolicy(context),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Consent Section
                _buildSection(
                  title: 'Data Collection',
                  children: [
                    SwitchListTile(
                      title: const Text('Data Collection Consent'),
                      subtitle: Text(
                        consentState.hasConsented
                            ? 'You have consented to data collection'
                            : 'You have not consented to data collection',
                      ),
                      value: consentState.hasConsented,
                      onChanged: (value) {
                        if (value) {
                          ref
                              .read(privacyConsentProvider.notifier)
                              .grantConsent();
                        } else {
                          _showRevokeConsentDialog(context, ref);
                        }
                      },
                    ),
                    if (consentState.consentDate != null)
                      ListTile(
                        title: const Text('Consent Date'),
                        subtitle: Text(_formatDate(consentState.consentDate!)),
                        leading: const Icon(Icons.calendar_today),
                      ),
                  ],
                ),

                const Divider(height: 32),

                // Data Statistics Section
                _buildSection(
                  title: 'Your Data',
                  children: [
                    ListTile(
                      title: const Text('Feed Formulations'),
                      subtitle: Text('${_statistics['feeds'] ?? 0} saved'),
                      leading: const Icon(Icons.description),
                    ),
                    ListTile(
                      title: const Text('Custom Ingredients'),
                      subtitle: Text(
                          '${_statistics['custom_ingredients'] ?? 0} created'),
                      leading: const Icon(Icons.add_circle),
                    ),
                    ListTile(
                      title: const Text('Database Size'),
                      subtitle: Text(_dataService.formatBytes(_databaseSize)),
                      leading: const Icon(Icons.storage),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Data Management Section
                _buildSection(
                  title: 'Data Management',
                  children: [
                    ListTile(
                      title: const Text('Export Data'),
                      subtitle: const Text('Export all your data as JSON'),
                      leading: const Icon(Icons.download, color: Colors.blue),
                      onTap: () => _exportData(),
                    ),
                    ListTile(
                      title: const Text('Import Data'),
                      subtitle: const Text('Import data from backup file'),
                      leading: const Icon(Icons.upload, color: Colors.green),
                      onTap: () => _importData(),
                    ),
                    ListTile(
                      title: const Text('Delete All Data'),
                      subtitle: const Text('Permanently delete all your data'),
                      leading:
                          const Icon(Icons.delete_forever, color: Colors.red),
                      onTap: () => _showDeleteDataDialog(context),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Your Rights Section
                _buildSection(
                  title: 'Your Rights',
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Under GDPR and other privacy laws, you have the right to:',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 12),
                          _RightItem('Access your data'),
                          _RightItem('Correct your data'),
                          _RightItem('Delete your data'),
                          _RightItem('Export your data'),
                          _RightItem('Withdraw consent'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Future<void> _launchPrivacyPolicy(BuildContext context) async {
    // Privacy policy URL - hosted on GitHub
    const url =
        'https://raw.githubusercontent.com/ebena107/redesigned-feed-app/main/PRIVACY_POLICY.md';

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Privacy policy URL: $url\nPlease update with your actual URL'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  void _showRevokeConsentDialog(BuildContext context, WidgetRef ref) {
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
      // Show loading dialog
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
                    Text('Exporting data...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      final file = await _dataService.exportDataToFile();

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your data has been exported to:'),
                const SizedBox(height: 8),
                Text(
                  file.path,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You can share this file or keep it as a backup.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Import feature: Please select a backup file'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
    // TODO: Implement file picker for import
    // This would require adding file_picker package
  }

  void _showDeleteDataDialog(BuildContext context) {
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
      // Show loading dialog
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
                    Text('Deleting data...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      await _dataService.deleteAllUserData();

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.fixed,
          ),
        );

        // Reload statistics
        await _loadStatistics();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: $e'),
            backgroundColor: Colors.red,
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

class _RightItem extends StatelessWidget {
  final String text;

  const _RightItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
