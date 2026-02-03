import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Service action grid with 2-column layout for primary operations
class ServiceActionGrid extends StatelessWidget {
  const ServiceActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final services = [
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Cash Deposit',
        'subtitle': 'Deposit cash into account',
        'color': const Color(0xFF1B365D),
      },
      {
        'icon': Icons.money,
        'title': 'Cash Withdrawal',
        'subtitle': 'Withdraw cash for customer',
        'color': const Color(0xFF2E8B8B),
      },
      {
        'icon': Icons.swap_horiz,
        'title': 'Same Bank Transfer',
        'subtitle': 'Transfer within the bank',
        'color': const Color(0xFF059669),
      },
      {
        'icon': Icons.send,
        'title': 'Other Bank Transfer',
        'subtitle': 'Instant interbank payment',
        'color': const Color(0xFFD97706),
      },
      {
        'icon': Icons.qr_code_scanner,
        'title': 'QR Deposit',
        'subtitle': 'Scan QR to deposit',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.qr_code,
        'title': 'QR Withdrawal',
        'subtitle': 'Scan QR to withdraw',
        'color': const Color(0xFFEC4899),
      },
      {
        'icon': Icons.person_add,
        'title': 'Open Savings Account',
        'subtitle': 'Create new customer account',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.account_balance,
        'title': 'Balance Enquiry',
        'subtitle': 'Check customer balance',
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.receipt,
        'title': 'Mini Statement',
        'subtitle': 'Last 10 transactions',
        'color': const Color(0xFF6366F1),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.1,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(
          context,
          icon: service['icon'] as IconData,
          title: service['title'] as String,
          subtitle: service['subtitle'] as String,
          color: service['color'] as Color,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFFAFBFC)
                        : const Color(0xFF1A1D23),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
