import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//import 'package:intl/intl.dart';

class AppConstants {
  AppConstants._();
  static const mainAppColor = Color(0xFF229064);
//  static const mainAppColor = const Color(0xFFf4fffc);
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
  static const gradientBackgroundColorStart = Color(0xff26c486);
  static const gradientBackgroundColorEnd = Color(0xFF229064);

  static SystemUiOverlayStyle pagesBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.light : Brightness.dark,
    systemNavigationBarColor:
        Colors.transparent, //bottom navigation bar - android
    systemNavigationBarDividerColor: AppConstants.mainAccentColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle mainBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.light : Brightness.dark,
    systemNavigationBarColor:
        appBackgroundColor, //bottom navigation bar - android
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

//=================DEVICE SIZES ==========================//
Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  // print("H:-  " + MediaQuery.of(context).size.height.toString());
  return MediaQuery.of(context).size.height;
}

double displayWidth(BuildContext context) {
  //print("W:-  " +MediaQuery.of(context).size.width.toString());
  return displaySize(context).width;
}

double widgetPadding(BuildContext context) {
  return 14;
}

TextStyle categoryTextStyle() {
  return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      color: AppConstants.appBackgroundColor);
}

TextStyle titleTextStyle() {
  return const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppConstants.appBackgroundColor,
    fontSize: 34.0,
  );
}

TextStyle menuTextStyle() {
  return const TextStyle(
    fontWeight: FontWeight.w400,
    color: AppConstants.appFontColor,
    fontSize: 16.0,
  );
}

TextStyle gridTitleTextStyle() {
  return const TextStyle(
    fontSize: 15.0,
  );
}

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
    borderRadius: BorderRadius.circular(28),
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
  String name = "";
  if (id != null) {
    switch (id) {
      case 1:
        name = 'assets/images/pig_feed.png';
        break;
      case 2:
        name = 'assets/images/chicken_feed.png';
        break;
      case 3:
        name = 'assets/images/rabbit_feed.png';
        break;
      case 4:
        name = 'assets/images/ruminant_feed.png';
        break;
      case 5:
        name = 'assets/images/fish_feed.png';
        break;
    }
  }

  return name;
}

String animalName({required int? id}) {
  String name = "";
  if (id != null) {
    switch (id) {
      case 1:
        name = 'Pig';
        break;
      case 2:
        name = 'Poultry';
        break;
      case 3:
        name = 'Rabbit';
        break;
      case 4:
        name = 'Ruminants';
        break;
      case 5:
        name = 'Salmonids / Fish';
        break;
    }
  }

  return name;
}
