import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/merchant_biometric_section_widget.dart';
import './widgets/merchant_login_form_widget.dart';
import './widgets/merchant_security_badge_widget.dart';

/// Merchant Banking Login Screen — Premium professional authentication UI
class MerchantLoginScreen extends StatefulWidget {
  const MerchantLoginScreen({super.key});

  @override
  State<MerchantLoginScreen> createState() => _MerchantLoginScreenState();
}

class _MerchantLoginScreenState extends State<MerchantLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _merchantIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _biometricAvailable = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _fadeSlideController;
  late AnimationController _pulseController;

  // Brand palette — Emerald
  static const _brandPrimary = Color(0xFF059669);
  static const _brandDark = Color(0xFF047857);
  static const _brandLight = Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _initAnimations();
  }

  void _initAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _fadeSlideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();
      setState(() => _biometricAvailable = canCheck && supported);
    } catch (_) {
      setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _handleBiometricLogin() async {
    if (!_biometricAvailable) {
      _showError('Biometric authentication not available on this device');
      return;
    }
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Merchant Banking',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (ok) {
        HapticFeedback.mediumImpact();
        _navigateToDashboard();
      }
    } catch (_) {
      _showError('Biometric authentication failed. Please try again.');
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      HapticFeedback.heavyImpact();
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    HapticFeedback.mediumImpact();
    _navigateToDashboard();
  }

  void _navigateToDashboard() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/merchant-banking-dashboard');
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(msg, style: GoogleFonts.inter(fontSize: 9.sp)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeSlideController.dispose();
    _pulseController.dispose();
    _merchantIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isLight
            ? const Color(0xFFF5F7FA)
            : const Color(0xFF0A0E14),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildHeroHeader(isLight),
              Transform.translate(
                offset: const Offset(0, -36),
                child: _buildMainCard(isLight),
              ),
              _buildFooter(isLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(bool isLight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 1.5.h,
        bottom: 7.h,
        left: 6.w,
        right: 6.w,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_brandDark, _brandPrimary, _brandLight],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _brandPrimary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.25), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _fadeSlideController,
                curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
              ),
            ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _fadeSlideController,
            curve: const Interval(0.0, 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  Icons.store_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Merchant\nBanking',
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                'Sign in to manage your merchant operations',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(bool isLight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _fadeSlideController,
                curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _fadeSlideController,
            curve: const Interval(0.3, 0.8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isLight ? Colors.white : const Color(0xFF1A1F2E),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isLight ? 0.06 : 0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: _brandPrimary.withValues(alpha: 0.04),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MerchantSecurityBadgeWidget(
                    pulseController: _pulseController,
                  ),
                  SizedBox(height: 3.h),
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    ),
                    child: MerchantLoginFormWidget(
                      formKey: _formKey,
                      merchantIdController: _merchantIdController,
                      passwordController: _passwordController,
                      isPasswordVisible: _isPasswordVisible,
                      isLoading: _isLoading,
                      onPasswordVisibilityToggle: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                      onLogin: _handleLogin,
                      brandColor: _brandPrimary,
                      brandDark: _brandDark,
                    ),
                  ),
                  if (_biometricAvailable) ...[
                    SizedBox(height: 2.5.h),
                    MerchantBiometricSectionWidget(
                      onBiometricLogin: _handleBiometricLogin,
                      brandColor: _brandPrimary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isLight) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _fadeSlideController,
          curve: const Interval(0.7, 1.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: isLight
                      ? const Color(0xFFB0B8C4)
                      : const Color(0xFF4B5563),
                ),
                const SizedBox(width: 6),
                Text(
                  'Protected by 256-bit SSL encryption',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    color: isLight
                        ? const Color(0xFFB0B8C4)
                        : const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.8.h),
            Text(
              '© 2026 Union Systems Global',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isLight
                    ? const Color(0xFFD0D5DD)
                    : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
