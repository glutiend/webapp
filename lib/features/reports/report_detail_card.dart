// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../models/models.dart';
import '../../core/utils/responsive_wrapper.dart';
import '../product_detail/product_detail_card.dart';
import '../../core/network/connectivity_helper.dart';
import 'widgets/report_voting_section.dart';

class ReportDetailCard extends StatefulWidget {
  final Product product;
  final VoidCallback onBack;

  // AGGIUNTO: Lo stato originale del prodotto prima della segnalazione
  final GlutenSafetyStatus originalStatus;

  // Dati fittizi per la segnalazione (Sostituisci con il tuo modello Report reale)
  final String reportReasonKey;
  final String reportComment;
  final String reportDate;
  final int initialUpvotes;
  final int upvotes;
  final int downvotes;

  final Future<void> Function(int voteDirection)? onVote;
  final Future<Map<String, int>> Function()? onInitVote;
  final UserSettings? userSettings;
  final bool isOwnReport;
  final String? reportId;
  final Future<void> Function(String reportId)? onDeleteReport;
  final bool useResponsiveWrapper;
  final bool showProductLink;

  // Iniezione opzionale per i test (usa FirebaseFirestore.instance in produzione)
  final FirebaseFirestore? firebaseFirestore;

  const ReportDetailCard({
    super.key,
    required this.product,
    required this.onBack,
    required this.originalStatus,
    required this.reportReasonKey,
    required this.reportComment,
    required this.reportDate,
    this.initialUpvotes = 12,
    this.onVote,
    this.upvotes = 0,
    this.downvotes = 0,
    this.onInitVote,
    this.userSettings,
    this.isOwnReport = false,
    this.reportId,
    this.onDeleteReport,
    this.useResponsiveWrapper = true,
    this.showProductLink = true,
    this.firebaseFirestore,
  });

  @override
  State<ReportDetailCard> createState() => _ReportDetailCardState();
}

class _ReportDetailCardState extends State<ReportDetailCard> {
  // Stato del voto: 0 = nessun voto, 1 = upvote, -1 = downvote
  int _currentVote = 0;
  late int _upvotes;
  late int _downvotes;
  bool _isVoteLoading = true;

  ProductReport? _activeReport;

