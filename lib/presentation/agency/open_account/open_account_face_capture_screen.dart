part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 2 – Face Verification Photo ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountFaceCaptureScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final _GhanaCardProfile ghanaCardProfile;
  final String phone;
  final String email;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountFaceCaptureScreen({
    required this.accountType,
    required this.minDeposit,
    required this.ghanaCardProfile,
    required this.phone,
    required this.email,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountFaceCaptureScreen> createState() =>
      _OpenAccountFaceCaptureScreenState();
}

class _OpenAccountFaceCaptureScreenState
    extends State<_OpenAccountFaceCaptureScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _cameraController;
  File? _capturedPhoto;
  bool _isCapturing = false;
  bool _cameraError = false;
  bool _isInitializingCamera = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _cameraController = null;
    } else if (state == AppLifecycleState.resumed && _capturedPhoto == null) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (_capturedPhoto != null) return;

    setState(() {
      _isInitializingCamera = true;
      _cameraError = false;
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw StateError('No cameras available');
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      await _cameraController?.dispose();
      setState(() {
        _cameraController = controller;
        _isInitializingCamera = false;
        _cameraError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cameraError = true;
        _isInitializingCamera = false;
      });
    }
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 2,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step == 3) {
      _goToPersonalDetails();
      return;
    }
    if (step >= 4) {
      _goToPersonalDetails();
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _OpenAccountContactScreen(
            accountType: widget.accountType,
            minDeposit: widget.minDeposit,
            ghanaCardProfile: widget.ghanaCardProfile,
            phone: widget.phone,
            email: widget.email,
            verificationPhoto: _capturedPhoto,
            title: widget.ghanaCardProfile.gender == 'Female' ? 'Ms.' : 'Mr.',
            firstName: widget.ghanaCardProfile.firstName,
            lastName: widget.ghanaCardProfile.lastName,
            otherName: widget.ghanaCardProfile.otherName,
            gender: widget.ghanaCardProfile.gender,
            maritalStatus: 'Single',
            dob: widget.ghanaCardProfile.dobDisplay,
            educationalLevel: 'SHS / Secondary',
            disabilityStatus: 'No',
            idType: 'National ID',
            idNumber: widget.ghanaCardProfile.nationalId,
            issueDate: widget.ghanaCardProfile.issueDate,
            expiryDate: widget.ghanaCardProfile.expiryDate,
            accentColor: widget.accentColor,
            gradientColors: widget.gradientColors,
          ),
        ),
      );
    }
  }

  void _goToPersonalDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountPersonalScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: _capturedPhoto,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  Future<void> _capturePhoto() async {
    final controller = _cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing ||
        _capturedPhoto != null) {
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final xFile = await controller.takePicture();
      await controller.dispose();
      _cameraController = null;

      if (mounted) {
        setState(() => _capturedPhoto = File(xFile.path));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not capture photo. Please try again.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _retakePhoto() async {
    setState(() => _capturedPhoto = null);
    await _initCamera();
  }

  void _onContinue() {
    if (_capturedPhoto == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountPersonalScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: _capturedPhoto,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  Widget _buildPreviewContent(bool isDark) {
    if (_capturedPhoto != null) {
      return Image.file(
        _capturedPhoto!,
        fit: BoxFit.cover,
      );
    }

    final controller = _cameraController;
    if (controller != null && controller.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: controller.value.previewSize!.height,
          height: controller.value.previewSize!.width,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: CameraPreview(controller),
          ),
        ),
      );
    }

    if (_isInitializingCamera) {
      return Container(
        color: isDark ? const Color(0xFF161B22) : const Color(0xFF111827),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: widget.accentColor,
          ),
        ),
      );
    }

    return Container(
      color: isDark ? const Color(0xFF161B22) : const Color(0xFF111827),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off_outlined,
            size: 40,
            color: isDark ? Colors.white24 : Colors.white38,
          ),
          SizedBox(height: 0.8.h),
          Text(
            _cameraError
                ? 'Camera unavailable on this device'
                : 'Starting camera...',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cameraReady = _cameraController?.value.isInitialized ?? false;

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
              title: 'Confirm Identity',
              subtitle:
                  'Open Account · Step 2 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.face_retouching_natural_rounded,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              2,
              accentColor: widget.accentColor,
              onStepTap: _handleWizardStepTap,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.2.h, 5.w, 1.h),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildPreviewContent(isDark),
                            CustomPaint(
                              painter: _FaceCaptureFramePainter(
                                accentColor: widget.accentColor,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.72),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  _capturedPhoto != null
                                      ? 'Face captured — retake below if needed'
                                      : 'Centre your face in the oval — forehead to chin',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        _buildGuideChip(
                          isDark,
                          Icons.light_mode_outlined,
                          'Good lighting',
                        ),
                        SizedBox(width: 2.w),
                        _buildGuideChip(
                          isDark,
                          Icons.remove_red_eye_outlined,
                          'Eyes visible',
                        ),
                        SizedBox(width: 2.w),
                        _buildGuideChip(
                          isDark,
                          Icons.no_photography_outlined,
                          'No cap/mask',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _capturedPhoto == null
                  ? _OpenAccountUi.buildPrimaryButton(
                      isDark: isDark,
                      label: _isCapturing ? 'Capturing...' : 'Capture Photo',
                      onTap: _isCapturing || !cameraReady ? null : _capturePhoto,
                      accentColor: widget.accentColor,
                      icon: Icons.camera_alt_outlined,
                      showArrow: false,
                    )
                  : Column(
                      children: [
                        _OpenAccountUi.buildPrimaryButton(
                          isDark: isDark,
                          label: 'Continue to Personal',
                          onTap: _onContinue,
                          accentColor: widget.accentColor,
                        ),
                        SizedBox(height: 0.8.h),
                        GestureDetector(
                          onTap: _isCapturing ? null : _retakePhoto,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.6.h),
                            child: Text(
                              _isCapturing ? 'Restarting camera...' : 'Retake Photo',
                              style: GoogleFonts.inter(
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.w600,
                                color: widget.accentColor,
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

  Widget _buildGuideChip(bool isDark, IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.55.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: widget.accentColor),
            SizedBox(height: 0.2.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 5.8.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaceCaptureFramePainter extends CustomPainter {
  /// Height-to-width ratio for a natural head-and-face silhouette.
  static const double _headAspectRatio = 1.32;

  final Color accentColor;

  _FaceCaptureFramePainter({required this.accentColor});

  Rect _faceOvalRect(Size size) {
    const horizontalInset = 0.1;
    const verticalInset = 0.08;

    final maxWidth = size.width * (1 - horizontalInset * 2);
    final maxHeight = size.height * (1 - verticalInset * 2);

    var ovalWidth = maxWidth * 0.92;
    var ovalHeight = ovalWidth * _headAspectRatio;
    if (ovalHeight > maxHeight) {
      ovalHeight = maxHeight;
      ovalWidth = ovalHeight / _headAspectRatio;
    }

    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.48),
      width: ovalWidth,
      height: ovalHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final faceRect = _faceOvalRect(size);

    final overlay = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(faceRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      overlay,
      Paint()..color = Colors.black.withValues(alpha: 0.62),
    );

    // Soft outer glow
    canvas.drawOval(
      faceRect.inflate(3),
      Paint()
        ..color = accentColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // Primary oval border
    canvas.drawOval(
      faceRect,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Inner highlight ring
    canvas.drawOval(
      faceRect.deflate(2),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final guide = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Eye-level alignment line (~42% from top of oval)
    final eyeY = faceRect.top + faceRect.height * 0.42;
    canvas.drawLine(
      Offset(faceRect.left + faceRect.width * 0.18, eyeY),
      Offset(faceRect.right - faceRect.width * 0.18, eyeY),
      guide,
    );

    final anchorGuide = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Chin anchor — helps user position lower face boundary
    final chinY = faceRect.bottom - faceRect.height * 0.08;
    canvas.drawLine(
      Offset(faceRect.center.dx - 8, chinY),
      Offset(faceRect.center.dx + 8, chinY),
      anchorGuide,
    );

    // Forehead anchor at top centre
    final foreheadY = faceRect.top + faceRect.height * 0.1;
    canvas.drawLine(
      Offset(faceRect.center.dx - 6, foreheadY),
      Offset(faceRect.center.dx + 6, foreheadY),
      anchorGuide,
    );
  }

  @override
  bool shouldRepaint(covariant _FaceCaptureFramePainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
