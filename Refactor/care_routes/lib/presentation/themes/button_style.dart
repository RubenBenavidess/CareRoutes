import 'package:flutter/material.dart';
import 'text_style.dart';

class AppButtonStyles {
  // Colores base
  static const Color primaryBlue = Color(0xFF0973ad);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53E3E);
  static const Color disabledGray = Color(0xFFBDBDBD);
  static const Color warningOrange = Color(0xFFFF9800);

  // Bordes y sombras
  static const double borderRadius = 8.0;
  static const double elevation = 2.0;

  // Botón de confirmación (Cargar)
  static ButtonStyle get confirm => ElevatedButton.styleFrom(
    backgroundColor: successGreen,
    foregroundColor: Colors.white,
    elevation: elevation,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText,
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withAlpha(51); // 20% opacity
        }
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withAlpha(76); // 30% opacity
        }
        return null;
      },
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledGray;
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF45A049); // Verde más oscuro
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF5CBF60); // Verde más claro
        }
        return successGreen;
      },
    ),
  );

  // Botón de cancelación
  static ButtonStyle get cancel => ElevatedButton.styleFrom(
    backgroundColor: errorRed,
    foregroundColor: Colors.white,
    elevation: elevation,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText,
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withAlpha(51);
        }
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withAlpha(76);
        }
        return null;
      },
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledGray;
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFD32F2F); // Rojo más oscuro
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFEF5350); // Rojo más claro
        }
        return errorRed;
      },
    ),
  );

  // Botón principal (Azul)
  static ButtonStyle get primary => ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    elevation: elevation,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText,
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withAlpha(51);
        }
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withAlpha(76);
        }
        return null;
      },
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledGray;
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF075A8A); // Azul más oscuro
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF0A82C4); // Azul más claro
        }
        return primaryBlue;
      },
    ),
  );

  // Botón deshabilitado/neutro
  static ButtonStyle get disabled => ElevatedButton.styleFrom(
    backgroundColor: disabledGray,
    foregroundColor: Colors.grey[600],
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText.copyWith(
      color: Colors.grey[600],
    ),
  );

  // Botón outlined (borde)
  static ButtonStyle get outlined => OutlinedButton.styleFrom(
    foregroundColor: primaryBlue,
    side: const BorderSide(color: primaryBlue, width: 1.5),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText.copyWith(color: primaryBlue),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return primaryBlue.withAlpha(25);
        }
        if (states.contains(WidgetState.pressed)) {
          return primaryBlue.withAlpha(51);
        }
        return null;
      },
    ),
  );

  // Botón de advertencia
  static ButtonStyle get warning => ElevatedButton.styleFrom(
    backgroundColor: warningOrange,
    foregroundColor: Colors.white,
    elevation: elevation,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText,
  ).copyWith(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledGray;
        }
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFFE68900); // Naranja más oscuro
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFFFA726); // Naranja más claro
        }
        return warningOrange;
      },
    ),
  );

  // Botón texto (sin fondo)
  static ButtonStyle get text => TextButton.styleFrom(
    foregroundColor: primaryBlue,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: AppTextStyles.buttonText.copyWith(color: primaryBlue),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return primaryBlue.withAlpha(25);
        }
        if (states.contains(WidgetState.pressed)) {
          return primaryBlue.withAlpha(51);
        }
        return null;
      },
    ),
  );
}

// Clases de compatibilidad con el código existente
class ConfirmButtonStyle {
  static ButtonStyle get elevated => AppButtonStyles.confirm;
}

class CancelButtonStyle {
  static ButtonStyle get elevated => AppButtonStyles.cancel;
}

class RestButtonStyle {
  static ButtonStyle get elevated => AppButtonStyles.disabled;
}

class PrimaryButtonStyle {
  static ButtonStyle get elevated => AppButtonStyles.primary;
}