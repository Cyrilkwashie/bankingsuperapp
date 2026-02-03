import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TransactionCardWidget extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionCardWidget({super.key, required this.transaction});

  @override
  State<TransactionCardWidget> createState() => _TransactionCardWidgetState();
}

class _TransactionCardWidgetState extends State<TransactionCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final type = widget.transaction['type'] as String;
    final status = widget.transaction['status'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTypeIcon(type),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.transaction['merchant'],
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1D23),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            widget.transaction['date'],
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
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
                          '${type == 'deposit' ? '+' : '-'}GH₵${widget.transaction['amount'].toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: type == 'deposit'
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        _buildStatusBadge(status),
                      ],
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  SizedBox(height: 2.h),
                  Divider(
                    color: const Color(0xFFE5E7EB),
                    height: 1,
                  ),
                  SizedBox(height: 2.h),
                  _buildDetailRow('Transaction ID', widget.transaction['id']),
                  SizedBox(height: 1.h),
                  _buildDetailRow('Reference', widget.transaction['reference']),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                      'Fee', 'GH₵${widget.transaction['fee'].toStringAsFixed(2)}'),
                  SizedBox(height: 1.h),
                  _buildDetailRow('Notes', widget.transaction['notes']),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'deposit':
        icon = Icons.arrow_downward;
        color = const Color(0xFF10B981);
        break;
      case 'withdrawal':
        icon = Icons.arrow_upward;
        color = const Color(0xFFEF4444);
        break;
      case 'transfer':
        icon = Icons.swap_horiz;
        color = const Color(0xFF3FA5A5);
        break;
      case 'payment':
        icon = Icons.payment;
        color = const Color(0xFF1B365D);
        break;
      default:
        icon = Icons.receipt;
        color = const Color(0xFF6B7280);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case 'success':
        backgroundColor = const Color(0xFF10B981).withValues(alpha: 0.1);
        textColor = const Color(0xFF10B981);
        label = 'Success';
        break;
      case 'pending':
        backgroundColor = const Color(0xFFD97706).withValues(alpha: 0.1);
        textColor = const Color(0xFFD97706);
        label = 'Pending';
        break;
      case 'failed':
        backgroundColor = const Color(0xFFEF4444).withValues(alpha: 0.1);
        textColor = const Color(0xFFEF4444);
        label = 'Failed';
        break;
      default:
        backgroundColor = const Color(0xFF6B7280).withValues(alpha: 0.1);
        textColor = const Color(0xFF6B7280);
        label = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1D23),
            ),
          ),
        ),
      ],
    );
  }
}