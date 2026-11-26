// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'package:flutter/material.dart';
import '../../models/gluten_safety_status.dart';
import 'app_colors.dart';

export 'app_colors.dart';

// ─── ThemeData ────────────────────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  brightness: Brightness.light,
  cardColor: lightCardBackground,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    primaryContainer: lightPrimaryContainer,
    onPrimaryContainer: lightOnPrimaryContainer,
    secondary: lightSecondaryContainer,
    onSecondary: lightOnSecondaryContainer,
    secondaryContainer: lightSecondaryContainer,
    onSecondaryContainer: lightOnSecondaryContainer,
    tertiary: lightStatusUncertainText,
    onTertiary: colorWhite,
    tertiaryContainer: lightTertiaryContainer,
    onTertiaryContainer: lightOnTertiaryContainer,
    error: lightError,
    onError: colorWhite,
    errorContainer: lightErrorContainer,
    onErrorContainer: lightOnErrorContainer,
    surface: lightSurface,
    onSurface: lightOnSurface,
    surfaceContainerHighest: lightSurfaceVariant,
    onSurfaceVariant: lightOnSurfaceVariant,
    outline: lightOutline,
    outlineVariant: lightCardPrimaryBorder,
    shadow: lightShadow,
    scrim: lightScrim,
    inverseSurface: darkSurface,
    onInverseSurface: lightSurface,
    inversePrimary: darkPrimary,
  ),
  scaffoldBackgroundColor: lightSurface,
  splashColor: lightPrimary.withValues(alpha: 0.12),
  highlightColor: lightPrimary.withValues(alpha: 0.08),
  appBarTheme: const AppBarTheme(
    backgroundColor: lightSurface,
    foregroundColor: lightOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: lightBottomNavBg,
    indicatorColor: lightPrimaryContainer,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: lightCardBackground,
    surfaceTintColor: colorTransparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: lightCardBackground,
    surfaceTintColor: colorTransparent,
    modalBackgroundColor: lightBottomSheetBg,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: lightCardBackground,
    elevation: 6,
    shadowColor: lightShadow,
    surfaceTintColor: colorTransparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: lightCardPrimaryBorder),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  brightness: Brightness.dark,
  cardColor: darkCardBackground,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    primaryContainer: darkPrimaryContainer,
    onPrimaryContainer: darkOnPrimaryContainer,
    secondary: darkSecondaryContainer,
    onSecondary: darkOnSecondaryContainer,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: darkOnSecondaryContainer,
    tertiary: darkStatusUncertainText,
    onTertiary: darkSurface,
    tertiaryContainer: darkTertiaryContainer,
    onTertiaryContainer: darkOnTertiaryContainer,
    error: darkError,
    onError: darkOnError,
    errorContainer: darkErrorContainer,
    onErrorContainer: darkOnErrorContainer,
    surface: darkSurface,
    onSurface: darkOnSurface,
    surfaceContainerHighest: darkSurfaceVariant,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkOutline,
    outlineVariant: darkCardPrimaryBorder,
    shadow: darkShadow,
    scrim: darkScrim,
    inverseSurface: lightSurface,
    onInverseSurface: darkSurface,
    inversePrimary: lightPrimary,
  ),
  scaffoldBackgroundColor: darkSurface,
  splashColor: darkPrimary.withValues(alpha: 0.12),
  highlightColor: darkPrimary.withValues(alpha: 0.08),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkSurface,
    foregroundColor: darkOnSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: darkBottomNavBg,
    indicatorColor: darkPrimaryContainer,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: darkCardBackground,
    surfaceTintColor: colorTransparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: darkCardBackground,
    surfaceTintColor: colorTransparent,
    modalBackgroundColor: darkBottomSheetBg,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: darkCardBackground,
    elevation: 6,
    shadowColor: darkShadow,
    surfaceTintColor: colorTransparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: darkCardPrimaryBorder),
    ),
  ),
);

// ─── Context Extensions ────────────────────────────────────────────────────────
extension AppThemeContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get cardBackground =>
      isDarkMode ? darkCardBackground : lightCardBackground;
  Color get surfaceContainerLow =>
      isDarkMode ? darkSurfaceContainerLow : lightSurfaceContainerLow;
  Color get modalBackgroundColor =>
      isDarkMode ? darkBottomSheetBg : lightBottomSheetBg;
  Color get bottomNavBg => isDarkMode ? darkBottomNavBg : lightBottomNavBg;
  Color get textTertiary => isDarkMode ? darkTextTertiary : lightTextTertiary;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
