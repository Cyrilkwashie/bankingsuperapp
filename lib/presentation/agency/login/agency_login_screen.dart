import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/agency_biometric_section_widget.dart';
import './widgets/agency_login_form_widget.dart';
import './widgets/agency_security_badge_widget.dart';

/// Agency Banking Login Screen - Secure authentication for banking agents
class AgencyLoginScreen extends StatefulWidget {
  const AgencyLoginScreen({super.key});

  @override
  State<AgencyLoginScreen> createState() => _AgencyLoginScreenState();
}

class _AgencyLoginScreenState extends State<AgencyLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _agentIdController = TextEditingController();
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
        localizedReason: 'Authenticate to access Agency Banking',
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

  bool _authenticateAgent(String agentId, String password) {
    final validCredentials = [
      {'agentId': 'AGENT001', 'password': 'Agent@123'},
      {'agentId': 'AGENT002', 'password': 'Agent@456'},
    ];

    return validCredentials.any(
      (cred) => cred['agentId'] == agentId && cred['password'] == password,
    );
  }

  void _navigateToDashboard() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/agency-banking-dashboard');
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
    _agentIdController.dispose();
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
        child: Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      'Sign in to your Agency Banking account',
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
                  AgencySecurityBadgeWidget(),
                  SizedBox(height: 4.h),
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: AgencyLoginFormWidget(
                      formKey: _formKey,
                      agentIdController: _agentIdController,
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
                    AgencyBiometricSectionWidget(
                      onBiometricLogin: _handleBiometricLogin,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
