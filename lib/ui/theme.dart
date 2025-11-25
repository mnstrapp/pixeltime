import 'package:flutter/material.dart';

class BaseColors {
  static const primaryColor = Color(0xff00f0ff);
  static final primaryContrastColor = Color.lerp(
    primaryColor,
    Colors.white,
    0.9,
  );
  static final primaryBodyColor = Color.lerp(
    primaryColor,
    Colors.black,
    0.6,
  );
  static const primaryContainerColor = Color.fromARGB(255, 0, 74, 80);
  static final primaryContainerContrastColor = Color.lerp(
    primaryContainerColor,
    Colors.white,
    0.9,
  );
  static final primaryContainerBodyColor = Color.lerp(
    primaryContainerColor,
    Colors.black,
    0.6,
  );
  static const primaryInverseContainerColor = Color.fromARGB(
    255,
    168,
    249,
    255,
  );
  static final primaryInverseContainerContrastColor = Color.lerp(
    primaryInverseContainerColor,
    Colors.black,
    0.9,
  );
  static final primaryInverseContainerBodyColor = Color.lerp(
    primaryInverseContainerColor,
    Colors.white,
    0.6,
  );
}

final _baseTheme = ThemeData(useMaterial3: true);
final _baseTextTheme = _baseTheme.textTheme.apply(
  fontFamily: 'Pixelify',
  displayColor: BaseColors.primaryContrastColor,
  bodyColor: BaseColors.primaryBodyColor,
);

class BreakPoints {
  static const tabletBreakpoint = 992;
  static const mobileBreakpoint = 768;
  static const smallMobileMinimumBreakpoint = 300;
  static const smallMobileMaximumBreakpoint = 420;
  static const largeMobileMinimumBreakpoint = 410;
  static const largeMobileMaximumBreakpoint = 480;
  static const foldableMinimumBreakpoint = 850;
  static const foldableMaximumBreakpoint = 900;
  static const tabletMinimumBreakpoint = 900;
  static const tabletMaximumBreakpoint = 1024;
  static const widescreenMinimumBreakpoint = 2560;
}

class BaseTheme {
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff00f0ff)),
    textTheme: _baseTextTheme,
    primaryColor: BaseColors.primaryColor,
    primaryColorDark: Color.lerp(BaseColors.primaryColor, Colors.black, 0.5),
    scaffoldBackgroundColor: BaseColors.primaryColor,
    appBarTheme: AppBarTheme(backgroundColor: BaseColors.primaryColor),
  );

  static double get elevationSmall => 2;
  static double get elevationMedium => 4;
  static double get elevationLarge => 6;
  static double get borderRadiusSmall => 4;
  static double get borderRadiusMedium => 8;
  static double get borderRadiusLarge => 16;
}