ThemeMode themeModeFromString(String value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

String themeModeToString(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    default:
      return 'system';
  }
}

// ─── Semantic colour tokens ───────────────────────────────────────────────────
//
// Unica fonte di verità per tutti i colori dell'applicazione.
// Ogni widget deve usare questi getter invece di calcolare i colori inline
// o usare colori hardcoded.
//
// Le fonti di verità sono separate logicamente: se due elementi oggi condividono
// lo stesso valore cromatico ma rappresentano concetti diversi, hanno comunque
// due getter distinti per consentire variazioni future indipendenti.
//
extension AppColorTokens on ColorScheme {
  // ── Helper di Miscelazione Tonale Semantica ─────────────────────────────
  Color _blendHeroBadge(Color solid, Color alpha) => Color.alphaBlend(
    solid.withValues(
      alpha: brightness == Brightness.dark
          ? statusHeroBadgeBlendDark
          : statusHeroBadgeBlendLight,
    ),
    alpha,
  );

  Color _blendBarcodeChip(Color solid) => Color.alphaBlend(
    solid.withValues(
      alpha: brightness == Brightness.dark
          ? statusBarcodeChipBlendDark
          : statusBarcodeChipBlendLight,
    ),
    surface,
  );

  // ── 1. STATI DEL CIBO (4 STATI GLUTINE + LATTOSIO) ────────────────────────
  // Ciascuno stato possiede i token:
  // - solid: per testi, icone, elementi grafici primari
  // - alpha: per sfondi, gradienti header, container, hero card (già pastello 100%)
  // - heroBadgeBg: badge circolare dietro icona esito, più scuro/intenso rispetto al gradiente
  // - barcodeChipBg: pillola codice a barre, tenue e discreta rispetto a surface

  // STATO SICURO (Safe / Adatto) - Scollegato da primary / primaryContainer
  Color get statusSafeSolid =>
      brightness == Brightness.dark ? darkStatusSafeText : lightStatusSafeText;
  Color get statusSafeAlpha =>
      brightness == Brightness.dark ? darkStatusSafeBg : lightStatusSafeBg;
  Color get statusSafeHeroBadgeBg =>
      _blendHeroBadge(statusSafeSolid, statusSafeAlpha);
  Color get statusSafeBarcodeChipBg => _blendBarcodeChip(statusSafeSolid);
  ({Color solid, Color alpha, Color heroBadgeBg, Color barcodeChipBg})
  get statusSafeColors => (
    solid: statusSafeSolid,
    alpha: statusSafeAlpha,
    heroBadgeBg: statusSafeHeroBadgeBg,
    barcodeChipBg: statusSafeBarcodeChipBg,
  );

  // STATO VIETATO (Unsafe / Non adatto)
  Color get statusUnsafeSolid => brightness == Brightness.dark
      ? darkStatusUnsafeText
      : lightStatusUnsafeText;
  Color get statusUnsafeAlpha =>
      brightness == Brightness.dark ? darkStatusUnsafeBg : lightStatusUnsafeBg;
  Color get statusUnsafeHeroBadgeBg =>
      _blendHeroBadge(statusUnsafeSolid, statusUnsafeAlpha);
  Color get statusUnsafeBarcodeChipBg => _blendBarcodeChip(statusUnsafeSolid);
  ({Color solid, Color alpha, Color heroBadgeBg, Color barcodeChipBg})
  get statusUnsafeColors => (
    solid: statusUnsafeSolid,
    alpha: statusUnsafeAlpha,
    heroBadgeBg: statusUnsafeHeroBadgeBg,
    barcodeChipBg: statusUnsafeBarcodeChipBg,
  );

  // STATO INCERTO (Uncertain / Warning / Segnalazione)
  Color get statusUncertainSolid => brightness == Brightness.dark
      ? darkStatusUncertainText
      : lightStatusUncertainText;
  Color get statusUncertainAlpha => brightness == Brightness.dark
      ? darkStatusUncertainBg
      : lightStatusUncertainBg;
  Color get statusUncertainHeroBadgeBg =>
      _blendHeroBadge(statusUncertainSolid, statusUncertainAlpha);
  Color get statusUncertainBarcodeChipBg =>
      _blendBarcodeChip(statusUncertainSolid);
  ({Color solid, Color alpha, Color heroBadgeBg, Color barcodeChipBg})
  get statusUncertainColors => (
    solid: statusUncertainSolid,
    alpha: statusUncertainAlpha,
    heroBadgeBg: statusUncertainHeroBadgeBg,
    barcodeChipBg: statusUncertainBarcodeChipBg,
  );

