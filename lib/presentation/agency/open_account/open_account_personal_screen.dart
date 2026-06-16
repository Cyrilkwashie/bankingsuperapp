part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 2 – Personal Details ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountPersonalScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final _GhanaCardProfile ghanaCardProfile;
  final String phone;
  final String email;
  final File? verificationPhoto;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountPersonalScreen({
    required this.accountType,
    required this.minDeposit,
    required this.ghanaCardProfile,
    required this.phone,
    required this.email,
    required this.verificationPhoto,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountPersonalScreen> createState() =>
      _OpenAccountPersonalScreenState();
}

class _OpenAccountPersonalScreenState
    extends State<_OpenAccountPersonalScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _otherNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  String _selectedTitle = '';
  String _selectedGender = '';
  String _selectedMarital = '';
  String _selectedEducation = '';
  String _selectedDisability = '';

  static const _titles = [
    'Mr.',
    'Mrs.',
    'Ms.',
    'Dr.',
    'Prof.',
    'Rev.',
  ];

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  static const _maritalStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];
  static const _educationLevels = [
    'No Formal Education',
    'Primary',
    'JHS / Middle School',
    'SHS / Secondary',
    'Technical / Vocational',
    'Diploma / HND',
    "Bachelor's Degree",
    "Master's Degree",
    'Doctorate / PhD',
    'Other',
  ];
  static const _disabilityStatuses = [
    'No Disability',
    'Physical Disability',
    'Visual Impairment',
    'Hearing Impairment',
    'Speech Impairment',
    'Intellectual Disability',
    'Multiple Disabilities',
    'Prefer Not to Say',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeIn =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    final profile = widget.ghanaCardProfile;
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text = profile.lastName;
    _otherNameCtrl.text = profile.otherName;
    _selectedGender = profile.gender;
    _dobCtrl.text = profile.dobDisplay;
    _selectedTitle = profile.gender == 'Female' ? 'Ms.' : 'Mr.';
  }

  @override
  void dispose() {
    _animController.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _otherNameCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedTitle.isNotEmpty &&
      _selectedMarital.isNotEmpty &&
      _selectedEducation.isNotEmpty &&
      _selectedDisability.isNotEmpty;

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountContactScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: widget.verificationPhoto,
          title: _selectedTitle,
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          otherName: _otherNameCtrl.text.trim(),
          gender: _selectedGender,
          maritalStatus: _selectedMarital,
          dob: _dobCtrl.text,
          educationalLevel: _selectedEducation,
          disabilityStatus: _selectedDisability,
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

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 3,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  Map<String, String> get _personalPayload => {
        'title': _selectedTitle.isNotEmpty
            ? _selectedTitle
            : (widget.ghanaCardProfile.gender == 'Female' ? 'Ms.' : 'Mr.'),
        'firstName': _firstNameCtrl.text.trim(),
        'lastName': _lastNameCtrl.text.trim(),
        'otherName': _otherNameCtrl.text.trim(),
        'gender': _selectedGender,
        'maritalStatus':
            _selectedMarital.isNotEmpty ? _selectedMarital : 'Single',
        'dob': _dobCtrl.text,
        'education': _selectedEducation.isNotEmpty
            ? _selectedEducation
            : 'SHS / Secondary',
        'disability': _selectedDisability.isNotEmpty
            ? _selectedDisability
            : 'No Disability',
      };

  void _openWizardStep(int step) {
    if (step <= 3) return;
    final data = _personalPayload;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountContactScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: widget.verificationPhoto,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
    if (!mounted || step <= 4) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountAddressScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: widget.verificationPhoto,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          altPhone: '',
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
    if (!mounted || step <= 5) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountEmergencyContactScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          phone: widget.phone,
          altPhone: '',
          email: widget.email,
          streetName: widget.ghanaCardProfile.address,
          houseAddress: '',
          digitalAddress: '',
          poBox: '',
          city: widget.ghanaCardProfile.city,
          region: 'Greater Accra',
          metroMunicipal: '',
          proofOfAddressType: 'Utility Bill',
          verificationPhoto: widget.verificationPhoto,
          hasIdCopy: false,
          hasPassportPhoto: widget.verificationPhoto != null,
          hasProofOfAddress: false,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
    if (!mounted || step <= 6) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountEmploymentScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          phone: widget.phone,
          altPhone: '',
          email: widget.email,
          streetName: widget.ghanaCardProfile.address,
          houseAddress: '',
          digitalAddress: '',
          poBox: '',
          city: widget.ghanaCardProfile.city,
          region: 'Greater Accra',
          metroMunicipal: '',
          proofOfAddressType: 'Utility Bill',
          verificationPhoto: widget.verificationPhoto,
          emergencyTitle: '',
          emergencySurname: '',
          emergencyOtherNames: '',
          emergencyGender: '',
          emergencyRelationship: '',
          emergencyResidentialAddress: '',
          emergencyPhone: '',
          hasIdCopy: false,
          hasPassportPhoto: widget.verificationPhoto != null,
          hasProofOfAddress: false,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
    if (!mounted || step <= 7) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountRequirementsScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          phone: widget.phone,
          altPhone: '',
          email: widget.email,
          streetName: widget.ghanaCardProfile.address,
          houseAddress: '',
          digitalAddress: '',
          poBox: '',
          city: widget.ghanaCardProfile.city,
          region: 'Greater Accra',
          metroMunicipal: '',
          proofOfAddressType: 'Utility Bill',
          proofOfAddressPhoto: null,
          verificationPhoto: widget.verificationPhoto,
          emergencyTitle: '',
          emergencySurname: '',
          emergencyOtherNames: '',
          emergencyGender: '',
          emergencyRelationship: '',
          emergencyResidentialAddress: '',
          emergencyPhone: '',
          employmentStatus: '',
          employmentCategory: '',
          employmentEmployerName: '',
          employmentJobTitle: '',
          employmentStartDate: '',
          employmentCountry: '',
          employmentRegion: '',
          employmentDistrict: '',
          employmentCityTown: '',
          employmentEmployerAddress: '',
          employmentMonthlyIncome: '',
          employmentOfficePhone: '',
          employmentEmployerEmail: '',
          hasIdCopy: false,
          hasPassportPhoto: widget.verificationPhoto != null,
          hasProofOfAddress: false,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
    if (!mounted || step <= 8) return;

    final signatoryName =
        '${data['firstName']!} ${data['otherName']!.isNotEmpty ? '${data['otherName']!} ' : ''}${data['lastName']!}'
            .trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountDeclarationScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          phone: widget.phone,
          altPhone: '',
          email: widget.email,
          streetName: widget.ghanaCardProfile.address,
          houseAddress: '',
          digitalAddress: '',
          poBox: '',
          city: widget.ghanaCardProfile.city,
          region: 'Greater Accra',
          metroMunicipal: '',
          proofOfAddressType: 'Utility Bill',
          emergencyTitle: '',
          emergencySurname: '',
          emergencyOtherNames: '',
          emergencyGender: '',
          emergencyRelationship: '',
          emergencyResidentialAddress: '',
          emergencyPhone: '',
          employmentStatus: '',
          employmentCategory: '',
          employmentEmployerName: '',
          employmentJobTitle: '',
          employmentStartDate: '',
          employmentCountry: '',
          employmentRegion: '',
          employmentDistrict: '',
          employmentCityTown: '',
          employmentEmployerAddress: '',
          employmentMonthlyIncome: '',
          employmentOfficePhone: '',
          employmentEmployerEmail: '',
          hasIdCopy: false,
          hasPassportPhoto: false,
          hasProofOfAddress: false,
          hasSignature: false,
          mandateSignatoryName: signatoryName,
          mandateAuthorization: 'Sole Signatory',
          mandateSignatureMethod: '',
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
    if (!mounted || step <= 9) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountReviewScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: data['title']!,
          firstName: data['firstName']!,
          lastName: data['lastName']!,
          otherName: data['otherName']!,
          gender: data['gender']!,
          maritalStatus: data['maritalStatus']!,
          dob: data['dob']!,
          educationalLevel: data['education']!,
          disabilityStatus: data['disability']!,
          idType: 'National ID',
          idNumber: widget.ghanaCardProfile.nationalId,
          issueDate: widget.ghanaCardProfile.issueDate,
          expiryDate: widget.ghanaCardProfile.expiryDate,
          phone: widget.phone,
          altPhone: '',
          email: widget.email,
          streetName: widget.ghanaCardProfile.address,
          houseAddress: '',
          digitalAddress: '',
          poBox: '',
          city: widget.ghanaCardProfile.city,
          region: 'Greater Accra',
          metroMunicipal: '',
          proofOfAddressType: 'Utility Bill',
          emergencyTitle: '',
          emergencySurname: '',
          emergencyOtherNames: '',
          emergencyGender: '',
          emergencyRelationship: '',
          emergencyResidentialAddress: '',
          emergencyPhone: '',
          employmentStatus: '',
          employmentCategory: '',
          employmentEmployerName: '',
          employmentJobTitle: '',
          employmentStartDate: '',
          employmentCountry: '',
          employmentRegion: '',
          employmentDistrict: '',
          employmentCityTown: '',
          employmentEmployerAddress: '',
          employmentMonthlyIncome: '',
          employmentOfficePhone: '',
          employmentEmployerEmail: '',
          hasIdCopy: false,
          hasPassportPhoto: false,
          hasProofOfAddress: false,
          hasSignature: false,
          mandateSignatoryName: '',
          mandateAuthorization: '',
          mandateSignatureMethod: '',
          declarationsAccepted: false,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  Widget _buildFormSectionHeader({
    required bool isDark,
    required String title,
    String? subtitle,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 15,
            color: widget.accentColor,
          ),
          SizedBox(width: 2.w),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 0.25.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 6.8.sp,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.4.h),
      child: Divider(
        height: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _fieldGap() => SizedBox(height: 1.2.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = widget.ghanaCardProfile;

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
              title: 'Personal Details',
              subtitle:
                  'Open Account · Step 3 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.person_outline_rounded,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              3,
              accentColor: widget.accentColor,
              onStepTap: _handleWizardStepTap,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161B22) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFE5E7EB),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: widget.accentColor
                                    .withValues(alpha: isDark ? 0.15 : 0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
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
                                    'Customer Information',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                  SizedBox(height: 0.2.h),
                                  Text(
                                    'Verified National ID details are locked. '
                                    'Complete the editable fields below.',
                                    style: GoogleFonts.inter(
                                      fontSize: 7.sp,
                                      height: 1.4,
                                      color: isDark
                                          ? Colors.white38
                                          : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.2.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.9.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669)
                                .withValues(alpha: isDark ? 0.1 : 0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF059669)
                                  .withValues(alpha: 0.18),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF059669),
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  'National ID verified',
                                  style: GoogleFonts.inter(
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildFormDivider(isDark),
                        _buildFormSectionHeader(
                          isDark: isDark,
                          title: 'National ID Details',
                          subtitle: 'Retrieved from national ID registry',
                          icon: Icons.badge_outlined,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildReadOnlyField(
                          label: 'ID Type *',
                          value: 'National ID',
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          icon: Icons.badge_outlined,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildReadOnlyField(
                          label: 'National ID Number *',
                          value: profile.nationalId,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          icon: Icons.credit_card_outlined,
                        ),
                        _fieldGap(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _OpenAccountUi.buildReadOnlyField(
                                label: 'Issue Date',
                                value: profile.issueDate,
                                isDark: isDark,
                                accentColor: widget.accentColor,
                                icon: Icons.event_outlined,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: _OpenAccountUi.buildReadOnlyField(
                                label: 'Expiry Date',
                                value: profile.expiryDate,
                                isDark: isDark,
                                accentColor: widget.accentColor,
                                icon: Icons.event_busy_outlined,
                              ),
                            ),
                          ],
                        ),
                        _buildFormDivider(isDark),
                        _buildFormSectionHeader(
                          isDark: isDark,
                          title: 'Personal Information',
                          icon: Icons.person_outline_rounded,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Title *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value:
                              _selectedTitle.isEmpty ? null : _selectedTitle,
                          items: _titles,
                          hint: 'Select title',
                          icon: Icons.person_pin_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) =>
                              setState(() => _selectedTitle = v ?? ''),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildReadOnlyField(
                          label: 'First Name *',
                          value: _firstNameCtrl.text,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          icon: Icons.person_outline_rounded,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildReadOnlyField(
                          label: 'Last Name *',
                          value: _lastNameCtrl.text,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          icon: Icons.person_outline_rounded,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildReadOnlyField(
                          label: 'Other Name(s)',
                          value: _otherNameCtrl.text,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          icon: Icons.person_outline_rounded,
                        ),
                        _fieldGap(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _OpenAccountUi.buildReadOnlyField(
                                label: 'Date of Birth *',
                                value: _dobCtrl.text,
                                isDark: isDark,
                                accentColor: widget.accentColor,
                                icon: Icons.calendar_today_outlined,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: _OpenAccountUi.buildReadOnlyField(
                                label: 'Gender *',
                                value: _selectedGender,
                                isDark: isDark,
                                accentColor: widget.accentColor,
                                icon: Icons.wc_rounded,
                              ),
                            ),
                          ],
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Marital Status *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedMarital.isEmpty
                              ? null
                              : _selectedMarital,
                          items: _maritalStatuses,
                          hint: 'Select status',
                          icon: Icons.favorite_border_rounded,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) =>
                              setState(() => _selectedMarital = v ?? ''),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                            'Educational Level *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedEducation.isEmpty
                              ? null
                              : _selectedEducation,
                          items: _educationLevels,
                          hint: 'Select education level',
                          icon: Icons.school_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) =>
                              setState(() => _selectedEducation = v ?? ''),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                            'Disability Status *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedDisability.isEmpty
                              ? null
                              : _selectedDisability,
                          items: _disabilityStatuses,
                          hint: 'Select disability status',
                          icon: Icons.accessible_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) =>
                              setState(() => _selectedDisability = v ?? ''),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: 'Continue to Contact',
                onTap: _canContinue ? _onContinue : null,
                accentColor: widget.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
