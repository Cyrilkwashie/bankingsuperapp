import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../../widgets/banking_bottom_navigation.dart';
import './widgets/agent_header_card.dart';
import './widgets/quick_stats_row.dart';
import './widgets/categorized_services_widget.dart';

/// Agency Banking Dashboard - Main workspace for banking agents
/// Redesigned with categorized menu sections and small icon grid buttons
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

    // Navigate to different screens based on index
    switch (index) {
      case 0: // Dashboard (current)
        // Already here
        break;
      case 1: // Transactions
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.agencyTransactions);
        break;
      case 2: // Locations
        Navigator.of(context).pushReplacementNamed(AppRoutes.agencyLocations);
        break;
      case 3: // Settings
        Navigator.of(context).pushReplacementNamed(AppRoutes.agencySettings);
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
            child: _currentIndex == 2
                ? _buildLocationsContent()
                : _buildDashboardContent(isDark),
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
              AgentHeaderCard(isDark: isDark),
              SizedBox(height: 2.h),
              QuickStatsRow(isDark: isDark),
              SizedBox(height: 1.5.h),
              CategorizedServicesWidget(isDark: isDark),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsNavigation() {
    return _buildTransactionHistoryContent();
  }

  Widget _buildTransactionHistoryContent() {
    final transactions = [
      {
        'id': 'TXN001234567',
        'type': 'deposit',
        'merchant': 'John Mensah',
        'amount': 5000.00,
        'date': '2026-02-03 14:30',
        'status': 'success',
        'reference': 'REF-2026-02-03-001',
        'fee': 10.00,
        'notes': 'Cash deposit for savings account',
      },
      {
        'id': 'TXN001234566',
        'type': 'withdrawal',
        'merchant': 'Ama Asante',
        'amount': 2500.00,
        'date': '2026-02-03 13:15',
        'status': 'success',
        'reference': 'REF-2026-02-03-002',
        'fee': 5.00,
        'notes': 'Cash withdrawal',
      },
      {
        'id': 'TXN001234565',
        'type': 'transfer',
        'merchant': 'Kwame Boateng',
        'amount': 1500.00,
        'date': '2026-02-03 11:45',
        'status': 'success',
        'reference': 'REF-2026-02-03-003',
        'fee': 0.00,
        'notes': 'Mobile money transfer',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction History',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1D23),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: transaction['type'] == 'deposit'
                              ? Colors.green.withValues(alpha: 0.1)
                              : transaction['type'] == 'withdrawal'
                              ? Colors.red.withValues(alpha: 0.1)
                              : Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          transaction['type'] == 'deposit'
                              ? Icons.arrow_downward
                              : transaction['type'] == 'withdrawal'
                              ? Icons.arrow_upward
                              : Icons.swap_horiz,
                          color: transaction['type'] == 'deposit'
                              ? Colors.green
                              : transaction['type'] == 'withdrawal'
                              ? Colors.red
                              : Colors.blue,
                          size: 4.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (transaction['merchant'] as String?) ?? 'Unknown',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1D23),
                              ),
                            ),
                            Text(
                              (transaction['date'] as String?) ?? 'Unknown',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${transaction['type'] == 'withdrawal' ? '-' : '+'}GH₵${transaction['amount']}',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: transaction['type'] == 'withdrawal'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: transaction['status'] == 'success'
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (transaction['status'] as String?)
                                      ?.toUpperCase() ??
                                  'UNKNOWN',
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
                                color: transaction['status'] == 'success'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationsContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 80,
              color: const Color(0xFF1B365D).withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              'Branch & ATM Locations',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1D23),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Find nearby branches and ATMs',
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
