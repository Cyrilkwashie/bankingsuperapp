import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CategorizedServicesWidget extends StatelessWidget {
  const CategorizedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceSection(context, 'Cash Services', [
          {'icon': 'add_circle', 'label': 'Cash Deposit'},
          {'icon': 'remove_circle', 'label': 'Cash Withdrawal'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Transfers', [
          {'icon': 'account_balance', 'label': 'Same Bank'},
          {'icon': 'send', 'label': 'Other Bank'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'QR Services', [
          {'icon': 'qr_code_scanner', 'label': 'QR Deposit'},
          {'icon': 'qr_code', 'label': 'QR Withdrawal'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Account Services', [
          {'icon': 'person_add', 'label': 'Open Account'},
          {'icon': 'account_balance_wallet', 'label': 'Balance'},
          {'icon': 'receipt', 'label': 'Mini Statement'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Account Requests', [
          {'icon': 'description', 'label': 'Statement'},
          {'icon': 'credit_card', 'label': 'ATM Card'},
          {'icon': 'book', 'label': 'Chequebook'},
          {'icon': 'block', 'label': 'Block Card'},
          {'icon': 'cancel', 'label': 'Stop Cheque'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Agent Tools', [
          {'icon': 'history', 'label': 'Daily Txns'},
          {'icon': 'undo', 'label': 'Reverse'},
          {'icon': 'location_on', 'label': 'Locations'},
          {'icon': 'settings', 'label': 'Settings'},
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
