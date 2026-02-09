import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MerchantBiometricSectionWidget extends StatelessWidget {
  final VoidCallback onBiometricLogin;
  final Color brandColor;

  const MerchantBiometricSectionWidget({
    super.key,
    required this.onBiometricLogin,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      isLight
                          ? const Color(0xFFE5E7EB)
                          : const Color(0xFF2A2F3E),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'or continue with',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: isLight
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isLight
                          ? const Color(0xFFE5E7EB)
                          : const Color(0xFF2A2F3E),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBiometricLogin,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: brandColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                color: brandColor.withValues(alpha: isLight ? 0.04 : 0.08),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.fingerprint_rounded,
                      color: brandColor,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Use Biometric Login',
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: brandColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
