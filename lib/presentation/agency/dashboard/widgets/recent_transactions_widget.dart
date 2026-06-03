import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/activity_helpers.dart';
import '../../../../data/mock_agency_activities.dart';
import '../../../../widgets/activity_list_item.dart';
import '../../transactions/agency_transaction_detail_screen.dart';

/// Recent activities — flat list, no card wrapper
class RecentTransactionsWidget extends StatelessWidget {
  final bool isDark;

  const RecentTransactionsWidget({super.key, required this.isDark});

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
                Navigator.of(context).pushNamed(AppRoutes.agencyTransactions);
              },
              child: Text(
                'See All',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E8B8B),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.2.h),
        ...MockAgencyActivities.recent.map(
          (activity) => ActivityListItem(
            activity: activity,
            isDark: isDark,
            module: ActivityModule.agency,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    AgencyTransactionDetailScreen(transaction: activity),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
