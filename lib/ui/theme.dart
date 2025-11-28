import 'package:flutter/material.dart';

// Light theme colors
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
  static const overlayColor = Color.fromARGB(255, 245, 254, 255);
  static final overlayContrastColor = Color.lerp(
    overlayColor,
    Colors.black,
    0.9,
  );
  static final overlayBodyColor = primaryBodyColor;
}

// Dark theme colors
class DarkColors {
  static final primaryColor =
      Color.lerp(
        BaseColors.primaryColor,
        Colors.black,
        0.9,
      ) ??
      Color.fromARGB(255, 0, 24, 26);
  static final primaryContrastColor = Color.lerp(
    primaryColor,
    BaseColors.primaryColor,
    0.9,
  );
  static final primaryBodyColor = Color.lerp(
    primaryColor,
    BaseColors.primaryColor,
    0.2,
  );
  static final primaryContainerColor = Color.lerp(
    primaryColor,
    BaseColors.primaryColor,
    0.9,
  );
  static final primaryContainerContrastColor = Color.lerp(
    primaryContainerColor,
    primaryColor,
    0.9,
  );
  static final primaryContainerBodyColor = Color.lerp(
    primaryContainerColor,
    primaryColor,
    0.6,
  );
  static final primaryInverseContainerColor = Color.lerp(
    primaryColor,
    BaseColors.primaryColor,
    0.1,
  );
  static final primaryInverseContainerContrastColor = Color.lerp(
    primaryInverseContainerColor,
    Colors.white,
    0.9,
  );
  static final primaryInverseContainerBodyColor = Color.lerp(
    primaryInverseContainerColor,
    Colors.white,
    0.6,
  );
  static const overlayColor = Color.fromARGB(255, 245, 254, 255);
  static final overlayContrastColor = Color.lerp(
    overlayColor,
    primaryColor,
    0.9,
  );
  static final overlayBodyColor = primaryBodyColor;
}

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
    textTheme: ThemeData(useMaterial3: true).textTheme.apply(
      fontFamily: 'Pixelify',
      displayColor: BaseColors.primaryContrastColor,
      bodyColor: BaseColors.primaryBodyColor,
    ),
    primaryColor: BaseColors.primaryColor,
    scaffoldBackgroundColor: BaseColors.primaryColor,
    cardTheme: CardThemeData(
      color: BaseColors.overlayColor,
      elevation: elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        elevation: WidgetStateProperty.all(elevationSmall),
        backgroundColor: WidgetStateProperty.all(
          BaseColors.primaryInverseContainerColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    menuBarTheme: MenuBarThemeData(
      style: MenuStyle(
        elevation: WidgetStateProperty.all(elevationSmall),
        backgroundColor: WidgetStateProperty.all(
          BaseColors.primaryInverseContainerColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          BaseColors.primaryInverseContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          BaseColors.primaryInverseContainerContrastColor,
        ),
        iconColor: WidgetStateProperty.all(
          BaseColors.primaryInverseContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          BaseColors.primaryContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          BaseColors.primaryContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          BaseColors.primaryContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          BaseColors.primaryContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(BaseColors.primaryBodyColor),
        visualDensity: VisualDensity.compact,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          BaseColors.primaryContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          BaseColors.primaryContainerContrastColor,
        ),
        iconColor: WidgetStateProperty.all(
          BaseColors.primaryContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(borderRadiusMedium),
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      filled: true,
      fillColor: Color.lerp(
        BaseColors.primaryColor,
        Colors.white,
        0.8,
      ),
      floatingLabelStyle: TextStyle(
        color: BaseColors.primaryBodyColor!,
        fontSize: 20,
      ),
      labelStyle: TextStyle(
        color: BaseColors.primaryBodyColor!,
      ),
      iconColor: BaseColors.primaryBodyColor!,
      visualDensity: VisualDensity.compact,
      prefixIconColor: BaseColors.primaryBodyColor!,
      suffixIconColor: BaseColors.primaryBodyColor!,
      helperStyle: TextStyle(
        color: BaseColors.primaryBodyColor!,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
        borderSide: BorderSide(
          color: BaseColors.primaryBodyColor!,
          width: 4,
        ),
      ),
      floatingLabelAlignment: FloatingLabelAlignment.center,
    ),
  );

  static ThemeData get darkThemeData => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: DarkColors.primaryColor),
    textTheme: ThemeData(useMaterial3: true).textTheme.apply(
      fontFamily: 'Pixelify',
      displayColor: DarkColors.primaryContrastColor,
      bodyColor: DarkColors.primaryBodyColor,
    ),
    primaryColor: DarkColors.primaryColor,
    scaffoldBackgroundColor: DarkColors.primaryColor,
    cardTheme: CardThemeData(
      color: DarkColors.overlayColor,
      elevation: elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        elevation: WidgetStateProperty.all(elevationSmall),
        backgroundColor: WidgetStateProperty.all(
          DarkColors.primaryInverseContainerColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    menuBarTheme: MenuBarThemeData(
      style: MenuStyle(
        elevation: WidgetStateProperty.all(elevationSmall),
        backgroundColor: WidgetStateProperty.all(
          DarkColors.primaryInverseContainerColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          DarkColors.primaryInverseContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          DarkColors.primaryInverseContainerContrastColor,
        ),
        iconColor: WidgetStateProperty.all(
          DarkColors.primaryInverseContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          DarkColors.primaryContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          DarkColors.primaryContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          DarkColors.primaryContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          DarkColors.primaryContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(DarkColors.primaryBodyColor),
        visualDensity: VisualDensity.compact,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          DarkColors.primaryContainerColor,
        ),
        foregroundColor: WidgetStateProperty.all(
          DarkColors.primaryContainerContrastColor,
        ),
        iconColor: WidgetStateProperty.all(
          DarkColors.primaryContainerContrastColor,
        ),
        visualDensity: VisualDensity.compact,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(borderRadiusMedium),
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      filled: true,
      fillColor: Color.lerp(
        DarkColors.primaryContainerColor,
        Colors.white,
        0.8,
      ),
      floatingLabelStyle: TextStyle(
        color: DarkColors.primaryBodyColor!,
        fontSize: 20,
      ),
      labelStyle: TextStyle(
        color: DarkColors.primaryBodyColor!,
      ),
      iconColor: DarkColors.primaryBodyColor!,
      visualDensity: VisualDensity.compact,
      prefixIconColor: DarkColors.primaryBodyColor!,
      suffixIconColor: DarkColors.primaryBodyColor!,
      helperStyle: TextStyle(
        color: DarkColors.primaryBodyColor!,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: DarkColors.primaryContrastColor!,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
      floatingLabelAlignment: FloatingLabelAlignment.center,
    ),
  );

  static double get elevationSmall => 2;
  static double get elevationMedium => 4;
  static double get elevationLarge => 6;
  static double get borderRadiusSmall => 4;
  static double get borderRadiusMedium => 8;
  static double get borderRadiusLarge => 16;
  static double get iconSizeSmall => 12;
  static double get iconSizeMedium => 24;
  static double get iconSizeLarge => 48;
}
