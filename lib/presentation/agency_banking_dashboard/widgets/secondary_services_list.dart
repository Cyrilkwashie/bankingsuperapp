import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Secondary services list for less frequent operations
class SecondaryServicesList extends StatelessWidget {
  const SecondaryServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final services = [
      {
        'icon': Icons.description,
        'title': 'Statement Request',
        'subtitle': 'Request account statement',
      },
      {
        'icon': Icons.credit_card,
        'title': 'ATM Card Request',
        'subtitle': 'Request new ATM card',
      },
      {
        'icon': Icons.book,
        'title': 'Chequebook Request',
        'subtitle': 'Request new chequebook',
      },
      {
        'icon': Icons.block,
        'title': 'Block ATM Card',
        'subtitle': 'Block lost or stolen card',
      },
      {
        'icon': Icons.cancel,
        'title': 'Stop Chequebook',
        'subtitle': 'Stop chequebook payments',
      },
    ];

    return Column(
      children: services.map((service) {
        return Padding(
          padding: EdgeInsets.only(bottom: 1.5.h),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2328) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.08,
                      ),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        service['icon'] as IconData,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['title'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFFAFBFC)
                                  : const Color(0xFF1A1D23),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            service['subtitle'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
