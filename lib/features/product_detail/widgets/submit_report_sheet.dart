// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/analyzer_service.dart';
import '../../../services/report_rate_limiter.dart';
import 'section_card.dart';

void showSubmitReportBottomSheet({
  required BuildContext context,
  required Product currentProduct,
  required UserSettings userSettings,
  required void Function(String barcode, Map<String, dynamic> reportData)
  onReportSubmit,
  required VoidCallback onSubmitted,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: false,
    constraints: const BoxConstraints(maxWidth: 500),
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetCtx) {
      return _SubmitReportSheetContent(
        currentProduct: currentProduct,
        userSettings: userSettings,
        onReportSubmit: onReportSubmit,
        onSubmitted: onSubmitted,
      );
    },
  );
}

class _SubmitReportSheetContent extends StatefulWidget {
  final Product currentProduct;
  final UserSettings userSettings;
  final void Function(String barcode, Map<String, dynamic> reportData)
  onReportSubmit;
  final VoidCallback onSubmitted;

  const _SubmitReportSheetContent({
    required this.currentProduct,
    required this.userSettings,
    required this.onReportSubmit,
    required this.onSubmitted,
  });

  @override
  State<_SubmitReportSheetContent> createState() =>
      _SubmitReportSheetContentState();
}

class _SubmitReportSheetContentState extends State<_SubmitReportSheetContent> {
  String _reportType = "incorrect_status";
  late final TextEditingController _commentsController;
  int _remainingSeconds = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _commentsController = TextEditingController();
    _initRateLimitCooldown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _commentsController.dispose();
    super.dispose();
  }

  void _initRateLimitCooldown() async {
    final sec = await ReportRateLimiter.getRemainingCooldownSeconds();
    if (!mounted) return;
    setState(() {
      _remainingSeconds = sec;
    });

    if (_remainingSeconds > 0) {
      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_remainingSeconds > 1) {
            _remainingSeconds--;
          } else {
            _remainingSeconds = 0;
            timer.cancel();
          }
        });
      });
    }
  }

  String _getReportTypeLabel(String type) {
    switch (type) {
      case "incorrect_status":
        return "common.reportReasons.incorrectStatus".tr();
      case "label_unclear":
        return "common.reportReasons.incorrectProductData".tr();
      case "other":
        return "common.reportReasons.missingInformation".tr();
      case "outdated":
      default:
        return "common.reportReasons.outdatedProductData".tr();
    }
  }

  Widget _buildReasonGrid(ColorScheme colorScheme) {
    const options = ["incorrect_status", "label_unclear", "other", "outdated"];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: _buildReasonTile(options[0], colorScheme)),
            const SizedBox(width: 10),
            Expanded(child: _buildReasonTile(options[1], colorScheme)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildReasonTile(options[2], colorScheme)),
            const SizedBox(width: 10),
            Expanded(child: _buildReasonTile(options[3], colorScheme)),
          ],
        ),
      ],
    );
  }

  Widget _buildReasonTile(String type, ColorScheme colorScheme) {
    final bool isSelected = _reportType == type;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.selectedItemBg
            : colorScheme.unselectedItemBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? colorScheme.selectedItemBorder
              : Colors.transparent,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() {
              _reportType = type;
            });
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: colorScheme.splashPrimary,
          highlightColor: colorScheme.selectedItemBg,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Center(
              child: Text(
                _getReportTypeLabel(type),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bool isBlocked = _remainingSeconds > 0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.modalBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- M3 Drag Handle ---
            Center(
              child: Container(
                width: 36,
                height: 5,
                margin: const EdgeInsets.only(top: 16, bottom: 24),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // --- Intestazione ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Text(
                  "product.actions.reportError".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Text(
                  "product.reportSheet.communityCallout".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Contenuto Scrollabile ---
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Selettore Motivo (Griglia 2x2 Simmetrica) ---
                    Center(
                      child: Text(
                        "product.reportSheet.reasonLabel".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildReasonGrid(colorScheme),

                    const SizedBox(height: 32),

                    // --- Sezione Dettagli ---
                    Center(
                      child: Text(
                        "product.reportSheet.detailsLabel".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _commentsController,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: "product.reportSheet.detailsHint".tr(),
                        hintStyle: TextStyle(color: colorScheme.textTertiary),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),

                    // --- Card Informativa Rate Limiting M3 (Stile Avviso OFF) ---
                    if (isBlocked) ...[
                      const SizedBox(height: 20),
                      SectionCard(
                        title: "product.reportSheet.rateLimitTitle".tr(),
                        icon: Icons.error_outline_outlined,
                        isCaution: true,
                        child: Text(
                          "product.reportSheet.rateLimitBanner".tr(),
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // --- Azioni Centrate e Compatte ---
                    Center(
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 100,
                                ),
                                child: SizedBox(
                                  height: 44,
                                  child: AppTertiaryButton(
                                    onPressed: () => Navigator.pop(context),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    label: "common.actions.cancel".tr(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 100,
                                ),
                                child: SizedBox(
                                  height: 44,
                                  child: AppPrimaryButton(
                                    onPressed: isBlocked
                                        ? null
                                        : () {
                                            // 1. Registra sottomissione per il rate limiting
                                            ReportRateLimiter.recordSubmission();

                                            final currentLang = widget
                                                .userSettings
                                                .preferredLanguage;
                                            final origAnalysis =
                                                AnalyzerService.analyzeGlutenSafety(
                                                  name: widget.currentProduct
                                                      .getName(currentLang),
                                                  brand: widget.currentProduct
                                                      .getBrand(currentLang),
                                                  ingredients: widget
                                                      .currentProduct
                                                      .getIngredients(
                                                        currentLang,
                                                      ),
                                                  allergensList: widget
                                                      .currentProduct
                                                      .getAllergens(
                                                        currentLang,
                                                      ),
                                                  reportCount: 0,
                                                  categoriesTags: widget
                                                      .currentProduct
                                                      .categoriesTags,
                                                  offTags: widget.currentProduct
                                                      .toOffTags(),
                                                  strictMode: widget
                                                      .userSettings
                                                      .strictMode,
                                                  warnAdditives: widget
                                                      .userSettings
                                                      .warnAdditives,
                                                  alertLactose: widget
                                                      .userSettings
                                                      .alertLactose,
                                                  preferredLanguage:
                                                      currentLang,
                                                  ignoreReports: true,
                                                );

                                            final reportData = {
                                              "type": _reportType,
                                              "comments":
                                                  _commentsController.text,
                                              "originalStatus":
                                                  origAnalysis.status.name,
                                            };

                                            // 2. Chiudi immediatamente il bottom sheet (0 ms)
                                            Navigator.pop(context);

                                            // 3. Notifica ottimistica alla vista sottostante
                                            widget.onSubmitted();

                                            // 4. Lancia persistenza e sync in background
                                            widget.onReportSubmit(
                                              widget.currentProduct.barcode,
                                              reportData,
                                            );
                                          },
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    label: isBlocked
                                        ? "product.reportSheet.waitCountdown".tr(
                                            namedArgs: {
                                              'time':
                                                  ReportRateLimiter.formatRemainingTime(
                                                    _remainingSeconds,
                                                  ),
                                            },
                                          )
                                        : "product.reportSheet.submit".tr(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
