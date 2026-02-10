import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/banking_bottom_navigation.dart';
import './widgets/agent_header_card.dart';
import './widgets/quick_actions_grid.dart';
import './widgets/recent_transactions_widget.dart';
import './agency_all_services_screen.dart';

class AgencyBankingDashboardScreen extends StatefulWidget {
  const AgencyBankingDashboardScreen({super.key});

  @override
  State<AgencyBankingDashboardScreen> createState() =>
      _AgencyBankingDashboardScreenState();
}

class _AgencyBankingDashboardScreenState
    extends State<AgencyBankingDashboardScreen> {
  int _currentIndex = 0;

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.agencyTransactions);
        break;
      case 2:
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.agencyLocations);
        break;
      case 3:
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.agencySettings);
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
          items: BankingNavigationItems.agencyItems,
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
            // Gradient header area (no SafeArea — gradient bleeds to status bar)
            AgentHeaderCard(isDark: isDark),
            // White content area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.5.h),
                  QuickActionsGrid(
                    isDark: isDark,
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AgencyAllServicesScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 2.5.h),
                  RecentTransactionsWidget(isDark: isDark),
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