  // STATO IGNOTO (Unknown / Sconosciuto / Neutro)
  Color get statusUnknownSolid => brightness == Brightness.dark
      ? darkStatusUnknownText
      : lightStatusUnknownText;
  Color get statusUnknownAlpha => brightness == Brightness.dark
      ? darkStatusUnknownBg
      : lightStatusUnknownBg;
  Color get statusUnknownHeroBadgeBg =>
      _blendHeroBadge(statusUnknownSolid, statusUnknownAlpha);
  Color get statusUnknownBarcodeChipBg => _blendBarcodeChip(statusUnknownSolid);
  ({Color solid, Color alpha, Color heroBadgeBg, Color barcodeChipBg})
  get statusUnknownColors => (
    solid: statusUnknownSolid,
    alpha: statusUnknownAlpha,
    heroBadgeBg: statusUnknownHeroBadgeBg,
    barcodeChipBg: statusUnknownBarcodeChipBg,
  );

  // STATO LATTOSIO (Lactose Alert / Intolleranza) - Scollegato da secondaryContainer / navSelected
  Color get statusLactoseSolid =>
      brightness == Brightness.dark ? darkLactoseText : lightLactoseText;
  Color get statusLactoseAlpha =>
      brightness == Brightness.dark ? darkLactoseBg : lightLactoseBg;
  Color get statusLactoseHeroBadgeBg =>
      _blendHeroBadge(statusLactoseSolid, statusLactoseAlpha);
  Color get statusLactoseBarcodeChipBg => _blendBarcodeChip(statusLactoseSolid);
  ({Color solid, Color alpha, Color heroBadgeBg, Color barcodeChipBg})
  get statusLactoseColors => (
    solid: statusLactoseSolid,
    alpha: statusLactoseAlpha,
    heroBadgeBg: statusLactoseHeroBadgeBg,
    barcodeChipBg: statusLactoseBarcodeChipBg,
  );

  /// Helper unificato per ottenere il set semantico ({solid, alpha, heroBadgeBg, barcodeChipBg})
  /// per qualsiasi [GlutenSafetyStatus].
  ({Color solid, Color alpha, Color heroBadgeBg, Color barcodeChipBg})
  statusColorsFor(GlutenSafetyStatus status) {
    switch (status) {
      case GlutenSafetyStatus.adatto:
        return statusSafeColors;
      case GlutenSafetyStatus.nonAdatto:
        return statusUnsafeColors;
      case GlutenSafetyStatus.incerto:
        return statusUncertainColors;
      case GlutenSafetyStatus.sconosciuto:
        return statusUnknownColors;
    }
  }

  // Pallini Legenda Scanner (pieni 100%)
  Color get statusSafeLegendDot => brightness == Brightness.dark
      ? darkStatusSafeText
      : lightStatusSafeLegendDot;
  Color get statusUncertainLegendDot => brightness == Brightness.dark
      ? darkStatusUncertainText
      : lightStatusUncertainLegendDot;
  Color get statusUnsafeLegendDot =>
      brightness == Brightness.dark ? darkError : lightStatusUnsafeLegendDot;
  Color get statusUnknownLegendDot => brightness == Brightness.dark
      ? darkStatusUnknownText
      : lightStatusUnknownLegendDot;

  // Alias semantici per compatibilità
  Color get statusPrimaryBg => statusSafeAlpha;
  Color get statusPrimaryText => statusSafeSolid;
  Color get statusErrorBg => statusUnsafeAlpha;
  Color get statusErrorText => statusUnsafeSolid;
  Color get statusTertiaryBg => statusUncertainAlpha;
  Color get statusTertiaryText => statusUncertainSolid;
  Color get statusNeutralBg => statusUnknownAlpha;
  Color get statusNeutralText => statusUnknownSolid;
  Color get statusSecondaryBg => statusLactoseAlpha;
  Color get statusSecondaryText => statusLactoseSolid;
  Color get lactoseBg => statusLactoseAlpha;
  Color get lactoseText => statusLactoseSolid;
  Color get statusTertiaryHeroBadgeBg => statusUncertainHeroBadgeBg;
  Color get statusTertiaryBarcodeChipBg => statusUncertainBarcodeChipBg;

