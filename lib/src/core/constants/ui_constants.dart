import 'package:feed_estimator/src/core/constants/app_dimensions.dart';
import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';

/// Centralized UI constants for consistent design across the app
///
/// Usage:
/// ```dart
/// Container(
///   height: UIConstants.fieldHeight,
///   padding: EdgeInsets.all(UIConstants.paddingMedium),
///   decoration: UIConstants.cardDecoration,
/// );
/// ```
class UIConstants {
  UIConstants._(); // Private constructor

  // ==================== DIMENSIONS ====================

  /// Standard field height for text inputs, buttons, etc.
  static const double fieldHeight = AppDimensions.fieldHeight;

  /// Standard field width for centered forms
  static const double fieldWidth = AppDimensions.fieldWidth;

  /// Minimum tap target size (Material Design guideline)
  static const double minTapTarget = AppDimensions.minTapTarget;

  /// Icon sizes
  static const double iconSizeSmall = AppDimensions.iconSizeSmall;
  static const double iconSizeMedium = AppDimensions.iconSizeMediumCompact;
  static const double iconSizeLarge = AppDimensions.iconSizeLarge;
  static const double iconSizeXLarge =
      AppDimensions.iconSizeMedium; // 24px alias

  // Backwards-compatible aliases
  static const double iconSmall = iconSizeSmall;
  static const double iconMedium = iconSizeMedium;
  static const double iconLarge = iconSizeLarge;
  static const double iconXLarge = iconSizeXLarge;

  /// Avatar sizes
  static const double avatarSizeSmall = AppDimensions.avatarSizeSmall;
  static const double avatarSizeMedium = AppDimensions.avatarSizeMedium;
  static const double avatarSizeLarge = AppDimensions.avatarSizeLarge;

  /// Card/Container standard dimensions
  static const double cardElevation = AppDimensions.cardElevation;
  static const double cardElevationHigh = AppDimensions.cardElevationHigh;

  // ==================== PADDING & MARGINS ====================

  /// Use AppConstants.spacing* for actual values
  /// These are semantic aliases for clarity

  static const double paddingTiny = AppDimensions.paddingExtraSmall;
  static const double paddingSmall = AppDimensions.paddingSmall;
  static const double paddingMedium = AppDimensions.paddingRegular;
  static const double paddingNormal = AppDimensions.paddingMedium;
  static const double paddingLarge = AppDimensions.paddingLarge;
  static const double paddingXLarge = AppDimensions.paddingExtraLarge;
  static const double paddingXXLarge = AppDimensions.paddingXXL;

  // Backwards-compatible EdgeInsets aliases
  static const EdgeInsets paddingSmallHorizontal =
      EdgeInsets.symmetric(horizontal: paddingSmall);
  static const EdgeInsets paddingSmallVertical =
      EdgeInsets.symmetric(vertical: paddingSmall);

  // ==================== BORDER ====================

  /// Border widths
  static const double borderWidthThin = AppDimensions.dividerThickness;
  static const double borderWidthNormal = AppDimensions.strokeWidth;
  static const double borderWidthThick = AppDimensions.strokeWidthMedium;

  /// Border radius - use AppConstants.radius* for actual values

  // ==================== COMMON DECORATIONS ====================

  /// Standard card decoration
  static BoxDecoration cardDecoration({
    Color? color,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? AppConstants.appBackgroundColor,
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppConstants.radiusMedium,
      ),
      border: borderColor != null
          ? Border.all(
              color: borderColor,
              width: borderWidth ?? borderWidthNormal,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: AppConstants.appShadowColor.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Input field border decoration
  static OutlineInputBorder inputBorder({
    Color? color,
    double? width,
    double? radius,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? AppConstants.appBlueColor,
        width: width ?? borderWidthNormal,
      ),
      borderRadius: BorderRadius.circular(radius ?? AppConstants.radiusLarge),
    );
  }

  /// Error border for input fields
  static OutlineInputBorder get errorBorder => OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: borderWidthNormal,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      );

  /// Focused border for input fields
  static OutlineInputBorder focusedBorder({Color? color}) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color ?? AppConstants.appBlueColor,
          width: borderWidthThick,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      );

  /// Container decoration for read-only fields
  static BoxDecoration readOnlyFieldDecoration({
    required Color borderColor,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.grey.shade50,
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      border: Border.all(
        color: borderColor,
        width: borderWidthNormal,
      ),
    );
  }

  // ==================== SHADOWS ====================

  /// Light shadow for cards
  static List<BoxShadow> get lightShadow => [
        BoxShadow(
          color: AppConstants.appShadowColor.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium shadow for elevated elements
  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: AppConstants.appShadowColor.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Heavy shadow for floating action buttons, modals
  static List<BoxShadow> get heavyShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  // ==================== DURATIONS ====================

  /// Animation durations for consistency
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Debounce durations for search/input
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // ==================== OPACITY VALUES ====================

  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityLight = 0.87;
  static const double overlayLight = 0.08;

  // ==================== COMMON PADDING PRESETS ====================

  static const EdgeInsets paddingAllSmall = EdgeInsets.all(paddingSmall);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(paddingMedium);
  static const EdgeInsets paddingAllNormal = EdgeInsets.all(paddingNormal);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(paddingLarge);

  static const EdgeInsets paddingHorizontalSmall =
      EdgeInsets.symmetric(horizontal: paddingSmall);
  static const EdgeInsets paddingHorizontalMedium =
      EdgeInsets.symmetric(horizontal: paddingMedium);
  static const EdgeInsets paddingHorizontalNormal =
      EdgeInsets.symmetric(horizontal: paddingNormal);
  static const EdgeInsets paddingHorizontalLarge =
      EdgeInsets.symmetric(horizontal: paddingLarge);

  static const EdgeInsets paddingVerticalSmall =
      EdgeInsets.symmetric(vertical: paddingSmall);
  static const EdgeInsets paddingVerticalMedium =
      EdgeInsets.symmetric(vertical: paddingMedium);
  static const EdgeInsets paddingVerticalNormal =
      EdgeInsets.symmetric(vertical: paddingNormal);
  static const EdgeInsets paddingVerticalLarge =
      EdgeInsets.symmetric(vertical: paddingLarge);

  // ==================== DIVIDERS ====================

  static const Divider dividerThin = Divider(
    thickness: 1,
    height: 1,
    color: AppConstants.appIconGreyColor,
  );

  static const Divider dividerThick = Divider(
    thickness: 2,
    height: 2,
    color: AppConstants.appIconGreyColor,
  );
}
