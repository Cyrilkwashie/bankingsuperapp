import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/agent_header_card.dart';
import './widgets/quick_stats_row.dart';
import './widgets/service_action_grid.dart';
import './widgets/secondary_services_list.dart';
import './widgets/daily_activity_card.dart';
import '../settings_screen/settings_screen.dart';

/// Agency Banking Dashboard - Main workspace for banking agents
/// Provides comprehensive access to daily operations and performance metrics
class AgencyBankingDashboardScreen extends StatefulWidget {
  const AgencyBankingDashboardScreen({super.key});

  @override
  State<AgencyBankingDashboardScreen> createState() =>
      _AgencyBankingDashboardScreenState();
}

class _AgencyBankingDashboardScreenState
    extends State<AgencyBankingDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xFFFAFBFC)
          : const Color(0xFF0F1419),
      body: SafeArea(
        child: _currentIndex == 0
            ? _buildDashboardContent()
            : _currentIndex == 1
            ? _buildTransactionsContent()
            : _currentIndex == 2
            ? _buildLocationsContent()
            : const SettingsScreen(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
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
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: theme.brightness == Brightness.light
                ? const Color(0xFF6B7280)
                : const Color(0xFF9CA3AF),
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
                label: 'Home',
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
                  child: Icon(Icons.location_on_outlined, size: 24),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.location_on, size: 24),
                ),
                label: 'Locations',
                tooltip: 'Branch & ATM Locations',
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
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AgentHeaderCard(),
              SizedBox(height: 2.h),
              const QuickStatsRow(),
              SizedBox(height: 3.h),
              Text(
                'Services',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF1A1D23)
                      : const Color(0xFFFAFBFC),
                ),
              ),
              SizedBox(height: 1.5.h),
              const ServiceActionGrid(),
              SizedBox(height: 3.h),
              Text(
                'More Services',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF1A1D23)
                      : const Color(0xFFFAFBFC),
                ),
              ),
              SizedBox(height: 1.5.h),
              const SecondaryServicesList(),
              SizedBox(height: 3.h),
              Text(
                'Today\'s Activity',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF1A1D23)
                      : const Color(0xFFFAFBFC),
                ),
              ),
              SizedBox(height: 1.5.h),
              const DailyActivityCard(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsContent() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'Transaction History',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF1A1D23)
                    : const Color(0xFFFAFBFC),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'View all your transactions here',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationsContent() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'Branch & ATM Locations',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF1A1D23)
                    : const Color(0xFFFAFBFC),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Find nearby branches and ATMs',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}