import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//=================APP CONSTANTS==========================//

class AppConstants {
  AppConstants._();

  // Color Palette
  static const mainAppColor = Color(0xFF229064);
  static const mainAccentColor = Color(0xff26c486);
  static const appBackgroundColor = Color(0xFFf4fffc);
  static const appFontColor = Color(0xFF311436);
  static const appAccentFontColor = Color(0xFFf4fffc);
  static const appIconGreyColor = Color(0xFF63768d);
  static const appHintColor = Color(0xFF311436);
  static const appCarrotColor = Color(0xffff6d00);
  static const appBlueColor = Color(0xff2962ff);
  static const appGreenColor = Color(0xff50c878);
  static const appShadowColor = Color(0xffE2FBF0);

  // Gradient Colors
  static const gradientBackgroundColorStart = Color(0xff26c486);
  static const gradientBackgroundColorEnd = Color(0xFF229064);
  static const gradientPurpleStart = Color(0xFF9C27B0); // Deep Purple
  static const gradientPurpleEnd = Color(0xFFBA68C8); // Purple Accent
  static const gradientBrownStart = Color(0xff87643E);
  static const gradientBrownEnd = Color(0xffA0826D);

  // Spacing Constants (8px base grid)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Responsive layout
  static const double mobileLayoutMaxWidth = 720.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusRound = 28.0;

  // Android 15+ edge-to-edge: Removed deprecated color properties
  // (statusBarColor, systemNavigationBarColor, systemNavigationBarDividerColor)
  static SystemUiOverlayStyle pagesBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.light : Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  // Android 15+ edge-to-edge: Removed deprecated color properties
  // (statusBarColor, systemNavigationBarColor, systemNavigationBarDividerColor)
  static SystemUiOverlayStyle mainBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.light : Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

//=================DEVICE SIZES ==========================//
Size displaySize(BuildContext context) {
  return MediaQuery.sizeOf(context);
}

double displayHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

bool isCompactLayout(BuildContext context) {
  return displayWidth(context) <= AppConstants.mobileLayoutMaxWidth;
}

//=================CONSOLIDATED TEXT STYLES (Material 3)==========================//

/// Display style - Large titles (34px)
TextStyle displayTextStyle() {
  return const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: AppConstants.appBackgroundColor,
    height: 1.2,
  );
}

/// Headline style - Section headers (24px)
TextStyle headlineTextStyle({Color? color}) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color ?? AppConstants.appBackgroundColor,
    height: 1.2,
  );
}

/// Title style - Card titles, important text (20px)
TextStyle titleTextStyle({Color? color, FontWeight? weight}) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: weight ?? FontWeight.w500,
    color: color ?? AppConstants.appFontColor,
    height: 1.3,
  );
}

/// Body style - Main content (16px)
TextStyle bodyTextStyle({Color? color, FontWeight? weight}) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: weight ?? FontWeight.w400,
    color: color ?? AppConstants.appFontColor,
    height: 1.5,
  );
}

/// Label style - Form labels, buttons (14px)
TextStyle labelTextStyle({Color? color, FontWeight? weight}) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: weight ?? FontWeight.w500,
    color: color ?? AppConstants.appFontColor,
    height: 1.4,
  );
}

/// Caption style - Timestamps, metadata (12px)
TextStyle captionTextStyle({Color? color}) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppConstants.appIconGreyColor,
    height: 1.3,
  );
}

//=================LEGACY STYLES (Deprecated - Use above instead)==========================//

@Deprecated('Use displayTextStyle() instead')
TextStyle appTitleStyle(context) {
  return displayTextStyle().copyWith(
    fontSize: displayHeight(context) * .05,
    shadows: const [
      Shadow(
        color: Color(0xff04b45c),
        offset: Offset(0, 3),
        blurRadius: 6,
      )
    ],
  );
}

@Deprecated('Use headlineTextStyle() instead')
TextStyle sideBarTitleStyle() {
  return headlineTextStyle();
}

@Deprecated('Use bodyTextStyle() instead')
TextStyle menuTextStyle() {
  return bodyTextStyle();
}

@Deprecated('Use labelTextStyle() instead')
TextStyle categoryTextStyle() {
  return labelTextStyle(color: AppConstants.appBackgroundColor);
}

//=================UTILITY FUNCTIONS==========================//

int currentTimeInSecond() {
  var now = DateTime.now();
  var ms = now.millisecondsSinceEpoch;
  return ms;
}

String secondToDate(int? seconds) {
  final myDate = DateTime.fromMillisecondsSinceEpoch(seconds!);
  final d = DateFormat("dd-MM-yyyy").format(myDate);
  return d;
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppConstants.radiusRound),
    borderSide: const BorderSide(color: AppConstants.appFontColor),
    gapPadding: 10,
  );

  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 35,
      vertical: 10,
    ),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

String feedImage({required int? id}) {
  if (id == null) {
    return 'assets/images/ruminant_feed.png'; // Default fallback
  }

  switch (id) {
    case 1:
      return 'assets/images/pig_feed.png';
    case 2:
      return 'assets/images/chicken_feed.png';
    case 3:
      return 'assets/images/rabbit_feed.png';
    case 4: // Dairy Cattle
    case 5: // Beef Cattle
    case 6: // Sheep
    case 7: // Goat
      return 'assets/images/ruminant_feed.png';
    case 8: // Tilapia
    case 9: // Catfish
      return 'assets/images/fish_feed.png';
    default:
      return 'assets/images/ruminant_feed.png'; // Safe default
  }
}

String animalName({required int? id}) {
  if (id == null) {
    return 'Unknown'; // Default fallback
  }

  switch (id) {
    case 1:
      return 'Pig';
    case 2:
      return 'Poultry';
    case 3:
      return 'Rabbit';
    case 4:
      return 'Dairy Cattle';
    case 5:
      return 'Beef Cattle';
    case 6:
      return 'Sheep';
    case 7:
      return 'Goat';
    case 8:
      return 'Fish (Tilapia)';
    case 9:
      return 'Fish (Catfish)';
    default:
      return 'Unknown';
  }
}
