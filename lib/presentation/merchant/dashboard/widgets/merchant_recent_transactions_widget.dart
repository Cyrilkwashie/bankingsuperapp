import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/activity_helpers.dart';
import '../../../../data/mock_merchant_activities.dart';
import '../../../../widgets/activity_list_item.dart';
import '../../transactions/merchant_transaction_detail_screen.dart';

/// Recent activities — flat list, no card wrapper
class MerchantRecentTransactionsWidget extends StatelessWidget {
  final bool isDark;

  const MerchantRecentTransactionsWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activities',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.merchantTransactions);
              },
              child: Text(
                'See All',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.2.h),
        ...MockMerchantActivities.recent.map(
          (activity) => ActivityListItem(
            activity: activity,
            isDark: isDark,
            module: ActivityModule.merchant,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    MerchantTransactionDetailScreen(transaction: activity),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
