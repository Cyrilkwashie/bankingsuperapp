part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 8 – Account Mandate ──
// ══════════════════════════════════════════════════════════════

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
  final String educationalLevel;
  final String disabilityStatus;
  final String idType;
  final String idNumber;
  final String issueDate;
  final String expiryDate;
  final String phone;
  final String altPhone;
  final String email;
  final String streetName;
  final String houseAddress;
  final String digitalAddress;
  final String poBox;
  final String city;
  final String region;
  final String metroMunicipal;
  final String proofOfAddressType;
  final File? proofOfAddressPhoto;
  final File? verificationPhoto;
  final String emergencyTitle;
  final String emergencySurname;
  final String emergencyOtherNames;
  final String emergencyGender;
  final String emergencyRelationship;
  final String emergencyResidentialAddress;
  final String emergencyPhone;
  final String employmentStatus;
  final String employmentCategory;
  final String employmentEmployerName;
  final String employmentJobTitle;
  final String employmentStartDate;
  final String employmentCountry;
  final String employmentRegion;
  final String employmentDistrict;
  final String employmentCityTown;
  final String employmentEmployerAddress;
  final String employmentMonthlyIncome;
  final String employmentOfficePhone;
  final String employmentEmployerEmail;
  final bool hasIdCopy;
  final bool hasPassportPhoto;
  final bool hasProofOfAddress;
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
    required this.educationalLevel,
    required this.disabilityStatus,
    required this.idType,
    required this.idNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.streetName,
    required this.houseAddress,
    required this.digitalAddress,
    required this.poBox,
    required this.city,
    required this.region,
    required this.metroMunicipal,
    required this.proofOfAddressType,
    required this.proofOfAddressPhoto,
    required this.verificationPhoto,
    required this.emergencyTitle,
    required this.emergencySurname,
    required this.emergencyOtherNames,
    required this.emergencyGender,
    required this.emergencyRelationship,
    required this.emergencyResidentialAddress,
    required this.emergencyPhone,
    required this.employmentStatus,
    required this.employmentCategory,
    required this.employmentEmployerName,
    required this.employmentJobTitle,
    required this.employmentStartDate,
    required this.employmentCountry,
    required this.employmentRegion,
    required this.employmentDistrict,
    required this.employmentCityTown,
    required this.employmentEmployerAddress,
    required this.employmentMonthlyIncome,
    required this.employmentOfficePhone,
    required this.employmentEmployerEmail,
    required this.hasIdCopy,
    required this.hasPassportPhoto,
    required this.hasProofOfAddress,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountRequirementsScreen> createState() =>
      _OpenAccountRequirementsScreenState();
}

