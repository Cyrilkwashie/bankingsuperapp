import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

/// A reusable bottom sheet that requires PIN entry or biometric authentication
/// before proceeding with a transaction. Call [showTransactionAuthBottomSheet]
/// to display it. If authentication succeeds, [onAuthenticated] fires.
Future<void> showTransactionAuthBottomSheet({
  required BuildContext context,
  required VoidCallback onAuthenticated,
  required Color accentColor,
  String title = 'Authorize Transaction',
  String subtitle = 'Enter your 4-digit transaction PIN or use biometrics',
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => _TransactionAuthSheet(
      onAuthenticated: onAuthenticated,
      accentColor: accentColor,
      title: title,
      subtitle: subtitle,
    ),
  );
}

class _TransactionAuthSheet extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final Color accentColor;
  final String title;
  final String subtitle;

  const _TransactionAuthSheet({
    required this.onAuthenticated,
    required this.accentColor,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_TransactionAuthSheet> createState() => _TransactionAuthSheetState();
}

class _TransactionAuthSheetState extends State<_TransactionAuthSheet>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(4, (_) => FocusNode());

  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _biometricAvailable = false;
  bool _isVerifying = false;
  bool _pinError = false;
  String _errorMessage = '';

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Mock PIN for demo
  static const String _mockPin = '1234';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() => _biometricAvailable = canCheck && isSupported);
      }
    } catch (_) {
      if (mounted) setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _isVerifying = true;
      _pinError = false;
      _errorMessage = '';
    });

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to authorize this transaction',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (mounted) {
        if (authenticated) {
          Navigator.of(context).pop();
          widget.onAuthenticated();
        } else {
          setState(() {
            _isVerifying = false;
            _pinError = true;
            _errorMessage = 'Authentication failed. Please try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _pinError = true;
          _errorMessage = 'Biometric authentication unavailable.';
        });
      }
    }
  }

  Future<void> _verifyPin() async {
    final enteredPin =
        _pinControllers.map((c) => c.text).join();
    if (enteredPin.length < 4) return;

    setState(() {
      _isVerifying = true;
      _pinError = false;
      _errorMessage = '';
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (enteredPin == _mockPin) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onAuthenticated();
      }
    } else {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _pinError = true;
          _errorMessage = 'Incorrect PIN. Please try again.';
        });
        _shakeController.forward(from: 0);
        HapticFeedback.heavyImpact();
        for (final c in _pinControllers) {
          c.clear();
        }
        _pinFocusNodes[0].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(6.w, 1.5.h, 6.w, 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),

                // Lock icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.accentColor.withValues(alpha: 0.15),
                        widget.accentColor.withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    color: widget.accentColor,
                    size: 26,
                  ),
                ),
                SizedBox(height: 1.5.h),

                // Title
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 0.5.h),

                // Subtitle
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 2.5.h),

                // PIN input
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _shakeController.isAnimating
                            ? _shakeAnimation.value *
                                ((_shakeController.value * 10).toInt().isEven
                                    ? 1
                                    : -1)
                            : 0,
                        0,
                      ),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 52,
                        height: 58,
                        margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0D1117)
                              : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _pinError
                                ? const Color(0xFFEF4444)
                                : _pinFocusNodes[index].hasFocus
                                    ? widget.accentColor
                                    : isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : const Color(0xFFE5E7EB),
                            width: _pinFocusNodes[index].hasFocus ? 1.5 : 1,
                          ),
                          boxShadow: _pinFocusNodes[index].hasFocus
                              ? [
                                  BoxShadow(
                                    color: widget.accentColor
                                        .withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: TextField(
                          controller: _pinControllers[index],
                          focusNode: _pinFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          obscureText: true,
                          obscuringCharacter: '●',
                          enabled: !_isVerifying,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() => _pinError = false);
                            if (value.isNotEmpty && index < 3) {
                              _pinFocusNodes[index + 1].requestFocus();
                            }
                            // Auto-verify when all 4 digits are entered
                            final pin = _pinControllers
                                .map((c) => c.text)
                                .join();
                            if (pin.length == 4) {
                              _verifyPin();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),

                // Error message
                if (_pinError && _errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: Color(0xFFEF4444), size: 14),
                        SizedBox(width: 1.w),
                        Text(
                          _errorMessage,
                          style: GoogleFonts.inter(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 2.h),

                // Verify button
                GestureDetector(
                  onTap: _isVerifying ? null : _verifyPin,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.6.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accentColor,
                          widget.accentColor.withValues(alpha: 0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: widget.accentColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isVerifying
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              'Verify & Proceed',
                              style: GoogleFonts.inter(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                // Biometric option
                if (_biometricAvailable) ...[
                  SizedBox(height: 1.5.h),

                  // Divider with "or"
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Text(
                          'or',
                          style: GoogleFonts.inter(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.35)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Biometric button
                  GestureDetector(
                    onTap: _isVerifying ? null : _handleBiometricAuth,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.4.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint_rounded,
                            color: widget.accentColor,
                            size: 22,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Use Biometric Authentication',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : const Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 1.5.h),

                // Cancel
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.8.h),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 0.5.h),

                // Security badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFFD1D5DB),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Protected by end-to-end encryption',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : const Color(0xFFD1D5DB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
