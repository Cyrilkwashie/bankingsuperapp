import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MerchantCategorizedServicesWidget extends StatefulWidget {
  final bool isDark;

  const MerchantCategorizedServicesWidget({super.key, required this.isDark});

  @override
  State<MerchantCategorizedServicesWidget> createState() =>
      _MerchantCategorizedServicesWidgetState();
}

class _MerchantCategorizedServicesWidgetState
    extends State<MerchantCategorizedServicesWidget> {
  // Track which section is currently expanded (null means all collapsed)
  String? _expandedSection;

  void _toggleSection(String sectionTitle) {
    setState(() {
      if (_expandedSection == sectionTitle) {
        // If tapping the same section, collapse it
        _expandedSection = null;
      } else {
        // Otherwise, expand this section (and collapse others)
        _expandedSection = sectionTitle;
      }
    });
  }

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
            {'icon': 'remove_circle', 'label': 'Cash Withdrawal'},
          ],
          const Color(0xFF059669),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Pay Utilities',
          'payments',
          [
            {'icon': 'phone_android', 'label': 'Airtime'},
            {'icon': 'flash_on', 'label': 'Electricity'},
            {'icon': 'water_drop', 'label': 'Water'},
          ],
          const Color(0xFF6366F1),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'QR Payments',
          'qr_code_scanner',
          [
            {'icon': 'qr_code_scanner', 'label': 'QR Deposit'},
            {'icon': 'qr_code', 'label': 'QR Withdrawal'},
          ],
          const Color(0xFF8B5CF6),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'ATM Cardless',
          'atm',
          [
            {'icon': 'atm', 'label': 'Cardless Cash'},
          ],
          const Color(0xFF0EA5E9),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Card Payments',
          'credit_card',
          [
            {'icon': 'credit_card', 'label': 'POS Payment'},
            {'icon': 'payment', 'label': 'Online Payment'},
          ],
          const Color(0xFFF59E0B),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Merchant Profile',
          'store',
          [
            {'icon': 'person', 'label': 'My Profile'},
            {'icon': 'business', 'label': 'Business Info'},
          ],
          const Color(0xFF10B981),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Settings',
          'settings',
          [
            {'icon': 'settings', 'label': 'Preferences'},
            {'icon': 'security', 'label': 'Security'},
          ],
          const Color(0xFF64748B),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Daily Transactions History',
          'history',
          [
            {'icon': 'history', 'label': 'View History'},
            {'icon': 'download', 'label': 'Export Report'},
          ],
          const Color(0xFFEF4444),
          widget.isDark,
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
    final isExpanded = _expandedSection == title;

    return GestureDetector(
      onTap: () => _toggleSection(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
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
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1D23),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.3.h,
                  ),
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
                SizedBox(width: 2.w),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                    size: 20,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
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
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
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
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 0.5.w),
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
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: accentColor,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(height: 0.3.h),
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
