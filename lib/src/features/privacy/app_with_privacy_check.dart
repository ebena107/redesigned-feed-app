import 'package:feed_estimator/src/features/privacy/privacy_consent.dart';
import 'package:feed_estimator/src/feed_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrapper that checks privacy consent before showing main app
class AppWithPrivacyCheck extends ConsumerStatefulWidget {
  const AppWithPrivacyCheck({super.key});

  @override
  ConsumerState<AppWithPrivacyCheck> createState() =>
      _AppWithPrivacyCheckState();
}

class _AppWithPrivacyCheckState extends ConsumerState<AppWithPrivacyCheck> {
  bool _hasCheckedConsent = false;

  @override
  void initState() {
    super.initState();
    // Check consent after state loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForLoadAndCheck();
    });
  }

  Future<void> _waitForLoadAndCheck() async {
    // Wait for consent state to finish loading from SharedPreferences
    while (ref.read(privacyConsentProvider).isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    // Small additional delay to ensure everything is ready
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      _checkPrivacyConsent();
    }
  }

  void _checkPrivacyConsent() {
    // Prevent multiple checks
    if (_hasCheckedConsent) return;

    final consentState = ref.read(privacyConsentProvider);

    debugPrint(
        'Checking privacy consent: isLoading=${consentState.isLoading}, hasSeenDialog=${consentState.hasSeenDialog}');

    // Show dialog only if user hasn't seen it yet and loading is complete
    if (!consentState.isLoading && !consentState.hasSeenDialog) {
      _hasCheckedConsent = true;
      debugPrint('Showing privacy dialog');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PrivacyConsentDialog(),
      );
    } else {
      _hasCheckedConsent = true;
      debugPrint('Privacy dialog not shown: already seen or still loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const FeedApp();
  }
}