  @override
  void initState() {
    super.initState();
    _upvotes = widget.upvotes;
    _downvotes = widget.downvotes;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final firestoreInstance =
          widget.firebaseFirestore ?? FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>>? querySnapshot;
      try {
        querySnapshot = await firestoreInstance
            .collection('reports')
            .where('barcode', isEqualTo: widget.product.barcode)
            .where('status', isEqualTo: 'open')
            .limit(1)
            .get()
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint("Impossibile caricare report da Firestore (offline?): $e");
      }

      Map<String, int> voteData = {};
      if (widget.onInitVote != null) {
        try {
          voteData = await widget.onInitVote!();
        } catch (e) {
          debugPrint("Impossibile recuperare voto iniziale: $e");
        }
      }

      if (mounted) {
        setState(() {
          if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
            _activeReport = ProductReport.fromJson(
              querySnapshot.docs.first.data(),
            );
          }
          if (voteData.isNotEmpty) {
            _upvotes = voteData['upvotes'] ?? widget.upvotes;
            _downvotes = voteData['downvotes'] ?? widget.downvotes;
            _currentVote = voteData['userVote'] ?? 0;
          }
          _isVoteLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Errore nel caricamento del report da Firestore: $e");
      if (mounted) {
        setState(() {
          _isVoteLoading = false;
        });
      }
    }
  }

  void _handleVote(int vote) async {
    final oldVote = _currentVote;
    final oldUpvotes = _upvotes;
    final oldDownvotes = _downvotes;
    setState(() {
      if (_currentVote == vote) {
        // Rimuove il voto (se riclicca)
        if (vote == 1) _upvotes = (_upvotes - 1).clamp(0, 999999);
        if (vote == -1) _downvotes = (_downvotes - 1).clamp(0, 999999);
        _currentVote = 0;
      } else {
        // Rimuovi il contributo precedente
        if (_currentVote == 1) _upvotes = (_upvotes - 1).clamp(0, 999999);
        if (_currentVote == -1) _downvotes = (_downvotes - 1).clamp(0, 999999);
        // Applica il nuovo voto
        if (vote == 1) _upvotes++;
        if (vote == -1) _downvotes++;
        _currentVote = vote;
      }
    });

    if (widget.onVote != null) {
      try {
        await widget.onVote!(_currentVote);
        final isOnline = await ConnectivityHelper.hasInternetConnection();
        if (!isOnline && mounted) {
          showAppSnackBar(context, "report.detail.voteOfflineSuccess".tr());
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _currentVote = oldVote;
            _upvotes = oldUpvotes;
            _downvotes = oldDownvotes;
          });
          showAppSnackBar(
            context,
            "report.detail.voteError".tr(),
            isError: true,
          );
        }
      }
    }
  }

  String _translateReason(String key) {
    switch (key) {
      case "label_unclear":
        return "common.reportReasons.incorrectProductData".tr();
      case "outdated":
        return "common.reportReasons.outdatedProductData".tr();
      case "incorrect_status":
        return "common.reportReasons.incorrectStatus".tr();
      case "other":
        return "common.reportReasons.missingInformation".tr();
      default:
        return "report.detail.generic".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.useResponsiveWrapper
        ? ResponsiveMaxCardWidth(child: _buildContent(context))
        : _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = context.colorScheme;
    final scaffoldBgColor = colorScheme.surface;
    final statusColors = colorScheme.statusUncertainColors;
    final String rawReportDate =
        (_activeReport?.submittedAt != null &&
            _activeReport!.submittedAt.isNotEmpty)
        ? _activeReport!.submittedAt
        : (widget.reportDate.isNotEmpty
              ? widget.reportDate
              : widget.product.lastUpdated);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: widget.onBack,
        ),
        title: Text(
          "report.detail.title".tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.isOwnReport && widget.onDeleteReport != null)
            AppCircleMoreMenu<String>(
              tooltip: "common.actions.moreOptions".tr(),
              onSelected: (value) {
                if (value == 'delete_report') {
                  showDeleteReportConfirmDialog(
                    context: context,
                    onConfirm: () async {
                      final targetId = widget.reportId ?? _activeReport?.id;
                      if (targetId != null && widget.onDeleteReport != null) {
                        await widget.onDeleteReport!(targetId);
                      }
                      if (mounted) widget.onBack();
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                AppDestructivePopupMenuItem<String>(
                  value: 'delete_report',
                  title: "common.actions.deleteReportConfirmTitle".tr(),
                  icon: Icons.report_gmailerrorred_rounded,
                  colorScheme: colorScheme,
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header Prodotto Centrato (su sfondo pulito) ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: statusColors.heroBadgeBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.report,
                      color: statusColors.solid,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.brand,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Pillola Barcode
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColors.barcodeChipBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 16,
                          color: statusColors.solid,
                        ),
                        const SizedBox(width: 8),
                        SelectableText(
                          widget.product.barcode,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: statusColors.solid,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Data della segnalazione
                  if (rawReportDate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        formatReportDate(rawReportDate),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                  // Accesso diretto alla scheda prodotto (TextButton puro)
                  if (widget.showProductLink)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: AppTextButton(
                        icon: Icons.storefront_outlined,
                        label: "report.detail.viewProductCard".tr(),
                        onPressed: () {
                          final productToShow = widget.product;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailCard(
                                product: productToShow,
                                onBack: () => Navigator.pop(context),
                                // Sola lettura: la segnalazione è già stata inviata,
                                // questi callback non verranno mai chiamati da qui.
                                onReportSubmit: (_, _) {},
                                onProductUpdate: (_) async {},
                                userSettings:
                                    widget.userSettings ??
                                    UserSettings(
                                      strictMode: true,
                                      alertLactose: false,
                                      warnAdditives: true,
                                      autoSaveHistory: true,
                                      preferredLanguage: 'it',
                                    ),
                                showReportLink: false,
                                showScanDate: false,
                                hasReportedThisSession: widget.isOwnReport,
                                userReportId: widget.reportId,
                                onDeleteReport: widget.onDeleteReport,
                                useResponsiveWrapper:
                                    widget.useResponsiveWrapper,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Card 1: Motivo Segnalazione (Testata Stitch) ───────────
                  Builder(
                    builder: (context) {
                      final String effectiveComment =
                          (_activeReport != null
                                  ? _activeReport!.comments
                                  : widget.reportComment)
                              .trim();
                      final bool hasComment =
                          effectiveComment.isNotEmpty &&
                          effectiveComment != "Nessun commento";

                      return AppCard.primary(
                        padding: EdgeInsets.zero,
                        borderRadius: 24,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Fascia superiore piena
                            Container(
                              color: colorScheme.statusUncertainAlpha,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    size: 16,
                                    color: colorScheme.statusUncertainSolid,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "report.detail.reasonHeader"
                                          .tr()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.statusUncertainSolid,
                                        letterSpacing: 0.7,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: colorScheme.statusUncertainSolid,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "report.detail.date.inReview".tr(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.statusUncertainSolid,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Corpo inferiore
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _translateReason(
                                      _activeReport?.type ??
                                          widget.reportReasonKey,
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    hasComment
                                        ? effectiveComment
                                        : "report.detail.noAdditionalComment"
                                              .tr(),
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontStyle: hasComment
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                      color: hasComment
                                          ? colorScheme.onSurface
                                          : colorScheme.onSurfaceVariant,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Card 2: Stato Prima della Segnalazione (Opzione 5) ─────
                  AppCard.primary(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.public_outlined,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "report.detail.previousStatusHeader"
                                    .tr()
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "report.detail.previousStatusExplanation".tr(),
                          style: TextStyle(
                            fontSize: 13.5,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.onSurface.withValues(alpha: 0.08),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              "report.detail.statusChangeLabel".tr(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  AppStatusPill.fromStatus(
                                    widget.originalStatus,
                                    isCompact: true,
                                    textOnly: true,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  AppStatusPill.fromStatus(
                                    GlutenSafetyStatus.incerto,
                                    isCompact: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Sistema di Voto (YouTube Style) ────────────────────────
                  ReportVotingSection(
                    isVoteLoading: _isVoteLoading,
                    currentVote: _currentVote,
                    upvotes: _upvotes,
                    downvotes: _downvotes,
                    onVote: _handleVote,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
