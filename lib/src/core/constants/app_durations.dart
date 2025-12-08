/// Centralized application durations and animation timings
///
/// Maintains consistent timing across animations, transitions, and delays.
/// This ensures a cohesive user experience and makes timing adjustments easier.
abstract class AppDurations {
  // Micro Animations (very quick feedback)
  static const Duration rapidFeedback = Duration(milliseconds: 100);
  static const Duration quickFeedback = Duration(milliseconds: 150);

  // Standard Transitions
  static const Duration transitionFast = Duration(milliseconds: 200);
  static const Duration transitionNormal = Duration(milliseconds: 300);
  static const Duration transitionSlow = Duration(milliseconds: 400);
  static const Duration transitionExtraSlow = Duration(milliseconds: 500);

  // Page Transitions
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration pageTransitionSlow = Duration(milliseconds: 500);

  // Route Animations
  static const Duration routeAnimation = Duration(milliseconds: 350);
  static const Duration routeAnimationSlow = Duration(milliseconds: 500);

  // Dialog Animations
  static const Duration dialogEnter = Duration(milliseconds: 200);
  static const Duration dialogExit = Duration(milliseconds: 150);

  // Bottom Sheet
  static const Duration bottomSheetEnter = Duration(milliseconds: 250);
  static const Duration bottomSheetExit = Duration(milliseconds: 200);

  // Fade Animations
  static const Duration fadeIn = Duration(milliseconds: 200);
  static const Duration fadeOut = Duration(milliseconds: 150);

  // Scale Animations
  static const Duration scaleAnimation = Duration(milliseconds: 250);

  // Slide Animations
  static const Duration slideAnimation = Duration(milliseconds: 300);
  static const Duration slideAnimationFast = Duration(milliseconds: 200);

  // Splash/Ripple Effect
  static const Duration splashEffect = Duration(milliseconds: 400);

  // Loading Indicators
  static const Duration loadingPulse = Duration(milliseconds: 1500);
  static const Duration loadingRotation = Duration(milliseconds: 1200);
  static const Duration loadingBounce = Duration(milliseconds: 1000);

  // Snackbar/Toast
  static const Duration snackbarDuration = Duration(milliseconds: 4000);
  static const Duration snackbarShow = Duration(milliseconds: 200);
  static const Duration snackbarHide = Duration(milliseconds: 200);

  // Tooltip
  static const Duration tooltipWait = Duration(milliseconds: 500);
  static const Duration tooltipShow = Duration(milliseconds: 200);

  // Debounce/Throttle
  static const Duration debounceSearch = Duration(milliseconds: 500);
  static const Duration debounceInput = Duration(milliseconds: 300);
  static const Duration throttleScroll = Duration(milliseconds: 16); // ~60 FPS

  // Network Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration networkTimeoutShort = Duration(seconds: 10);
  static const Duration networkTimeoutLong = Duration(seconds: 60);

  // Database Operations
  static const Duration databaseTimeout = Duration(seconds: 10);
  static const Duration databaseRetry = Duration(milliseconds: 500);

  // Polling Intervals
  static const Duration pollingFrequent = Duration(milliseconds: 1000);
  static const Duration pollingNormal = Duration(seconds: 5);
  static const Duration pollingLow = Duration(seconds: 30);

  // Refresh/Sync
  static const Duration autoRefresh = Duration(seconds: 30);
  static const Duration syncInterval = Duration(minutes: 5);

  // Delays (UX)
  static const Duration delayMinimal = Duration(milliseconds: 100);
  static const Duration delaySmall = Duration(milliseconds: 200);
  static const Duration delayMedium = Duration(milliseconds: 500);
  static const Duration delayLarge = Duration(seconds: 1);

  // Animation Curves (used with durations)
  // Note: Curves are defined in a separate constant, these are timing durations

  // Scroll Physics
  static const Duration scrollDecelerationDuration =
      Duration(milliseconds: 400);

  // Keyboard
  static const Duration keyboardOpenDuration = Duration(milliseconds: 200);
  static const Duration keyboardCloseDuration = Duration(milliseconds: 200);

  // System
  static const Duration appInitializationTimeout = Duration(seconds: 10);
  static const Duration appResumeDuration = Duration(milliseconds: 100);

  // Haptic Feedback
  static const Duration hapticDuration = Duration(milliseconds: 50);

  // Video/Media
  static const Duration videoLoadTimeout = Duration(seconds: 30);
  static const Duration mediaBufferingTimeout = Duration(seconds: 15);

  // Batch Operations
  static const Duration batchOperationDelay = Duration(milliseconds: 100);
  static const Duration batchOperationTimeout = Duration(minutes: 5);

  // Retry Logic
  static const Duration retryDelayInitial = Duration(milliseconds: 500);
  static const Duration retryDelayMax = Duration(seconds: 30);
  static const int retryAttempts = 3;

  // Keep Alive (for caching)
  static const Duration keepAliveShort = Duration(minutes: 5);
  static const Duration keepAliveMedium = Duration(minutes: 15);
  static const Duration keepAliveLong = Duration(hours: 1);

  // Notification
  static const Duration notificationDisplay = Duration(seconds: 5);
  static const Duration notificationAnimation = Duration(milliseconds: 300);

  // Gesture Recognition
  static const Duration longPressInterval = Duration(milliseconds: 500);
  static const Duration doubleTapInterval = Duration(milliseconds: 300);
}

/// Curve constants for animations
///
/// Provides consistent easing functions for smooth animations.
/// Uses Flutter's standard curves or custom bezier curves.
abstract class AppCurves {
  // Standard Flutter Curves (reference)
  // - Curves.linear: constant velocity
  // - Curves.easeIn: starts slowly, accelerates
  // - Curves.easeOut: starts fast, decelerates
  // - Curves.easeInOut: eases in and out
  // - Curves.elasticIn: bouncy ease in
  // - Curves.elasticOut: bouncy ease out
  // - Curves.bounceIn: bounces at start
  // - Curves.bounceOut: bounces at end
  // - Curves.decelerate: starts fast, decelerates

  // Documentation:
  // Recommended curves for:
  // - Page transitions: easeInOut
  // - Dialog animations: easeOut
  // - Loading indicators: linear
  // - Interactive elements: easeInOut
  // - Dismissal animations: easeIn
}
