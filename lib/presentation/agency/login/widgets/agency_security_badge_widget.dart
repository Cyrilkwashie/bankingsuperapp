import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AgencySecurityBadgeWidget extends StatelessWidget {
  final AnimationController pulseController;

  const AgencySecurityBadgeWidget({super.key, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    const accent = Color(0xFF2E8B8B);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLight
              ? [const Color(0xFFF0FDFA), const Color(0xFFF0FDF9)]
              : [const Color(0xFF0D2626), const Color(0xFF0F2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent.withValues(alpha: isLight ? 0.15 : 0.2),
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final scale = 1.0 + (pulseController.value * 0.08);
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: accent,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Agent Access',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isLight
                        ? const Color(0xFF1A1D23)
                        : const Color(0xFFF9FAFB),
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  'Bank-grade encryption • Real-time monitoring',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w400,
                    color: isLight
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isLight ? const Color(0xFFD1D5DB) : const Color(0xFF4B5563),
            size: 20,
          ),
        ],
      ),
    );
  }
}
