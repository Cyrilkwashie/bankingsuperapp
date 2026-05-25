import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Professional date picker and field for agency banking flows.
class AgencyDatePicker {
  AgencyDatePicker._();

  static const Color defaultAccent = Color(0xFF2E8B8B);

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static String formatStandard(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';
  }

  static String formatWithWeekday(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    return '$weekday, ${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  static String formatSlash(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  static String formatDisplay(
    DateTime date, {
    AgencyDateFormat format = AgencyDateFormat.standard,
  }) {
    switch (format) {
      case AgencyDateFormat.withWeekday:
        return formatWithWeekday(date);
      case AgencyDateFormat.slash:
        return formatSlash(date);
      case AgencyDateFormat.standard:
        return formatStandard(date);
    }
  }

  /// Opens a styled bottom-sheet calendar and returns the chosen date.
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select Date',
    String? subtitle,
    Color accentColor = defaultAccent,
  }) {
    final clampedInitial = _clampDate(initialDate, firstDate, lastDate);

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => _AgencyDatePickerSheet(
        initialDate: clampedInitial,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
        subtitle: subtitle,
        accentColor: accentColor,
      ),
    );
  }

  static DateTime _clampDate(DateTime date, DateTime first, DateTime last) {
    if (date.isBefore(first)) return first;
    if (date.isAfter(last)) return last;
    return date;
  }

  static ThemeData _pickerTheme(
    BuildContext context, {
    required Color accentColor,
    required bool isDark,
  }) {
    final surface = isDark ? const Color(0xFF161B22) : Colors.white;
    final onSurface = isDark ? Colors.white : const Color(0xFF111827);
    final muted = isDark ? Colors.white54 : const Color(0xFF6B7280);

    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accentColor,
        onPrimary: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: surface,
        headerBackgroundColor: Colors.transparent,
        headerForegroundColor: onSurface,
        headerHeadlineStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: -0.3,
        ),
        headerHelpStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: muted,
        ),
        weekdayStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: muted,
        ),
        dayStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        yearStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          if (states.contains(WidgetState.disabled)) {
            return isDark ? Colors.white24 : const Color(0xFFD1D5DB);
          }
          return onSurface;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentColor;
          return Colors.transparent;
        }),
        todayForegroundColor: WidgetStateProperty.all(accentColor),
        todayBackgroundColor: WidgetStateProperty.all(
          accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
        ),
        todayBorder: BorderSide(color: accentColor.withValues(alpha: 0.5)),
        rangeSelectionBackgroundColor: accentColor.withValues(alpha: 0.12),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

enum AgencyDateFormat { standard, withWeekday, slash }

/// Tap-to-open date field matching agency form styling.
class AgencyDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final bool isDark;
  final Color accentColor;
  final double fieldRadius;
  final EdgeInsets? contentPadding;
  final bool compact;
  final AgencyDateFormat displayFormat;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? pickerTitle;
  final String? pickerSubtitle;
  final ValueChanged<DateTime?> onChanged;

  const AgencyDateField({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.accentColor = AgencyDatePicker.defaultAccent,
    this.fieldRadius = 10,
    this.contentPadding,
    this.compact = false,
    this.displayFormat = AgencyDateFormat.standard,
    this.initialDate,
    this.pickerTitle,
    this.pickerSubtitle,
  });

  Future<void> _openPicker(BuildContext context) async {
    final picked = await AgencyDatePicker.show(
      context,
      initialDate: value ?? initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      title: pickerTitle ?? label,
      subtitle: pickerSubtitle,
      accentColor: accentColor,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    final padding = contentPadding ??
        EdgeInsets.symmetric(
          horizontal: compact ? 2.5.w : 3.5.w,
          vertical: compact ? 0.85.h : 0.95.h,
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openPicker(context),
        borderRadius: BorderRadius.circular(fieldRadius),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(fieldRadius),
            border: Border.all(
              color: hasValue
                  ? accentColor.withValues(alpha: 0.45)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE5E7EB),
            ),
            boxShadow: hasValue
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: compact ? 32 : 36,
                height: compact ? 32 : 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: isDark ? 0.22 : 0.14),
                      accentColor.withValues(alpha: isDark ? 0.08 : 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(compact ? 8 : 9),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: compact ? 16 : 18,
                  color: hasValue
                      ? accentColor
                      : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                ),
              ),
              SizedBox(width: compact ? 2.w : 2.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasValue && !compact) ...[
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 6.5.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                        ),
                      ),
                      SizedBox(height: 0.15.h),
                    ],
                    Text(
                      hasValue
                          ? AgencyDatePicker.formatDisplay(
                              value!,
                              format: displayFormat,
                            )
                          : label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: compact ? 8.sp : 9.sp,
                        fontWeight:
                            hasValue ? FontWeight.w600 : FontWeight.w400,
                        color: hasValue
                            ? (isDark ? Colors.white : const Color(0xFF1A1D23))
                            : (isDark
                                ? Colors.white24
                                : const Color(0xFFD1D5DB)),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: compact ? 18 : 20,
                color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgencyDatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;
  final String? subtitle;
  final Color accentColor;

  const _AgencyDatePickerSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  State<_AgencyDatePickerSheet> createState() => _AgencyDatePickerSheetState();
}

class _AgencyDatePickerSheetState extends State<_AgencyDatePickerSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _selectToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (!today.isBefore(widget.firstDate) && !today.isAfter(widget.lastDate)) {
      setState(() => _selectedDate = today);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF161B22) : Colors.white;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 0),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          widget.accentColor.withValues(alpha: 0.22),
                          widget.accentColor.withValues(alpha: 0.08),
                        ]
                      : [
                          widget.accentColor.withValues(alpha: 0.12),
                          widget.accentColor.withValues(alpha: 0.04),
                        ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: widget.accentColor,
                      size: 21,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: 0.2.h),
                          Text(
                            widget.subtitle!,
                            style: GoogleFonts.inter(
                              fontSize: 7.5.sp,
                              height: 1.3,
                              color: isDark ? Colors.white54 : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Theme(
                data: AgencyDatePicker._pickerTheme(
                  context,
                  accentColor: widget.accentColor,
                  isDark: isDark,
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  currentDate: DateTime.now(),
                  onDateChanged: (date) => setState(() => _selectedDate = date),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0.5.h, 4.w, 1.2.h),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _selectToday,
                    icon: Icon(Icons.today_rounded, size: 16, color: widget.accentColor),
                    label: Text(
                      'Today',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(_selectedDate),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.1.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.accentColor,
                            widget.accentColor.withValues(alpha: 0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: widget.accentColor.withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
