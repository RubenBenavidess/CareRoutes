import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Colores principales de la aplicación
class AppColors {
  static const Color primaryBlue = Color(0xFF0973AD);
  static const Color secondaryPink = Color(0xFFFF8989);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  
  // Colores de estado
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53E3E);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Colores de texto
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFF999999);
  static const Color sidebarGray = Color(0xFF76777C);
  
  // Colores de sidebar
  static const Color sidebarBackground = Color(0xFFF2F2F2);
  static const Color sidebarSelected = Color(0xFF0973AD);
  static const Color sidebarHover = Color(0xFFE0E0E0);
  
  // Colores de drop zone
  static const Color dropZoneNormal = Color.fromARGB(255, 203, 255, 177);
  static const Color dropZoneDragEntered = Color.fromARGB(219, 255, 193, 113);
  static const Color dropZoneSelected = Color.fromARGB(192, 65, 169, 255);
  static const Color dropZoneError = Color.fromARGB(255, 255, 182, 193);
}

final ThemeData mainTheme = ThemeData(
  // Configuración básica
  useMaterial3: true,
  
  // Esquema de colores
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.light,
    primary: AppColors.primaryBlue,
    secondary: AppColors.secondaryPink,
    surface: AppColors.surfaceColor,
    surfaceTint: AppColors.backgroundColor,
    error: AppColors.errorRed,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.darkGray,
    onError: Colors.white,
  ),

  // Configuración de fuentes
  fontFamily: 'Wix Madefor Text',
  
  // Theme de texto
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryBlue,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryBlue,
    ),
    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryPink,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.sidebarGray,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGray,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGray,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGray,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.mediumGray,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.darkGray,
      height: 1.4,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.mediumGray,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.mediumGray,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGray,
      letterSpacing: 0.3,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGray,
      letterSpacing: 0.2,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.lightGray,
      letterSpacing: 0.1,
    ),
  ),

  // Theme de AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundColor,
    foregroundColor: AppColors.primaryBlue,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
      fontFamily: 'Wix Madefor Text',
    ),
    iconTheme: IconThemeData(
      color: AppColors.primaryBlue,
      size: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),

  // Theme de botones elevados
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        fontFamily: 'Wix Madefor Text',
      ),
    ),
  ),

  // Theme de botones outlined
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        fontFamily: 'Wix Madefor Text',
      ),
    ),
  ),

  // Theme de botones de texto
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        fontFamily: 'Wix Madefor Text',
      ),
    ),
  ),

  // Theme de campos de texto
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.lightGray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.lightGray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.errorRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
    ),
    labelStyle: const TextStyle(
      color: AppColors.mediumGray,
      fontFamily: 'Wix Madefor Text',
    ),
    hintStyle: const TextStyle(
      color: AppColors.lightGray,
      fontFamily: 'Wix Madefor Text',
    ),
    helperStyle: const TextStyle(
      color: AppColors.mediumGray,
      fontSize: 12,
      fontFamily: 'Wix Madefor Text',
    ),
    errorStyle: const TextStyle(
      color: AppColors.errorRed,
      fontSize: 12,
      fontFamily: 'Wix Madefor Text',
    ),
  ),

  // Theme de cards
  cardTheme: CardThemeData(
    color: AppColors.surfaceColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(8),
  ),

  // Theme de dividers
  dividerTheme: const DividerThemeData(
    color: AppColors.sidebarGray,
    thickness: 1,
    space: 1,
  ),

  // Theme de drawer
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.sidebarBackground,
    elevation: 4,
    shape: RoundedRectangleBorder(),
  ),

  // Theme de ListTile
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    dense: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    style: ListTileStyle.list,
    textColor: AppColors.sidebarGray,
    iconColor: AppColors.sidebarGray,
  ),

  // Theme de SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.darkGray,
    contentTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Wix Madefor Text',
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    behavior: SnackBarBehavior.floating,
  ),

  // Theme de progreso circular
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryBlue,
    linearTrackColor: AppColors.lightGray,
    circularTrackColor: AppColors.lightGray,
  ),

  // Theme de checkbox
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryBlue;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),

  // Theme de radio buttons
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryBlue;
      }
      return AppColors.lightGray;
    }),
  ),

  // Theme de switches
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryBlue;
      }
      return AppColors.lightGray;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryBlue.withValues(alpha: 0.5);
      }
      return AppColors.lightGray.withValues(alpha: 0.5);
    }),
  ),

  // Theme de sliders
  sliderTheme: const SliderThemeData(
    activeTrackColor: AppColors.primaryBlue,
    inactiveTrackColor: AppColors.lightGray,
    thumbColor: AppColors.primaryBlue,
    overlayColor: Color.fromRGBO(9, 115, 173, 0.2),
    valueIndicatorColor: AppColors.primaryBlue,
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'Wix Madefor Text',
    ),
  ),

  // Theme de tabs
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.primaryBlue,
    unselectedLabelColor: AppColors.mediumGray,
    indicatorColor: AppColors.primaryBlue,
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Wix Madefor Text',
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Wix Madefor Text',
    ),
  ),

  // Theme de tooltips
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: AppColors.darkGray.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(6),
    ),
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontFamily: 'Wix Madefor Text',
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),

  // Configuración de scroll
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(AppColors.mediumGray.withValues(alpha: .5)),
    trackColor: WidgetStateProperty.all(AppColors.lightGray.withValues(alpha: 0.2)),
    radius: const Radius.circular(4),
    thickness: WidgetStateProperty.all(6),
    minThumbLength: 48,
  ),
);

// Extensiones útiles para usar en la app
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}