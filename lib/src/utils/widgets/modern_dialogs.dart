import 'package:flutter/material.dart';

/// Modern, consistent dialog components for the app
///
/// Provides standardized dialogs with:
/// - Semantic icons and colors
/// - Consistent button styles
/// - Professional Material 3 design
/// - Clear visual hierarchy

/// Base modern alert dialog with consistent styling
class ModernAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget>? actions;
  final Widget? content;

  const ModernAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.actions,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: icon != null
          ? Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text(title)),
              ],
            )
          : Text(title),
      content: content ??
          Text(
            message,
            style: const TextStyle(fontSize: 15),
          ),
      actions: actions,
    );
  }
}

/// Success dialog with green checkmark
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final Widget? content;

  const SuccessDialog({
    super.key,
    this.title = 'Success',
    required this.message,
    this.primaryButtonText = 'Done',
    this.onPrimaryPressed,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ModernAlertDialog(
      title: title,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green[600],
      content: content,
      actions: [
        FilledButton(
          onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
          child: Text(primaryButtonText!),
        ),
      ],
    );
  }

  /// Show success dialog
  static Future<void> show(
    BuildContext context, {
    String title = 'Success',
    required String message,
    String primaryButtonText = 'Done',
    VoidCallback? onPrimaryPressed,
    Widget? content,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        content: content,
      ),
    );
  }
}

/// Error dialog with red error icon
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.primaryButtonText = 'OK',
    this.onPrimaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ModernAlertDialog(
      title: title,
      message: message,
      icon: Icons.error,
      iconColor: Colors.red[600],
      actions: [
        FilledButton(
          onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red[600],
          ),
          child: Text(primaryButtonText!),
        ),
      ],
    );
  }

  /// Show error dialog
  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String primaryButtonText = 'OK',
    VoidCallback? onPrimaryPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
      ),
    );
  }
}

/// Confirmation dialog with warning icon for destructive actions
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModernAlertDialog(
      title: title,
      message: message,
      icon: isDestructive ? Icons.warning : Icons.help_outline,
      iconColor: isDestructive ? Colors.orange[600] : Colors.blue[600],
      actions: [
        OutlinedButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: Colors.red[600],
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show confirmation dialog and return result
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }
}

/// Info dialog with blue info icon
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final Widget? content;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText = 'OK',
    this.onPrimaryPressed,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ModernAlertDialog(
      title: title,
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue[600],
      content: content,
      actions: [
        FilledButton(
          onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
          child: Text(primaryButtonText!),
        ),
      ],
    );
  }

  /// Show info dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String primaryButtonText = 'OK',
    VoidCallback? onPrimaryPressed,
    Widget? content,
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        content: content,
      ),
    );
  }
}

/// Loading dialog with centered spinner
class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  /// Show loading dialog
  static void show(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Hide loading dialog
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
