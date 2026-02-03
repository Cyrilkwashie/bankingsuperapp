import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Transactions',
            '24',
            Icons.swap_horiz,
            const Color(0xFF3FA5A5),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            'Cash In',
            '₦125K',
            Icons.arrow_downward,
            const Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            'Cash Out',
            '₦75K',
            Icons.arrow_upward,
            const Color(0xFFEF4444),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 0.2.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
