import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/banking_bottom_navigation.dart';
import 'smart_branch_transaction_detail_screen.dart';

/// Smart Branch Transactions Screen - Dedicated transaction history and management
class SmartBranchTransactionsScreen extends StatefulWidget {
  const SmartBranchTransactionsScreen({super.key});

  @override
  State<SmartBranchTransactionsScreen> createState() =>
      _SmartBranchTransactionsScreenState();
}

class _SmartBranchTransactionsScreenState
    extends State<SmartBranchTransactionsScreen> {
  final int _currentIndex = 1; // Transactions tab is selected

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001234567',
      'type': 'deposit',
      'customer': 'John Mensah',
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
      'customer': 'Ama Asante',
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
      'customer': 'Kofi Johnson',
      'amount': 15000.00,
      'date': '2026-02-03 12:45',
      'status': 'success',
      'reference': 'REF-2026-02-03-003',
      'fee': 25.00,
      'notes': 'Inter-branch transfer',
    },
    {
      'id': 'TXN001234564',
      'type': 'deposit',
      'customer': 'Sarah Wilson',
      'amount': 7500.00,
      'date': '2026-02-03 11:30',
      'status': 'pending',
      'reference': 'REF-2026-02-03-004',
      'fee': 15.00,
      'notes': 'Check deposit - pending verification',
    },
    {
      'id': 'TXN001234563',
      'type': 'withdrawal',
      'customer': 'Michael Brown',
      'amount': 3200.00,
      'date': '2026-02-03 10:15',
      'status': 'success',
      'reference': 'REF-2026-02-03-005',
      'fee': 8.00,
      'notes': 'ATM withdrawal',
    },
    {
      'id': 'TXN001234562',
      'type': 'deposit',
      'customer': 'Grace Owusu',
      'amount': 12000.00,
      'date': '2026-02-02 16:45',
      'status': 'success',
      'reference': 'REF-2026-02-02-006',
      'fee': 20.00,
      'notes': 'Business account deposit',
    },
    {
      'id': 'TXN001234561',
      'type': 'transfer',
      'customer': 'Emmanuel Adjei',
      'amount': 8500.00,
      'date': '2026-02-02 15:20',
      'status': 'failed',
      'reference': 'REF-2026-02-02-007',
      'fee': 15.00,
      'notes': 'International transfer - insufficient funds',
    },
    {
      'id': 'TXN001234560',
      'type': 'deposit',
      'customer': 'Abena Darko',
      'amount': 2200.00,
      'date': '2026-02-02 14:10',
      'status': 'success',
      'reference': 'REF-2026-02-02-008',
      'fee': 5.00,
      'notes': 'Salary deposit',
    },
    {
      'id': 'TXN001234559',
      'type': 'withdrawal',
      'customer': 'Kwame Boateng',
      'amount': 6000.00,
      'date': '2026-02-02 12:30',
      'status': 'success',
      'reference': 'REF-2026-02-02-009',
      'fee': 12.00,
      'notes': 'Cash withdrawal for business',
    },
    {
      'id': 'TXN001234558',
      'type': 'transfer',
      'customer': 'Yaa Mensah',
      'amount': 3500.00,
      'date': '2026-02-02 10:45',
      'status': 'pending',
      'reference': 'REF-2026-02-02-010',
      'fee': 7.00,
      'notes': 'Transfer to savings account',
    },
    {
      'id': 'TXN001234557',
      'type': 'deposit',
      'customer': 'Nana Akufo',
      'amount': 18000.00,
      'date': '2026-02-01 16:20',
      'status': 'success',
      'reference': 'REF-2026-02-01-011',
      'fee': 30.00,
      'notes': 'Business revenue deposit',
    },
    {
      'id': 'TXN001234556',
      'type': 'withdrawal',
      'customer': 'Efua Appiah',
      'amount': 1500.00,
      'date': '2026-02-01 14:55',
      'status': 'success',
      'reference': 'REF-2026-02-01-012',
      'fee': 3.00,
      'notes': 'Personal withdrawal',
    },
  ];

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;

    // Navigate to different screens based on index
    switch (index) {
      case 0: // Dashboard
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.smartBranchDashboard);
        break;
      case 1: // Transactions (current)
        // Already here
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Transaction History',
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
                        'GH₵ 127,500',
                        Icons.trending_up,
                        const Color(0xFF1B365D),
                        isDark,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildSummaryCard(
                        'Transactions',
                        '247',
                        Icons.receipt_long,
                        const Color(0xFF1B365D),
                        isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),

                // Transaction List
                Expanded(
                  child: ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return _buildTransactionCard(transaction);
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
          items: BankingNavigationItems.smartBranchItems,
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

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isSuccess = transaction['status'] == 'success';
    final isPending = transaction['status'] == 'pending';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SmartBranchTransactionDetailScreen(transaction: transaction),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getTransactionIcon(transaction['type']),
                    color: iconColor,
                    size: 14,
                  ),
                ),
                SizedBox(width: 2.5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (transaction['customer'] as String?) ??
                            'Unknown Customer',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A1D23),
                        ),
                      ),
                      SizedBox(height: 0.2.h),
                      Text(
                        '${(transaction['type'] as String?)?.toUpperCase() ?? 'UNKNOWN'} • ${(transaction['date'] as String?) ?? 'Unknown'}',
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${transaction['type'] == 'deposit' ? '+' : '-'}GH₵${transaction['amount'] ?? 0}',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w,
                        vertical: 0.2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                            : isPending
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                            : const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (transaction['status'] as String?)?.toUpperCase() ??
                            'UNKNOWN',
                        style: GoogleFonts.inter(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: isSuccess
                              ? const Color(0xFF10B981)
                              : isPending
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(String? type) {
    switch (type) {
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdrawal':
        return Icons.arrow_upward;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.receipt;
    }
  }
}
