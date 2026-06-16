part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 4 – Contact Information ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountContactScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final _GhanaCardProfile ghanaCardProfile;
  final String phone;
  final String email;
  final File? verificationPhoto;
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
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountContactScreen({
    required this.accountType,
    required this.minDeposit,
    required this.ghanaCardProfile,
    required this.phone,
    required this.email,
    required this.verificationPhoto,
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
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountContactScreen> createState() =>
      _OpenAccountContactScreenState();
}

class _OpenAccountContactScreenState extends State<_OpenAccountContactScreen>
    with SingleTickerProviderStateMixin {
  final _altPhoneCtrl = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeIn;

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
    _altPhoneCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountAddressScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: widget.verificationPhoto,
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
          altPhone: _altPhoneCtrl.text.trim(),
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 4,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step <= 4) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountAddressScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: widget.ghanaCardProfile,
          phone: widget.phone,
          email: widget.email,
          verificationPhoto: widget.verificationPhoto,
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
          altPhone: _altPhoneCtrl.text.trim(),
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
          altPhone: _altPhoneCtrl.text.trim(),
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
          altPhone: _altPhoneCtrl.text.trim(),
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
          altPhone: _altPhoneCtrl.text.trim(),
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

    final signatoryName = [
      widget.firstName.trim(),
      widget.otherName.trim(),
      widget.lastName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');

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
          altPhone: _altPhoneCtrl.text.trim(),
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
          altPhone: _altPhoneCtrl.text.trim(),
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
              title: 'Contact Information',
              subtitle:
                  'Open Account · Step 4 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.contact_phone_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              4,
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
                      'Primary phone and email were verified during OTP. '
                      'You may add an alternative phone number if needed.',
                      accentColor: widget.accentColor,
                    ),
                    SizedBox(height: 1.5.h),
                    _OpenAccountUi.buildSectionCard(
                      isDark: isDark,
                      title: 'Contact Details',
                      subtitle: 'Confirmed via OTP',
                      icon: Icons.contact_mail_outlined,
                      accentColor: widget.accentColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OpenAccountUi.buildReadOnlyField(
                            label: 'Phone Number *',
                            value: widget.phone,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            icon: Icons.phone_outlined,
                            helperText: 'Verified with OTP',
                          ),
                          SizedBox(height: 1.3.h),
                          _OpenAccountUi.buildReadOnlyField(
                            label: 'Email Address *',
                            value: widget.email,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            icon: Icons.email_outlined,
                            helperText: 'Verified with OTP',
                          ),
                          SizedBox(height: 1.3.h),
                          _OpenAccountUi.buildFieldLabel(
                            'Alternative Phone (Optional)',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _altPhoneCtrl,
                            hint: 'Optional second number',
                            icon: Icons.phone_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            required: false,
                            keyboardType: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ],
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
                label: 'Continue to Address',
                onTap: _onContinue,
                accentColor: widget.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
