import 'dart:async';
import 'dart:io';

import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/privacy/app_with_privacy_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Splash screen shown during app initialization and database migration
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _statusMessage = 'Initializing app...';
  double _progress = 0.0;
  bool _showError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Database initialization
      _updateProgress(0.2, 'Loading database...');
      await Future.delayed(const Duration(milliseconds: 300));

      // Initialize database (runs migrations if needed)
      await AppDatabase().database;
      debugPrint('Database initialized successfully');

      _updateProgress(0.6, 'Preparing features...');
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 2: Load additional resources if needed
      _updateProgress(0.9, 'Ready to go!');
      await Future.delayed(const Duration(milliseconds: 500));

      _updateProgress(1.0, 'Starting app...');

      // Small delay for smooth animation
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        // Navigate to FeedApp with privacy consent check
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ProviderScope(
              child: AppWithPrivacyCheck(),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error during app initialization: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        _showErrorState(e.toString());
      }
    }
  }

  void _updateProgress(double progress, String message) {
    if (mounted) {
      setState(() {
        _progress = progress.clamp(0.0, 1.0);
        _statusMessage = message;
      });
    }
  }

  void _showErrorState(String error) {
    setState(() {
      _showError = true;
      _errorMessage = error;
      _progress = 0.0;
      _statusMessage = 'Initialization Error';
    });
  }

  void _retryInitialization() {
    setState(() {
      _showError = false;
      _errorMessage = '';
      _progress = 0.0;
      _statusMessage = 'Initializing app...';
    });
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.mainAppColor.withValues(alpha: 0.1),
              AppConstants.mainAppColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Center(
          child: _showError ? _buildErrorWidget() : _buildLoadingWidget(),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App Logo/Icon
        ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut),
          ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.mainAppColor.withValues(alpha: 0.1),
            ),
            // child: const Icon(
            //   Icons.agriculture,
            //   size: 40,
            //   color: AppConstants.mainAppColor,
            // ),
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // App Title
        Text(
          'Feed Estimator',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppConstants.mainAppColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 48),

        // Status Message
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ),
        const SizedBox(height: 24),

        // Progress Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppConstants.mainAppColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${(_progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Feature hints
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              _featureHint('Agriculture-standard nutrients'),
              const SizedBox(height: 8),
              _featureHint('Industry-validated ingredients'),
              const SizedBox(height: 8),
              _featureHint('Precise feed calculations'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _featureHint(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16,
          color: AppConstants.mainAppColor.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),

          // Error Title
          Text(
            'Initialization Error',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Error Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.05),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Text(
                _errorMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red[700],
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Error Description
          Text(
            'Failed to initialize the application. This may be due to database issues or corrupted data.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Retry Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _retryInitialization,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppConstants.mainAppColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Exit Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => exit(0),
              icon: const Icon(Icons.close),
              label: const Text('Exit'),
            ),
          ),
        ],
      ),
    );
  }
}
