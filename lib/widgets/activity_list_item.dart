import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/activity_helpers.dart';
import '../core/app_export.dart';

class ActivityListItem extends StatelessWidget {
  final Map<String, dynamic> activity;
  final bool isDark;
  final VoidCallback onTap;
  final ActivityModule module;
  final bool compact;

  const ActivityListItem({
    super.key,
    required this.activity,
    required this.isDark,
    required this.onTap,
    required this.module,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final type = activity['type'] as String?;
    final statusColor = ActivityHelpers.statusColor(activity);
    final iconColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final trailingIsAmount = ActivityHelpers.trailingIsAmount(activity);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    ActivityHelpers.iconFor(type),
                    color: iconColor,
                    size: 14,
                  ),
                ),
                SizedBox(width: 2.5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ActivityHelpers.personName(activity),
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : const Color(0xFF1A1D23),
                        ),
                      ),
                      SizedBox(height: 0.2.h),
                      Text(
                        ActivityHelpers.subtitleFor(
                          activity,
                          module: module,
                          compact: compact,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ActivityHelpers.trailingText(activity),
                      style: GoogleFonts.inter(
                        fontSize: trailingIsAmount ? 8.sp : 7.sp,
                        fontWeight: trailingIsAmount
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: trailingIsAmount
                            ? (isDark ? Colors.white : const Color(0xFF1A1D23))
                            : (isDark
                                ? Colors.white70
                                : const Color(0xFF475569)),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w,
                        vertical: 0.2.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ActivityHelpers.statusLabel(activity),
                        style: GoogleFonts.inter(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark ? const Color(0xFF262C33) : const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }
}
