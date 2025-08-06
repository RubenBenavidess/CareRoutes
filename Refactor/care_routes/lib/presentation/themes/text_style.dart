import 'package:flutter/material.dart';

class AppTextStyles {
  // Colores base
  static const Color primaryBlue = Color(0xFF0973ad);
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFF999999);
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53E3E);
  static const Color warningOrange = Color(0xFFFF9800);

  // Fuente principal
  static const String primaryFont = 'Wix Madefor Text';

  // Títulos
  static TextStyle get mainTitle => const TextStyle(
    fontSize: 40,
    color: primaryBlue,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    letterSpacing: -0.5,
  );

  static TextStyle get sectionTitle => const TextStyle(
    fontSize: 24,
    color: primaryBlue,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
  );

  static TextStyle get subTitle => const TextStyle(
    fontSize: 18,
    color: darkGray,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
  );

  // Texto normal
  static TextStyle get normalText => const TextStyle(
    fontSize: 16,
    color: darkGray,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    height: 1.4,
  );

  static TextStyle get bodyText => const TextStyle(
    fontSize: 14,
    color: mediumGray,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    height: 1.5,
  );

  static TextStyle get smallText => const TextStyle(
    fontSize: 12,
    color: mediumGray,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
  );

  // Texto de estado
  static TextStyle get successText => const TextStyle(
    fontSize: 14,
    color: successGreen,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
  );

  static TextStyle get errorText => const TextStyle(
    fontSize: 14,
    color: errorRed,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
  );

  static TextStyle get warningText => const TextStyle(
    fontSize: 14,
    color: warningOrange,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
  );

  // Texto de botones
  static TextStyle get buttonText => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    letterSpacing: 0.3,
  );

  static TextStyle get smallButtonText => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    letterSpacing: 0.2,
  );

  // Texto de dropzone
  static TextStyle get dropZoneText => const TextStyle(
    fontSize: 16,
    color: darkGray,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
  );

  static TextStyle get dropZoneInfoText => const TextStyle(
    fontSize: 12,
    color: darkGray,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
  );

  // Labels y hints
  static TextStyle get labelText => const TextStyle(
    fontSize: 14,
    color: darkGray,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
  );

  static TextStyle get hintText => const TextStyle(
    fontSize: 14,
    color: lightGray,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
  );

  // Texto de resultado de importación
  static TextStyle get resultTitle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
  );

  static TextStyle get resultText => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    height: 1.3,
  );
}

// Clase de compatibilidad con el código existente
class NormalTextStyle {
  static TextStyle get normalText => AppTextStyles.normalText;
}