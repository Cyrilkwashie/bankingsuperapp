import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MerchantQuickStatsRow extends StatelessWidget {
  const MerchantQuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Today\'s Txns',
                '47',
                Icons.receipt_long,
                const Color(0xFF3FA5A5),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                'Revenue',
                'GH₵12.5K',
                Icons.trending_up,
                const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Available',
                'GH₵85.5K',
                Icons.account_balance_wallet,
                const Color(0xFF059669),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                'Customers',
                '234',
                Icons.people,
                const Color(0xFF2E8B8B),
              ),
            ),
          ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              color: const Color(0xFF1A1D23),
            ),
          ),
          SizedBox(height: 0.2.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
