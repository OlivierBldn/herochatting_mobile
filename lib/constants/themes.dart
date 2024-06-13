// lib/constants/themes.dart

import 'package:flutter/material.dart';
import 'colors.dart';

// Define the light and dark themes
// The light theme is the default theme
final ThemeData lightTheme = ThemeData(
  primaryColor: AppColor.hBlue,
  scaffoldBackgroundColor: AppColor.hWhite,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.hWhite,
    titleTextStyle: TextStyle(color: AppColor.hBlack, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: AppColor.hGreyDark),
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColor.hBlue,
    secondary: AppColor.hBlueLight,
    background: AppColor.hGreyLight,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColor.hBlack),
    bodyMedium: TextStyle(color: AppColor.hGreyDark),
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: AppColor.hBlue,
  scaffoldBackgroundColor: AppColor.hBlack,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.hGreyDark,
    titleTextStyle: TextStyle(color: AppColor.hWhite, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: AppColor.hGreyLight),
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColor.hBlue,
    secondary: AppColor.hBlueLight,
    background: AppColor.hGreyDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColor.hWhite),
    bodyMedium: TextStyle(color: AppColor.hGreyLight),
  ),
);