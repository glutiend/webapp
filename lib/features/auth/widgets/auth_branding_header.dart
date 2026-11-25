// Copyright (c) 2026 Emanuele Ciotola. All Rights Reserved.
// PROJECT: GlutiEnd — See LICENSE file in root for terms.

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/theme.dart';

class AuthBrandingHeader extends StatelessWidget {
  const AuthBrandingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isSystemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final logoAsset = isSystemDark
        ? 'assets/splash/splash_icon_dark.png'
        : 'assets/splash/splash_icon.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: context.colorScheme.iconCirclePrimaryBg,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Transform.translate(
            offset: const Offset(0, 2),
            child: Image.asset(logoAsset, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "GlutiEnd",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "auth.branding.tagline".tr(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.textTertiary),
        ),
      ],
    );
  }
}
