import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  String? hint,
  String? errorText,
  String? iconPath,
  IconData? icon,
  String? label,
}) {
  return InputDecoration(
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppConstants.appIconGreyColor)),
    hintText: hint,
    labelText: hint,
    // helperStyle: ,
    errorText: errorText,
    enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppConstants.appIconGreyColor)),
    icon: iconPath == '' || iconPath == null
        ? icon != null
            ? Icon(icon)
            : null
        : Image.asset(iconPath),
    filled: true,
    isDense: true,
    // isCollapsed: true,
    focusColor: AppConstants.appCarrotColor,
  );
}
