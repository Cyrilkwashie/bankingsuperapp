import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Biometric authentication section widget
class BiometricSectionWidget extends StatelessWidget {
  final VoidCallback onBiometricLogin;

  const BiometricSectionWidget({super.key, required this.onBiometricLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.colorScheme.outline)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                'OR',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: theme.colorScheme.outline)),
          ],
        ),

        SizedBox(height: 2.h),

        OutlinedButton.icon(
          onPressed: onBiometricLogin,
          icon: CustomIconWidget(
            iconName: 'fingerprint',
            size: 24,
            color: theme.colorScheme.primary,
          ),
          label: Text(
            'Use Biometric Login',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 7.h),
            side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
      ],
    );
  }
}
