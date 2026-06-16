part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 6 – Emergency Contact ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountEmergencyContactScreen extends StatefulWidget {
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
  final File? verificationPhoto;
  final bool hasIdCopy;
  final bool hasPassportPhoto;
  final bool hasProofOfAddress;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountEmergencyContactScreen({
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
    this.verificationPhoto,
    required this.hasIdCopy,
    required this.hasPassportPhoto,
    required this.hasProofOfAddress,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountEmergencyContactScreen> createState() =>
      _OpenAccountEmergencyContactScreenState();
}

class _OpenAccountEmergencyContactScreenState
    extends State<_OpenAccountEmergencyContactScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _surnameCtrl = TextEditingController();
  final _otherNamesCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _selectedTitle = '';
  String _selectedGender = '';
  String _selectedRelationship = '';
  bool _useMyResidentialAddress = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  static const _titles = [
    'Mr.',
    'Mrs.',
    'Ms.',
    'Dr.',
    'Prof.',
    'Rev.',
  ];

  static const _genders = [
    'Male',
    'Female',
  ];

  static const _relationships = [
    'Spouse',
    'Parent',
    'Sibling',
    'Child',
    'Friend',
    'Colleague',
    'Other',
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
    _surnameCtrl.dispose();
    _otherNamesCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String get _accountHolderAddress {
    final parts = <String>[
      if (widget.houseAddress.trim().isNotEmpty) widget.houseAddress.trim(),
      if (widget.streetName.trim().isNotEmpty) widget.streetName.trim(),
      if (widget.digitalAddress.trim().isNotEmpty) widget.digitalAddress.trim(),
      if (widget.poBox.trim().isNotEmpty) 'P.O. Box ${widget.poBox.trim()}',
      if (widget.city.trim().isNotEmpty) widget.city.trim(),
      if (widget.metroMunicipal.trim().isNotEmpty) widget.metroMunicipal.trim(),
      if (widget.region.trim().isNotEmpty) widget.region.trim(),
    ];
    return parts.join(', ');
  }

  String get _emergencyResidentialAddress => _useMyResidentialAddress
      ? _accountHolderAddress
      : _addressCtrl.text.trim();

  Map<String, String> get _emergencyPayload => {
        'title': _selectedTitle,
        'surname': _surnameCtrl.text.trim(),
        'otherNames': _otherNamesCtrl.text.trim(),
        'gender': _selectedGender,
        'relationship': _selectedRelationship,
        'residentialAddress': _emergencyResidentialAddress,
        'phone': _phoneCtrl.text.trim(),
      };

  bool get _canContinue =>
      _selectedTitle.isNotEmpty &&
      _surnameCtrl.text.trim().isNotEmpty &&
      _selectedGender.isNotEmpty &&
      _selectedRelationship.isNotEmpty &&
      _emergencyResidentialAddress.isNotEmpty &&
      _phoneCtrl.text.trim().length == 10;

  void _toggleUseMyAddress(bool? value) {
    setState(() {
      _useMyResidentialAddress = value ?? false;
      if (_useMyResidentialAddress) {
        _addressCtrl.text = _accountHolderAddress;
      } else {
        _addressCtrl.clear();
      }
    });
  }

  void _pushEmploymentScreen(Map<String, String> data) {
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
          verificationPhoto: widget.verificationPhoto,
          emergencyTitle: data['title']!,
          emergencySurname: data['surname']!,
          emergencyOtherNames: data['otherNames']!,
          emergencyGender: data['gender']!,
          emergencyRelationship: data['relationship']!,
          emergencyResidentialAddress: data['residentialAddress']!,
          emergencyPhone: data['phone']!,
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) return;

    _pushEmploymentScreen(_emergencyPayload);
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 6,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step <= 6) return;

    final data = _emergencyPayload;
    _pushEmploymentScreen({
      'title': data['title']!.isNotEmpty ? data['title']! : 'Mr.',
      'surname': data['surname']!,
      'otherNames': data['otherNames']!,
      'gender': data['gender']!.isNotEmpty ? data['gender']! : 'Male',
      'relationship':
          data['relationship']!.isNotEmpty ? data['relationship']! : 'Spouse',
      'residentialAddress': data['residentialAddress']!.isNotEmpty
          ? data['residentialAddress']!
          : _accountHolderAddress,
      'phone': data['phone']!,
    });
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
          proofOfAddressPhoto: null,
          verificationPhoto: widget.verificationPhoto,
          emergencyTitle: data['title']!.isNotEmpty ? data['title']! : 'Mr.',
          emergencySurname: data['surname']!,
          emergencyOtherNames: data['otherNames']!,
          emergencyGender:
              data['gender']!.isNotEmpty ? data['gender']! : 'Male',
          emergencyRelationship: data['relationship']!.isNotEmpty
              ? data['relationship']!
              : 'Spouse',
          emergencyResidentialAddress: data['residentialAddress']!.isNotEmpty
              ? data['residentialAddress']!
              : _accountHolderAddress,
          emergencyPhone: data['phone']!,
          employmentStatus: 'Full-Time Permanent',
          employmentCategory: 'Software Engineer',
          employmentEmployerName: '',
          employmentJobTitle: '',
          employmentStartDate: 'January 2024',
          employmentCountry: 'Ghana',
          employmentRegion: 'Greater Accra',
          employmentDistrict: 'Accra Metropolitan',
          employmentCityTown: 'Accra',
          employmentEmployerAddress: '',
          employmentMonthlyIncome: 'Below GH₵ 1,000',
          employmentOfficePhone: '',
          employmentEmployerEmail: '',
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
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
          emergencyTitle: data['title']!.isNotEmpty ? data['title']! : 'Mr.',
          emergencySurname: data['surname']!,
          emergencyOtherNames: data['otherNames']!,
          emergencyGender:
              data['gender']!.isNotEmpty ? data['gender']! : 'Male',
          emergencyRelationship: data['relationship']!.isNotEmpty
              ? data['relationship']!
              : 'Spouse',
          emergencyResidentialAddress: data['residentialAddress']!.isNotEmpty
              ? data['residentialAddress']!
              : _accountHolderAddress,
          emergencyPhone: data['phone']!,
          employmentStatus: 'Full-Time Permanent',
          employmentCategory: 'Software Engineer',
          employmentEmployerName: '',
          employmentJobTitle: '',
          employmentStartDate: 'January 2024',
          employmentCountry: 'Ghana',
          employmentRegion: 'Greater Accra',
          employmentDistrict: 'Accra Metropolitan',
          employmentCityTown: 'Accra',
          employmentEmployerAddress: '',
          employmentMonthlyIncome: 'Below GH₵ 1,000',
          employmentOfficePhone: '',
          employmentEmployerEmail: '',
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
          hasSignature: false,
          mandateSignatoryName: signatoryName,
          mandateAuthorization: 'Sole Signatory',
          mandateSignatureMethod: '',
          verificationPhoto: widget.verificationPhoto,
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
          emergencyTitle: data['title']!.isNotEmpty ? data['title']! : 'Mr.',
          emergencySurname: data['surname']!,
          emergencyOtherNames: data['otherNames']!,
          emergencyGender:
              data['gender']!.isNotEmpty ? data['gender']! : 'Male',
          emergencyRelationship: data['relationship']!.isNotEmpty
              ? data['relationship']!
              : 'Spouse',
          emergencyResidentialAddress: data['residentialAddress']!.isNotEmpty
              ? data['residentialAddress']!
              : _accountHolderAddress,
          emergencyPhone: data['phone']!,
          employmentStatus: 'Full-Time Permanent',
          employmentCategory: 'Software Engineer',
          employmentEmployerName: '',
          employmentJobTitle: '',
          employmentStartDate: 'January 2024',
          employmentCountry: 'Ghana',
          employmentRegion: 'Greater Accra',
          employmentDistrict: 'Accra Metropolitan',
          employmentCityTown: 'Accra',
          employmentEmployerAddress: '',
          employmentMonthlyIncome: 'Below GH₵ 1,000',
          employmentOfficePhone: '',
          employmentEmployerEmail: '',
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
          hasSignature: false,
          mandateSignatoryName: '',
          mandateAuthorization: '',
          mandateSignatureMethod: '',
          declarationsAccepted: false,
          verificationPhoto: widget.verificationPhoto,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  Widget _fieldGap() => SizedBox(height: 1.2.h);

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
              title: 'Emergency Contact',
              subtitle:
                  'Open Account · Step 6 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.contact_emergency_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              6,
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
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.12 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OpenAccountUi.buildIntroTip(
                          isDark,
                          'Provide someone we can reach in case of an emergency. '
                          'This person should not be the account holder.',
                          accentColor: widget.accentColor,
                        ),
                        SizedBox(height: 1.5.h),
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
                        _OpenAccountUi.buildFieldLabel('Surname *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _surnameCtrl,
                          hint: 'e.g. Mensah',
                          icon: Icons.person_outline_rounded,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (_) => setState(() {}),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Other Name(s)', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _otherNamesCtrl,
                          hint: 'Optional middle or other names',
                          icon: Icons.person_outline_rounded,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          required: false,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Gender *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value:
                              _selectedGender.isEmpty ? null : _selectedGender,
                          items: _genders,
                          hint: 'Select gender',
                          icon: Icons.wc_rounded,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) =>
                              setState(() => _selectedGender = v ?? ''),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Relationship *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedRelationship.isEmpty
                              ? null
                              : _selectedRelationship,
                          items: _relationships,
                          hint: 'Select relationship',
                          icon: Icons.family_restroom_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) => setState(
                            () => _selectedRelationship = v ?? '',
                          ),
                        ),
                        _fieldGap(),
                        Row(
                          children: [
                            Expanded(
                              child: _OpenAccountUi.buildFieldLabel(
                                'Residential Address *',
                                isDark,
                              ),
                            ),
                            Transform.scale(
                              scale: 0.85,
                              child: Checkbox(
                                value: _useMyResidentialAddress,
                                onChanged: _accountHolderAddress.isEmpty
                                    ? null
                                    : _toggleUseMyAddress,
                                activeColor: widget.accentColor,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: _accountHolderAddress.isEmpty
                                    ? null
                                    : () => _toggleUseMyAddress(
                                          !_useMyResidentialAddress,
                                        ),
                                child: Text(
                                  'Use my residential address',
                                  style: GoogleFonts.inter(
                                    fontSize: 6.8.sp,
                                    fontWeight: FontWeight.w500,
                                    color: _accountHolderAddress.isEmpty
                                        ? (isDark
                                            ? Colors.white24
                                            : const Color(0xFF9CA3AF))
                                        : (isDark
                                            ? Colors.white70
                                            : const Color(0xFF374151)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.4.h),
                        if (_useMyResidentialAddress)
                          _OpenAccountUi.buildReadOnlyField(
                            label: 'Address',
                            value: _accountHolderAddress,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            icon: Icons.home_outlined,
                          )
                        else
                          _OpenAccountUi.buildTextField(
                            controller: _addressCtrl,
                            hint: 'Enter residential address',
                            icon: Icons.home_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            maxLines: 3,
                            onChanged: (_) => setState(() {}),
                          ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Phone Number *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _phoneCtrl,
                          hint: 'e.g. 0241234567',
                          icon: Icons.phone_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          keyboardType: TextInputType.phone,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (_) => setState(() {}),
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
                label: 'Continue',
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
