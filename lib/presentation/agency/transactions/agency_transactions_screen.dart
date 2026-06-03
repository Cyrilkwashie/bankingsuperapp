import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/activity_helpers.dart';
import '../../../../data/mock_agency_activities.dart';
import '../../../../widgets/activity_list_item.dart';
import '../../../../widgets/banking_bottom_navigation.dart';
import 'agency_transaction_detail_screen.dart';

/// Agency Banking Transactions Screen - Dedicated transaction history and management
class AgencyTransactionsScreen extends StatefulWidget {
  const AgencyTransactionsScreen({super.key});

  @override
  State<AgencyTransactionsScreen> createState() =>
      _AgencyTransactionsScreenState();
}

class _AgencyTransactionsScreenState extends State<AgencyTransactionsScreen> {
  final int _currentIndex = 1; // Transactions tab is selected

  final List<Map<String, dynamic>> _transactions = MockAgencyActivities.history;

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;

    // Navigate to different screens based on index
    switch (index) {
      case 0: // Dashboard
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.agencyBankingDashboard,
        );
        break;
      case 1: // Transactions (current)
        // Already here
        break;
      case 2: // Locations
        AppRoutes.replaceWithoutTransition(context, AppRoutes.agencyLocations);
        break;
      case 3: // Settings
        AppRoutes.replaceWithoutTransition(context, AppRoutes.agencySettings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'History',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color:
                  theme.appBarTheme.titleTextStyle?.color ??
                  theme.colorScheme.onSurface,
            ),
          ),
          actions: [
            IconButton(
              icon: CustomIconWidget(
                iconName: 'filter_list',
                color:
                    theme.appBarTheme.iconTheme?.color ??
                    theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: () {
                // Show filter options
              },
            ),
            IconButton(
              icon: CustomIconWidget(
                iconName: 'search',
                color:
                    theme.appBarTheme.iconTheme?.color ??
                    theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: () {
                // Show search
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Today\'s Volume',
                        'GH₵ 89,200',
                        Icons.trending_up,
                        const Color(0xFF2E8B8B),
                        isDark,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildSummaryCard(
                        'Activities',
                        '48',
                        Icons.history,
                        const Color(0xFF2E8B8B),
                        isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Activity List
                Expanded(
                  child: ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return ActivityListItem(
                        activity: transaction,
                        isDark: isDark,
                        module: ActivityModule.agency,
                        compact: false,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AgencyTransactionDetailScreen(
                              transaction: transaction,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BankingBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onNavigationTap,
          items: BankingNavigationItems.agencyItems,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color brandColor,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        color: brandColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: brandColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brandColor, size: 16),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: brandColor,
            ),
          ),
          SizedBox(height: 0.2.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: brandColor,
            ),
          ),
        ],
      ),
    );
  }
}
