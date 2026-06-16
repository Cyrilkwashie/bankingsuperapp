part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 7 – Employment Details ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountEmploymentScreen extends StatefulWidget {
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
  final String emergencyTitle;
  final String emergencySurname;
  final String emergencyOtherNames;
  final String emergencyGender;
  final String emergencyRelationship;
  final String emergencyResidentialAddress;
  final String emergencyPhone;
  final bool hasIdCopy;
  final bool hasPassportPhoto;
  final bool hasProofOfAddress;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountEmploymentScreen({
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
    required this.emergencyTitle,
    required this.emergencySurname,
    required this.emergencyOtherNames,
    required this.emergencyGender,
    required this.emergencyRelationship,
    required this.emergencyResidentialAddress,
    required this.emergencyPhone,
    required this.hasIdCopy,
    required this.hasPassportPhoto,
    required this.hasProofOfAddress,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountEmploymentScreen> createState() =>
      _OpenAccountEmploymentScreenState();
}

class _OpenAccountEmploymentScreenState extends State<_OpenAccountEmploymentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _employerNameCtrl = TextEditingController();
  final _jobTitleCtrl = TextEditingController();
  final _employerAddressCtrl = TextEditingController();
  final _customEmploymentCategoryCtrl = TextEditingController();
  final _officePhoneCtrl = TextEditingController();
  final _employerEmailCtrl = TextEditingController();

  String _selectedEmploymentStatus = '';
  String _selectedEmploymentCategory = '';
  String _selectedStartMonth = '';
  String _selectedStartYear = '';
  String _selectedCountry = '';
  String _selectedRegion = '';
  String _selectedDistrict = '';
  String _selectedCityTown = '';
  String _selectedMonthlyIncome = '';

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  static const _employmentStatuses = [
    'Full-Time Permanent',
    'Full-Time Contract',
    'Part-Time Permanent',
    'Part-Time Contract',
    'Casual / Temporary',
    'Self-Employed',
    'Business Owner',
    'Intern / Trainee',
    'Student',
    'Unemployed',
    'Retired',
  ];

  static const _employerRequiredStatuses = {
    'Full-Time Permanent',
    'Full-Time Contract',
    'Part-Time Permanent',
    'Part-Time Contract',
    'Casual / Temporary',
    'Self-Employed',
    'Business Owner',
    'Intern / Trainee',
  };

  static const _employmentCategories = [
    'Software Engineer',
    'Accountant',
    'Teacher',
    'Nurse / Health Worker',
    'Doctor / Medical Professional',
    'Engineer',
    'Lawyer',
    'Banker / Financial Services',
    'Sales / Marketing',
    'Driver',
    'Farmer / Agriculturist',
    'Trader / Merchant',
    'Artisan / Craftsperson',
    'Civil Servant',
    'Military / Security',
    'Business Owner',
    'Student',
    'Other',
  ];

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _countries = [
    'Ghana',
    'Nigeria',
    'Côte d\'Ivoire',
    'Togo',
    'Burkina Faso',
    'United Kingdom',
    'United States',
    'Canada',
    'Other',
  ];

  static const _regions = [
    'Greater Accra',
    'Ashanti',
    'Northern',
    'Western',
    'Central',
    'Brong Ahafo',
    'Volta',
    'Eastern',
    'Upper West',
    'Upper East',
    'Bono East',
    'Ahafo',
    'Savannah',
    'North East',
    'Oti',
    'Western North',
  ];

  static const _districts = [
    'Accra Metropolitan',
    'Tema Metropolitan',
    'Kumasi Metropolitan',
    'Tamale Metropolitan',
    'Sekondi-Takoradi Metropolitan',
    'Cape Coast Metropolitan',
    'Ga Central Municipal',
    'Ga East Municipal',
    'Ga West Municipal',
    'Ga North Municipal',
    'Ledzokuku Municipal',
    'La Dade Kotopon Municipal',
    'La Nkwantanang Madina Municipal',
    'Adentan Municipal',
    'Ashaiman Municipal',
    'Oforikrom Municipal',
    'Asokwa Municipal',
    'Suame Municipal',
    'Sunyani Municipal',
    'Ho Municipal',
    'Koforidua Municipal',
    'Bolgatanga Municipal',
    'Wa Municipal',
  ];

  static const _cities = [
    'Accra',
    'Kumasi',
    'Tamale',
    'Takoradi',
    'Cape Coast',
    'Sunyani',
    'Ho',
    'Koforidua',
    'Wa',
    'Bolgatanga',
    'Techiman',
    'Tema',
    'Obuasi',
    'Tarkwa',
  ];

  static const _monthlyIncomeRanges = [
    'Below GH₵ 1,000',
    'GH₵ 1,000 – GH₵ 5,000',
    'GH₵ 5,000 – GH₵ 20,000',
    'GH₵ 20,000 – GH₵ 50,000',
    'GH₵ 50,000 and above',
  ];

  static List<String> get _years {
    final currentYear = DateTime.now().year;
    return List.generate(50, (index) => '${currentYear - index}');
  }

  bool get _requiresEmployerDetails =>
      _employerRequiredStatuses.contains(_selectedEmploymentStatus);

  String get _resolvedStartDate =>
      _selectedStartMonth.isNotEmpty && _selectedStartYear.isNotEmpty
          ? '$_selectedStartMonth $_selectedStartYear'
          : '';

  void _clearEmployerFields() {
    _employerNameCtrl.clear();
    _jobTitleCtrl.clear();
    _employerAddressCtrl.clear();
    _officePhoneCtrl.clear();
    _employerEmailCtrl.clear();
    _selectedStartMonth = '';
    _selectedStartYear = '';
    _selectedCountry = '';
    _selectedRegion = '';
    _selectedDistrict = '';
    _selectedCityTown = '';
  }

  bool get _canContinue {
    if (_selectedEmploymentStatus.isEmpty ||
        _selectedEmploymentCategory.isEmpty ||
        _selectedMonthlyIncome.isEmpty) {
      return false;
    }
    if (_selectedEmploymentCategory == 'Other' &&
        _customEmploymentCategoryCtrl.text.trim().isEmpty) {
      return false;
    }
    if (_requiresEmployerDetails) {
      if (_employerNameCtrl.text.trim().isEmpty ||
          _selectedStartMonth.isEmpty ||
          _selectedStartYear.isEmpty ||
          _selectedCountry.isEmpty ||
          _selectedRegion.isEmpty ||
          _selectedDistrict.isEmpty ||
          _selectedCityTown.isEmpty ||
          _employerAddressCtrl.text.trim().isEmpty) {
        return false;
      }
      final officePhone = _officePhoneCtrl.text.trim();
      if (officePhone.isNotEmpty && officePhone.length != 10) {
        return false;
      }
    }
    return true;
  }

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
    _employerNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    _employerAddressCtrl.dispose();
    _customEmploymentCategoryCtrl.dispose();
    _officePhoneCtrl.dispose();
    _employerEmailCtrl.dispose();
    super.dispose();
  }

  String get _resolvedEmploymentCategory =>
      _selectedEmploymentCategory == 'Other'
          ? _customEmploymentCategoryCtrl.text.trim()
          : _selectedEmploymentCategory;

  Map<String, String> get _employmentPayload => {
        'status': _selectedEmploymentStatus,
        'category': _resolvedEmploymentCategory,
        'employerName': _employerNameCtrl.text.trim(),
        'jobTitle': _jobTitleCtrl.text.trim(),
        'startDate': _resolvedStartDate,
        'country': _selectedCountry,
        'region': _selectedRegion,
        'district': _selectedDistrict,
        'cityTown': _selectedCityTown,
        'employerAddress': _employerAddressCtrl.text.trim(),
        'monthlyIncome': _selectedMonthlyIncome,
        'officePhone': _officePhoneCtrl.text.trim(),
        'employerEmail': _employerEmailCtrl.text.trim(),
      };

  void _pushSignatureScreen(Map<String, String> employment) {
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
          emergencyTitle: widget.emergencyTitle,
          emergencySurname: widget.emergencySurname,
          emergencyOtherNames: widget.emergencyOtherNames,
          emergencyGender: widget.emergencyGender,
          emergencyRelationship: widget.emergencyRelationship,
          emergencyResidentialAddress: widget.emergencyResidentialAddress,
          emergencyPhone: widget.emergencyPhone,
          employmentStatus: employment['status']!,
          employmentCategory: employment['category']!,
          employmentEmployerName: employment['employerName']!,
          employmentJobTitle: employment['jobTitle']!,
          employmentStartDate: employment['startDate']!,
          employmentCountry: employment['country']!,
          employmentRegion: employment['region']!,
          employmentDistrict: employment['district']!,
          employmentCityTown: employment['cityTown']!,
          employmentEmployerAddress: employment['employerAddress']!,
          employmentMonthlyIncome: employment['monthlyIncome']!,
          employmentOfficePhone: employment['officePhone']!,
          employmentEmployerEmail: employment['employerEmail']!,
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
    _pushSignatureScreen(_employmentPayload);
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 7,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step <= 7) return;

    final employment = _employmentPayload;
    _pushSignatureScreen({
      'status': employment['status']!.isNotEmpty
          ? employment['status']!
          : 'Full-Time Permanent',
      'category': employment['category']!.isNotEmpty
          ? employment['category']!
          : _employmentCategories.first,
      'employerName': employment['employerName']!,
      'jobTitle': employment['jobTitle']!,
      'startDate': employment['startDate']!.isNotEmpty
          ? employment['startDate']!
          : 'January ${_years.first}',
      'country': employment['country']!.isNotEmpty
          ? employment['country']!
          : _countries.first,
      'region': employment['region']!.isNotEmpty
          ? employment['region']!
          : _regions.first,
      'district': employment['district']!.isNotEmpty
          ? employment['district']!
          : _districts.first,
      'cityTown': employment['cityTown']!.isNotEmpty
          ? employment['cityTown']!
          : _cities.first,
      'employerAddress': employment['employerAddress']!,
      'monthlyIncome': employment['monthlyIncome']!.isNotEmpty
          ? employment['monthlyIncome']!
          : _monthlyIncomeRanges.first,
      'officePhone': employment['officePhone']!,
      'employerEmail': employment['employerEmail']!,
    });
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
          emergencyTitle: widget.emergencyTitle,
          emergencySurname: widget.emergencySurname,
          emergencyOtherNames: widget.emergencyOtherNames,
          emergencyGender: widget.emergencyGender,
          emergencyRelationship: widget.emergencyRelationship,
          emergencyResidentialAddress: widget.emergencyResidentialAddress,
          emergencyPhone: widget.emergencyPhone,
          employmentStatus: employment['status']!.isNotEmpty
              ? employment['status']!
              : 'Full-Time Permanent',
          employmentCategory: employment['category']!.isNotEmpty
              ? employment['category']!
              : _employmentCategories.first,
          employmentEmployerName: employment['employerName']!,
          employmentJobTitle: employment['jobTitle']!,
          employmentStartDate: employment['startDate']!.isNotEmpty
              ? employment['startDate']!
              : 'January ${_years.first}',
          employmentCountry: employment['country']!.isNotEmpty
              ? employment['country']!
              : _countries.first,
          employmentRegion: employment['region']!.isNotEmpty
              ? employment['region']!
              : _regions.first,
          employmentDistrict: employment['district']!.isNotEmpty
              ? employment['district']!
              : _districts.first,
          employmentCityTown: employment['cityTown']!.isNotEmpty
              ? employment['cityTown']!
              : _cities.first,
          employmentEmployerAddress: employment['employerAddress']!,
          employmentMonthlyIncome: employment['monthlyIncome']!.isNotEmpty
              ? employment['monthlyIncome']!
              : _monthlyIncomeRanges.first,
          employmentOfficePhone: employment['officePhone']!,
          employmentEmployerEmail: employment['employerEmail']!,
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
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
          employmentStatus: employment['status']!.isNotEmpty
              ? employment['status']!
              : 'Full-Time Permanent',
          employmentCategory: employment['category']!.isNotEmpty
              ? employment['category']!
              : _employmentCategories.first,
          employmentEmployerName: employment['employerName']!,
          employmentJobTitle: employment['jobTitle']!,
          employmentStartDate: employment['startDate']!.isNotEmpty
              ? employment['startDate']!
              : 'January ${_years.first}',
          employmentCountry: employment['country']!.isNotEmpty
              ? employment['country']!
              : _countries.first,
          employmentRegion: employment['region']!.isNotEmpty
              ? employment['region']!
              : _regions.first,
          employmentDistrict: employment['district']!.isNotEmpty
              ? employment['district']!
              : _districts.first,
          employmentCityTown: employment['cityTown']!.isNotEmpty
              ? employment['cityTown']!
              : _cities.first,
          employmentEmployerAddress: employment['employerAddress']!,
          employmentMonthlyIncome: employment['monthlyIncome']!.isNotEmpty
              ? employment['monthlyIncome']!
              : _monthlyIncomeRanges.first,
          employmentOfficePhone: employment['officePhone']!,
          employmentEmployerEmail: employment['employerEmail']!,
          hasIdCopy: widget.hasIdCopy,
          hasPassportPhoto: widget.hasPassportPhoto,
          hasProofOfAddress: widget.hasProofOfAddress,
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
              title: 'Employment Details',
              subtitle:
                  'Open Account · Step 7 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.work_outline_rounded,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              7,
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
                          'Tell us about the customer\'s current employment or source of income.',
                          accentColor: widget.accentColor,
                        ),
                        SizedBox(height: 1.5.h),
                        _OpenAccountUi.buildFieldLabel(
                          'Employment Category *',
                          isDark,
                        ),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedEmploymentCategory.isEmpty
                              ? null
                              : _selectedEmploymentCategory,
                          items: _employmentCategories,
                          hint: 'Select employment category',
                          icon: Icons.category_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) => setState(() {
                            _selectedEmploymentCategory = v ?? '';
                            if (v != 'Other') {
                              _customEmploymentCategoryCtrl.clear();
                            }
                          }),
                        ),
                        if (_selectedEmploymentCategory == 'Other') ...[
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Specify Employment Category *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _customEmploymentCategoryCtrl,
                            hint: 'Enter employment category',
                            icon: Icons.edit_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                          'Employment Status *',
                          isDark,
                        ),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedEmploymentStatus.isEmpty
                              ? null
                              : _selectedEmploymentStatus,
                          items: _employmentStatuses,
                          hint: 'Select employment status',
                          icon: Icons.work_outline_rounded,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) => setState(() {
                            _selectedEmploymentStatus = v ?? '';
                            if (!_requiresEmployerDetails) {
                              _clearEmployerFields();
                            }
                          }),
                        ),
                        if (_requiresEmployerDetails) ...[
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Employment Start Date *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          Row(
                            children: [
                              Expanded(
                                child: _OpenAccountUi.buildDropdown(
                                  value: _selectedStartMonth.isEmpty
                                      ? null
                                      : _selectedStartMonth,
                                  items: _months,
                                  hint: 'Month',
                                  icon: Icons.calendar_month_outlined,
                                  isDark: isDark,
                                  accentColor: widget.accentColor,
                                  onChanged: (v) => setState(
                                    () => _selectedStartMonth = v ?? '',
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: _OpenAccountUi.buildDropdown(
                                  value: _selectedStartYear.isEmpty
                                      ? null
                                      : _selectedStartYear,
                                  items: _years,
                                  hint: 'Year',
                                  icon: Icons.calendar_today_outlined,
                                  isDark: isDark,
                                  accentColor: widget.accentColor,
                                  onChanged: (v) => setState(
                                    () => _selectedStartYear = v ?? '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Employer / Business Name *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _employerNameCtrl,
                            hint: 'e.g. ABC Company Ltd',
                            icon: Icons.business_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (_) => setState(() {}),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel('Job Title', isDark),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _jobTitleCtrl,
                            hint: 'e.g. Sales Manager',
                            icon: Icons.work_history_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            required: false,
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel('Country *', isDark),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildDropdown(
                            value: _selectedCountry.isEmpty
                                ? null
                                : _selectedCountry,
                            items: _countries,
                            hint: 'Select country',
                            icon: Icons.public_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (v) => setState(
                              () => _selectedCountry = v ?? '',
                            ),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel('Region *', isDark),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildDropdown(
                            value: _selectedRegion.isEmpty
                                ? null
                                : _selectedRegion,
                            items: _regions,
                            hint: 'Select region',
                            icon: Icons.map_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (v) => setState(
                              () => _selectedRegion = v ?? '',
                            ),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'District (MMDA) *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildDropdown(
                            value: _selectedDistrict.isEmpty
                                ? null
                                : _selectedDistrict,
                            items: _districts,
                            hint: 'Select district',
                            icon: Icons.location_city_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (v) => setState(
                              () => _selectedDistrict = v ?? '',
                            ),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'City / Town *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildDropdown(
                            value: _selectedCityTown.isEmpty
                                ? null
                                : _selectedCityTown,
                            items: _cities,
                            hint: 'Select city or town',
                            icon: Icons.location_on_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (v) => setState(
                              () => _selectedCityTown = v ?? '',
                            ),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Employer Address *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _employerAddressCtrl,
                            hint: 'Street, building, or office location',
                            icon: Icons.home_work_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            maxLines: 2,
                            onChanged: (_) => setState(() {}),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Monthly Salary *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildDropdown(
                            value: _selectedMonthlyIncome.isEmpty
                                ? null
                                : _selectedMonthlyIncome,
                            items: _monthlyIncomeRanges,
                            hint: 'Select salary range',
                            icon: Icons.payments_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (v) => setState(
                              () => _selectedMonthlyIncome = v ?? '',
                            ),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Office Phone Number',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _officePhoneCtrl,
                            hint: '10-digit office phone',
                            icon: Icons.phone_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            required: false,
                            keyboardType: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (_) => setState(() {}),
                          ),
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Employer Email',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildTextField(
                            controller: _employerEmailCtrl,
                            hint: 'e.g. hr@company.com',
                            icon: Icons.email_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            required: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                        if (!_requiresEmployerDetails) ...[
                          _fieldGap(),
                          _OpenAccountUi.buildFieldLabel(
                            'Monthly Salary *',
                            isDark,
                          ),
                          SizedBox(height: 0.4.h),
                          _OpenAccountUi.buildDropdown(
                            value: _selectedMonthlyIncome.isEmpty
                                ? null
                                : _selectedMonthlyIncome,
                            items: _monthlyIncomeRanges,
                            hint: 'Select salary range',
                            icon: Icons.payments_outlined,
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            onChanged: (v) => setState(
                              () => _selectedMonthlyIncome = v ?? '',
                            ),
                          ),
                        ],
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
