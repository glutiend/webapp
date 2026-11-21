// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../theme/app_theme.dart';

/// Pulsante circolare 40dp con tre puntini verticali per menu opzioni,
/// coordinato con il design system di GlutiEnd.
class AppCircleMoreMenu<T> extends StatelessWidget {
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final String? tooltip;
  final Offset offset;

  const AppCircleMoreMenu({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.tooltip,
    this.offset = const Offset(0, 48),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final cardBg = context.cardBackground;

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: colorScheme.onSurface.withValues(alpha: 0.12),
          highlightColor: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        child: PopupMenuButton<T>(
          tooltip: tooltip ?? "common.actions.moreOptions".tr(),
          elevation: 6,
          shadowColor: colorScheme.shadow,
          offset: offset,
          color: cardBg,
          surfaceTintColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: colorScheme.cardPrimaryBorder,
              width: 1,
            ),
          ),
          icon: Icon(
            Icons.more_vert_rounded,
            color: colorScheme.onSurface,
          ),
          onSelected: onSelected,
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}
