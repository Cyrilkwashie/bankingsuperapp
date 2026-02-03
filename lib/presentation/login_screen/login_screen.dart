import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_section_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/security_badge_widget.dart';

/// Login Screen - Secure authentication with biometric support
///
/// Features:
/// - Phone/username authentication with floating labels
/// - Password visibility toggle
/// - Biometric authentication (fingerprint/Face ID)
/// - Real-time validation with inline errors
/// - Progressive security delays on failed attempts
/// - Bank-grade encryption messaging
/// - Forgot password recovery flow
/// - Account creation navigation
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
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
    // In production, load from secure storage
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
        localizedReason: 'Authenticate to access your banking account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        HapticFeedback.mediumImpact();
        _navigateToServiceSelection();
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

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock authentication logic
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (_authenticateUser(username, password)) {
      _failedAttempts = 0;
      _lockoutTime = null;

      // Enable biometric for future logins
      setState(() {
        _biometricEnabled = true;
      });

      HapticFeedback.mediumImpact();
      _navigateToServiceSelection();
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

  bool _authenticateUser(String username, String password) {
    // Mock credentials for demonstration
    final validCredentials = [
      {'username': 'demo@bank.com', 'password': 'Demo@123'},
      {'username': '1234567890', 'password': 'Mobile@123'},
      {'username': 'testuser', 'password': 'Test@123'},
    ];

    return validCredentials.any(
      (cred) => cred['username'] == username && cred['password'] == password,
    );
  }

  void _navigateToServiceSelection() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/service-selection-screen');
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

  void _handleForgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 4.w,
          right: 4.w,
          top: 2.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            Text(
              'Enter your registered email or phone number to receive password reset instructions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email or Phone',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showErrorSnackBar('Password reset link sent successfully');
                },
                child: const Text('Send Reset Link'),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
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

                  Text(
                    'Sign in to access your banking services',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    formKey: _formKey,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    isPasswordVisible: _isPasswordVisible,
                    isLoading: _isLoading,
                    onPasswordVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    onLogin: _handleLogin,
                    onForgotPassword: _handleForgotPassword,
                  ),

                  SizedBox(height: 3.h),

                  // Biometric Section
                  if (_biometricAvailable)
                    BiometricSectionWidget(
                      onBiometricLogin: _handleBiometricLogin,
                    ),

                  SizedBox(height: 4.h),

                  // Security Badges
                  const SecurityBadgeWidget(),

                  SizedBox(height: 3.h),

                  // Create Account Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to account creation
                        },
                        child: Text(
                          'Create Account',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
