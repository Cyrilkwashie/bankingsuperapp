part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 9 – Declaration & Terms ──
// ══════════════════════════════════════════════════════════════

class _DeclarationDocument {
  final String title;
  final IconData icon;
  final String body;

  const _DeclarationDocument({
    required this.title,
    required this.icon,
    required this.body,
  });

  List<String> get paragraphs {
    if (body.trim().isEmpty) return const [];

    return body
        .split(RegExp(r'\.\s+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .map((part) => part.endsWith('.') ? part : '$part.')
        .toList();
  }
}

class _OpenAccountDeclarationScreen extends StatefulWidget {
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
  final File? verificationPhoto;
  final File? mandateSignatureUpload;
  final List<List<Offset?>> mandateSignatureStrokes;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountDeclarationScreen({
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
    this.verificationPhoto,
    this.mandateSignatureUpload,
    this.mandateSignatureStrokes = const [],
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountDeclarationScreen> createState() =>
      _OpenAccountDeclarationScreenState();
}

class _OpenAccountDeclarationScreenState
    extends State<_OpenAccountDeclarationScreen>
    with SingleTickerProviderStateMixin {
  bool _agreedToTerms = false;
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  static const _documents = [
    _DeclarationDocument(
      title: 'Declaration and Undertaking',
      icon: Icons.description_outlined,
      body:
          'I/We declare that all information provided in this account opening '
          'application is true, complete, and accurate to the best of my/our '
          'knowledge. I/We undertake to notify the Bank immediately of any '
          'changes to the information supplied and accept that the Bank may '
          'verify any details provided before or after account activation.',
    ),
    _DeclarationDocument(
      title: 'Customer Declaration',
      icon: Icons.person_pin_outlined,
      body:
          'I/We confirm that I/we am/are the beneficial owner(s) of this '
          'account and that the account will not be used for money laundering, '
          'terrorist financing, fraud, or any unlawful activity. I/We authorize '
          'the Bank to process my/our personal data for account administration, '
          'regulatory reporting, and customer service purposes.',
    ),
    _DeclarationDocument(
      title: 'Disclosure for Dormant Account',
      icon: Icons.hourglass_empty_rounded,
      body:
          'I/We acknowledge that if no customer-initiated transaction occurs on '
          'this account for a continuous period as defined by the Bank and '
          'regulators, the account may be classified as dormant. Dormant accounts '
          'may be subject to restricted operations, periodic review, and applicable '
          'maintenance or reactivation requirements.',
    ),
    _DeclarationDocument(
      title: 'Disclosure for Credit Bureaus',
      icon: Icons.account_balance_outlined,
      body:
          'I/We consent to the Bank obtaining credit and identity information '
          'about me/us from licensed credit bureaus and other authorized sources '
          'for account opening, credit assessment, and ongoing relationship '
          'management. I/We understand this information may be shared with credit '
          'reference bureaus in accordance with applicable law.',
    ),
    _DeclarationDocument(
      title: 'Dud Cheques',
      icon: Icons.money_off_csred_outlined,
      body:
          'I/We understand that issuing a cheque without sufficient funds is an '
          'offence and may result in penalties, reporting to the Bank of Ghana, '
          'restriction of cheque book facilities, and legal action. I/We agree to '
          'maintain adequate balances before issuing cheques and to comply with all '
          'applicable dishonoured cheque regulations.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool get _canContinue => _agreedToTerms;

  void _openDocument(_DeclarationDocument document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _DeclarationDocumentPage(
          document: document,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors.isNotEmpty
              ? widget.gradientColors
              : _OpenAccountUi.gradient,
        ),
      ),
    );
  }

  void _pushReviewScreen() {
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
          hasSignature: widget.hasSignature,
          mandateSignatoryName: widget.mandateSignatoryName,
          mandateAuthorization: widget.mandateAuthorization,
          mandateSignatureMethod: widget.mandateSignatureMethod,
          declarationsAccepted: true,
          verificationPhoto: widget.verificationPhoto,
          mandateSignatureUpload: widget.mandateSignatureUpload,
          mandateSignatureStrokes: widget.mandateSignatureStrokes,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  void _onContinue() {
    if (!_canContinue) return;
    _pushReviewScreen();
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 9,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step <= 9) return;
    _pushReviewScreen();
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
              title: 'Declaration & Terms',
              subtitle:
                  'Open Account · Step 9 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.gavel_rounded,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              9,
              accentColor: widget.accentColor,
              onStepTap: _handleWizardStepTap,
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
                      'Review each declaration below, then confirm your agreement to continue.',
                      accentColor: widget.accentColor,
                    ),
                    SizedBox(height: 1.5.h),
                    ..._documents.map(
                      (doc) => Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: _buildDocumentTile(isDark, doc),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    GestureDetector(
                      onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(
                          color: _agreedToTerms
                              ? widget.accentColor
                                  .withValues(alpha: isDark ? 0.12 : 0.08)
                              : (isDark
                                  ? const Color(0xFF161B22)
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _agreedToTerms
                                ? widget.accentColor.withValues(alpha: 0.4)
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : const Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: _agreedToTerms,
                                onChanged: (v) =>
                                    setState(() => _agreedToTerms = v ?? false),
                                activeColor: widget.accentColor,
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFFCBD5E1),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            SizedBox(width: 2.5.w),
                            Expanded(
                              child: Text(
                                'I agree to all declarations, disclosures, and terms listed above.',
                                style: GoogleFonts.inter(
                                  fontSize: 8.5.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: 'Continue to Review',
                onTap: _canContinue ? _onContinue : null,
                accentColor: widget.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile(bool isDark, _DeclarationDocument doc) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDocument(doc),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B22) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.4.h),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.accentColor
                        .withValues(alpha: isDark ? 0.14 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(doc.icon, size: 18, color: widget.accentColor),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    doc.title,
                    style: GoogleFonts.inter(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeclarationDocumentPage extends StatelessWidget {
  final _DeclarationDocument document;
  final Color accentColor;
  final List<Color> gradientColors;

  const _DeclarationDocumentPage({
    required this.document,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paragraphs = document.paragraphs;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _OpenAccountUi.buildAgencyHeader(
            context: context,
            isDark: isDark,
            title: 'Legal Document',
            subtitle: document.title,
            gradientColors: gradientColors,
            icon: document.icon,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withValues(alpha: isDark ? 0.18 : 0.12),
                          accentColor.withValues(alpha: isDark ? 0.08 : 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(document.icon, color: accentColor, size: 22),
                        ),
                        SizedBox(width: 3.5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.title,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: 0.4.h),
                              Text(
                                'Please read carefully before agreeing',
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.5.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFE5E7EB),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.12 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Content',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(height: 1.2.h),
                        if (paragraphs.isEmpty)
                          Text(
                            document.body,
                            style: GoogleFonts.inter(
                              fontSize: 9.5.sp,
                              height: 1.6,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF374151),
                            ),
                          )
                        else
                          ...paragraphs.map(
                            (paragraph) => Padding(
                              padding: EdgeInsets.only(bottom: 1.2.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 0.5.h),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color:
                                          accentColor.withValues(alpha: 0.7),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      paragraph,
                                      style: GoogleFonts.inter(
                                        fontSize: 9.5.sp,
                                        height: 1.6,
                                        color: isDark
                                            ? Colors.white70
                                            : const Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF161B22)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: accentColor,
                        ),
                        SizedBox(width: 2.5.w),
                        Expanded(
                          child: Text(
                            'This document forms part of your account opening agreement. Return to the previous screen and check "I agree" to continue.',
                            style: GoogleFonts.inter(
                              fontSize: 8.sp,
                              height: 1.45,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
