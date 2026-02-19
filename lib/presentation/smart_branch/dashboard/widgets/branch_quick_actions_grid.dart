import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../smart_branch_all_services_screen.dart';

/// Quick actions — icon + label only, 4 across
class BranchQuickActionsGrid extends StatelessWidget {
  final bool isDark;
  final VoidCallback onViewAll;

  const BranchQuickActionsGrid({
    super.key,
    required this.isDark,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(width: 0.5.w),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF2563EB),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F25) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF262C33)
                  : const Color(0xFFEEF0F2),
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF64748B).withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              _buildAction(context, 'Deposit', 'arrow_downward',
                  const Color(0xFF10B981)),
              _buildAction(context, 'Withdraw', 'arrow_upward',
                  const Color(0xFFEF4444)),
              _buildAction(context, 'Transactions', 'receipt_long',
                  const Color(0xFF6366F1)),
              _buildAction(context, 'Settings', 'settings',
                  const Color(0xFFF59E0B)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context,
    String label,
    String iconName,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == 'Deposit' || label == 'Withdraw') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SmartBranchAllServicesScreen(),
              ),
            );
            return;
          }
          if (label == 'Transactions') {
            Navigator.of(context).pushNamed(AppRoutes.smartBranchTransactions);
            return;
          }
          if (label == 'Settings') {
            Navigator.of(context).pushNamed(AppRoutes.smartBranchSettings);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label — Coming Soon'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.12 : 0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withValues(alpha: isDark ? 0.18 : 0.1),
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 21,
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.8)
                    : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
