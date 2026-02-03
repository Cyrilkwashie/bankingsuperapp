import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/custom_icon_widget.dart';

class CategorizedServicesWidget extends StatelessWidget {
  const CategorizedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceSection(
          context,
          'Cash Services',
          'Handle customer cash transactions',
          [
            {'icon': 'add_circle', 'label': 'Cash Deposit'},
            {'icon': 'remove_circle', 'label': 'Cash Withdrawal'},
          ],
        ),
        SizedBox(height: 3.h),
        _buildServiceSection(context, 'Transfers', 'Send money for customers', [
          {'icon': 'account_balance', 'label': 'Same Bank'},
          {'icon': 'send', 'label': 'Other Bank'},
        ]),
        SizedBox(height: 3.h),
        _buildServiceSection(
          context,
          'QR Services',
          'Scan and process QR transactions',
          [
            {'icon': 'qr_code_scanner', 'label': 'QR Deposit'},
            {'icon': 'qr_code', 'label': 'QR Withdrawal'},
          ],
        ),
        SizedBox(height: 3.h),
        _buildServiceSection(
          context,
          'Account Services',
          'Customer account operations',
          [
            {'icon': 'person_add', 'label': 'Open Account'},
            {'icon': 'account_balance_wallet', 'label': 'Balance'},
            {'icon': 'receipt', 'label': 'Mini Statement'},
          ],
        ),
        SizedBox(height: 3.h),
        _buildServiceSection(
          context,
          'Account Requests',
          'Manage customer account tools',
          [
            {'icon': 'description', 'label': 'Statement'},
            {'icon': 'credit_card', 'label': 'ATM Card'},
            {'icon': 'book', 'label': 'Chequebook'},
            {'icon': 'block', 'label': 'Block Card'},
            {'icon': 'cancel', 'label': 'Stop Cheque'},
          ],
        ),
        SizedBox(height: 3.h),
        _buildServiceSection(
          context,
          'Agent Tools',
          'Agent operations and controls',
          [
            {'icon': 'history', 'label': 'Daily Txns'},
            {'icon': 'undo', 'label': 'Reverse'},
            {'icon': 'location_on', 'label': 'Locations'},
            {'icon': 'settings', 'label': 'Settings'},
          ],
        ),
      ],
    );
  }

  Widget _buildServiceSection(
    BuildContext context,
    String title,
    String subtitle,
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
            color: const Color(0xFFFAFBFC),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
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
      width: (100.w - 8.w - 6.w) / 3,
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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2E3A4F)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5A8F).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: const Color(0xFF3FA5A5),
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
                    color: const Color(0xFFFAFBFC),
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
