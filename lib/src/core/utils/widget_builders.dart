import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Centralized widget builders for consistent UI across the app
///
/// Usage:
/// ```dart
/// Widget myField = WidgetBuilders.buildTextField(
///   label: 'Feed Name',
///   hint: 'e.g., Broiler Starter',
///   controller: _controller,
/// );
/// ```
class WidgetBuilders {
  WidgetBuilders._(); // Private constructor

  // ==================== TEXT FIELDS ====================

  /// Build a standard text field with consistent styling
  static Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? errorText,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool enabled = true,
    bool readOnly = false,
    TextAlign textAlign = TextAlign.start,
    int? maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: UIConstants.inputBorder(),
        focusedBorder: UIConstants.focusedBorder(),
        errorBorder: UIConstants.errorBorder,
        enabledBorder: UIConstants.inputBorder(
          color: AppConstants.appIconGreyColor.withValues(alpha: 0.5),
        ),
        disabledBorder: UIConstants.inputBorder(
          color: AppConstants.appIconGreyColor.withValues(alpha: 0.3),
        ),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Build a read-only display field (for edit mode)
  static Widget buildReadOnlyField({
    required String value,
    required Color borderColor,
    Widget? icon,
    double? height,
  }) {
    return Container(
      padding: UIConstants.paddingHorizontalNormal.add(
        UIConstants.paddingVerticalMedium,
      ),
      height: height ?? UIConstants.fieldHeight,
      decoration: UIConstants.readOnlyFieldDecoration(borderColor: borderColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppConstants.appFontColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: UIConstants.paddingSmall),
            icon,
          ],
        ],
      ),
    );
  }

  // ==================== BUTTONS ====================

  /// Build a primary elevated button
  static Widget buildPrimaryButton({
    required String label,
    required VoidCallback? onPressed,
    Widget? icon,
    bool isLoading = false,
    Color? backgroundColor,
    Color? foregroundColor,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height ?? UIConstants.fieldHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppConstants.mainAppColor,
          foregroundColor: foregroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          elevation: UIConstants.cardElevation,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon,
                      const SizedBox(width: UIConstants.paddingSmall),
                      Text(label),
                    ],
                  )
                : Text(label),
      ),
    );
  }

  /// Build an outlined button
  static Widget buildOutlinedButton({
    required String label,
    required VoidCallback? onPressed,
    Widget? icon,
    Color? borderColor,
    Color? foregroundColor,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height ?? UIConstants.fieldHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppConstants.appBlueColor,
          side: BorderSide(
            color: borderColor ?? AppConstants.appBlueColor,
            width: UIConstants.borderWidthNormal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(width: UIConstants.paddingSmall),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }

  // ==================== CARDS ====================

  /// Build a standard card with consistent styling
  static Widget buildCard({
    required Widget child,
    Color? color,
    Color? borderColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? elevation,
    VoidCallback? onTap,
  }) {
    final content = Container(
      padding: padding ?? UIConstants.paddingAllNormal,
      decoration: UIConstants.cardDecoration(
        color: color,
        borderColor: borderColor,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: content,
      );
    }

    return Card(
      margin: margin ?? UIConstants.paddingAllSmall,
      elevation: elevation ?? UIConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: content,
    );
  }

  // ==================== LOADING INDICATORS ====================

  /// Build a centered loading indicator
  static Widget buildLoadingIndicator({
    String? message,
    Color? color,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppConstants.mainAppColor,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: UIConstants.paddingNormal),
            Text(
              message,
              style: const TextStyle(
                color: AppConstants.appIconGreyColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== EMPTY STATES ====================

  /// Build an empty state widget
  static Widget buildEmptyState({
    required String message,
    Widget? icon,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: UIConstants.paddingAllLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(height: UIConstants.paddingNormal),
            ],
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppConstants.appIconGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: UIConstants.paddingLarge),
              action,
            ],
          ],
        ),
      ),
    );
  }

  // ==================== ERROR STATES ====================

  /// Build an error state widget
  static Widget buildErrorState({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: UIConstants.paddingAllLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: UIConstants.paddingNormal),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppConstants.appFontColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: UIConstants.paddingLarge),
              buildPrimaryButton(
                label: 'Retry',
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== DIVIDERS ====================

  /// Build a section divider with optional label
  static Widget buildSectionDivider({String? label}) {
    if (label == null) {
      return UIConstants.dividerThin;
    }

    return Row(
      children: [
        const Expanded(child: UIConstants.dividerThin),
        Padding(
          padding: UIConstants.paddingHorizontalMedium,
          child: Text(
            label,
            style: const TextStyle(
              color: AppConstants.appIconGreyColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: UIConstants.dividerThin),
      ],
    );
  }
}
