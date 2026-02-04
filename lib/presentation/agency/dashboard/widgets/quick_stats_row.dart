import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickStatsRow extends StatelessWidget {
  final bool isDark;

  const QuickStatsRow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Today\'s Txns',
              '24',
              'swap_horiz',
              const Color(0xFF2E8B8B),
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          Expanded(
            child: _buildStatCard(
              'Cash In',
              'GH₵125K',
              'arrow_downward',
              const Color(0xFF10B981),
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          Expanded(
            child: _buildStatCard(
              'Cash Out',
              'GH₵75K',
              'arrow_upward',
              const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.5.w),
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 15,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1D23),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
