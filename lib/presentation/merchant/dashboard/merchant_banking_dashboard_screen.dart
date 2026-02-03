import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/merchant_header_card.dart';
import './widgets/merchant_quick_stats_row.dart';
import './widgets/merchant_categorized_services_widget.dart';
import '../../settings_screen/settings_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: _currentIndex == 0
              ? _buildDashboardContent()
              : _currentIndex == 1
              ? _buildTransactionsNavigation()
              : _currentIndex == 2
              ? _buildCustomersContent()
              : _currentIndex == 3
              ? _buildReportsContent()
              : const SettingsScreen(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, -2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF1B365D),
            unselectedItemColor: const Color(0xFF6B7280),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              height: 1.33,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              height: 1.33,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard, size: 24),
                ),
                label: 'Dashboard',
                tooltip: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.receipt_long_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.receipt_long, size: 24),
                ),
                label: 'Transactions',
                tooltip: 'Transaction History',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people_outline, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people, size: 24),
                ),
                label: 'Customers',
                tooltip: 'Customer Management',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.bar_chart_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.bar_chart, size: 24),
                ),
                label: 'Reports',
                tooltip: 'Business Reports',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.settings_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.settings, size: 24),
                ),
                label: 'Settings',
                tooltip: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
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
              const MerchantHeaderCard(),
              SizedBox(height: 2.h),
              const MerchantQuickStatsRow(),
              SizedBox(height: 3.h),
              const MerchantCategorizedServicesWidget(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed('/merchant-transaction-history-screen');
      setState(() {
        _currentIndex = 0;
      });
    });
    return const SizedBox.shrink();
  }

  Widget _buildCustomersContent() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 80,
              color: const Color(0xFF1B365D).withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'Customer Management',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1D23),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'View and manage your customer base',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsContent() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 80,
              color: const Color(0xFF1B365D).withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'Business Reports',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1D23),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'View sales analytics and performance metrics',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
