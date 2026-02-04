import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CategorizedServicesWidget extends StatelessWidget {
  final bool isDark;

  const CategorizedServicesWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceSection(
          context,
          'Cash Services',
          'account_balance_wallet',
          [
            {'icon': 'add_circle', 'label': 'Cash Deposit'},
            {'icon': 'remove_circle', 'label': 'Cash Withdrawal'},
          ],
          const Color(0xFF2E8B8B),
          isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Transfers',
          'send',
          [
            {'icon': 'account_balance', 'label': 'Same Bank'},
            {'icon': 'send', 'label': 'Other Bank'},
          ],
          const Color(0xFF6366F1),
          isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'QR Services',
          'qr_code_scanner',
          [
            {'icon': 'qr_code_scanner', 'label': 'QR Deposit'},
            {'icon': 'qr_code', 'label': 'QR Withdrawal'},
          ],
          const Color(0xFF8B5CF6),
          isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Account Services',
          'manage_accounts',
          [
            {'icon': 'person_add', 'label': 'Open Account'},
            {'icon': 'account_balance_wallet', 'label': 'Balance'},
            {'icon': 'receipt', 'label': 'Mini Statement'},
          ],
          const Color(0xFF0EA5E9),
          isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Account Requests',
          'description',
          [
            {'icon': 'description', 'label': 'Statement'},
            {'icon': 'credit_card', 'label': 'ATM Card'},
            {'icon': 'book', 'label': 'Chequebook'},
            {'icon': 'block', 'label': 'Block Card'},
            {'icon': 'cancel', 'label': 'Stop Cheque'},
          ],
          const Color(0xFFF59E0B),
          isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Agent Tools',
          'build',
          [
            {'icon': 'history', 'label': 'Daily Txns'},
            {'icon': 'undo', 'label': 'Reverse'},
            {'icon': 'location_on', 'label': 'Locations'},
            {'icon': 'settings', 'label': 'Settings'},
          ],
          const Color(0xFF64748B),
          isDark,
        ),
      ],
    );
  }

  Widget _buildServiceSection(
    BuildContext context,
    String title,
    String titleIcon,
    List<Map<String, String>> services,
    Color accentColor,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.15),
                      accentColor.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: titleIcon,
                    color: accentColor,
                    size: 13,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1D23),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${services.length}',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          Wrap(
            spacing: 0,
            runSpacing: 0.8.h,
            children: services.map((service) {
              return _buildServiceButton(
                context,
                service['icon']!,
                service['label']!,
                accentColor,
                isDark,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(
    BuildContext context,
    String iconName,
    String label,
    Color accentColor,
    bool isDark,
  ) {
    return SizedBox(
      width: 22.w,
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
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 1.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentColor.withValues(alpha: 0.15),
                        accentColor.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: accentColor,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
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
