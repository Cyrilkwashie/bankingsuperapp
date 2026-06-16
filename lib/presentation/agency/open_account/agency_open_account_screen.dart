import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../cash_deposit/agency_cash_deposit_screen.dart';
import 'widgets/open_account_signature_painter.dart';

part 'open_account_verify_screen.dart';
part 'open_account_face_capture_screen.dart';
part 'open_account_otp_screen.dart';
part 'open_account_personal_screen.dart';
part 'open_account_contact_screen.dart';
part 'open_account_address_screen.dart';
part 'open_account_emergency_contact_screen.dart';
part 'open_account_employment_screen.dart';
part 'open_account_requirements_screen.dart';
part 'open_account_declaration_screen.dart';
part 'open_account_review_screen.dart';
part 'open_account_success_screen.dart';

// ── Shared slim agency UI tokens & helpers ────────────────────

abstract class _OpenAccountUi {
  static const Color accent = Color(0xFF2E8B8B);
  static const List<Color> gradient = [Color(0xFF1B365D), Color(0xFF2E8B8B)];
  static const Color success = Color(0xFF059669);
  static const double fieldRadius = 10;

  static EdgeInsets get fieldPadding =>
      EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.95.h);

  static const List<String> wizardLabels = [
    'Verify',
    'Photo',
    'Personal',
    'Contact',
    'Address',
    'Emergency',
    'Employment',
    'Mandate',
    'Declaration',
    'Review',
  ];

  static const int wizardStepCount = 10;

  static Widget buildAgencyHeader({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    IconData? icon,
    bool showBack = true,
    Widget? leading,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : gradientColors,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              if (leading != null)
                leading
              else if (showBack)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                ),
              if (showBack || leading != null) SizedBox(width: 3.5.w),
              if (icon != null) ...[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Center(
                    child: Icon(icon, color: Colors.white, size: 21),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              trailing ?? buildOnlineBadge(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildOnlineBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4ADE80),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 1.5.w),
          Text(
            'Online',
            style: GoogleFonts.inter(
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSuccessBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: success.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: success.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 11, color: Color(0xFF34D399)),
          SizedBox(width: 1.w),
          Text(
            'Success',
            style: GoogleFonts.inter(
              fontSize: 6.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF34D399),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildWizardStepIndicator(
    bool isDark,
    int currentStep, {
    required Color accentColor,
    ValueChanged<int>? onStepTap,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < wizardLabels.length; i++) ...[
              _wizardStepDot(
                step: i + 1,
                current: currentStep,
                label: wizardLabels[i],
                isDark: isDark,
                accentColor: accentColor,
                onTap: onStepTap != null ? () => onStepTap(i + 1) : null,
              ),
              if (i < wizardLabels.length - 1)
                Container(
                  width: 5.w,
                  height: 2,
                  margin: EdgeInsets.only(bottom: 2.2.h, left: 0.4.w, right: 0.4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: currentStep > i + 1
                        ? LinearGradient(
                            colors: [
                              accentColor,
                              accentColor.withValues(alpha: 0.5),
                            ],
                          )
                        : null,
                    color: currentStep > i + 1
                        ? null
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE5E7EB)),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  static void popWizardSteps(BuildContext context, int count) {
    for (var i = 0; i < count; i++) {
      if (!Navigator.canPop(context)) break;
      Navigator.pop(context);
    }
  }

  static void handleWizardStepTap(
    BuildContext context, {
    required int currentStep,
    required int targetStep,
    required ValueChanged<int> onForwardStep,
  }) {
    if (targetStep == currentStep) return;
    if (targetStep < currentStep) {
      popWizardSteps(context, currentStep - targetStep);
      return;
    }
    onForwardStep(targetStep);
  }

  static Widget _wizardStepDot({
    required int step,
    required int current,
    required String label,
    required bool isDark,
    required Color accentColor,
    VoidCallback? onTap,
  }) {
    final completed = step < current;
    final isCurrent = step == current;
    final content = Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? success
                : isCurrent
                    ? accentColor
                    : (isDark
                        ? const Color(0xFF1E2328)
                        : const Color(0xFFF3F4F6)),
            border: completed || isCurrent
                ? null
                : Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFD1D5DB),
                  ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                : Text(
                    '$step',
                    style: GoogleFonts.inter(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isCurrent
                          ? Colors.white
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 0.4.h),
        SizedBox(
          width: 11.w,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 5.8.sp,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
              color: isCurrent || completed
                  ? accentColor
                  : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (onTap == null) return content;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }

  static Widget buildIntroTip(bool isDark, String message, {Color? accentColor}) {
    final accent = accentColor ?? _OpenAccountUi.accent;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: isDark ? 0.12 : 0.06),
            accent.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: accent, size: 15),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.35,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSectionCard({
    required bool isDark,
    required String title,
    String? subtitle,
    IconData? icon,
    required Widget child,
    Color? accentColor,
  }) {
    final accent = accentColor ?? _OpenAccountUi.accent;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: accent, size: 15),
                ),
                SizedBox(width: 2.5.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.1.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.3.h),
          child,
        ],
      ),
    );
  }

  static Widget buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 7.5.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: isDark ? Colors.white54 : const Color(0xFF64748B),
      ),
    );
  }

  static Widget buildReadOnlyField({
    required String label,
    required String value,
    required bool isDark,
    required Color accentColor,
    IconData? icon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFieldLabel(label, isDark),
        SizedBox(height: 0.4.h),
        Container(
          width: double.infinity,
          padding: fieldPadding,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(fieldRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  size: 17,
                ),
                SizedBox(width: 2.w),
              ],
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                  ),
                ),
              ),
              Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
        if (helperText != null) ...[
          SizedBox(height: 0.35.h),
          Text(
            helperText,
            style: GoogleFonts.inter(
              fontSize: 6.8.sp,
              height: 1.35,
              color: accentColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ],
    );
  }

  static Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required Color accentColor,
    bool required = true,
    bool readOnly = false,
    IconData? icon,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      maxLines: maxLines,
      onChanged: onChanged ?? (_) {},
      validator: validator ??
          (required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null),
      style: GoogleFonts.inter(
        fontSize: 9.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: readOnly
            ? (isDark
                ? Colors.white.withValues(alpha: 0.03)
                : const Color(0xFFF1F5F9))
            : (isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC)),
        contentPadding: fieldPadding,
        prefixIcon: icon != null
            ? Icon(icon,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                size: 17)
            : null,
        prefixIconConstraints:
            icon != null ? const BoxConstraints(minWidth: 40) : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                size: 20)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: accentColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1),
        ),
      ),
    );
  }

  static Widget buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color accentColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(fieldRadius),
        border: Border.all(
          color: value != null
              ? accentColor.withValues(alpha: 0.4)
              : isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: value != null
                ? accentColor
                : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
          ),
          dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(fieldRadius),
          hint: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF1A1D23),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  static Widget buildPrimaryButton({
    required bool isDark,
    required String label,
    required VoidCallback? onTap,
    Color? accentColor,
    IconData? icon,
    bool showArrow = true,
  }) {
    final accent = accentColor ?? _OpenAccountUi.accent;
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.25.h),
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  colors: [accent, accent.withValues(alpha: 0.85)],
                )
              : null,
          color: enabled
              ? null
              : (isDark ? const Color(0xFF1E2328) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: enabled ? Colors.white : Colors.grey, size: 16),
              SizedBox(width: 1.5.w),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? Colors.white
                    : (isDark ? Colors.white24 : const Color(0xFF9CA3AF)),
              ),
            ),
            if (enabled && showArrow) ...[
              SizedBox(width: 1.5.w),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 16),
            ],
          ],
        ),
      ),
    );
  }

  static Widget buildStickyActionBar({
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }

  static Widget buildReviewSummaryRow(_OpenAccountSummaryRow row, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.75.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34.w,
            child: Text(
              row.label,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.value,
              style: row.mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: row.valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                      height: 1.35,
                    )
                  : GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: row.valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                      height: 1.35,
                    ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildReviewSectionCard({
    required bool isDark,
    required Color accentColor,
    required String title,
    required IconData icon,
    required List<_OpenAccountSummaryRow> rows,
  }) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(4.5.w, 1.6.h, 4.5.w, 1.4.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.1 : 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(17),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            buildReviewSummaryRow(rows[i], isDark),
            if (i < rows.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                child: Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFF3F4F6),
                ),
              ),
          ],
          SizedBox(height: 0.6.h),
        ],
      ),
    );
  }

  static Widget buildSummaryCard({
    required bool isDark,
    required Color accentColor,
    required String title,
    required List<_OpenAccountSummaryRow> rows,
    Widget? footer,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 2.h, 4.5.w, 1.5.h),
            child: Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: accentColor, size: 18),
                SizedBox(width: 2.5.w),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            buildSummaryRow(rows[i], isDark),
            if (i < rows.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w),
                child: Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFF3F4F6),
                ),
              ),
          ],
          if (footer != null) footer,
        ],
      ),
    );
  }

  static Widget buildSummaryRow(_OpenAccountSummaryRow row, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.w,
            child: Text(
              row.label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.value,
              style: row.mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: row.valueColor ??
                          (isDark ? Colors.white70 : const Color(0xFF374151)),
                      height: 1.35,
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: row.valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                    ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildHeroBanner({
    required bool isDark,
    required Color accentColor,
    required IconData icon,
    required String label,
    required String headline,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [
                  accentColor.withValues(alpha: 0.08),
                  accentColor.withValues(alpha: 0.02),
                ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildSecurityNote(bool isDark, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: success.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 16,
            color: success.withValues(alpha: 0.8),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.4,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSuccessIcon(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: success.withValues(alpha: isDark ? 0.08 : 0.06),
          ),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                success.withValues(alpha: 0.2),
                success.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(color: success.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: success.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: success, size: 32),
        ),
      ],
    );
  }

  static Widget buildReceiptCard({
    required bool isDark,
    required Color accentColor,
    required String heroValue,
    required String heroLabel,
    required List<_OpenAccountSummaryRow> rows,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: success, width: 3)),
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: isDark ? 0.1 : 0.05),
                    accentColor.withValues(alpha: isDark ? 0.03 : 0.01),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    heroValue,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    heroLabel,
                    style: GoogleFonts.inter(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF3F4F6),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.7.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30.w,
                            child: Text(
                              rows[i].label,
                              style: GoogleFonts.inter(
                                fontSize: 7.5.sp,
                                color: isDark
                                    ? Colors.white38
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              rows[i].value,
                              style: rows[i].mono
                                  ? GoogleFonts.jetBrainsMono(
                                      fontSize: 7.sp,
                                      fontWeight: FontWeight.w500,
                                      color: rows[i].valueColor ??
                                          (isDark
                                              ? Colors.white
                                              : const Color(0xFF111827)),
                                    )
                                  : GoogleFonts.inter(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w600,
                                      color: rows[i].valueColor ??
                                          (isDark
                                              ? Colors.white
                                              : const Color(0xFF111827)),
                                    ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenAccountSummaryRow {
  final String label;
  final String value;
  final bool mono;
  final Color? valueColor;

  const _OpenAccountSummaryRow(
    this.label,
    this.value, {
    this.mono = false,
    this.valueColor,
  });
}

// ══════════════════════════════════════════════════════════════
// ── Agency Open Account – Requirements Overview (Entry Screen) ──
// ══════════════════════════════════════════════════════════════

class AgencyOpenAccountScreen extends StatefulWidget {
  const AgencyOpenAccountScreen({super.key});

  @override
  State<AgencyOpenAccountScreen> createState() =>
      _AgencyOpenAccountScreenState();
}

class _AgencyOpenAccountScreenState extends State<AgencyOpenAccountScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = _OpenAccountUi.accent;
  static const List<Color> _gradient = _OpenAccountUi.gradient;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onStart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _OpenAccountTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _OpenAccountUi.buildAgencyHeader(
              context: context,
              isDark: isDark,
              title: 'Open Account',
              subtitle: 'Agency Banking · Requirements',
              gradientColors: _gradient,
              icon: Icons.account_balance_rounded,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OpenAccountUi.buildIntroTip(
                      isDark,
                      'Review the checklist to ensure a smooth and complete account opening experience.',
                      accentColor: _accent,
                    ),
                    SizedBox(height: 1.5.h),
                    _OpenAccountUi.buildSectionCard(
                      isDark: isDark,
                      title: 'Before You Start',
                      subtitle: 'General guidance for every account opening',
                      icon: Icons.info_outline_rounded,
                      accentColor: _accent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Each product has its own required documents and minimum deposit. '
                            'On the next step, review the full checklist on the product card '
                            'before you begin the application.',
                            style: GoogleFonts.inter(
                              fontSize: 7.5.sp,
                              height: 1.45,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 1.2.h),
                          _buildReqCard(
                            icon: Icons.assignment_outlined,
                            iconColor: _accent,
                            title: 'Product-specific requirements',
                            subtitle:
                                'Savings, Current, Fixed Deposit and Susu each list what the customer needs',
                            isDark: isDark,
                          ),
                          SizedBox(height: 1.h),
                          _buildReqCard(
                            icon: Icons.timer_outlined,
                            iconColor: _accent,
                            title: 'Estimated time',
                            subtitle:
                                'Allow 10–15 minutes if all documents are ready',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    _buildDurationHint(isDark),
                  ],
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: 'Start Application',
                onTap: _onStart,
                accentColor: _accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReqCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    bool optional = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(_OpenAccountUi.fieldRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 16)),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    if (optional)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w, vertical: 0.2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Optional',
                          style: GoogleFonts.inter(
                            fontSize: 6.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    color: isDark
                        ? Colors.white38
                        : const Color(0xFF9CA3AF),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationHint(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(_OpenAccountUi.fieldRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            size: 14,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'This process takes approximately 5–10 minutes to complete.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark
                    ? Colors.white38
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Select Account Type (Screen 2) ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountTypeScreen extends StatefulWidget {
  const _OpenAccountTypeScreen();

  @override
  State<_OpenAccountTypeScreen> createState() =>
      _OpenAccountTypeScreenState();
}

class _OpenAccountTypeScreenState extends State<_OpenAccountTypeScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = _OpenAccountUi.accent;
  static const List<Color> _gradient = _OpenAccountUi.gradient;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  int _selectedTypeIndex = -1;

  static const List<_AccountTypeOption> _accountTypes = [
    _AccountTypeOption(
      icon: Icons.savings_rounded,
      iconColor: Color(0xFF2E8B8B),
      title: 'Savings Account',
      subtitle: 'Earn interest on deposits with flexible access to funds',
      badge: 'Popular',
      badgeColor: Color(0xFF059669),
      minDeposit: 'GH₵ 20.00',
      features: [
        'Monthly interest accrual',
        'Unlimited deposits',
        'Flexible withdrawals',
      ],
      requirements: [
        _AccountRequirement(
          icon: Icons.badge_outlined,
          title: 'Valid Government-Issued ID',
          subtitle: 'Ghana Card, Voter ID, Passport or Driver\'s License',
        ),
        _AccountRequirement(
          icon: Icons.photo_camera_outlined,
          title: 'Passport-Sized Photograph',
          subtitle: 'Recent clear front-facing photo of the customer',
        ),
        _AccountRequirement(
          icon: Icons.phone_outlined,
          title: 'Active Phone Number',
          subtitle: 'Ghanaian mobile number for SMS alerts and OTP',
        ),
        _AccountRequirement(
          icon: Icons.email_outlined,
          title: 'Email Address',
          subtitle: 'For e-statements and digital notifications',
        ),
        _AccountRequirement(
          icon: Icons.home_outlined,
          title: 'Proof of Address',
          subtitle: 'Utility bill, bank statement or tenancy agreement',
        ),
        _AccountRequirement(
          icon: Icons.payments_outlined,
          title: 'Initial Deposit',
          subtitle: 'Minimum GH₵ 20.00 to activate the account',
        ),
      ],
    ),
    _AccountTypeOption(
      icon: Icons.account_balance_rounded,
      iconColor: Color(0xFF1D4ED8),
      title: 'Current Account',
      subtitle: 'Ideal for daily transactions with cheque-book facility',
      badge: 'Business',
      badgeColor: Color(0xFF1D4ED8),
      minDeposit: 'GH₵ 50.00',
      features: [
        'Cheque-book facility',
        'Overdraft eligible',
        'High transaction volume',
      ],
      requirements: [
        _AccountRequirement(
          icon: Icons.badge_outlined,
          title: 'Valid Government-Issued ID',
          subtitle: 'Ghana Card, Voter ID, Passport or Driver\'s License',
        ),
        _AccountRequirement(
          icon: Icons.photo_camera_outlined,
          title: 'Passport-Sized Photograph',
          subtitle: 'Recent clear front-facing photo of the customer',
        ),
        _AccountRequirement(
          icon: Icons.phone_outlined,
          title: 'Active Phone Number',
          subtitle: 'Ghanaian mobile number for SMS alerts and OTP',
        ),
        _AccountRequirement(
          icon: Icons.email_outlined,
          title: 'Email Address',
          subtitle: 'Required for business correspondence and e-statements',
        ),
        _AccountRequirement(
          icon: Icons.home_outlined,
          title: 'Proof of Address',
          subtitle: 'Business or residential utility bill or tenancy agreement',
        ),
        _AccountRequirement(
          icon: Icons.storefront_outlined,
          title: 'Business / Trade Certificate',
          subtitle: 'For registered businesses, traders and sole proprietors',
        ),
        _AccountRequirement(
          icon: Icons.payments_outlined,
          title: 'Initial Deposit',
          subtitle: 'Minimum GH₵ 50.00 to activate the account',
        ),
      ],
    ),
    _AccountTypeOption(
      icon: Icons.lock_clock_rounded,
      iconColor: Color(0xFFD97706),
      title: 'Fixed Deposit',
      subtitle: 'Higher returns on locked funds for a fixed term',
      badge: 'High Yield',
      badgeColor: Color(0xFFD97706),
      minDeposit: 'GH₵ 500.00',
      features: [
        'Above-average interest rate',
        'Defined maturity date',
        'Capital guaranteed',
      ],
      requirements: [
        _AccountRequirement(
          icon: Icons.badge_outlined,
          title: 'Valid Government-Issued ID',
          subtitle: 'Ghana Card, Voter ID, Passport or Driver\'s License',
        ),
        _AccountRequirement(
          icon: Icons.photo_camera_outlined,
          title: 'Passport-Sized Photograph',
          subtitle: 'Recent clear front-facing photo of the customer',
        ),
        _AccountRequirement(
          icon: Icons.phone_outlined,
          title: 'Active Phone Number',
          subtitle: 'Ghanaian mobile number for maturity alerts and OTP',
        ),
        _AccountRequirement(
          icon: Icons.email_outlined,
          title: 'Email Address',
          subtitle: 'For maturity alerts and investment statements',
        ),
        _AccountRequirement(
          icon: Icons.home_outlined,
          title: 'Proof of Address',
          subtitle: 'Utility bill, bank statement or tenancy agreement',
        ),
        _AccountRequirement(
          icon: Icons.receipt_long_outlined,
          title: 'Source of Funds Declaration',
          subtitle: 'Required for fixed deposits of GH₵ 500 and above',
        ),
        _AccountRequirement(
          icon: Icons.payments_outlined,
          title: 'Initial Deposit',
          subtitle: 'Minimum GH₵ 500.00 locked for the agreed term',
        ),
      ],
    ),
    _AccountTypeOption(
      icon: Icons.savings_outlined,
      iconColor: Color(0xFF7C3AED),
      title: 'Susu Account',
      subtitle: 'Daily micro-savings designed for traders and artisans',
      badge: 'Micro-savings',
      badgeColor: Color(0xFF7C3AED),
      minDeposit: 'GH₵ 5.00',
      features: [
        'Daily contribution model',
        'Low entry threshold',
        'Community-friendly',
      ],
      requirements: [
        _AccountRequirement(
          icon: Icons.badge_outlined,
          title: 'Valid Government-Issued ID',
          subtitle: 'Ghana Card, Voter ID, Passport or Driver\'s License',
        ),
        _AccountRequirement(
          icon: Icons.photo_camera_outlined,
          title: 'Passport-Sized Photograph',
          subtitle: 'Recent clear front-facing photo of the customer',
        ),
        _AccountRequirement(
          icon: Icons.phone_outlined,
          title: 'Active Phone Number',
          subtitle: 'Required for daily contribution alerts',
        ),
        _AccountRequirement(
          icon: Icons.home_outlined,
          title: 'Proof of Address',
          subtitle: 'Utility bill, bank statement or tenancy agreement',
        ),
        _AccountRequirement(
          icon: Icons.groups_outlined,
          title: 'Occupation Reference',
          subtitle: 'Trade association or market leader reference',
        ),
        _AccountRequirement(
          icon: Icons.payments_outlined,
          title: 'Initial Deposit',
          subtitle: 'Minimum GH₵ 5.00 to activate the susu plan',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool get _canContinue => _selectedTypeIndex >= 0;

  void _onContinue() {
    if (!_canContinue) return;
    final selected = _accountTypes[_selectedTypeIndex];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountVerifyScreen(
          accountType: selected.title,
          minDeposit: selected.minDeposit,
          accentColor: _accent,
          gradientColors: _gradient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _OpenAccountUi.buildAgencyHeader(
              context: context,
              isDark: isDark,
              title: 'Account Type',
              subtitle: 'Open Account · Choose product',
              gradientColors: _gradient,
              icon: Icons.savings_rounded,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 1.6.h, 5.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OpenAccountUi.buildIntroTip(
                      isDark,
                      'Select a product below. Each card lists the documents and deposit required for that account type.',
                      accentColor: _accent,
                    ),
                    SizedBox(height: 1.2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.view_agenda_outlined,
                          size: 14,
                          color: _accent,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Available Products',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_accountTypes.length} options',
                          style: GoogleFonts.inter(
                            fontSize: 7.sp,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    for (var i = 0; i < _accountTypes.length; i++) ...[
                      if (i > 0) SizedBox(height: 1.2.h),
                      _buildAccountTypeCard(
                        _accountTypes[i],
                        _selectedTypeIndex == i,
                        i,
                        isDark,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: 'Continue',
                onTap: _canContinue ? _onContinue : null,
                accentColor: _accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeCard(
    _AccountTypeOption type,
    bool selected,
    int index,
    bool isDark,
  ) {
    final accent = selected ? _accent : type.iconColor;
    final borderColor = selected
        ? _accent
        : (isDark
            ? Colors.white.withValues(alpha: 0.07)
            : const Color(0xFFE5E7EB));

    return GestureDetector(
      onTap: () => setState(() => _selectedTypeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(3.5.w, 1.4.h, 3.5.w, 1.2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? 0.18 : 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(type.icon, color: accent, size: 22),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type.title,
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF111827),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 0.45.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.25.h,
                              ),
                              decoration: BoxDecoration(
                                color: type.badgeColor
                                    .withValues(alpha: isDark ? 0.14 : 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                type.badge,
                                style: GoogleFonts.inter(
                                  fontSize: 6.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: type.badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? _accent : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? _accent
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : const Color(0xFFD1D5DB)),
                            width: 1.5,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    type.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 7.5.sp,
                      height: 1.4,
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 0.9.h),
                  Wrap(
                    spacing: 1.2.w,
                    runSpacing: 0.45.h,
                    children: type.features
                        .map(
                          (f) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 11,
                                color: accent.withValues(alpha: 0.85),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                f,
                                style: GoogleFonts.inter(
                                  fontSize: 6.8.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white60
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.7.h,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: isDark ? 0.08 : 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          size: 14,
                          color: accent,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Minimum deposit: ${type.minDeposit}',
                          style: GoogleFonts.inter(
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFF1F5F9),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(3.5.w, 1.1.h, 3.5.w, 1.4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.checklist_rounded,
                        size: 14,
                        color: accent,
                      ),
                      SizedBox(width: 1.5.w),
                      Text(
                        'Requirements',
                        style: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.9.h),
                  ...type.requirements.map(
                    (req) => Padding(
                      padding: EdgeInsets.only(bottom: 0.8.h),
                      child: _buildProductRequirementRow(
                        requirement: req,
                        accent: accent,
                        isDark: isDark,
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

  Widget _buildProductRequirementRow({
    required _AccountRequirement requirement,
    required Color accent,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              requirement.icon,
              color: accent,
              size: 14,
            ),
          ),
        ),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requirement.title,
                style: GoogleFonts.inter(
                  fontSize: 7.8.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  height: 1.25,
                ),
              ),
              SizedBox(height: 0.15.h),
              Text(
                requirement.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 6.8.sp,
                  height: 1.35,
                  color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Ghana Card lookup ───────────────────────────────────────────

class _GhanaCardProfile {
  final String nationalId;
  final String firstName;
  final String lastName;
  final String otherName;
  final String gender;
  final DateTime dateOfBirth;
  final String issueDate;
  final String expiryDate;
  final String address;
  final String city;
  final String phone;

  const _GhanaCardProfile({
    required this.nationalId,
    required this.firstName,
    required this.lastName,
    required this.otherName,
    required this.gender,
    required this.dateOfBirth,
    required this.issueDate,
    required this.expiryDate,
    required this.address,
    required this.city,
    required this.phone,
  });

  String get dobDisplay => AgencyDatePicker.formatSlash(dateOfBirth);
}

abstract class _OpenAccountGhanaCardLookup {
  static final RegExp _idPattern = RegExp(r'^GHA-\d{9}-\d$');

  static String normalizeNationalId(String value) {
    final raw = value.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
    final compact = raw.replaceAll('-', '');
    final compactMatch = RegExp(r'^GHA(\d{9})(\d)$').firstMatch(compact);
    if (compactMatch != null) {
      return 'GHA-${compactMatch.group(1)}-${compactMatch.group(2)}';
    }
    return raw;
  }

  static bool isValidNationalId(String value) =>
      _idPattern.hasMatch(normalizeNationalId(value));

  static _GhanaCardProfile? lookup(String nationalId) {
    final normalized = normalizeNationalId(nationalId);
    if (!isValidNationalId(normalized)) return null;

    final suffix = normalized.substring(normalized.length - 1);
    final profiles = {
      '1': _GhanaCardProfile(
        nationalId: normalized,
        firstName: 'Kwame',
        lastName: 'Mensah',
        otherName: 'Kofi',
        gender: 'Male',
        dateOfBirth: DateTime(1990, 5, 15),
        issueDate: '12/03/2021',
        expiryDate: '11/03/2031',
        address: 'House No. 12, Ring Road East',
        city: 'Accra',
        phone: '0244123456',
      ),
      '2': _GhanaCardProfile(
        nationalId: normalized,
        firstName: 'Ama',
        lastName: 'Boateng',
        otherName: 'Serwaa',
        gender: 'Female',
        dateOfBirth: DateTime(1995, 8, 22),
        issueDate: '04/06/2022',
        expiryDate: '03/06/2032',
        address: 'Plot 8, Adum Street',
        city: 'Kumasi',
        phone: '0209876543',
      ),
      '3': _GhanaCardProfile(
        nationalId: normalized,
        firstName: 'Kofi',
        lastName: 'Asante',
        otherName: 'Yaw',
        gender: 'Male',
        dateOfBirth: DateTime(1988, 1, 9),
        issueDate: '18/09/2020',
        expiryDate: '17/09/2030',
        address: 'Block C, Tamale Central',
        city: 'Tamale',
        phone: '0271112233',
      ),
    };

    return profiles[suffix] ?? profiles['1']!;
  }
}

// ── Account Type Models ─────────────────────────────────────────

class _AccountRequirement {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AccountRequirement({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _AccountTypeOption {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final String minDeposit;
  final List<String> features;
  final List<_AccountRequirement> requirements;

  const _AccountTypeOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.minDeposit,
    required this.features,
    required this.requirements,
  });
}
