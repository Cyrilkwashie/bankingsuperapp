import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the enterprise banking application.
/// Implements Contemporary Financial Minimalism design style with Professional Depth Palette.
class AppTheme {
  AppTheme._();

  // Primary Brand Colors - Professional Depth Palette
  static const Color primaryNavyLight = Color(0xFF1B365D);
  static const Color secondaryTealLight = Color(0xFF2E8B8B);
  static const Color backgroundLightColor = Color(0xFFFAFBFC);
  static const Color surfaceWhiteLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1D23);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // Dark Mode Colors
  static const Color primaryNavyDark = Color(0xFF2E5A8F);
  static const Color secondaryTealDark = Color(0xFF3FA5A5);
  static const Color backgroundDarkColor = Color(0xFF0F1419);
  static const Color surfaceWhiteDark = Color(0xFF1E2328);
  static const Color textPrimaryDark = Color(0xFFFAFBFC);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Status Colors - Universal across themes
  static const Color successGreen = Color(0xFF059669);
  static const Color warningAmber = Color(0xFFD97706);
  static const Color errorRed = Color(0xFFDC2626);

  // Semantic Colors
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onSuccessLight = Color(0xFFFFFFFF);

  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onErrorDark = Color(0xFFFFFFFF);
  static const Color onSuccessDark = Color(0xFFFFFFFF);

  // Border and Divider Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // Shadow Colors - Subtle elevation (2-4dp with 0.08 opacity)
  static const Color shadowLight = Color(0x14000000); // 0.08 opacity
  static const Color shadowDark = Color(0x14FFFFFF); // 0.08 opacity

  // Text Emphasis Levels
  static const Color textHighEmphasisLight = Color(0xFF1A1D23);
  static const Color textMediumEmphasisLight = Color(0xFF6B7280);
  static const Color textDisabledLight = Color(0x611A1D23); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xFFFAFBFC);
  static const Color textMediumEmphasisDark = Color(0xFF9CA3AF);
  static const Color textDisabledDark = Color(0x61FAFBFC); // 38% opacity

  /// Light theme - Contemporary Financial Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryNavyLight,
      onPrimary: onPrimaryLight,
      primaryContainer: primaryNavyLight,
      onPrimaryContainer: onPrimaryLight,
      secondary: secondaryTealLight,
      onSecondary: onSecondaryLight,
      secondaryContainer: secondaryTealLight,
      onSecondaryContainer: onSecondaryLight,
      tertiary: secondaryTealLight,
      onTertiary: onSecondaryLight,
      tertiaryContainer: secondaryTealLight,
      onTertiaryContainer: onSecondaryLight,
      error: errorRed,
      onError: onErrorLight,
      surface: surfaceWhiteLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: borderLight,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: backgroundDarkColor,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryNavyDark,
    ),
    scaffoldBackgroundColor: backgroundLightColor,
    cardColor: surfaceWhiteLight,
    dividerColor: dividerLight,

    // AppBar Theme - Clean professional header
    appBarTheme: AppBarThemeData(
      backgroundColor: surfaceWhiteLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      shadowColor: shadowLight,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
    ),

    // Card Theme - Subtle elevation for content separation
    cardTheme: CardThemeData(
      color: surfaceWhiteLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation - Hub-and-Spoke pattern support
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceWhiteLight,
      selectedItemColor: primaryNavyLight,
      unselectedItemColor: textMediumEmphasisLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryTealLight,
      foregroundColor: onSecondaryLight,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    // Elevated Button - Primary actions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryLight,
        backgroundColor: primaryNavyLight,
        disabledForegroundColor: textDisabledLight,
        disabledBackgroundColor: borderLight,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 56), // Enhanced touch target
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Outlined Button - Secondary actions
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryNavyLight,
        disabledForegroundColor: textDisabledLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 56),
        side: const BorderSide(color: primaryNavyLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button - Tertiary actions
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryNavyLight,
        disabledForegroundColor: textDisabledLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Theme - Inter font family with banking-appropriate hierarchy
    textTheme: _buildTextTheme(isLight: true),

    // Input Decoration - Contextual Floating Labels pattern
    inputDecorationTheme: InputDecorationThemeData(
      fillColor: surfaceWhiteLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // Default border - minimal 1px
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),

      // Enabled border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),

      // Focused border - primary navy for clear interaction state
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryNavyLight, width: 2.0),
      ),

      // Error border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),

      // Focused error border
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),

      // Disabled border
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderLight.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),

      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisLight,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryNavyLight,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textDisabledLight,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorRed,
      ),
      prefixIconColor: textMediumEmphasisLight,
      suffixIconColor: textMediumEmphasisLight,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderLight;
        }
        return surfaceWhiteLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyLight.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.disabled)) {
          return borderLight.withValues(alpha: 0.3);
        }
        return textMediumEmphasisLight.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderLight;
        }
        return surfaceWhiteLight;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderLight;
        }
        return textMediumEmphasisLight;
      }),
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryNavyLight,
      linearTrackColor: borderLight,
      circularTrackColor: borderLight,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryNavyLight,
      inactiveTrackColor: borderLight,
      thumbColor: primaryNavyLight,
      overlayColor: primaryNavyLight.withValues(alpha: 0.2),
      valueIndicatorColor: primaryNavyLight,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onPrimaryLight,
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryNavyLight,
      unselectedLabelColor: textMediumEmphasisLight,
      indicatorColor: primaryNavyLight,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: surfaceWhiteLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryLight,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: surfaceWhiteLight,
      ),
      actionTextColor: secondaryTealLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceWhiteLight,
      elevation: 8.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: backgroundLightColor,
      deleteIconColor: textMediumEmphasisLight,
      disabledColor: borderLight,
      selectedColor: primaryNavyLight.withValues(alpha: 0.2),
      secondarySelectedColor: secondaryTealLight.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );

  /// Dark theme - Contemporary Financial Minimalism (Dark Mode)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryNavyDark,
      onPrimary: onPrimaryDark,
      primaryContainer: primaryNavyDark,
      onPrimaryContainer: onPrimaryDark,
      secondary: secondaryTealDark,
      onSecondary: onSecondaryDark,
      secondaryContainer: secondaryTealDark,
      onSecondaryContainer: onSecondaryDark,
      tertiary: secondaryTealDark,
      onTertiary: onSecondaryDark,
      tertiaryContainer: secondaryTealDark,
      onTertiaryContainer: onSecondaryDark,
      error: errorRed,
      onError: onErrorDark,
      surface: surfaceWhiteDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderDark,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: backgroundLightColor,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryNavyLight,
    ),
    scaffoldBackgroundColor: backgroundDarkColor,
    cardColor: surfaceWhiteDark,
    dividerColor: dividerDark,

    // AppBar Theme
    appBarTheme: AppBarThemeData(
      backgroundColor: surfaceWhiteDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      shadowColor: shadowDark,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: surfaceWhiteDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceWhiteDark,
      selectedItemColor: primaryNavyDark,
      unselectedItemColor: textMediumEmphasisDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryTealDark,
      foregroundColor: onSecondaryDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryDark,
        backgroundColor: primaryNavyDark,
        disabledForegroundColor: textDisabledDark,
        disabledBackgroundColor: borderDark,
        elevation: 2.0,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryNavyDark,
        disabledForegroundColor: textDisabledDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(88, 56),
        side: const BorderSide(color: primaryNavyDark, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryNavyDark,
        disabledForegroundColor: textDisabledDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Theme
    textTheme: _buildTextTheme(isLight: false),

    // Input Decoration
    inputDecorationTheme: InputDecorationThemeData(
      fillColor: surfaceWhiteDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderDark, width: 1.0),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderDark, width: 1.0),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryNavyDark, width: 2.0),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: borderDark.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),

      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisDark,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryNavyDark,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textDisabledDark,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorRed,
      ),
      prefixIconColor: textMediumEmphasisDark,
      suffixIconColor: textMediumEmphasisDark,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyDark;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderDark;
        }
        return surfaceWhiteDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyDark.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.disabled)) {
          return borderDark.withValues(alpha: 0.3);
        }
        return textMediumEmphasisDark.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyDark;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderDark;
        }
        return surfaceWhiteDark;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryNavyDark;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderDark;
        }
        return textMediumEmphasisDark;
      }),
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryNavyDark,
      linearTrackColor: borderDark,
      circularTrackColor: borderDark,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryNavyDark,
      inactiveTrackColor: borderDark,
      thumbColor: primaryNavyDark,
      overlayColor: primaryNavyDark.withValues(alpha: 0.2),
      valueIndicatorColor: primaryNavyDark,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onPrimaryDark,
      ),
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryNavyDark,
      unselectedLabelColor: textMediumEmphasisDark,
      indicatorColor: primaryNavyDark,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: backgroundDarkColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryDark,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: backgroundDarkColor,
      ),
      actionTextColor: secondaryTealDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceWhiteDark,
      elevation: 8.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: backgroundDarkColor,
      deleteIconColor: textMediumEmphasisDark,
      disabledColor: borderDark,
      selectedColor: primaryNavyDark.withValues(alpha: 0.2),
      secondarySelectedColor: secondaryTealDark.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for headings, body, and captions
  /// Uses JetBrains Mono for data/financial figures (not implemented in base theme)
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight
        ? textHighEmphasisLight
        : textHighEmphasisDark;
    final Color textMediumEmphasis = isLight
        ? textMediumEmphasisLight
        : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles - Large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Section headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Card titles, list items
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Main content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Buttons, tabs, captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Helper method to get monospace text style for financial data
  /// Uses JetBrains Mono for account numbers, amounts, etc.
  static TextStyle getDataTextStyle({
    required bool isLight,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor = isLight
        ? textHighEmphasisLight
        : textHighEmphasisDark;

    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0,
    );
  }
}
