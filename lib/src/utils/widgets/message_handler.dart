import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';

Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
    messageHandlerWidget(
        {required BuildContext context,
        required String? message,
        String? type}) async {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
          message!,
          style: const TextStyle(color: AppConstants.appBackgroundColor),
        ),
        backgroundColor: type == "failure"
            ? Theme.of(context).colorScheme.error
            : type == "success"
                ? Theme.of(context).colorScheme.primary
                : const Color(0xffffbb33)),
  );
}
