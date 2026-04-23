import 'package:flutter/material.dart';

/// App Theme Constants
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============== Fonts ==============
  static const String fontFamily = 'OpenSans';

  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeHeading = 24.0;
  static const double fontSizeTitle = 28.0;

  // ============== Colors ==============
  static const Color primaryColor = Color(0xFF25AFF4);
  static const Color primaryDark = Color(0xFF1A7BA8);
  static const Color primaryLight = Color(0xFF5FD4F0);

  static const Color secondaryColor = Color(0xFFFF6B35);
  static const Color secondaryDark = Color(0xFFC9520D);
  static const Color secondaryLight = Color(0xFFFFAA66);

  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color infoColor = Color(0xFF3498DB);

  // ============== Text Colors ==============
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textHintColor = Color(0xFFBDBDBD);
  static const Color textDisabledColor = Color(0xFFE0E0E0);

  // ============== Border Radius ==============
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  static const double borderRadiusCircular = 50.0;

  static const Radius radiusSmall = Radius.circular(borderRadiusSmall);
  static const Radius radiusMedium = Radius.circular(borderRadiusMedium);
  static const Radius radiusLarge = Radius.circular(borderRadiusLarge);
  static const Radius radiusXLarge = Radius.circular(borderRadiusXLarge);
  static const Radius radiusCircular = Radius.circular(borderRadiusCircular);

  // ============== Border ==============
  static const double borderWidth = 1.0;
  static const double borderWidthThick = 2.0;

  static const Border borderDefault = Border(
    top: BorderSide(color: textHintColor, width: borderWidth),
    bottom: BorderSide(color: textHintColor, width: borderWidth),
    left: BorderSide(color: textHintColor, width: borderWidth),
    right: BorderSide(color: textHintColor, width: borderWidth),
  );

  // ============== Padding & Spacing ==============
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;
  static const double spacingHuge = 32.0;

  // ============== Elevation & Shadows ==============
  static const double elevationSmall = 1.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;

  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 1.0,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ];

  // ============== Icon Sizes ==============
  static const double iconSizeXSmall = 16.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // ============== Button Sizes ==============
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 52.0;

  static const double buttonWidthSmall = 80.0;
  static const double buttonWidthMedium = 100.0;
  static const double buttonWidthLarge = 120.0;

  // ============== Input & Form ==============
  static const double inputBorderRadius = borderRadiusMedium;
  static const double inputHeight = 48.0;
  static const double textFieldPadding = spacingMedium;

  // ============== Opacity ==============
  static const double opacityDisabled = 0.5;
  static const double opacityHover = 0.8;
  static const double opacityFull = 1.0;

  // ============== Duration & Animation ==============
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 600);

  // ============== Text Styles ==============
  static const TextStyle headingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeHeading,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle titleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXXLarge,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXLarge,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
  );

  static const TextStyle bodySmallStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  // ============== Theme Data ==============
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: elevationSmall,
        centerTitle: true,
        titleTextStyle: headingStyle.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: bodyStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: borderWidth),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.all(textFieldPadding),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: textHintColor, width: borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: textHintColor, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: primaryColor, width: borderWidthThick),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: errorColor, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: errorColor, width: borderWidthThick),
        ),
        hintStyle: bodySmallStyle,
        labelStyle: labelStyle,
        errorStyle: captionStyle.copyWith(color: errorColor),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: elevationMedium,
        shape: const CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(
        color: textHintColor,
        thickness: borderWidth,
        space: spacingLarge,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: surfaceColor,
        outline: textHintColor,
      ),
    );
  }
}
