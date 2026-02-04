import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../routes/app_routes.dart';
import '../../../../widgets/banking_bottom_navigation.dart';
import './widgets/branch_header_card.dart';
import './widgets/branch_quick_stats_row.dart';
import './widgets/smart_branch_categorized_services_widget.dart';

/// Smart Branch Dashboard - Comprehensive operational hub for Smart Branch banking services
class SmartBranchDashboardScreen extends StatefulWidget {
  const SmartBranchDashboardScreen({super.key});

  @override
  State<SmartBranchDashboardScreen> createState() =>
      _SmartBranchDashboardScreenState();
}

class _SmartBranchDashboardScreenState
    extends State<SmartBranchDashboardScreen> {
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
        ).pushReplacementNamed(AppRoutes.smartBranchTransactions);
        break;
      case 2: // Settings
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.smartBranchSettings);
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
          items: BankingNavigationItems.smartBranchItems,
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
              BranchHeaderCard(isDark: isDark),
              SizedBox(height: 2.h),
              BranchQuickStatsRow(isDark: isDark),
              SizedBox(height: 1.5.h),
              SmartBranchCategorizedServicesWidget(isDark: isDark),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
