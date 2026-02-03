import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Daily activity card showing recent transactions
class DailyActivityCard extends StatelessWidget {
  const DailyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final transactions = [
      {
        'type': 'Cash Deposit',
        'amount': '+ ₦ 45,000',
        'time': '10:30 AM',
        'icon': Icons.arrow_downward,
        'color': const Color(0xFF059669),
      },
      {
        'type': 'Cash Withdrawal',
        'amount': '- ₦ 25,000',
        'time': '11:15 AM',
        'icon': Icons.arrow_upward,
        'color': const Color(0xFFDC2626),
      },
      {
        'type': 'Same Bank Transfer',
        'amount': '- ₦ 15,000',
        'time': '12:45 PM',
        'icon': Icons.swap_horiz,
        'color': const Color(0xFF2E8B8B),
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFFAFBFC)
                      : const Color(0xFF1A1D23),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ...transactions.map((transaction) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (transaction['color'] as Color).withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      transaction['icon'] as IconData,
                      color: transaction['color'] as Color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['type'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFFAFBFC)
                                : const Color(0xFF1A1D23),
                          ),
                        ),
                        SizedBox(height: 0.2.h),
                        Text(
                          transaction['time'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    transaction['amount'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: transaction['color'] as Color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
