import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Privacy consent state provider
final privacyConsentProvider =
    StateNotifierProvider<PrivacyConsentNotifier, PrivacyConsentState>((ref) {
  return PrivacyConsentNotifier();
});

/// Privacy consent state
class PrivacyConsentState {
  final bool hasConsented;
  final bool hasSeenDialog;
  final DateTime? consentDate;
  final bool isLoading;

  const PrivacyConsentState({
    this.hasConsented = false,
    this.hasSeenDialog = false,
    this.consentDate,
    this.isLoading = true,
  });

  PrivacyConsentState copyWith({
    bool? hasConsented,
    bool? hasSeenDialog,
    DateTime? consentDate,
    bool? isLoading,
  }) {
    return PrivacyConsentState(
      hasConsented: hasConsented ?? this.hasConsented,
      hasSeenDialog: hasSeenDialog ?? this.hasSeenDialog,
      consentDate: consentDate ?? this.consentDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Privacy consent notifier
class PrivacyConsentNotifier extends StateNotifier<PrivacyConsentState> {
  PrivacyConsentNotifier() : super(const PrivacyConsentState(isLoading: true)) {
    _loadConsentState();
  }

  static const String _consentKey = 'privacy_consent';
  static const String _consentDateKey = 'privacy_consent_date';
  static const String _seenDialogKey = 'privacy_seen_dialog';

  Future<void> _loadConsentState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasConsented = prefs.getBool(_consentKey) ?? false;
      final hasSeenDialog = prefs.getBool(_seenDialogKey) ?? false;
      final consentDateMs = prefs.getInt(_consentDateKey);

      state = PrivacyConsentState(
        hasConsented: hasConsented,
        hasSeenDialog: hasSeenDialog,
        consentDate: consentDateMs != null
            ? DateTime.fromMillisecondsSinceEpoch(consentDateMs)
            : null,
        isLoading: false,
      );

      debugPrint(
          'Privacy consent loaded: hasSeenDialog=$hasSeenDialog, hasConsented=$hasConsented');
    } catch (e) {
      debugPrint('Error loading privacy consent: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> grantConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await prefs.setBool(_consentKey, true);
    await prefs.setBool(_seenDialogKey, true);
    await prefs.setInt(_consentDateKey, now.millisecondsSinceEpoch);

    state = state.copyWith(
      hasConsented: true,
      hasSeenDialog: true,
      consentDate: now,
    );
  }

  Future<void> revokeConsent() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_consentKey, false);
    await prefs.remove(_consentDateKey);

    state = state.copyWith(
      hasConsented: false,
      consentDate: null,
    );
  }

  Future<void> markDialogSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenDialogKey, true);

    state = state.copyWith(hasSeenDialog: true);
  }
}

/// Privacy consent dialog
class PrivacyConsentDialog extends ConsumerWidget {
  const PrivacyConsentDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Privacy & Data Usage'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Feed Estimator!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We value your privacy. Here\'s how we handle your data:',
            ),
            const SizedBox(height: 12),
            _buildBulletPoint('All data is stored locally on your device'),
            _buildBulletPoint('No data is shared with third parties'),
            _buildBulletPoint('No internet connection required'),
            _buildBulletPoint('You can delete your data at any time'),
            const SizedBox(height: 16),
            const Text(
              'Data we store:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Feed formulations you create'),
            _buildBulletPoint('Custom ingredients you add'),
            _buildBulletPoint('App preferences and settings'),
            const SizedBox(height: 16),
            const Text(
              'By continuing, you agree to our data practices as described in our Privacy Policy.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _launchPrivacyPolicy(context),
          child: const Text('Privacy Policy'),
        ),
        TextButton(
          onPressed: () {
            ref.read(privacyConsentProvider.notifier).markDialogSeen();
            Navigator.of(context).pop();
          },
          child: const Text('Decline'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(privacyConsentProvider.notifier).grantConsent();
            Navigator.of(context).pop();
          },
          child: const Text('Accept'),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Future<void> _launchPrivacyPolicy(BuildContext context) async {
    // Privacy policy URL - hosted on GitHub
    const url =
        'https://raw.githubusercontent.com/ebena107/redesigned-feed-app/main/PRIVACY_POLICY.md';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy policy URL not configured'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }
}

/// Privacy settings screen
class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentState = ref.watch(privacyConsentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('View our privacy policy'),
            leading: const Icon(Icons.policy),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _launchPrivacyPolicy(context),
          ),
          const Divider(),
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
                ref.read(privacyConsentProvider.notifier).grantConsent();
              } else {
                _showRevokeConsentDialog(context, ref);
              }
            },
          ),
          if (consentState.consentDate != null)
            ListTile(
              title: const Text('Consent Date'),
              subtitle: Text(
                _formatDate(consentState.consentDate!),
              ),
              leading: const Icon(Icons.calendar_today),
            ),
          const Divider(),
          ListTile(
            title: const Text('Delete All Data'),
            subtitle: const Text(
                'Permanently delete all your feed formulations and settings'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () => _showDeleteDataDialog(context),
          ),
          const Divider(),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Export your data as CSV'),
            leading: const Icon(Icons.download),
            onTap: () {
              // Data export is implemented in Settings > Import/Export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please use Settings > Import/Export for data export'),
                  behavior: SnackBarBehavior.fixed,
                ),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                    'Under GDPR and other privacy laws, you have the right to:'),
                SizedBox(height: 8),
                Text('• Access your data'),
                Text('• Correct your data'),
                Text('• Delete your data'),
                Text('• Export your data'),
                Text('• Withdraw consent'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPrivacyPolicy(BuildContext context) async {
    const url =
        'https://raw.githubusercontent.com/ebena107/redesigned-feed-app/main/PRIVACY_POLICY.md';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy policy URL not configured'),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
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

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'Are you sure you want to delete all your data? '
          'This action cannot be undone.',
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
            onPressed: () {
              // Data deletion is implemented in Settings > Delete All Data
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please use Settings > Delete All Data for data deletion'),
                  behavior: SnackBarBehavior.fixed,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
