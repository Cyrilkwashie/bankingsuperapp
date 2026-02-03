import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MerchantTransactionCardWidget extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const MerchantTransactionCardWidget({super.key, required this.transaction});

  @override
  State<MerchantTransactionCardWidget> createState() =>
      _MerchantTransactionCardWidgetState();
}

class _MerchantTransactionCardWidgetState
    extends State<MerchantTransactionCardWidget> {
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
                            widget.transaction['customer'],
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1D23),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Row(
                            children: [
                              Icon(
                                _getPaymentMethodIcon(
                                  widget.transaction['paymentMethod'],
                                ),
                                size: 14,
                                color: const Color(0xFF6B7280),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                widget.transaction['paymentMethod'],
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            widget.transaction['date'],
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
                          'GH₵${widget.transaction['amount'].toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Commission: GH₵${widget.transaction['commission'].toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: widget.transaction['commission'] >= 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            fontWeight: FontWeight.w600,
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
                  Divider(color: const Color(0xFFE5E7EB), height: 1),
                  SizedBox(height: 2.h),
                  _buildDetailRow('Transaction ID', widget.transaction['id']),
                  SizedBox(height: 1.h),
                  _buildDetailRow('Reference', widget.transaction['reference']),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    'Settlement Status',
                    widget.transaction['settlementStatus'],
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow('Notes', widget.transaction['notes']),
                  SizedBox(height: 2.h),
                  _buildActionButtons(),
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
      case 'card_payment':
        icon = Icons.credit_card;
        color = const Color(0xFF059669);
        break;
      case 'qr_transaction':
        icon = Icons.qr_code_scanner;
        color = const Color(0xFF3FA5A5);
        break;
      case 'cash_deposit':
        icon = Icons.attach_money;
        color = const Color(0xFF10B981);
        break;
      case 'refund':
        icon = Icons.undo;
        color = const Color(0xFFEF4444);
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
      child: Icon(icon, color: color, size: 24),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    if (method.contains('Visa') || method.contains('Mastercard')) {
      return Icons.credit_card;
    } else if (method.contains('QR')) {
      return Icons.qr_code;
    } else if (method.contains('Cash')) {
      return Icons.money;
    }
    return Icons.payment;
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
          width: 35.w,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipt regenerated'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.receipt, size: 16),
            label: Text('Receipt', style: GoogleFonts.inter(fontSize: 11.sp)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF059669),
              side: const BorderSide(color: Color(0xFF059669)),
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispute initiated'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.report_problem, size: 16),
            label: Text('Dispute', style: GoogleFonts.inter(fontSize: 11.sp)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD97706),
              side: const BorderSide(color: Color(0xFFD97706)),
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
          ),
        ),
      ],
    );
  }
}
