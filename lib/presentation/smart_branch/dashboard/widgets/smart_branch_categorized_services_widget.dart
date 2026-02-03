import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SmartBranchCategorizedServicesWidget extends StatelessWidget {
  const SmartBranchCategorizedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceSection(context, 'Customer Management', [
          {'icon': 'person_add', 'label': 'Individual Account'},
          {'icon': 'edit', 'label': 'Customer Update'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Account Management', [
          {'icon': 'description', 'label': 'Statement Request'},
          {'icon': 'lock', 'label': 'Lien'},
          {'icon': 'refresh', 'label': 'Dormancy Reactivation'},
          {'icon': 'cancel', 'label': 'Close Account'},
          {'icon': 'block', 'label': 'Account Blockage'},
          {'icon': 'book', 'label': 'Cheque Book'},
          {'icon': 'credit_card', 'label': 'ATM Cards'},
          {'icon': 'stop', 'label': 'Stop Cheque'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Teller Activities', [
          {'icon': 'arrow_upward', 'label': 'Cash Withdrawal'},
          {'icon': 'arrow_downward', 'label': 'Cash Deposit'},
          {'icon': 'receipt', 'label': 'Cheque Withdrawal'},
          {'icon': 'receipt_long', 'label': 'Counter Cheque'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Back Office', [
          {'icon': 'savings', 'label': 'Fixed Deposit'},
          {'icon': 'account_balance', 'label': 'Credit Origination'},
          {'icon': 'post_add', 'label': 'Batch Posting'},
          {'icon': 'upload_file', 'label': 'Uploads'},
        ]),
      ],
    );
  }

  Widget _buildServiceSection(
    BuildContext context,
    String title,
    List<Map<String, String>> services,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1D23),
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.5.w,
          runSpacing: 1.5.h,
          children: services.map((service) {
            return _buildServiceButton(
              context,
              service['icon']!,
              service['label']!,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceButton(
    BuildContext context,
    String iconName,
    String label,
  ) {
    return SizedBox(
      width: (100.w - 12.w - 5.w) / 3,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label - Coming Soon'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.5.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B365D).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: const Color(0xFF1B365D),
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1D23),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
