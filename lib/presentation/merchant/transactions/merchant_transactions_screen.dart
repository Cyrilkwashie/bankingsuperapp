import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
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

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001234567',
      'type': 'card_payment',
      'customer': 'John Mensah',
      'amount': 150.00,
      'paymentMethod': 'Visa',
      'date': '2026-02-03 14:30',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-03-001',
      'fee': 2.25,
    },
    {
      'id': 'TXN001234566',
      'type': 'qr_transaction',
      'customer': 'Ama Asante',
      'amount': 75.50,
      'paymentMethod': 'Mobile Money',
      'date': '2026-02-03 13:15',
      'settlementStatus': 'Pending',
      'reference': 'REF-2026-02-03-002',
      'fee': 1.13,
    },
    {
      'id': 'TXN001234565',
      'type': 'card_payment',
      'customer': 'Kofi Johnson',
      'amount': 320.00,
      'paymentMethod': 'Mastercard',
      'date': '2026-02-03 12:45',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-03-003',
      'fee': 4.80,
    },
    {
      'id': 'TXN001234564',
      'type': 'qr_transaction',
      'customer': 'Sarah Wilson',
      'amount': 45.00,
      'paymentMethod': 'Mobile Money',
      'date': '2026-02-03 11:30',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-03-004',
      'fee': 0.68,
    },
    {
      'id': 'TXN001234563',
      'type': 'card_payment',
      'customer': 'Michael Brown',
      'amount': 200.00,
      'paymentMethod': 'Visa',
      'date': '2026-02-03 10:15',
      'settlementStatus': 'Processing',
      'reference': 'REF-2026-02-03-005',
      'fee': 3.00,
    },
    {
      'id': 'TXN001234562',
      'type': 'qr_transaction',
      'customer': 'Grace Owusu',
      'amount': 95.00,
      'paymentMethod': 'Mobile Money',
      'date': '2026-02-02 16:45',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-02-006',
      'fee': 1.43,
    },
    {
      'id': 'TXN001234561',
      'type': 'card_payment',
      'customer': 'Emmanuel Adjei',
      'amount': 450.00,
      'paymentMethod': 'Mastercard',
      'date': '2026-02-02 15:20',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-02-007',
      'fee': 6.75,
    },
    {
      'id': 'TXN001234560',
      'type': 'qr_transaction',
      'customer': 'Abena Darko',
      'amount': 65.00,
      'paymentMethod': 'Mobile Money',
      'date': '2026-02-02 14:10',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-02-008',
      'fee': 0.98,
    },
    {
      'id': 'TXN001234559',
      'type': 'card_payment',
      'customer': 'Kwame Boateng',
      'amount': 280.00,
      'paymentMethod': 'Visa',
      'date': '2026-02-02 12:30',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-02-009',
      'fee': 4.20,
    },
    {
      'id': 'TXN001234558',
      'type': 'qr_transaction',
      'customer': 'Yaa Mensah',
      'amount': 120.00,
      'paymentMethod': 'Mobile Money',
      'date': '2026-02-02 10:45',
      'settlementStatus': 'Pending',
      'reference': 'REF-2026-02-02-010',
      'fee': 1.80,
    },
    {
      'id': 'TXN001234557',
      'type': 'card_payment',
      'customer': 'Nana Akufo',
      'amount': 550.00,
      'paymentMethod': 'Mastercard',
      'date': '2026-02-01 16:20',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-01-011',
      'fee': 8.25,
    },
    {
      'id': 'TXN001234556',
      'type': 'qr_transaction',
      'customer': 'Efua Appiah',
      'amount': 38.50,
      'paymentMethod': 'Mobile Money',
      'date': '2026-02-01 14:55',
      'settlementStatus': 'Settled',
      'reference': 'REF-2026-02-01-012',
      'fee': 0.58,
    },
  ];

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
                        'Transactions',
                        '89',
                        Icons.receipt_long,
                        const Color(0xFF059669),
                        isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

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

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isSettled = transaction['settlementStatus'] == 'Settled';
    final isPending = transaction['settlementStatus'] == 'Pending';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              MerchantTransactionDetailScreen(transaction: transaction),
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
                        '${(transaction['paymentMethod'] as String?) ?? 'Unknown'} • ${(transaction['date'] as String?) ?? 'Unknown'}',
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
                      '+GH₵${transaction['amount'] ?? 0}',
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
                        color: isSettled
                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                            : isPending
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                            : const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (transaction['settlementStatus'] as String?) ??
                            'Unknown',
                        style: GoogleFonts.inter(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: isSettled
                              ? const Color(0xFF10B981)
                              : isPending
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF6366F1),
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
      case 'card_payment':
        return Icons.credit_card;
      case 'qr_transaction':
        return Icons.qr_code;
      default:
        return Icons.receipt;
    }
  }
}
