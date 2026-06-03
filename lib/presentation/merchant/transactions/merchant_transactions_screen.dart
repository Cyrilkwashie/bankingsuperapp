import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/activity_helpers.dart';
import '../../../../data/mock_merchant_activities.dart';
import '../../../../widgets/activity_list_item.dart';
import '../../../../widgets/banking_bottom_navigation.dart';
import 'merchant_transaction_detail_screen.dart';

/// Merchant Banking Transactions Screen - Dedicated transaction history and management
class MerchantTransactionsScreen extends StatefulWidget {
  const MerchantTransactionsScreen({super.key});

  @override
  State<MerchantTransactionsScreen> createState() =>
      _MerchantTransactionsScreenState();
}

class _MerchantTransactionsScreenState
    extends State<MerchantTransactionsScreen> {
  final int _currentIndex = 1; // Transactions tab is selected

  final List<Map<String, dynamic>> _transactions =
      MockMerchantActivities.history;

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;

    // Navigate to different screens based on index
    switch (index) {
      case 0: // Dashboard
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.merchantBankingDashboard,
        );
        break;
      case 1: // Transactions (current)
        // Already here
        break;
      case 2: // Settings
        AppRoutes.replaceWithoutTransition(context, AppRoutes.merchantSettings);
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
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Today\'s Revenue',
                        'GH₵ 2,847',
                        Icons.trending_up,
                        const Color(0xFF059669),
                        isDark,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildSummaryCard(
                        'Activities',
                        '32',
                        Icons.history,
                        const Color(0xFF059669),
                        isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Activity List
                Expanded(
                  child: ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return ActivityListItem(
                        activity: transaction,
                        isDark: isDark,
                        module: ActivityModule.merchant,
                        compact: false,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MerchantTransactionDetailScreen(
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
          items: BankingNavigationItems.merchantItems,
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
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: brandColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: brandColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brandColor, size: 12),
          SizedBox(height: 0.3.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 6.sp,
              fontWeight: FontWeight.w500,
              color: brandColor,
            ),
          ),
          SizedBox(height: 0.1.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              color: brandColor,
            ),
          ),
        ],
      ),
    );
  }
}
