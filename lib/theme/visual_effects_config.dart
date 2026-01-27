import 'package:flutter/cupertino.dart';

/// Configuration file for all visual effects parameters
/// Change these values to customize the app's appearance
class VisualEffectsConfig {
  // ==================== GRADIENT COLORS ====================

  /// Primary gradient colors for main buttons and accents
  static const Color primaryGradientStart = Color.fromARGB(
    255,
    225,
    122,
    53,
  ); // Purple
  static const Color primaryGradientEnd = Color(0xFFEC4899); // Pink

  /// Secondary gradient for pack screen
  static const Color packGradientStart = Color.fromARGB(
    255,
    168,
    99,
    241,
  ); // Indigo
  static const Color packGradientEnd = Color.fromARGB(
    255,
    246,
    92,
    184,
  ); // Purple

  /// Unpack screen gradient
  static const Color unpackGradientStart = Color(0xFFEC4899); // Pink
  static const Color unpackGradientEnd = Color(0xFFF59E0B); // Amber

  /// Advice/Wisdom screen gradient
  static const Color adviceGradientStart = Color(0xFF10B981); // Green
  static const Color adviceGradientEnd = Color(0xFF3B82F6); // Blue

  /// Settings screen gradient
  static const Color settingsGradientStart = Color(0xFF6B7280); // Gray
  static const Color settingsGradientEnd = Color(0xFF4B5563); // Dark gray

  /// Card gradient overlay
  static const Color cardGradientStart = Color(
    0x1AFFFFFF,
  ); // Semi-transparent white
  static const Color cardGradientEnd = Color(
    0x0DFFFFFF,
  ); // More transparent white

  /// Background gradient
  static const Color backgroundGradientStart = Color.fromARGB(
    255,
    41,
    54,
    72,
  ); // Dark
  static const Color backgroundGradientEnd = Color.fromARGB(
    255,
    31,
    44,
    71,
  ); // Darker

  /// Locked capsule gradient
  static const Color lockedGradientStart = Color(0xFF6B7280); // Gray
  static const Color lockedGradientEnd = Color(0xFF9CA3AF); // Light gray

  /// Unlocked capsule gradient
  static const Color unlockedGradientStart = Color(0xFF10B981); // Green
  static const Color unlockedGradientEnd = Color(0xFF34D399); // Light green

  // ==================== GLOW EFFECTS ====================

  /// Primary glow color
  static const Color primaryGlowColor = Color(0xFFEC4899); // Pink

  /// Secondary glow color
  static const Color secondaryGlowColor = Color(0xFF8B5CF6); // Purple

  /// Success glow color
  static const Color successGlowColor = Color(0xFF10B981); // Green

  /// Warning glow color
  static const Color warningGlowColor = Color(0xFFF59E0B); // Amber

  /// Glow blur radius
  static const double glowBlurRadius = 20.0;

  /// Glow spread radius
  static const double glowSpreadRadius = 5.0;

  /// Glow opacity
  static const double glowOpacity = 0.6;

  /// Shimmer base color
  static const Color shimmerBaseColor = Color(0x33FFFFFF); // Transparent white

  /// Shimmer highlight color
  static const Color shimmerHighlightColor = Color(
    0x66FFFFFF,
  ); // Semi-transparent white

  // ==================== GRADIENT PARAMETERS ====================

  /// Button gradient begin alignment
  static const Alignment buttonGradientBeginAlign = Alignment.topLeft;

  /// Button gradient end alignment
  static const Alignment buttonGradientEndAlign = Alignment.bottomRight;

  /// Background gradient begin alignment
  static const Alignment backgroundGradientBeginAlign = Alignment.topCenter;

  /// Background gradient end alignment
  static const Alignment backgroundGradientEndAlign = Alignment.bottomCenter;

  /// Card gradient begin alignment
  static const Alignment cardGradientBeginAlign = Alignment.topLeft;

  /// Card gradient end alignment
  static const Alignment cardGradientEndAlign = Alignment.bottomRight;

  // ==================== OPACITY & TRANSPARENCY ====================

  /// Card overlay opacity
  static const double cardOverlayOpacity = 0.15;

  /// Glass effect opacity
  static const double glassEffectOpacity = 0.1;

  /// Blur background opacity
  static const double blurBackgroundOpacity = 0.3;

  // ==================== BORDER RADIUS ====================

  /// Button border radius
  static const double buttonBorderRadius = 16.0;

  /// Card border radius
  static const double cardBorderRadius = 20.0;

  /// Small card border radius
  static const double smallCardBorderRadius = 12.0;

  // ==================== ANIMATION DURATIONS ====================

  /// Shimmer animation duration in milliseconds
  static const int shimmerDuration = 2000;

  /// Glow pulse duration in milliseconds
  static const int glowPulseDuration = 1500;

  /// Gradient transition duration in milliseconds
  static const int gradientTransitionDuration = 300;

  // ==================== HELPER METHODS ====================

  /// Creates a linear gradient for buttons
  static LinearGradient createButtonGradient({
    Color? startColor,
    Color? endColor,
  }) {
    return LinearGradient(
      begin: buttonGradientBeginAlign,
      end: buttonGradientEndAlign,
      colors: [
        startColor ?? primaryGradientStart,
        endColor ?? primaryGradientEnd,
      ],
    );
  }

  /// Creates a linear gradient for backgrounds
  static LinearGradient createBackgroundGradient({
    Color? startColor,
    Color? endColor,
  }) {
    return LinearGradient(
      begin: backgroundGradientBeginAlign,
      end: backgroundGradientEndAlign,
      colors: [
        startColor ?? backgroundGradientStart,
        endColor ?? backgroundGradientEnd,
      ],
    );
  }

  /// Creates a linear gradient for cards
  static LinearGradient createCardGradient({
    Color? startColor,
    Color? endColor,
  }) {
    return LinearGradient(
      begin: cardGradientBeginAlign,
      end: cardGradientEndAlign,
      colors: [startColor ?? cardGradientStart, endColor ?? cardGradientEnd],
    );
  }

  /// Creates glow effect box shadows
  static List<BoxShadow> createGlowEffect({
    Color? color,
    double? blurRadius,
    double? spreadRadius,
    double? opacity,
  }) {
    final glowColor = (color ?? primaryGlowColor).withOpacity(
      opacity ?? glowOpacity,
    );
    return [
      BoxShadow(
        color: glowColor,
        blurRadius: blurRadius ?? glowBlurRadius,
        spreadRadius: spreadRadius ?? glowSpreadRadius,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: glowColor.withOpacity((opacity ?? glowOpacity) * 0.5),
        blurRadius: (blurRadius ?? glowBlurRadius) * 1.5,
        spreadRadius: (spreadRadius ?? glowSpreadRadius) * 1.5,
        offset: const Offset(0, 0),
      ),
    ];
  }

  /// Creates a subtle inner glow effect
  static List<BoxShadow> createInnerGlow({Color? color, double? opacity}) {
    final glowColor = (color ?? primaryGlowColor).withOpacity(opacity ?? 0.3);
    return [
      BoxShadow(
        color: glowColor,
        blurRadius: 10,
        spreadRadius: -5,
        offset: const Offset(0, 0),
      ),
    ];
  }
}
