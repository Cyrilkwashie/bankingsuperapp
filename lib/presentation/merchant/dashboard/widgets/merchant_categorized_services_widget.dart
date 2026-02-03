import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MerchantCategorizedServicesWidget extends StatelessWidget {
  const MerchantCategorizedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceSection(context, 'Cash Services', [
          {'icon': 'remove_circle', 'label': 'Cash Withdrawal'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Pay Utilities', [
          {'icon': 'phone_android', 'label': 'Airtime'},
          {'icon': 'flash_on', 'label': 'Electricity'},
          {'icon': 'water_drop', 'label': 'Water'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'QR Payments', [
          {'icon': 'qr_code_scanner', 'label': 'QR Deposit'},
          {'icon': 'qr_code', 'label': 'QR Withdrawal'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'ATM Cardless', [
          {'icon': 'atm', 'label': 'Cardless Cash'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Card Payments', [
          {'icon': 'credit_card', 'label': 'POS Payment'},
          {'icon': 'payment', 'label': 'Online Payment'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Merchant Profile', [
          {'icon': 'person', 'label': 'My Profile'},
          {'icon': 'business', 'label': 'Business Info'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Settings', [
          {'icon': 'settings', 'label': 'Preferences'},
          {'icon': 'security', 'label': 'Security'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Daily Transactions History', [
          {'icon': 'history', 'label': 'View History'},
          {'icon': 'download', 'label': 'Export Report'},
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1D23),
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
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
      width: (100.w - 12.w - 6.w) / 3,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (label == 'View History') {
              Navigator.of(
                context,
              ).pushNamed('/merchant-transaction-history-screen');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label - Coming Soon'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: const Color(0xFF059669),
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
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
