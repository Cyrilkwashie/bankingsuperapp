import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SmartBranchCategorizedServicesWidget extends StatefulWidget {
  final bool isDark;

  const SmartBranchCategorizedServicesWidget({super.key, required this.isDark});

  @override
  State<SmartBranchCategorizedServicesWidget> createState() =>
      _SmartBranchCategorizedServicesWidgetState();
}

class _SmartBranchCategorizedServicesWidgetState
    extends State<SmartBranchCategorizedServicesWidget> {
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
          'Customer Management',
          'people',
          [
            {'icon': 'person_add', 'label': 'Individual Account'},
            {'icon': 'edit', 'label': 'Customer Update'},
          ],
          const Color(0xFF1B365D),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Account Management',
          'manage_accounts',
          [
            {'icon': 'description', 'label': 'Statement Request'},
            {'icon': 'lock', 'label': 'Lien'},
            {'icon': 'refresh', 'label': 'Dormancy Reactivation'},
            {'icon': 'cancel', 'label': 'Close Account'},
            {'icon': 'block', 'label': 'Account Blockage'},
            {'icon': 'book', 'label': 'Cheque Book'},
            {'icon': 'credit_card', 'label': 'ATM Cards'},
            {'icon': 'stop', 'label': 'Stop Cheque'},
          ],
          const Color(0xFF6366F1),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Teller Activities',
          'point_of_sale',
          [
            {'icon': 'arrow_upward', 'label': 'Cash Withdrawal'},
            {'icon': 'arrow_downward', 'label': 'Cash Deposit'},
            {'icon': 'receipt', 'label': 'Cheque Withdrawal'},
            {'icon': 'receipt_long', 'label': 'Counter Cheque'},
          ],
          const Color(0xFF10B981),
          widget.isDark,
        ),
        SizedBox(height: 1.5.h),
        _buildServiceSection(
          context,
          'Back Office',
          'business_center',
          [
            {'icon': 'savings', 'label': 'Fixed Deposit'},
            {'icon': 'account_balance', 'label': 'Credit Origination'},
            {'icon': 'post_add', 'label': 'Batch Posting'},
            {'icon': 'upload_file', 'label': 'Uploads'},
          ],
          const Color(0xFFF59E0B),
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
