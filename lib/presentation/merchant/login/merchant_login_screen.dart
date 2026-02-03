import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './widgets/merchant_biometric_section_widget.dart';
import './widgets/merchant_login_form_widget.dart';
import './widgets/merchant_security_badge_widget.dart';

/// Merchant Banking Login Screen - Secure authentication for merchants
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
  bool _biometricEnabled = false;
  int _failedAttempts = 0;
  DateTime? _lockoutTime;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadBiometricPreference();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      setState(() {
        _biometricAvailable = canCheckBiometrics && isDeviceSupported;
      });
    } catch (e) {
      setState(() {
        _biometricAvailable = false;
      });
    }
  }

  Future<void> _loadBiometricPreference() async {
    setState(() {
      _biometricEnabled = false;
    });
  }

  Future<void> _handleBiometricLogin() async {
    if (!_biometricAvailable) {
      _showErrorSnackBar(
        'Biometric authentication not available on this device',
      );
      return;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Merchant Banking',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        HapticFeedback.mediumImpact();
        _navigateToDashboard();
      }
    } catch (e) {
      _showErrorSnackBar('Biometric authentication failed. Please try again.');
    }
  }

  Future<void> _handleLogin() async {
    if (_lockoutTime != null && DateTime.now().isBefore(_lockoutTime!)) {
      final remainingSeconds = _lockoutTime!
          .difference(DateTime.now())
          .inSeconds;
      _showErrorSnackBar(
        'Account temporarily locked. Try again in $remainingSeconds seconds.',
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final merchantId = _merchantIdController.text.trim();
    final password = _passwordController.text;

    if (_authenticateMerchant(merchantId, password)) {
      _failedAttempts = 0;
      _lockoutTime = null;

      setState(() {
        _biometricEnabled = true;
      });

      HapticFeedback.mediumImpact();
      _navigateToDashboard();
    } else {
      _failedAttempts++;

      if (_failedAttempts >= 3) {
        final lockoutDuration = _failedAttempts == 3
            ? 30
            : (_failedAttempts == 4 ? 60 : 300);
        _lockoutTime = DateTime.now().add(Duration(seconds: lockoutDuration));
        _showErrorSnackBar(
          'Too many failed attempts. Account locked for $lockoutDuration seconds.',
        );
      } else {
        _showErrorSnackBar(
          'Invalid credentials. ${3 - _failedAttempts} attempts remaining.',
        );
      }

      _shakeController.forward().then((_) => _shakeController.reverse());
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _authenticateMerchant(String merchantId, String password) {
    final validCredentials = [
      {'merchantId': 'MERCH001', 'password': 'Merchant@123'},
      {'merchantId': 'MERCH002', 'password': 'Merchant@456'},
    ];

    return validCredentials.any(
      (cred) =>
          cred['merchantId'] == merchantId && cred['password'] == password,
    );
  }

  void _navigateToDashboard() {
    _showErrorSnackBar('Merchant Dashboard - Coming Soon');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _merchantIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xFFFAFBFC)
          : const Color(0xFF0F1419),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                Row(
                  children: [
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: theme.brightness == Brightness.light
                            ? const Color(0xFF1A1D23)
                            : const Color(0xFFFAFBFC),
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.brightness == Brightness.light
                            ? const Color(0xFF1A1D23)
                            : const Color(0xFFFAFBFC),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Text(
                    'Sign in to your Merchant Banking account',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.brightness == Brightness.light
                          ? const Color(0xFF6B7280)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                MerchantSecurityBadgeWidget(),
                SizedBox(height: 4.h),
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: MerchantLoginFormWidget(
                    formKey: _formKey,
                    merchantIdController: _merchantIdController,
                    passwordController: _passwordController,
                    isPasswordVisible: _isPasswordVisible,
                    isLoading: _isLoading,
                    onPasswordVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    onLogin: _handleLogin,
                  ),
                ),
                SizedBox(height: 3.h),
                if (_biometricAvailable)
                  MerchantBiometricSectionWidget(
                    onBiometricLogin: _handleBiometricLogin,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
