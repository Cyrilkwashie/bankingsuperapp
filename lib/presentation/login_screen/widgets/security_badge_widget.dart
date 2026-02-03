import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Security badge widget showing encryption and SSL indicators
class SecurityBadgeWidget extends StatelessWidget {
  const SecurityBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'verified_user',
            size: 20,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              'Bank-Grade 256-bit Encryption',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'lock',
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
