import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartBranchTransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const SmartBranchTransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSuccess = transaction['status'] == 'success';
    final isPending = transaction['status'] == 'pending';
    final isDeposit = transaction['type'] == 'deposit';
    final statusColor = isSuccess
        ? const Color(0xFF10B981)
        : isPending
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F1419)
          : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Gradient Header
          SliverAppBar(
            expandedHeight: 16.h,
            pinned: true,
            backgroundColor: isDeposit
                ? const Color(0xFF0891B2)
                : const Color(0xFFDC2626),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => _showSnackBar(context, 'Sharing receipt...'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDeposit
                        ? [const Color(0xFF0891B2), const Color(0xFF06B6D4)]
                        : [const Color(0xFFDC2626), const Color(0xFFEF4444)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDeposit ? Icons.south_west : Icons.north_east,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Text(
                        '${isDeposit ? '+' : '-'}GH\u20B5 ${transaction['amount'] ?? 0}',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        (transaction['type'] as String?)?.toUpperCase() ??
                            'TRANSACTION',
                        style: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -1.5.h),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F1419)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    // Status Pill
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 1.5.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.5.w,
                          vertical: 0.6.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              isSuccess
                                  ? 'Completed'
                                  : isPending
                                  ? 'Pending'
                                  : 'Failed',
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // Transaction Details Card
                    _buildCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'Transaction Details',
                      isDark: isDark,
                      children: [
                        _buildRow(
                          'Transaction ID',
                          transaction['id'] ?? 'N/A',
                          isDark: isDark,
                          copyable: true,
                        ),
                        _buildRow(
                          'Reference',
                          transaction['reference'] ?? 'N/A',
                          isDark: isDark,
                          copyable: true,
                        ),
                        _buildRow(
                          'Date & Time',
                          transaction['date'] ?? 'N/A',
                          isDark: isDark,
                        ),
                      ],
                    ),

                    // Amount Card
                    _buildCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Amount Breakdown',
                      isDark: isDark,
                      children: [
                        _buildRow(
                          'Amount',
                          'GH\u20B5 ${transaction['amount'] ?? 0}',
                          isDark: isDark,
                        ),
                        _buildRow(
                          'Fee',
                          'GH\u20B5 ${transaction['fee'] ?? 0}',
                          isDark: isDark,
                        ),
                        _buildTotalRow(
                          'Total',
                          'GH\u20B5 ${((transaction['amount'] ?? 0) + (transaction['fee'] ?? 0)).toStringAsFixed(2)}',
                          isDark: isDark,
                        ),
                      ],
                    ),

                    // Customer Card
                    _buildCard(
                      icon: Icons.person_outlined,
                      title: 'Customer',
                      isDark: isDark,
                      children: [
                        _buildRow(
                          'Name',
                          transaction['customer'] ?? 'N/A',
                          isDark: isDark,
                        ),
                      ],
                    ),

                    // Notes Card
                    if (transaction['notes'] != null &&
                        transaction['notes'].toString().isNotEmpty)
                      _buildCard(
                        icon: Icons.note_outlined,
                        title: 'Notes',
                        isDark: isDark,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF374151)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              transaction['notes'] ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),

                    // Action Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      child: Row(
                        children: [
                          _buildActionBtn(
                            Icons.receipt_outlined,
                            'Receipt',
                            () => _showSnackBar(context, 'Downloading...'),
                            isDark,
                          ),
                          SizedBox(width: 2.w),
                          _buildActionBtn(
                            Icons.support_agent_outlined,
                            'Support',
                            () => _showSnackBar(context, 'Opening support...'),
                            isDark,
                          ),
                          SizedBox(width: 2.w),
                          _buildActionBtn(
                            Icons.replay_outlined,
                            'Repeat',
                            () => _showSnackBar(context, 'New transaction...'),
                            isDark,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF64748B,
            ).withValues(alpha: isDark ? 0.1 : 0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(2.5.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.2.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0891B2).withValues(alpha: 0.2)
                        : const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 12, color: const Color(0xFF0891B2)),
                ),
                SizedBox(width: 1.5.w),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
          ),
          Padding(
            padding: EdgeInsets.all(2.5.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool copyable = false,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              if (copyable) ...[
                SizedBox(width: 1.w),
                GestureDetector(
                  onTap: () => Clipboard.setData(ClipboardData(text: value)),
                  child: Icon(
                    Icons.copy_outlined,
                    size: 10,
                    color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {required bool isDark}) {
    return Container(
      margin: EdgeInsets.only(top: 0.5.h),
      padding: EdgeInsets.only(top: 0.8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0891B2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDark,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2328) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF0891B2)),
              SizedBox(height: 0.3.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
