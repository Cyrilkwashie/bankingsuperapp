import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Quick stats row displaying key daily metrics
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.swap_horiz,
            label: 'Transactions',
            value: '24',
            color: const Color(0xFF2E8B8B),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.arrow_downward,
            label: 'Cash In',
            value: '₦ 850K',
            color: const Color(0xFF059669),
            isDark: isDark,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.arrow_upward,
            label: 'Cash Out',
            value: '₦ 620K',
            color: const Color(0xFFD97706),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.08,
            ),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFFAFBFC) : const Color(0xFF1A1D23),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
