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
  final int _currentIndex = 0;

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        break;
      case 1:
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.agencyTransactions,
        );
        break;
      case 2:
        AppRoutes.replaceWithoutTransition(context, AppRoutes.agencyLocations);
        break;
      case 3:
        AppRoutes.replaceWithoutTransition(context, AppRoutes.agencySettings);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgentHeaderCard(isDark: isDark),
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0),
          child: QuickActionsGrid(
            isDark: isDark,
            onViewAll: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AgencyAllServicesScreen(),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.5.h),
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF2E8B8B),
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
              children: [
                RecentTransactionsWidget(isDark: isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
