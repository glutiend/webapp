// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:glutiend/core/theme/app_theme.dart';

/// Barra di navigazione inferiore flottante a pillola M3 per dispositivi mobili.
class MainCustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const MainCustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colorScheme.floatingNavBackdropColors,
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colorScheme.floatingNavBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: colorScheme.floatingNavBorder),
                boxShadow: colorScheme.floatingNavShadows,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    _buildNavItem(
                      context,
                      0,
                      Icons.qr_code_scanner,
                      Icons.qr_code_scanner,
                      "common.navigation.scanner".tr(),
                    ),
                    _buildNavItem(
                      context,
                      1,
                      Icons.history,
                      Icons.history,
                      "common.navigation.history".tr(),
                    ),
                    _buildNavItem(
                      context,
                      2,
                      Icons.report_problem,
                      Icons.report_problem_outlined,
                      "common.navigation.reports".tr(),
                    ),
                    _buildNavItem(
                      context,
                      3,
                      Icons.settings,
                      Icons.settings_outlined,
                      "common.navigation.settings".tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final bool isSelected = currentIndex == index;
    final colorScheme = context.colorScheme;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: colorTransparent,
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => onTabSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.navSelectedBg
                          : colorTransparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(
                      isSelected ? activeIcon : inactiveIcon,
                      color: isSelected
                          ? colorScheme.navSelectedFg
                          : colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
