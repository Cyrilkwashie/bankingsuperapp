part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 10 – Review & Confirm ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountReviewScreen extends StatefulWidget {
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
  final bool hasSignature;
  final String mandateSignatoryName;
  final String mandateAuthorization;
  final String mandateSignatureMethod;
  final bool declarationsAccepted;
  final File? verificationPhoto;
  final File? mandateSignatureUpload;
  final List<List<Offset?>> mandateSignatureStrokes;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountReviewScreen({
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
    required this.hasSignature,
    required this.mandateSignatoryName,
    required this.mandateAuthorization,
    required this.mandateSignatureMethod,
    required this.declarationsAccepted,
    this.verificationPhoto,
    this.mandateSignatureUpload,
    this.mandateSignatureStrokes = const [],
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountReviewScreen> createState() =>
      _OpenAccountReviewScreenState();
}

class _OpenAccountReviewScreenState
    extends State<_OpenAccountReviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeIn =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String get _fullName => [
        if (widget.title.isNotEmpty) widget.title,
        widget.firstName,
        if (widget.otherName.isNotEmpty) widget.otherName,
        widget.lastName,
      ].join(' ');

  String _docStatus(bool provided) =>
      provided ? '✓ Provided' : '— Not provided';

  void _onSubmit() {
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: widget.accentColor,
      title: 'Authorize Account Opening',
      subtitle:
          'Enter your PIN to open a ${widget.accountType} account for $_fullName',
      onAuthenticated: () {
        setState(() => _isSubmitting = true);

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() => _isSubmitting = false);

          final random = Random();
          final accountNum =
              '${1000 + random.nextInt(9000)}${1000 + random.nextInt(9000)}${10 + random.nextInt(90)}';
          final refNum =
              'OA${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => _OpenAccountSuccessScreen(
                accountType: widget.accountType,
                fullName: _fullName,
                accountNumber: accountNum,
                referenceNumber: refNum,
                phone: widget.phone,
                accentColor: widget.accentColor,
                gradientColors: widget.gradientColors,
              ),
            ),
          );
        });
      },
    );
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 10,
      targetStep: targetStep,
      onForwardStep: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              title: 'Review & Confirm',
              subtitle:
                  'Open Account · Step 10 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.fact_check_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              10,
              accentColor: widget.accentColor,
              onStepTap: _handleWizardStepTap,
            ),
            Expanded(
              child: _isSubmitting
                  ? _buildLoadingState(isDark)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCustomerVerificationPanel(isDark),
                          SizedBox(height: 1.5.h),
                          _OpenAccountUi.buildHeroBanner(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            icon: Icons.account_balance_rounded,
                            label: 'Account Type',
                            headline: widget.accountType,
                            subtitle: 'Min. deposit ${widget.minDeposit}',
                          ),
                          SizedBox(height: 1.5.h),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Personal Details',
                            icon: Icons.person_outline_rounded,
                            rows: [
                              _OpenAccountSummaryRow('Full Name', _fullName),
                              _OpenAccountSummaryRow(
                                  'Date of Birth', widget.dob),
                              _OpenAccountSummaryRow('Gender', widget.gender),
                              _OpenAccountSummaryRow(
                                  'Marital Status', widget.maritalStatus),
                              _OpenAccountSummaryRow('Educational Level',
                                  widget.educationalLevel),
                              _OpenAccountSummaryRow('Disability Status',
                                  widget.disabilityStatus),
                            ],
                          ),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Identity & Contact',
                            icon: Icons.badge_outlined,
                            rows: [
                              _OpenAccountSummaryRow(
                                  'National ID Type', widget.idType),
                              _OpenAccountSummaryRow('National ID Number',
                                  widget.idNumber,
                                  mono: true),
                              if (widget.issueDate.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Issue Date', widget.issueDate),
                              if (widget.expiryDate.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Expiry Date', widget.expiryDate),
                              _OpenAccountSummaryRow('Phone', widget.phone),
                              if (widget.altPhone.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Alt Phone', widget.altPhone),
                              _OpenAccountSummaryRow('Email', widget.email),
                            ],
                          ),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Residential Address',
                            icon: Icons.home_outlined,
                            rows: [
                              _OpenAccountSummaryRow(
                                  'Street Name', widget.streetName),
                              _OpenAccountSummaryRow(
                                  'House / Building', widget.houseAddress),
                              _OpenAccountSummaryRow(
                                  'Digital Address', widget.digitalAddress),
                              if (widget.poBox.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'P.O. Box', widget.poBox),
                              _OpenAccountSummaryRow('City', widget.city),
                              _OpenAccountSummaryRow('Region', widget.region),
                              _OpenAccountSummaryRow('Metro / Municipal',
                                  widget.metroMunicipal),
                              _OpenAccountSummaryRow('Proof of Address',
                                  widget.proofOfAddressType),
                            ],
                          ),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Emergency Contact',
                            icon: Icons.contact_emergency_outlined,
                            rows: [
                              _OpenAccountSummaryRow(
                                  'Title', widget.emergencyTitle),
                              _OpenAccountSummaryRow(
                                  'Surname', widget.emergencySurname),
                              if (widget.emergencyOtherNames.isNotEmpty)
                                _OpenAccountSummaryRow('Other Names',
                                    widget.emergencyOtherNames),
                              _OpenAccountSummaryRow(
                                  'Gender', widget.emergencyGender),
                              _OpenAccountSummaryRow('Relationship',
                                  widget.emergencyRelationship),
                              _OpenAccountSummaryRow('Address',
                                  widget.emergencyResidentialAddress),
                              _OpenAccountSummaryRow(
                                  'Phone', widget.emergencyPhone),
                            ],
                          ),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Employment',
                            icon: Icons.work_outline_rounded,
                            rows: [
                              _OpenAccountSummaryRow('Status',
                                  widget.employmentStatus),
                              _OpenAccountSummaryRow('Category',
                                  widget.employmentCategory),
                              if (widget.employmentEmployerName.isNotEmpty)
                                _OpenAccountSummaryRow('Employer / Business',
                                    widget.employmentEmployerName),
                              if (widget.employmentJobTitle.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Job Title', widget.employmentJobTitle),
                              if (widget.employmentStartDate.isNotEmpty)
                                _OpenAccountSummaryRow('Start Date',
                                    widget.employmentStartDate),
                              if (widget.employmentCountry.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Country', widget.employmentCountry),
                              if (widget.employmentRegion.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Region', widget.employmentRegion),
                              if (widget.employmentDistrict.isNotEmpty)
                                _OpenAccountSummaryRow('District (MMDA)',
                                    widget.employmentDistrict),
                              if (widget.employmentCityTown.isNotEmpty)
                                _OpenAccountSummaryRow('City / Town',
                                    widget.employmentCityTown),
                              if (widget.employmentEmployerAddress.isNotEmpty)
                                _OpenAccountSummaryRow('Employer Address',
                                    widget.employmentEmployerAddress),
                              _OpenAccountSummaryRow('Monthly Salary',
                                  widget.employmentMonthlyIncome),
                              if (widget.employmentOfficePhone.isNotEmpty)
                                _OpenAccountSummaryRow('Office Phone',
                                    widget.employmentOfficePhone),
                              if (widget.employmentEmployerEmail.isNotEmpty)
                                _OpenAccountSummaryRow('Employer Email',
                                    widget.employmentEmployerEmail),
                            ],
                          ),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Account Mandate',
                            icon: Icons.assignment_ind_outlined,
                            rows: [
                              _OpenAccountSummaryRow('Signatory Name',
                                  widget.mandateSignatoryName),
                              _OpenAccountSummaryRow('Authorization',
                                  widget.mandateAuthorization),
                              _OpenAccountSummaryRow(
                                'Signature',
                                widget.hasSignature
                                    ? widget.mandateSignatureMethod
                                    : 'Not captured',
                                valueColor: widget.hasSignature
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                            ],
                          ),
                          _OpenAccountUi.buildReviewSectionCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Declarations & Documents',
                            icon: Icons.folder_open_outlined,
                            rows: [
                              _OpenAccountSummaryRow(
                                'Terms & Declarations',
                                widget.declarationsAccepted
                                    ? 'Accepted'
                                    : 'Not accepted',
                                valueColor: widget.declarationsAccepted
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                              _OpenAccountSummaryRow(
                                'Proof of Address',
                                _docStatus(widget.hasProofOfAddress),
                                valueColor: widget.hasProofOfAddress
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                            ],
                          ),
                          _OpenAccountUi.buildSecurityNote(
                            isDark,
                            'You will be asked to authorize this account opening with your transaction PIN.',
                          ),
                        ],
                      ),
                    ),
            ),
            if (!_isSubmitting)
              _OpenAccountUi.buildStickyActionBar(
                isDark: isDark,
                child: Column(
                  children: [
                    _OpenAccountUi.buildPrimaryButton(
                      isDark: isDark,
                      label: 'Submit & Open Account',
                      onTap: _onSubmit,
                      accentColor: widget.accentColor,
                      icon: Icons.lock_outline_rounded,
                      showArrow: false,
                    ),
                    SizedBox(height: 0.8.h),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.6.h),
                        child: Text(
                          'Go Back & Edit',
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

  Widget _buildCustomerVerificationPanel(bool isDark) {
    final linePaint = isDark
        ? Colors.white.withValues(alpha: 0.85)
        : const Color(0xFF1B365D);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 1.6.h, 4.5.w, 1.2.h),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: widget.accentColor,
                    size: 18,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Verification',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 0.2.h),
                      Text(
                        _fullName,
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 0, 4.5.w, 2.h),
            child: Row(
              children: [
                Expanded(
                  child: _buildVerificationTile(
                    isDark: isDark,
                    label: 'Identity Photo',
                    caption: widget.hasPassportPhoto ? 'Captured' : 'Not provided',
                    isProvided: widget.hasPassportPhoto,
                    child: widget.verificationPhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.verificationPhoto!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : _buildVerificationPlaceholder(
                            isDark: isDark,
                            icon: Icons.face_retouching_natural_outlined,
                            text: 'No photo',
                          ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildVerificationTile(
                    isDark: isDark,
                    label: 'Signature',
                    caption: widget.hasSignature
                        ? widget.mandateSignatureMethod
                        : 'Not captured',
                    isProvided: widget.hasSignature,
                    child: widget.mandateSignatureUpload != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.mandateSignatureUpload!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : widget.mandateSignatureStrokes.isNotEmpty
                            ? ColoredBox(
                                color: isDark
                                    ? const Color(0xFF0D1117)
                                    : const Color(0xFFF8FAFC),
                                child: SizedBox.expand(
                                  child: CustomPaint(
                                    painter: OpenAccountSignaturePainter(
                                      strokes: widget.mandateSignatureStrokes,
                                      color: linePaint,
                                      fitToBounds: true,
                                    ),
                                  ),
                                ),
                              )
                            : _buildVerificationPlaceholder(
                                isDark: isDark,
                                icon: Icons.draw_outlined,
                                text: 'No signature',
                              ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationTile({
    required bool isDark,
    required String label,
    required String caption,
    required bool isProvided,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.25.h),
              decoration: BoxDecoration(
                color: isProvided
                    ? _OpenAccountUi.success.withValues(alpha: 0.12)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isProvided ? '✓' : '—',
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: isProvided
                      ? _OpenAccountUi.success
                      : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Container(
          height: 18.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isProvided
                  ? widget.accentColor.withValues(alpha: 0.35)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE5E7EB)),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: child,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          caption,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationPlaceholder({
    required bool isDark,
    required IconData icon,
    required String text,
  }) {
    return Container(
      color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
            ),
            SizedBox(height: 0.6.h),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            'Processing Account Opening...',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            'Please wait while we create the account',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