  // ── 2. PULSANTI (BUTTONS) ─────────────────────────────────────────────────
  // Token cromatici dedicati per la gerarchia dei pulsanti dell'app.

  // Pulsante Primario (pieno blu Cobalt Mist; in dark mode usa darkButtonPrimaryBg anti-abbagliamento)
  Color get buttonPrimaryBg =>
      brightness == Brightness.dark ? darkButtonPrimaryBg : primary;
  Color get buttonPrimaryFg =>
      brightness == Brightness.dark ? darkButtonPrimaryFg : onPrimary;
  Color get buttonPrimaryDisabledBg => buttonPrimaryBg.withValues(alpha: 0.38);
  Color get buttonPrimaryDisabledFg => buttonPrimaryFg.withValues(alpha: 0.38);

  // Pulsante Secondario (grigio pieno)
  Color get buttonSecondaryBg => surfaceContainerHighest;
  Color get buttonSecondaryFg => onSurface;
  Color get buttonSecondaryDisabledBg =>
      surfaceContainerHighest.withValues(alpha: 0.38);
  Color get buttonSecondaryDisabledFg => onSurface.withValues(alpha: 0.38);

  // Pulsante Terziario (outlined blu)
  Color get buttonTertiaryBg => colorTransparent;
  Color get buttonTertiaryBorder => brightness == Brightness.dark
      ? darkButtonTertiaryBorder
      : lightButtonTertiaryBorder;
  Color get buttonTertiaryFg => primary;
  Color get buttonTertiaryDisabledBorder =>
      buttonTertiaryBorder.withValues(alpha: 0.2);
  Color get buttonTertiaryDisabledFg => primary.withValues(alpha: 0.38);

  // Pulsante Primario Distruttivo (rosso pieno di eliminazione)
  Color get buttonPrimaryDestructiveBg => error;
  Color get buttonPrimaryDestructiveFg => onError;
  Color get buttonPrimaryDestructiveDisabledBg => error.withValues(alpha: 0.6);
  Color get buttonPrimaryDestructiveDisabledFg =>
      onError.withValues(alpha: 0.6);

  // Pulsante Terziario Distruttivo (cancellazione, outline rosso senza sfondo)
  Color get buttonTertiaryDestructiveBg => colorTransparent;
  Color get buttonTertiaryDestructiveBorder => error.withValues(alpha: 0.38);
  Color get buttonTertiaryDestructiveFg => error;
  Color get buttonTertiaryDestructiveDisabledBg => colorTransparent;
  Color get buttonTertiaryDestructiveDisabledBorder =>
      error.withValues(alpha: 0.2);
  Color get buttonTertiaryDestructiveDisabledFg =>
      error.withValues(alpha: 0.38);

  // Compatibilità per AppDestructiveActionButton
  Color get destructiveButtonBg => buttonTertiaryDestructiveBg;
  Color get destructiveButtonBorder => buttonTertiaryDestructiveBorder;
  Color get destructiveButtonFg => buttonTertiaryDestructiveFg;

  // ── 3. CARD (SCHEDE) ──────────────────────────────────────────────────────
  // Token cromatici dedicati per le tre tipologie di card.

