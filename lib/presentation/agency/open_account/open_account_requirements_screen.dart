part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 3 – Documents, Photos & Initial Deposit ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountRequirementsScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final String firstName;
  final String lastName;
  final String otherName;
  final String gender;
  final String maritalStatus;
  final String dob;
  final String mothersMaidenName;
  final String occupation;
  final String idType;
  final String idNumber;
  final String issueDate;
  final String expiryDate;
  final String phone;
  final String altPhone;
  final String email;
  final String address;
  final String city;
  final String nokName;
  final String nokPhone;
  final String nokRelation;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountRequirementsScreen({
    required this.accountType,
    required this.minDeposit,
    required this.firstName,
    required this.lastName,
    required this.otherName,
    required this.gender,
    required this.maritalStatus,
    required this.dob,
    required this.mothersMaidenName,
    required this.occupation,
    required this.idType,
    required this.idNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.address,
    required this.city,
    required this.nokName,
    required this.nokPhone,
    required this.nokRelation,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountRequirementsScreen> createState() =>
      _OpenAccountRequirementsScreenState();
}

class _OpenAccountRequirementsScreenState
    extends State<_OpenAccountRequirementsScreen>
    with SingleTickerProviderStateMixin {
  final _depositCtrl = TextEditingController();
  final _picker = ImagePicker();

  // Captured images
  File? _passportPhoto;
  File? _idFrontPhoto;
  File? _idBackPhoto;
  File? _signaturePhoto;
  File? _proofOfAddressPhoto;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeIn =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _depositCtrl.dispose();
    super.dispose();
  }

  int get _requiredCaptured =>
      [_passportPhoto, _idFrontPhoto].where((f) => f != null).length;
  int get _optionalCaptured =>
      [_idBackPhoto, _signaturePhoto, _proofOfAddressPhoto]
          .where((f) => f != null)
          .length;
  int get _totalCaptured => _requiredCaptured + _optionalCaptured;

  double get _depositAmount =>
      double.tryParse(_depositCtrl.text.replaceAll(',', '')) ?? 0;
  double get _minDepositNum =>
      double.tryParse(widget.minDeposit.replaceAll(RegExp(r'[^\d.]'), '')) ??
      0;

  bool get _canContinue =>
      _passportPhoto != null &&
      _idFrontPhoto != null &&
      _depositCtrl.text.trim().isNotEmpty &&
      _depositAmount >= _minDepositNum;

  // ── Passport — camera only (live photo) ───────────────────

  Future<void> _capturePassportPhoto() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1200,
        maxHeight: 1600,
      );
      if (xFile != null && mounted) {
        setState(() => _passportPhoto = File(xFile.path));
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Could not open camera. Please check permissions.');
    }
  }

  // ── Documents — premium source picker ─────────────────────

  Future<void> _captureDocumentPhoto({
    required String title,
    required String description,
    required IconData headerIcon,
    required ValueChanged<File> onCaptured,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF161B22) : Colors.white;
        final surfaceDim =
            isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC);

        return Container(
          margin: EdgeInsets.fromLTRB(3.w, 0, 3.w, 1.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Gradient header strip ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              const Color(0xFF162032),
                              const Color(0xFF0D1117)
                            ]
                          : widget.gradientColors,
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 1.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: 0.08)),
                            ),
                            child: Center(
                              child: Icon(headerIcon,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 0.2.h),
                                Text(
                                  description,
                                  style: GoogleFonts.inter(
                                    fontSize: 7.5.sp,
                                    color: Colors.white
                                        .withValues(alpha: 0.65),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color:
                                    Colors.white.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.close_rounded,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Options ──
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(4.w, 2.5.h, 4.w, 2.h),
                  child: Column(
                    children: [
                      // Camera option
                      _buildSourceTile(
                        icon: Icons.camera_alt_rounded,
                        iconBg: widget.accentColor,
                        title: 'Take Photo',
                        subtitle:
                            'Use your camera to capture the document',
                        isDark: isDark,
                        surfaceDim: surfaceDim,
                        onTap: () =>
                            Navigator.pop(ctx, ImageSource.camera),
                      ),
                      SizedBox(height: 1.2.h),
                      // Gallery option
                      _buildSourceTile(
                        icon: Icons.photo_library_rounded,
                        iconBg: const Color(0xFF7C3AED),
                        title: 'Upload from Gallery',
                        subtitle:
                            'Select an existing photo from your device',
                        isDark: isDark,
                        surfaceDim: surfaceDim,
                        onTap: () =>
                            Navigator.pop(ctx, ImageSource.gallery),
                      ),
                      SizedBox(height: 1.5.h),
                      // Tip row
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: widget.accentColor
                              .withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: widget.accentColor
                                .withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline_rounded,
                                color: widget.accentColor, size: 16),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                'Ensure the document is well-lit, flat, and all edges are visible.',
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : const Color(0xFF6B7280),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final xFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
        maxWidth: 1400,
        maxHeight: 1400,
      );
      if (xFile != null && mounted) {
        onCaptured(File(xFile.path));
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Could not capture image. Please try again.');
    }
  }

  Widget _buildSourceTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color surfaceDim,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 3.5.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: surfaceDim,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconBg,
                      iconBg.withValues(alpha: 0.75),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconBg.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      Icon(icon, color: Colors.white, size: 18),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
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
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: isDark
                        ? Colors.white24
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, fontSize: 8.5.sp)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFDC2626),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      ),
    );
  }

  void _onContinue() {
    if (!_canContinue) {
      _showError(_depositAmount < _minDepositNum
          ? 'Minimum deposit is GH₵${widget.minDeposit}'
          : 'Please capture the required photos');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountReviewScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          firstName: widget.firstName,
          lastName: widget.lastName,
          otherName: widget.otherName,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          dob: widget.dob,
          mothersMaidenName: widget.mothersMaidenName,
          occupation: widget.occupation,
          idType: widget.idType,
          idNumber: widget.idNumber,
          issueDate: widget.issueDate,
          expiryDate: widget.expiryDate,
          phone: widget.phone,
          altPhone: widget.altPhone,
          email: widget.email,
          address: widget.address,
          city: widget.city,
          nokName: widget.nokName,
          nokPhone: widget.nokPhone,
          nokRelation: widget.nokRelation,
          hasIdCopy: _idFrontPhoto != null,
          hasPassportPhoto: _passportPhoto != null,
          hasProofOfAddress: _proofOfAddressPhoto != null,
          hasSignature: _signaturePhoto != null,
          initialDeposit: _depositCtrl.text.trim(),
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF161B22) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(isDark, 3, 4),
                    SizedBox(height: 2.5.h),

                    // ── Customer summary banner ─────────────
                    Container(
                      padding: EdgeInsets.all(3.5.w),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              widget.accentColor.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.gradientColors,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.firstName[0]}${widget.lastName[0]}',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.firstName} ${widget.lastName}',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF111827),
                                  ),
                                ),
                                Text(
                                  '${widget.accountType} Account · ${widget.idType}',
                                  style: GoogleFonts.inter(
                                    fontSize: 7.5.sp,
                                    color: isDark
                                        ? Colors.white38
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildProgressRing(isDark),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // ════════════════════════════════════════
                    // ── SECTION 1: Live Customer Photo ──────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.person_rounded,
                      title: 'Customer Photograph',
                      subtitle: 'Live camera capture required',
                      badgeText: 'Required',
                      badgeColor: const Color(0xFFDC2626),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),

                    // Passport photo card — camera only
                    GestureDetector(
                      onTap: _capturePassportPhoto,
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _passportPhoto != null
                                ? const Color(0xFF059669)
                                    .withValues(alpha: 0.5)
                                : borderColor,
                            width: _passportPhoto != null ? 1.5 : 1,
                          ),
                          boxShadow: [
                            if (_passportPhoto != null)
                              BoxShadow(
                                color: const Color(0xFF059669)
                                    .withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(17)),
                              child: AspectRatio(
                                aspectRatio: 16 / 7,
                                child: _passportPhoto != null
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(
                                            _passportPhoto!,
                                            fit: BoxFit.cover,
                                          ),
                                          // Gradient scrim
                                          Positioned.fill(
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment
                                                      .topCenter,
                                                  end: Alignment
                                                      .bottomCenter,
                                                  colors: [
                                                    Colors.black
                                                        .withValues(
                                                            alpha: 0.3),
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withValues(
                                                            alpha: 0.4),
                                                  ],
                                                  stops: const [
                                                    0,
                                                    0.4,
                                                    1
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Top row
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            right: 8,
                                            child: Row(
                                              children: [
                                                _capturedBadge(),
                                                const Spacer(),
                                                _removeBtn(() =>
                                                    setState(() =>
                                                        _passportPhoto =
                                                            null)),
                                              ],
                                            ),
                                          ),
                                          // Bottom retake
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: _retakeBtn(),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.02)
                                              : const Color(0xFFF9FAFB),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    widget.accentColor
                                                        .withValues(
                                                            alpha: 0.15),
                                                    widget.accentColor
                                                        .withValues(
                                                            alpha: 0.05),
                                                  ],
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons
                                                      .camera_alt_rounded,
                                                  color: widget
                                                      .accentColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 0.6.h),
                                            Text(
                                              'Tap to take photo',
                                              style: GoogleFonts.inter(
                                                fontSize: 8.sp,
                                                fontWeight:
                                                    FontWeight.w600,
                                                color: widget
                                                    .accentColor,
                                              ),
                                            ),
                                            SizedBox(height: 0.3.h),
                                            Text(
                                              'Front-facing · Live capture only',
                                              style: GoogleFonts.inter(
                                                fontSize: 7.sp,
                                                color: isDark
                                                    ? Colors.white30
                                                    : const Color(
                                                        0xFFB0B0B0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            // Footer
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.2.h),
                              child: Row(
                                children: [
                                  Icon(
                                    _passportPhoto != null
                                        ? Icons
                                            .check_circle_rounded
                                        : Icons.face_rounded,
                                    size: 18,
                                    color: _passportPhoto != null
                                        ? const Color(0xFF059669)
                                        : widget.accentColor,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Passport Photograph',
                                          style: GoogleFonts.inter(
                                            fontSize: 9.sp,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(
                                                    0xFF111827),
                                          ),
                                        ),
                                        Text(
                                          _passportPhoto != null
                                              ? 'Photo captured successfully'
                                              : 'Camera only — no gallery',
                                          style: GoogleFonts.inter(
                                            fontSize: 7.sp,
                                            color: _passportPhoto !=
                                                    null
                                                ? const Color(
                                                    0xFF059669)
                                                : (isDark
                                                    ? Colors.white24
                                                    : const Color(
                                                        0xFFBBBBBB)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDC2626)
                                          .withValues(alpha: 0.08),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons
                                              .videocam_rounded,
                                          size: 11,
                                          color:
                                              const Color(0xFFDC2626),
                                        ),
                                        SizedBox(width: 0.8.w),
                                        Text(
                                          'Live',
                                          style: GoogleFonts.inter(
                                            fontSize: 6.5.sp,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: const Color(
                                                0xFFDC2626),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // ════════════════════════════════════════
                    // ── SECTION 2: ID Document ──────────────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.badge_rounded,
                      title: 'Identity Document',
                      subtitle:
                          '${widget.idType} — ${widget.idNumber}',
                      badgeText: 'Required',
                      badgeColor: const Color(0xFFDC2626),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDocCard(
                            title: 'ID Front',
                            subtitle: widget.idType,
                            icon: Icons.badge_outlined,
                            file: _idFrontPhoto,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            onCapture: () => _captureDocumentPhoto(
                              title: 'ID Front Side',
                              description:
                                  'Capture the front of the ${widget.idType}',
                              headerIcon: Icons.badge_outlined,
                              onCaptured: (f) =>
                                  setState(() => _idFrontPhoto = f),
                            ),
                            onRemove: () =>
                                setState(() => _idFrontPhoto = null),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildDocCard(
                            title: 'ID Back',
                            subtitle: 'Back side',
                            icon: Icons.flip_rounded,
                            file: _idBackPhoto,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            isOptional: true,
                            onCapture: () => _captureDocumentPhoto(
                              title: 'ID Back Side',
                              description:
                                  'Capture the back of the ${widget.idType}',
                              headerIcon: Icons.flip_rounded,
                              onCaptured: (f) =>
                                  setState(() => _idBackPhoto = f),
                            ),
                            onRemove: () =>
                                setState(() => _idBackPhoto = null),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // ════════════════════════════════════════
                    // ── SECTION 3: Supporting Documents ──────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.folder_open_rounded,
                      title: 'Supporting Documents',
                      subtitle: 'Optional but recommended',
                      badgeText: 'Optional',
                      badgeColor: const Color(0xFF6B7280),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDocCard(
                            title: 'Signature',
                            subtitle: 'Mandate card',
                            icon: Icons.draw_outlined,
                            file: _signaturePhoto,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            isOptional: true,
                            onCapture: () => _captureDocumentPhoto(
                              title: 'Customer Signature',
                              description:
                                  'Capture the signed mandate card',
                              headerIcon: Icons.draw_outlined,
                              onCaptured: (f) => setState(
                                  () => _signaturePhoto = f),
                            ),
                            onRemove: () => setState(
                                () => _signaturePhoto = null),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildDocCard(
                            title: 'Proof of Addr.',
                            subtitle: 'Utility bill etc.',
                            icon: Icons.home_outlined,
                            file: _proofOfAddressPhoto,
                            isDark: isDark,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            isOptional: true,
                            onCapture: () => _captureDocumentPhoto(
                              title: 'Proof of Address',
                              description:
                                  'Utility bill, bank statement, or tenancy agreement',
                              headerIcon: Icons.home_outlined,
                              onCaptured: (f) => setState(
                                  () => _proofOfAddressPhoto = f),
                            ),
                            onRemove: () => setState(
                                () => _proofOfAddressPhoto = null),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // ════════════════════════════════════════
                    // ── SECTION 4: Initial Deposit ───────────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'Initial Deposit',
                      subtitle:
                          'Minimum GH₵${widget.minDeposit} for ${widget.accountType}',
                      badgeText: 'Required',
                      badgeColor: const Color(0xFFDC2626),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),

                    // Deposit card
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: widget.accentColor
                                      .withValues(alpha: 0.08),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'GH₵',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: widget.accentColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: TextFormField(
                                  controller: _depositCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[\d.]')),
                                  ],
                                  onChanged: (_) =>
                                      setState(() {}),
                                  style:
                                      GoogleFonts.jetBrainsMono(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1D23),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    hintStyle:
                                        GoogleFonts.jetBrainsMono(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white.withValues(
                                              alpha: 0.08)
                                          : const Color(0xFFE5E7EB),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Divider(
                            color: borderColor,
                            height: 1,
                          ),
                          SizedBox(height: 1.h),
                          // Validation message
                          if (_depositCtrl.text.isNotEmpty &&
                              _depositAmount < _minDepositNum)
                            Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDC2626)
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Color(0xFFDC2626),
                                      size: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 1.5.w),
                                Text(
                                  'Below minimum of GH₵${widget.minDeposit}',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: const Color(0xFFDC2626),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          else if (_depositAmount >= _minDepositNum)
                            Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF059669)
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Color(0xFF059669),
                                      size: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 1.5.w),
                                Text(
                                  'Deposit amount accepted',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: const Color(0xFF059669),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Enter the opening deposit amount',
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                color: isDark
                                    ? Colors.white24
                                    : const Color(0xFFB0B0B0),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.2.h),

                    // Quick-fill chips
                    Row(
                      children: [50, 100, 200, 500].map((amt) {
                        final isSelected =
                            _depositCtrl.text == amt.toString();
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.8.w),
                            child: GestureDetector(
                              onTap: () => setState(() =>
                                  _depositCtrl.text =
                                      amt.toString()),
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.9.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? widget.accentColor
                                          .withValues(alpha: 0.12)
                                      : cardBg,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? widget.accentColor
                                            .withValues(alpha: 0.4)
                                        : borderColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'GH₵$amt',
                                    style: GoogleFonts.inter(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? widget.accentColor
                                          : (isDark
                                              ? Colors.white54
                                              : const Color(
                                                  0xFF6B7280)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.5.h),

                    // Continue button
                    _buildContinueButton(isDark),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reusable document capture card ────────────────────────

  Widget _buildDocCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? file,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    bool isOptional = false,
    required VoidCallback onCapture,
    required VoidCallback onRemove,
  }) {
    final hasCaptured = file != null;

    return GestureDetector(
      onTap: hasCaptured ? null : onCapture,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasCaptured
                ? const Color(0xFF059669).withValues(alpha: 0.4)
                : borderColor,
            width: hasCaptured ? 1.5 : 1,
          ),
          boxShadow: hasCaptured
              ? [
                  BoxShadow(
                    color: const Color(0xFF059669)
                        .withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: AspectRatio(
                aspectRatio: 16 / 8,
                child: hasCaptured
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(file, fit: BoxFit.cover),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black
                                        .withValues(alpha: 0.25),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            child: _capturedBadge(),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: _removeBtn(onRemove),
                          ),
                        ],
                      )
                    : Container(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.02)
                            : const Color(0xFFF9FAFB),
                        child: Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: isDark
                                    ? Colors.white24
                                    : const Color(0xFFD1D5DB),
                                size: 22,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Capture',
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white24
                                      : const Color(0xFFC0C0C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            // Label
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 2.5.w, vertical: 0.8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!isOptional) ...[
                              SizedBox(width: 0.5.w),
                              Text(
                                '*',
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 6.5.sp,
                            color: isDark
                                ? Colors.white24
                                : const Color(0xFFC0C0C0),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (hasCaptured)
                    GestureDetector(
                      onTap: onCapture,
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: widget.accentColor,
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

  // ── Micro-widgets ─────────────────────────────────────────

  Widget _capturedBadge() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF059669),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded,
              color: Colors.white, size: 9),
          SizedBox(width: 0.5.w),
          Text(
            'Done',
            style: GoogleFonts.inter(
              fontSize: 5.5.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _removeBtn(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.2), width: 0.5),
        ),
        child: const Center(
          child:
              Icon(Icons.close_rounded, color: Colors.white, size: 12),
        ),
      ),
    );
  }

  Widget _retakeBtn() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt_rounded,
              color: Colors.white, size: 12),
          SizedBox(width: 1.w),
          Text(
            'Retake',
            style: GoogleFonts.inter(
              fontSize: 6.5.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing(bool isDark) {
    const total = 5;
    final pct = _totalCaptured / total;
    final allDone = _totalCaptured == total;
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              value: pct,
              strokeWidth: 3,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation(
                allDone
                    ? const Color(0xFF059669)
                    : widget.accentColor,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '$_totalCaptured/$total',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 6.5.sp,
              fontWeight: FontWeight.w700,
              color: allDone
                  ? const Color(0xFF059669)
                  : (isDark ? Colors.white54 : const Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ────────────────────────────────────────

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: widget.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(icon, color: widget.accentColor, size: 14),
          ),
        ),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color:
                      isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
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
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 2.w, vertical: 0.3.h),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: badgeColor.withValues(alpha: 0.15)),
          ),
          child: Text(
            badgeText,
            style: GoogleFonts.inter(
              fontSize: 6.5.sp,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  // ── Shared helpers ────────────────────────────────────────

  Widget _buildStepIndicator(bool isDark, int current, int total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: List.generate(total, (i) {
          final step = i + 1;
          final isActive = step == current;
          final isComplete = step < current;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 3,
                          decoration: BoxDecoration(
                            color: isComplete || isActive
                                ? widget.accentColor
                                : (isDark
                                    ? Colors.white
                                        .withValues(alpha: 0.08)
                                    : const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    _stepLabel(step),
                    style: GoogleFonts.inter(
                      fontSize: 6.sp,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? widget.accentColor
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _stepLabel(int step) {
    switch (step) {
      case 1:
        return 'Personal';
      case 2:
        return 'ID & Contact';
      case 3:
        return 'Documents';
      case 4:
        return 'Review';
      default:
        return '';
    }
  }

  Widget _buildContinueButton(bool isDark) {
    return GestureDetector(
      onTap: _canContinue ? _onContinue : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: _canContinue
              ? const LinearGradient(
                  colors: [Color(0xFF2E8B8B), Color(0xFF1B6B6B)])
              : null,
          color: _canContinue
              ? null
              : (isDark
                  ? const Color(0xFF1E2328)
                  : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _canContinue
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E8B8B)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Review Application',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: _canContinue
                    ? Colors.white
                    : (isDark
                        ? Colors.white24
                        : const Color(0xFF9CA3AF)),
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.arrow_forward_rounded,
              color: _canContinue
                  ? Colors.white
                  : (isDark
                      ? Colors.white24
                      : const Color(0xFF9CA3AF)),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : widget.gradientColors,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents & Deposit',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Open Account · Step 3 of 4',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color:
                            Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          Colors.white.withValues(alpha: 0.08)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
