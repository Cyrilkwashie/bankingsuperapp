part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 3 – Documents & Verification ──
// ══════════════════════════════════════════════════════════════

enum _DocumentCaptureSource { scan, upload }

class _OpenAccountRequirementsScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final String title;
  final String firstName;
  final String lastName;
  final String otherName;
  final String gender;
  final String maritalStatus;
  final String dob;
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
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountRequirementsScreen({
    required this.accountType,
    required this.minDeposit,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.otherName,
    required this.gender,
    required this.maritalStatus,
    required this.dob,
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
  final _picker = ImagePicker();

  // Captured images
  File? _passportPhoto;
  File? _idFrontPhoto;
  File? _idBackPhoto;
  File? _proofOfAddressPhoto;

  CameraDevice _passportCamera = CameraDevice.rear;

  // Signature pad
  final List<List<Offset?>> _signatureStrokes = [];

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
    super.dispose();
  }

  int get _docsCaptured =>
      [_passportPhoto, _idFrontPhoto, _idBackPhoto, _proofOfAddressPhoto]
          .where((f) => f != null)
          .length;
  bool get _signatureDone => _signatureStrokes.isNotEmpty;

  bool get _canContinue =>
      _passportPhoto != null &&
      _idFrontPhoto != null &&
      _idBackPhoto != null;

  // ── Passport — camera only (live photo) ───────────────────

  void _togglePassportCamera() {
    setState(() {
      _passportCamera = _passportCamera == CameraDevice.front
          ? CameraDevice.rear
          : CameraDevice.front;
    });
  }

  Future<void> _capturePassportPhoto() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: _passportCamera,
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
    final source = await showModalBottomSheet<_DocumentCaptureSource>(
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
                      // Scan option
                      _buildSourceTile(
                        icon: Icons.document_scanner_outlined,
                        iconBg: widget.accentColor,
                        title: 'Scan Document',
                        subtitle:
                            'Use your camera to scan the document',
                        isDark: isDark,
                        surfaceDim: surfaceDim,
                        onTap: () =>
                            Navigator.pop(ctx, _DocumentCaptureSource.scan),
                      ),
                      SizedBox(height: 1.2.h),
                      // File upload option
                      _buildSourceTile(
                        icon: Icons.upload_file_rounded,
                        iconBg: const Color(0xFF7C3AED),
                        title: 'Upload from Files',
                        subtitle:
                            'Choose a PDF or image from your device',
                        isDark: isDark,
                        surfaceDim: surfaceDim,
                        onTap: () =>
                            Navigator.pop(ctx, _DocumentCaptureSource.upload),
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

    if (source == _DocumentCaptureSource.upload) {
      await _pickDocumentFromFiles(onCaptured);
      return;
    }

    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
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
      _showError('Could not scan document. Please try again.');
    }
  }

  Future<void> _pickDocumentFromFiles(ValueChanged<File> onCaptured) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'heic', 'pdf'],
        allowMultiple: false,
        withData: false,
      );
      final path = result?.files.single.path;
      if (path != null && mounted) {
        onCaptured(File(path));
      }
    } on MissingPluginException {
      if (!mounted) return;
      _showError(
        'File upload is not ready yet. Stop the app completely, then run it again.',
      );
    } catch (e) {
      if (!mounted) return;
      _showError('Could not open files. Please try again.');
    }
  }

  bool _isPdfFile(File file) => file.path.toLowerCase().endsWith('.pdf');

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
      final missing = <String>[];
      if (_passportPhoto == null) missing.add('customer photo');
      if (_idFrontPhoto == null) missing.add('ID front');
      if (_idBackPhoto == null) missing.add('ID back');
      _showError('Please provide ${missing.join(', ')} to continue.');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountReviewScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: widget.title,
          firstName: widget.firstName,
          lastName: widget.lastName,
          otherName: widget.otherName,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          dob: widget.dob,
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
          hasIdCopy: _idFrontPhoto != null && _idBackPhoto != null,
          hasPassportPhoto: _passportPhoto != null,
          hasProofOfAddress: _proofOfAddressPhoto != null,
          hasSignature: _signatureDone,
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
            _OpenAccountUi.buildAgencyHeader(
              context: context,
              isDark: isDark,
              title: 'Documents & Verification',
              subtitle: 'Open Account · Step 3 of 4',
              gradientColors: widget.gradientColors,
              icon: Icons.description_rounded,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              3,
              accentColor: widget.accentColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OpenAccountUi.buildIntroTip(
                      isDark,
                      'Capture the customer photo and both sides of the ID document to continue. Supporting documents can be scanned or uploaded from files.',
                      accentColor: widget.accentColor,
                    ),
                    SizedBox(height: 1.5.h),

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
                          // Progress pill
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _canContinue
                                  ? const Color(0xFF059669)
                                      .withValues(alpha: 0.1)
                                  : widget.accentColor
                                      .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _canContinue
                                    ? const Color(0xFF059669)
                                        .withValues(alpha: 0.3)
                                    : widget.accentColor
                                        .withValues(alpha: 0.15),
                              ),
                            ),
                            child: Text(
                              _canContinue
                                  ? '✓ Ready'
                                  : '$_docsCaptured docs',
                              style: GoogleFonts.inter(
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w600,
                                color: _canContinue
                                    ? const Color(0xFF059669)
                                    : widget.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // ════════════════════════════════════════
                    // ── SECTION 1: Customer Photograph ───────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.person_rounded,
                      title: 'Customer Photograph',
                      subtitle:
                          'Live photo of the customer — switch camera if needed',
                      badgeText: 'Required',
                      badgeColor: const Color(0xFFDC2626),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),

                    // Compact photo row
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _passportPhoto != null
                              ? const Color(0xFF059669)
                                  .withValues(alpha: 0.5)
                              : borderColor,
                          width: _passportPhoto != null ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 52,
                              height: 52,
                              child: _passportPhoto != null
                                  ? Image.file(
                                      _passportPhoto!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: isDark
                                          ? Colors.white
                                              .withValues(alpha: 0.04)
                                          : const Color(0xFFF3F4F6),
                                      child: Center(
                                        child: Icon(
                                          Icons.person_outline_rounded,
                                          color: isDark
                                              ? Colors.white24
                                              : const Color(0xFFD1D5DB),
                                          size: 24,
                                        ),
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
                                  _passportPhoto != null
                                      ? 'Photo captured'
                                      : 'Take customer photo',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _passportPhoto != null
                                        ? const Color(0xFF059669)
                                        : (isDark
                                            ? Colors.white
                                            : const Color(0xFF111827)),
                                  ),
                                ),
                                SizedBox(height: 0.3.h),
                                Text(
                                  _passportPhoto != null
                                      ? 'Tap camera to retake'
                                      : _passportCamera ==
                                              CameraDevice.rear
                                          ? 'Rear camera · for agent capture'
                                          : 'Front camera · for selfie',
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
                          GestureDetector(
                            onTap: _togglePassportCamera,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: widget.accentColor
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: widget.accentColor
                                      .withValues(alpha: 0.15),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.cameraswitch_rounded,
                                  size: 18,
                                  color: widget.accentColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          GestureDetector(
                            onTap: _capturePassportPhoto,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: _passportPhoto != null
                                    ? const Color(0xFF059669)
                                        .withValues(alpha: 0.1)
                                    : widget.accentColor
                                        .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  _passportPhoto != null
                                      ? Icons.refresh_rounded
                                      : Icons.camera_alt_outlined,
                                  size: 18,
                                  color: _passportPhoto != null
                                      ? const Color(0xFF059669)
                                      : widget.accentColor,
                                ),
                              ),
                            ),
                          ),
                          if (_passportPhoto != null) ...[
                            SizedBox(width: 2.w),
                            GestureDetector(
                              onTap: () => setState(
                                  () => _passportPhoto = null),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626)
                                      .withValues(alpha: 0.08),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5.h),

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
                    SizedBox(height: 2.5.h),

                    // ════════════════════════════════════════
                    // ── SECTION 3: Digital Signature ─────────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.draw_rounded,
                      title: 'Customer Signature',
                      subtitle: 'Customer signs directly on screen',
                      badgeText: 'Optional',
                      badgeColor: const Color(0xFF6B7280),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),
                    _buildSignaturePad(isDark, cardBg, borderColor),
                    SizedBox(height: 2.5.h),

                    // ════════════════════════════════════════
                    // ── SECTION 4: Supporting Documents ──────
                    // ════════════════════════════════════════
                    _buildSectionHeader(
                      icon: Icons.folder_open_rounded,
                      title: 'Supporting Documents',
                      subtitle: 'Scan or upload from files',
                      badgeText: 'Optional',
                      badgeColor: const Color(0xFF6B7280),
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.5.h),

                    _buildDocCard(
                      title: 'Proof of Address',
                      subtitle: 'Utility bill, bank statement, or tenancy agreement',
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
                    SizedBox(height: 1.5.h),
                  ],
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: 'Review Application',
                onTap: _canContinue ? _onContinue : null,
                accentColor: widget.accentColor,
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
                          if (_isPdfFile(file))
                            Container(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : const Color(0xFFF3F4F6),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: const Color(0xFFDC2626),
                                      size: 28,
                                    ),
                                    SizedBox(height: 0.4.h),
                                    Text(
                                      'PDF uploaded',
                                      style: GoogleFonts.inter(
                                        fontSize: 7.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white54
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
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
                                Icons.document_scanner_outlined,
                                color: isDark
                                    ? Colors.white24
                                    : const Color(0xFFD1D5DB),
                                size: 22,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Scan / Upload',
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

  // ── Signature — full-screen signing flow ─────────────────

  Future<void> _openSignatureScreen() async {
    final result = await Navigator.of(context).push<List<List<Offset?>>>(
      MaterialPageRoute(
        builder: (_) => _OpenAccountSignatureScreen(
          initialStrokes: _signatureStrokes
              .map((stroke) => List<Offset?>.from(stroke))
              .toList(),
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _signatureStrokes
        ..clear()
        ..addAll(result.map((stroke) => List<Offset?>.from(stroke)));
    });
  }

  Widget _buildSignaturePad(bool isDark, Color cardBg, Color borderColor) {
    final hasSig = _signatureStrokes.isNotEmpty;
    return GestureDetector(
      onTap: _openSignatureScreen,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasSig
                ? const Color(0xFF059669).withValues(alpha: 0.4)
                : borderColor,
            width: hasSig ? 1.5 : 1,
          ),
        ),
        child: hasSig
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mini preview of the saved signature
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 10.h,
                      width: double.infinity,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.03)
                          : const Color(0xFFFAFAFA),
                      child: CustomPaint(
                        willChange: true,
                        painter: OpenAccountSignaturePainter(
                          strokes: _signatureStrokes,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.85)
                              : const Color(0xFF1B365D),
                          fitToBounds: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 15, color: Color(0xFF059669)),
                      SizedBox(width: 1.5.w),
                      Expanded(
                        child: Text(
                          'Signature saved — tap to redo',
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _signatureStrokes.clear();
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.5.w, vertical: 0.4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626)
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFDC2626)
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.delete_outline_rounded,
                                  size: 13, color: Color(0xFFDC2626)),
                              SizedBox(width: 1.w),
                              Text(
                                'Clear',
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(Icons.draw_rounded,
                          color: widget.accentColor, size: 22),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tap to Sign',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          'Opens a dedicated signing screen',
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
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          size: 15, color: widget.accentColor),
                    ),
                  ),
                ],
              ),
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
}