  // Card Principale (sfondo #FFFFFF / #161920 con bordo quasi invisibile e micro-ombra in light)
  Color get cardPrimaryBg =>
      brightness == Brightness.dark ? darkCardBackground : lightCardBackground;
  Color get cardPrimaryBorder => brightness == Brightness.dark
      ? darkCardPrimaryBorder
      : lightCardPrimaryBorder;
  List<BoxShadow> get cardPrimaryShadows => brightness == Brightness.dark
      ? const []
      : const [
          BoxShadow(
            color: lightCardShadowAmbient,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: lightCardShadowElevation,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ];
  Color get cardPrimaryShadow =>
      brightness == Brightness.dark ? colorTransparent : lightCardShadowAmbient;
  Color get cardPrimaryHover => surfaceContainerHighest;
  Color get cardPrimaryHighlight => brightness == Brightness.dark
      ? darkSurfaceContainerLow
      : lightSurfaceContainerLow;

  // Card Secondaria (sfondo #EAEEF4 / #12141A, ZERO bordo, ZERO ombra)
  Color get cardSecondaryBg => brightness == Brightness.dark
      ? darkCardSecondaryBg
      : lightCardSecondaryBg;
  Color get cardSecondaryBorder => colorTransparent;
  Color get cardSecondaryFg => onSurface;
  Color get cardSecondaryShadow => colorTransparent;
  List<BoxShadow> get cardSecondaryShadows => const [];

  // Card ad Alta Evidenziazione (High Emphasis)
  Color get cardHighEmphasisBg => cardPrimaryBg;
  Color get cardHighEmphasisBorder => cardPrimaryBorder;
  Color get cardHighEmphasisShadow => cardPrimaryShadow;

  // ── 4. CERCHI ICONA (ICON CIRCLES) ────────────────────────────────────────
  // Cerchio brand usa primaryContainer pieno; i cerchi stato usano gli sfondi pieni.
  Color get iconCircleSafeBg => statusSafeAlpha;
  Color get iconCirclePrimaryBg => primaryContainer;
  Color get iconCircleErrorBg => statusUnsafeAlpha;
  Color get iconCircleTertiaryBg => statusUncertainAlpha;
  Color get iconCircleNeutralBg => statusUnknownAlpha;
  Color get iconCircleSecondaryBg => statusLactoseAlpha;

  // ── 5. CALL TO ACTION BAR (FOOTER CARD SEGNALAZIONI/DETTAGLI) ────────────
  Color get ctaBarBg => cardSecondaryBg;
  Color get ctaBarBorder => cardSecondaryBorder;
  Color get ctaBarFg => primary;
  Color get ctaTertiaryBg => ctaBarBg;

  // ── 6. ELEMENTI SELEZIONABILI E NON SELEZIONATI ──────────────────────────
  Color get selectedItemBg => primaryContainer;
  Color get selectedItemBorder => primary.withValues(alpha: 0.35);
  Color get selectedErrorItemBg => statusUnsafeAlpha;
  Color get selectedErrorItemBorder => error.withValues(alpha: 0.35);
  Color get unselectedItemBg => surfaceContainerHighest;
  Color get radioUnselectedBorder => brightness == Brightness.dark
      ? darkRadioUnselectedBorder
      : lightRadioUnselectedBorder;

  // ── 7. SELETTORI POPUP / PILL ─────────────────────────────────────────────
  Color get dropdownPillBg => surfaceContainerHighest;

  // ── 8. CONTAINER LEGENDA SCANNER ──────────────────────────────────────────
  Color get scannerLegendContainerBg => brightness == Brightness.dark
      ? darkScannerLegendBg
      : lightScannerLegendBg;

  // ── 9. NAVIGAZIONE E MODAL ───────────────────────────────────────────────
  Color get bottomNavBg =>
      brightness == Brightness.dark ? darkBottomNavBg : lightBottomNavBg;
  Color get floatingNavBg =>
      brightness == Brightness.dark ? darkFloatingNavBg : lightFloatingNavBg;
  Color get floatingNavBorder => brightness == Brightness.dark
      ? darkFloatingNavBorder
      : lightFloatingNavBorder;
  List<BoxShadow> get floatingNavShadows => brightness == Brightness.dark
      ? const [
          BoxShadow(
            color: darkFloatingNavShadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ]
      : const [
          BoxShadow(
            color: lightFloatingNavShadowAmbient,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: lightFloatingNavShadowElevation,
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ];
  List<Color> get floatingNavBackdropColors => [
    surface.withValues(alpha: 0.0),
    surface.withValues(alpha: 0.75),
    surface.withValues(alpha: 0.92),
  ];
  Color get modalBackgroundColor =>
      brightness == Brightness.dark ? darkBottomSheetBg : lightBottomSheetBg;
  Color get navSelectedBg => iconCirclePrimaryBg;
  Color get navSelectedFg => onSecondaryContainer;

  // ── 10. ACCESSO ANONIMO ───────────────────────────────────────────────────
  Color get anonymousEntryFg => primary;

  // ── 11. EFFETTI SPLASH / OVERLAY ──────────────────────────────────────────
  Color get splashPrimary => primary.withValues(alpha: 0.12);
  Color get splashError => error.withValues(alpha: 0.12);

  // ── 12. TESTO TERZIARIO (Hint / Placeholder) ──────────────────────────────
  Color get textTertiary =>
      brightness == Brightness.dark ? darkTextTertiary : lightTextTertiary;
}
