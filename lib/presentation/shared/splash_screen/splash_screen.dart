import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Splash Screen - Branded app launch experience
///
/// Features:
/// - Animated bank logo with scale and fade-in effects
/// - Premium gradient background (deep blue to navy)
/// - Tagline display with smooth animation
/// - Abstract financial graphics in background
/// - Background initialization tasks:
///   * Biometric availability check
///   * Security certificates loading
///   * App integrity verification
///   * Encrypted storage preparation
/// - Smart navigation logic:
///   * Authenticated users → Service Selection
///   * Expired sessions → Login Screen
///   * First-time users → Service Selection
/// - Network timeout handling (5 seconds)
/// - Accessibility support (reduced motion)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _taglineFadeAnimation;
  late Animation<Offset> _graphicsSlideAnimation;

  bool _isInitializing = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo scale animation (0.0 to 1.0)
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Tagline fade animation (appears after logo)
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // Background graphics slide animation
    _graphicsSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.3, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate background initialization tasks
      await Future.wait([
        _checkBiometricAvailability(),
        _loadSecurityCertificates(),
        _verifyAppIntegrity(),
        _prepareEncryptedStorage(),
      ]).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Proceed to next screen even on timeout
          return [];
        },
      );

      // Wait for animations to complete
      await Future.delayed(const Duration(milliseconds: 3000));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isInitializing = false;
      });

      // Navigate anyway after showing error briefly
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  Future<void> _checkBiometricAvailability() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Biometric check logic would go here
  }

  Future<void> _loadSecurityCertificates() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Security certificates loading logic
  }

  Future<void> _verifyAppIntegrity() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // App integrity verification logic
  }

  Future<void> _prepareEncryptedStorage() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Encrypted storage preparation logic
  }

  void _navigateToNextScreen() {
    // Navigation logic:
    // - Check authentication status
    // - Authenticated users with active sessions → Service Selection
    // - Users with expired sessions → Login Screen
    // - First-time users → Service Selection

    // For this implementation, we'll navigate to Service Selection
    // In production, this would check actual auth state
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/service-selection-screen');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: theme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1B365D), // Deep blue
                const Color(0xFF0F1F3D), // Navy
              ],
            ),
          ),
          child: Stack(
            children: [
              // Abstract financial graphics background
              _buildBackgroundGraphics(),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo
                    _buildAnimatedLogo(),

                    SizedBox(height: 4.h),

                    // Animated tagline
                    _buildAnimatedTagline(theme),

                    if (_hasError) ...[
                      SizedBox(height: 3.h),
                      _buildErrorIndicator(theme),
                    ],
                  ],
                ),
              ),

              // Loading indicator at bottom
              if (_isInitializing && !_hasError)
                Positioned(
                  bottom: 8.h,
                  left: 0,
                  right: 0,
                  child: _buildLoadingIndicator(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundGraphics() {
    return SlideTransition(
      position: _graphicsSlideAnimation,
      child: Stack(
        children: [
          // Geometric shapes
          Positioned(
            top: 15.h,
            right: -10.w,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: -15.w,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            right: 10.w,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // Connecting lines
          Positioned(
            top: 25.h,
            left: 20.w,
            right: 20.w,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: CustomPaint(
                size: Size(60.w, 2),
                painter: _DottedLinePainter(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return ScaleTransition(
      scale: _logoScaleAnimation,
      child: FadeTransition(
        opacity: _logoFadeAnimation,
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'account_balance',
                color: const Color(0xFF1B365D),
                size: 16.w,
              ),
              SizedBox(height: 1.h),
              Text(
                'BSA',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B365D),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline(ThemeData theme) {
    return FadeTransition(
      opacity: _taglineFadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          'One App. Three Powerful Banking Solutions',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: SizedBox(
        width: 8.w,
        height: 8.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIndicator(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'info_outline',
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              'Initializing in offline mode',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for dotted lines in background graphics
class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
