import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
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
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    HapticFeedback.mediumImpact();
    _navigateToDashboard();
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
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/merchant-banking-dashboard');
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

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.brightness == Brightness.light
                            ? const Color(0xFF1A1D23)
                            : const Color(0xFFFAFBFC),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Sign in to your Merchant Banking account',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.brightness == Brightness.light
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    MerchantSecurityBadgeWidget(),
                    SizedBox(height: 3.h),
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
                    SizedBox(height: 2.h),
                    if (_biometricAvailable)
                      MerchantBiometricSectionWidget(
                        onBiometricLogin: _handleBiometricLogin,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
