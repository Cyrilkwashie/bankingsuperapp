import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../transactions/merchant_transaction_detail_screen.dart';

/// Recent transactions — flat list, no card wrapper
class MerchantRecentTransactionsWidget extends StatelessWidget {
  final bool isDark;

  const MerchantRecentTransactionsWidget({super.key, required this.isDark});

  static final List<Map<String, dynamic>> _transactions = [
    {
      'name': 'Ama Darko',
      'type': 'payment',
      'desc': 'POS Payment',
      'amount': 1250.00,
      'time': '3:45 PM',
      'date': 'Today',
      'status': 'success',
    },
    {
      'name': 'Yaw Mensah',
      'type': 'payment',
      'desc': 'QR Payment',
      'amount': 340.00,
      'time': '2:10 PM',
      'date': 'Today',
      'status': 'success',
    },
    {
      'name': 'Cash Withdrawal',
      'type': 'withdrawal',
      'desc': 'ATM Cardless',
      'amount': 5000.00,
      'time': '12:30 PM',
      'date': 'Today',
      'status': 'success',
    },
    {
      'name': 'Airtime - MTN',
      'type': 'utility',
      'desc': 'Utility Bill',
      'amount': 50.00,
      'time': '10:15 AM',
      'date': 'Today',
      'status': 'success',
    },
    {
      'name': 'Kofi Asante',
      'type': 'payment',
      'desc': 'Online Payment',
      'amount': 8900.00,
      'time': '6:00 PM',
      'date': 'Yesterday',
      'status': 'pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.merchantTransactions);
              },
              child: Text(
                'See All',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.2.h),
        ...List.generate(_transactions.length, (index) {
          return _buildTransactionCard(context, _transactions[index]);
        }),
      ],
    );
  }

  Widget _buildTransactionCard(BuildContext context, Map<String, dynamic> txn) {
    final type = txn['type'] as String;
    final isDebit = type == 'withdrawal';
    final isSuccess = txn['status'] == 'success';
    final isPending = txn['status'] == 'pending';

    final iconColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MerchantTransactionDetailScreen(transaction: txn),
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
                  _getTransactionIcon(type),
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
                      txn['name'],
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      '${txn['desc']} • ${txn['date']}, ${txn['time']}',
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
                    '${isDebit ? '-' : '+'}GH₵${_formatAmount(txn['amount'])}',
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
                      (txn['status'] as String).toUpperCase(),
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
          color: isDark ? const Color(0xFF262C33) : const Color(0xFFE5E7EB),
        ),
      ],
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.south_west;
      case 'withdrawal':
        return Icons.north_east;
      case 'utility':
        return Icons.receipt_long;
      default:
        return Icons.receipt;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      final formatted = amount.toStringAsFixed(0);
      final result = StringBuffer();
      int count = 0;
      for (int i = formatted.length - 1; i >= 0; i--) {
        count++;
        result.write(formatted[i]);
        if (count % 3 == 0 && i > 0) result.write(',');
      }
      return result.toString().split('').reversed.join();
    }
    return amount.toStringAsFixed(2);
  }
}