class _OpenAccountRequirementsScreenState
    extends State<_OpenAccountRequirementsScreen>
    with TickerProviderStateMixin {
  final _signatoryNameCtrl = TextEditingController();
  final _picker = ImagePicker();
  final List<List<Offset?>> _signatureStrokes = [];
  List<Offset?> _currentStroke = [];

  String _selectedMandateAuthorization = '';
  File? _uploadedSignature;
  int _signatureTabIndex = 0;
  late TabController _signatureTabCtrl;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  static const _defaultMandateAuthorization = 'Sole Signatory';

  String get _defaultSignatoryName {
    final parts = [
      widget.firstName.trim(),
      widget.otherName.trim(),
      widget.lastName.trim(),
    ].where((part) => part.isNotEmpty);
    return parts.join(' ');
  }

  bool get _hasLiveSignature => _signatureStrokes.any(
        (stroke) => stroke.any((point) => point != null),
      );

  bool get _hasUploadedSignature => _uploadedSignature != null;

  bool get _hasSignature =>
      _signatureTabIndex == 0 ? _hasLiveSignature : _hasUploadedSignature;

  String get _signatureMethod =>
      _signatureTabIndex == 0 ? 'Live Signature' : 'Uploaded Signature';

  bool get _canContinue => _hasSignature;

  @override
  void initState() {
    super.initState();
    _signatoryNameCtrl.text = _defaultSignatoryName;
    _selectedMandateAuthorization = _defaultMandateAuthorization;
    _signatureTabCtrl = TabController(length: 2, vsync: this);
    _signatureTabCtrl.addListener(() {
      if (_signatureTabCtrl.indexIsChanging) return;
      setState(() => _signatureTabIndex = _signatureTabCtrl.index);
    });
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeIn =
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _signatoryNameCtrl.dispose();
    _signatureTabCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _clearLiveSignature() {
    setState(() {
      _signatureStrokes.clear();
      _currentStroke = [];
    });
  }

  void _clearUploadedSignature() {
    setState(() => _uploadedSignature = null);
  }

  void _clearCurrentSignature() {
    if (_signatureTabIndex == 0) {
      _clearLiveSignature();
    } else {
      _clearUploadedSignature();
    }
  }

  Future<void> _pickSignatureFromGallery() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (xFile != null && mounted) {
        setState(() => _uploadedSignature = File(xFile.path));
      }
    } catch (_) {
      if (!mounted) return;
      _showError('Could not open gallery.');
    }
  }

  Future<void> _pickSignatureFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null && mounted) {
        setState(
          () => _uploadedSignature = File(result.files.single.path!),
        );
      }
    } catch (_) {
      if (!mounted) return;
      _showError('Could not open file picker.');
    }
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

  void _pushDeclarationScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountDeclarationScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: widget.title,
          firstName: widget.firstName,
          lastName: widget.lastName,
          otherName: widget.otherName,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          dob: widget.dob,
          educationalLevel: widget.educationalLevel,
          disabilityStatus: widget.disabilityStatus,
          idType: widget.idType,
          idNumber: widget.idNumber,
          issueDate: widget.issueDate,
          expiryDate: widget.expiryDate,
          phone: widget.phone,
          altPhone: widget.altPhone,
          email: widget.email,
          streetName: widget.streetName,
          houseAddress: widget.houseAddress,
          digitalAddress: widget.digitalAddress,
          poBox: widget.poBox,
          city: widget.city,
          region: widget.region,
          metroMunicipal: widget.metroMunicipal,
          proofOfAddressType: widget.proofOfAddressType,
          emergencyTitle: widget.emergencyTitle,
          emergencySurname: widget.emergencySurname,
          emergencyOtherNames: widget.emergencyOtherNames,
          emergencyGender: widget.emergencyGender,
          emergencyRelationship: widget.emergencyRelationship,
          emergencyResidentialAddress: widget.emergencyResidentialAddress,
          emergencyPhone: widget.emergencyPhone,
          employmentStatus: widget.employmentStatus,
          employmentCategory: widget.employmentCategory,
          employmentEmployerName: widget.employmentEmployerName,
          employmentJobTitle: widget.employmentJobTitle,
          employmentStartDate: widget.employmentStartDate,
          employmentCountry: widget.employmentCountry,
          employmentRegion: widget.employmentRegion,
          employmentDistrict: widget.employmentDistrict,
          employmentCityTown: widget.employmentCityTown,
          employmentEmployerAddress: widget.employmentEmployerAddress,
          employmentMonthlyIncome: widget.employmentMonthlyIncome,
          employmentOfficePhone: widget.employmentOfficePhone,
          employmentEmployerEmail: widget.employmentEmployerEmail,
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
          hasSignature: _hasSignature,
          mandateSignatoryName: _signatoryNameCtrl.text.trim(),
          mandateAuthorization: _selectedMandateAuthorization,
          mandateSignatureMethod: _signatureMethod,
          verificationPhoto: widget.verificationPhoto,
          mandateSignatureUpload:
              _hasUploadedSignature ? _uploadedSignature : null,
          mandateSignatureStrokes: _hasLiveSignature
              ? _signatureStrokes
                  .map((stroke) => List<Offset?>.from(stroke))
                  .toList()
              : const [],
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  void _onContinue() {
    if (!_canContinue) {
      _showError('Please capture a signature to continue.');
      return;
    }
    _pushDeclarationScreen();
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 8,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step <= 8) return;
    _pushDeclarationScreen();
    if (!mounted || step <= 9) return;

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
          educationalLevel: widget.educationalLevel,
          disabilityStatus: widget.disabilityStatus,
          idType: widget.idType,
          idNumber: widget.idNumber,
          issueDate: widget.issueDate,
          expiryDate: widget.expiryDate,
          phone: widget.phone,
          altPhone: widget.altPhone,
          email: widget.email,
          streetName: widget.streetName,
          houseAddress: widget.houseAddress,
          digitalAddress: widget.digitalAddress,
          poBox: widget.poBox,
          city: widget.city,
          region: widget.region,
          metroMunicipal: widget.metroMunicipal,
          proofOfAddressType: widget.proofOfAddressType,
          emergencyTitle: widget.emergencyTitle,
          emergencySurname: widget.emergencySurname,
          emergencyOtherNames: widget.emergencyOtherNames,
          emergencyGender: widget.emergencyGender,
          emergencyRelationship: widget.emergencyRelationship,
          emergencyResidentialAddress: widget.emergencyResidentialAddress,
          emergencyPhone: widget.emergencyPhone,
          employmentStatus: widget.employmentStatus,
          employmentCategory: widget.employmentCategory,
          employmentEmployerName: widget.employmentEmployerName,
          employmentJobTitle: widget.employmentJobTitle,
          employmentStartDate: widget.employmentStartDate,
          employmentCountry: widget.employmentCountry,
          employmentRegion: widget.employmentRegion,
          employmentDistrict: widget.employmentDistrict,
          employmentCityTown: widget.employmentCityTown,
          employmentEmployerAddress: widget.employmentEmployerAddress,
          employmentMonthlyIncome: widget.employmentMonthlyIncome,
          employmentOfficePhone: widget.employmentOfficePhone,
          employmentEmployerEmail: widget.employmentEmployerEmail,
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
          hasSignature: _hasSignature,
          mandateSignatoryName: _signatoryNameCtrl.text.trim(),
          mandateAuthorization: _selectedMandateAuthorization,
          mandateSignatureMethod: _signatureMethod,
          declarationsAccepted: false,
          verificationPhoto: widget.verificationPhoto,
          mandateSignatureUpload:
              _hasUploadedSignature ? _uploadedSignature : null,
          mandateSignatureStrokes: _hasLiveSignature
              ? _signatureStrokes
                  .map((stroke) => List<Offset?>.from(stroke))
                  .toList()
              : const [],
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canvasBg = isDark ? const Color(0xFF161B22) : Colors.white;
    final linePaint = isDark
        ? Colors.white.withValues(alpha: 0.85)
        : const Color(0xFF1B365D);

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
              title: 'Account Mandate',
              subtitle:
                  'Open Account · Step 8 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.assignment_ind_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              8,
              accentColor: widget.accentColor,
              onStepTap: _handleWizardStepTap,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        physics: _signatureTabIndex == 0
                            ? const NeverScrollableScrollPhysics()
                            : const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OpenAccountUi.buildIntroTip(
                              isDark,
                              'Set up the account signing mandate and capture the customer signature.',
                              accentColor: widget.accentColor,
                            ),
                            SizedBox(height: 1.2.h),
                            _OpenAccountUi.buildReadOnlyField(
                              label: 'Signatory Name',
                              value: _signatoryNameCtrl.text,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              icon: Icons.person_outline_rounded,
                              helperText: 'Pre-filled from customer details',
                            ),
                            SizedBox(height: 1.2.h),
                            _OpenAccountUi.buildReadOnlyField(
                              label: 'Mandate Authorization',
                              value: _selectedMandateAuthorization,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              icon: Icons.verified_user_outlined,
                              helperText: 'Assigned based on account type',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          'Signature *',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                        const Spacer(),
                        if (_hasSignature)
                          GestureDetector(
                            onTap: _clearCurrentSignature,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w,
                                vertical: 0.45.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626)
                                    .withValues(alpha: isDark ? 0.12 : 0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFDC2626)
                                      .withValues(alpha: 0.18),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.refresh_rounded,
                                    size: 13,
                                    color: Color(0xFFDC2626),
                                  ),
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
                    SizedBox(height: 0.6.h),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF161B22)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: TabBar(
                        controller: _signatureTabCtrl,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: widget.accentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: 'Sign Live'),
                          Tab(text: 'Upload'),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    Expanded(
                      child: _signatureTabIndex == 0
                          ? _buildLiveSignaturePad(
                              isDark: isDark,
                              canvasBg: canvasBg,
                              linePaint: linePaint,
                            )
                          : _buildUploadSignaturePanel(isDark),
                    ),
                  ],
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: _canContinue ? 'Continue' : 'Sign to continue',
                onTap: _canContinue ? _onContinue : null,
                accentColor: widget.accentColor,
                icon: _canContinue ? Icons.check_rounded : Icons.draw_rounded,
                showArrow: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveSignaturePad({
    required bool isDark,
    required Color canvasBg,
    required Color linePaint,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: canvasBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasLiveSignature
              ? const Color(0xFF059669).withValues(alpha: 0.35)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB)),
          width: _hasLiveSignature ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                willChange: true,
                painter: OpenAccountSignaturePainter(
                  strokes: _signatureStrokes,
                  color: linePaint,
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: 16,
              right: 16,
              child: IgnorePointer(
                child: Container(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : const Color(0xFFE5E7EB),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 16,
              child: IgnorePointer(
                child: Text(
                  'Sign above this line',
                  style: GoogleFonts.inter(
                    fontSize: 6.5.sp,
                    color: isDark ? Colors.white12 : const Color(0xFFD1D5DB),
                  ),
                ),
              ),
            ),
            if (!_hasLiveSignature)
              IgnorePointer(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gesture_rounded,
                        size: 36,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFFE5E7EB),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Draw signature here',
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          color: isDark ? Colors.white12 : const Color(0xFFD1D5DB),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (_) {},
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (d) => setState(() {
                    _currentStroke = [d.localPosition];
                    _signatureStrokes.add(_currentStroke);
                  }),
                  onPanUpdate: (d) => setState(() {
                    _currentStroke.add(d.localPosition);
                  }),
                  onPanEnd: (_) => setState(() => _currentStroke = []),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSignaturePanel(bool isDark) {
    final isPdf = _uploadedSignature?.path.toLowerCase().endsWith('.pdf') ??
        false;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasUploadedSignature
              ? const Color(0xFF059669).withValues(alpha: 0.35)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB)),
          width: _hasUploadedSignature ? 1.5 : 1,
        ),
      ),
      child: _hasUploadedSignature
          ? Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: isPdf
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 48,
                                  color: widget.accentColor,
                                ),
                                SizedBox(height: 1.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.w),
                                  child: Text(
                                    _uploadedSignature!.path.split('/').last,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            _uploadedSignature!,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669)
                          .withValues(alpha: isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Uploaded',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file_outlined,
                      size: 40,
                      color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                    ),
                    SizedBox(height: 1.2.h),
                    Text(
                      'Upload a scanned signature image or PDF',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        color: isDark ? Colors.white38 : const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUploadAction(
                            isDark: isDark,
                            icon: Icons.photo_library_outlined,
                            label: 'Gallery',
                            onTap: _pickSignatureFromGallery,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildUploadAction(
                            isDark: isDark,
                            icon: Icons.folder_open_outlined,
                            label: 'Browse Files',
                            onTap: _pickSignatureFile,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUploadAction({
    required bool isDark,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        decoration: BoxDecoration(
          color: widget.accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: widget.accentColor, size: 22),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: widget.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
