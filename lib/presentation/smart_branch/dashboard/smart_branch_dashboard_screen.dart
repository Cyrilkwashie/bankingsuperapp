import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/banking_bottom_navigation.dart';
import './widgets/branch_header_card.dart';
import './widgets/branch_quick_actions_grid.dart';
import './widgets/branch_recent_transactions_widget.dart';
import './smart_branch_all_services_screen.dart';

class SmartBranchDashboardScreen extends StatefulWidget {
  const SmartBranchDashboardScreen({super.key});

  @override
  State<SmartBranchDashboardScreen> createState() =>
      _SmartBranchDashboardScreenState();
}

class _SmartBranchDashboardScreenState
    extends State<SmartBranchDashboardScreen> {
  final int _currentIndex = 0;

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        break;
      case 1:
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.smartBranchTransactions,
        );
        break;
      case 2:
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.smartBranchSettings,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F6FA),
        body: _buildBody(isDark),
        bottomNavigationBar: BankingBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onNavigationTap,
          items: BankingNavigationItems.smartBranchItems,
        ),
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BranchHeaderCard(isDark: isDark),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.5.h),
                  BranchQuickActionsGrid(
                    isDark: isDark,
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const SmartBranchAllServicesScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  BranchRecentTransactionsWidget(isDark: isDark),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
