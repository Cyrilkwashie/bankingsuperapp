import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MerchantLoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController merchantIdController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onLogin;
  final Color brandColor;
  final Color brandDark;

  const MerchantLoginFormWidget({
    super.key,
    required this.formKey,
    required this.merchantIdController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onPasswordVisibilityToggle,
    required this.onLogin,
    required this.brandColor,
    required this.brandDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Merchant ID ─────────────────────
          Text(
            'Merchant ID',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: isLight
                  ? const Color(0xFF374151)
                  : const Color(0xFFD1D5DB),
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 0.8.h),
          TextFormField(
            controller: merchantIdController,
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: isLight
                  ? const Color(0xFF1A1D23)
                  : const Color(0xFFF9FAFB),
            ),
            decoration: _inputDecoration(
              hintText: 'Enter your merchant ID',
              prefixIcon: Icons.store_outlined,
              isLight: isLight,
            ),
            validator: (v) => (v == null || v.isEmpty)
                ? 'Please enter your merchant ID'
                : null,
          ),

          SizedBox(height: 2.h),

          // ── Password ─────────────────────
          Text(
            'Password',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: isLight
                  ? const Color(0xFF374151)
                  : const Color(0xFFD1D5DB),
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 0.8.h),
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: isLight
                  ? const Color(0xFF1A1D23)
                  : const Color(0xFFF9FAFB),
            ),
            decoration: _inputDecoration(
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              isLight: isLight,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isLight
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                  size: 20,
                ),
                onPressed: onPasswordVisibilityToggle,
                splashRadius: 20,
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Please enter your password' : null,
          ),

          SizedBox(height: 1.2.h),

          // ── Forgot Password ─────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: brandColor,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.5.h),

          // ── Sign In Button ─────────────────────
          SizedBox(
            width: double.infinity,
            height: 6.5.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLoading
                      ? [
                          brandColor.withValues(alpha: 0.6),
                          brandDark.withValues(alpha: 0.6),
                        ]
                      : [brandColor, brandDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: brandColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: -4,
                        ),
                      ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    required bool isLight,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: isLight ? const Color(0xFFB0B8C4) : const Color(0xFF4B5563),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Icon(
          prefixIcon,
          size: 20,
          color: isLight ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isLight ? const Color(0xFFF9FAFB) : const Color(0xFF141824),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isLight ? const Color(0xFFE5E7EB) : const Color(0xFF2A2F3E),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isLight ? const Color(0xFFE5E7EB) : const Color(0xFF2A2F3E),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: brandColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 8.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFDC2626),
      ),
    );
  }
}
