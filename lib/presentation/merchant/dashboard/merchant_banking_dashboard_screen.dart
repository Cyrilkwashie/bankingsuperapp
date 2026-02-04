import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../routes/app_routes.dart';
import '../../../../widgets/banking_bottom_navigation.dart';
import './widgets/merchant_header_card.dart';
import './widgets/merchant_quick_stats_row.dart';
import './widgets/merchant_categorized_services_widget.dart';

/// Merchant Banking Dashboard - Main workspace for merchant banking operations
class MerchantBankingDashboardScreen extends StatefulWidget {
  const MerchantBankingDashboardScreen({super.key});

  @override
  State<MerchantBankingDashboardScreen> createState() =>
      _MerchantBankingDashboardScreenState();
}

class _MerchantBankingDashboardScreenState
    extends State<MerchantBankingDashboardScreen> {
  int _currentIndex = 0;

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;

    // Navigate to different screens based on index
    switch (index) {
      case 0: // Dashboard (current)
        // Already here
        break;
      case 1: // Transactions
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.merchantTransactions);
        break;
      case 2: // Settings
        Navigator.of(context).pushReplacementNamed(AppRoutes.merchantSettings);
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
        backgroundColor: isDark
            ? const Color(0xFF0F1419)
            : const Color(0xFFFAFBFC),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: _buildDashboardContent(isDark),
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

  Widget _buildDashboardContent(bool isDark) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MerchantHeaderCard(isDark: isDark),
              SizedBox(height: 2.h),
              MerchantQuickStatsRow(isDark: isDark),
              SizedBox(height: 1.5.h),
              MerchantCategorizedServicesWidget(isDark: isDark),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
