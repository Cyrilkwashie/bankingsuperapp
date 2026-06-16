part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 5 – Address Information ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountAddressScreen extends StatefulWidget {
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
  final String altPhone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountAddressScreen({
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
    required this.altPhone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountAddressScreen> createState() =>
      _OpenAccountAddressScreenState();
}

class _OpenAccountAddressScreenState extends State<_OpenAccountAddressScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _streetNameCtrl = TextEditingController();
  final _houseAddressCtrl = TextEditingController();
  final _digitalAddressCtrl = TextEditingController();
  final _poBoxCtrl = TextEditingController();

  String _selectedCity = '';
  String _selectedRegion = '';
  String _selectedMetroMunicipal = '';
  String _selectedProofType = '';
  File? _proofOfAddressPhoto;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

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

  static const _metroMunicipals = [
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

  static const _proofOfAddressTypes = [
    'Utility Bill',
    'Bank Statement',
    'Tenancy Agreement',
    'Property Rate Receipt',
    'Digital Address Confirmation',
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

    _streetNameCtrl.text = widget.ghanaCardProfile.address;
    _houseAddressCtrl.text = widget.ghanaCardProfile.address;
    _selectedCity = widget.ghanaCardProfile.city;
    _selectedRegion = 'Greater Accra';
    _selectedMetroMunicipal = 'Accra Metropolitan';
  }

  @override
  void dispose() {
    _animController.dispose();
    _streetNameCtrl.dispose();
    _houseAddressCtrl.dispose();
    _digitalAddressCtrl.dispose();
    _poBoxCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _streetNameCtrl.text.trim().isNotEmpty &&
      _houseAddressCtrl.text.trim().isNotEmpty &&
      _digitalAddressCtrl.text.trim().isNotEmpty &&
      _selectedCity.isNotEmpty &&
      _selectedRegion.isNotEmpty &&
      _selectedMetroMunicipal.isNotEmpty &&
      _selectedProofType.isNotEmpty &&
      _proofOfAddressPhoto != null;

  Future<void> _captureProofPhoto() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (xFile != null && mounted) {
        setState(() => _proofOfAddressPhoto = File(xFile.path));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open camera.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _uploadProofDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null && mounted) {
        setState(
          () => _proofOfAddressPhoto = File(result.files.single.path!),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open file picker.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete all required address and proof of address fields',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
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
          altPhone: widget.altPhone,
          email: widget.email,
          streetName: _streetNameCtrl.text.trim(),
          houseAddress: _houseAddressCtrl.text.trim(),
          digitalAddress: _digitalAddressCtrl.text.trim(),
          poBox: _poBoxCtrl.text.trim(),
          city: _selectedCity,
          region: _selectedRegion,
          metroMunicipal: _selectedMetroMunicipal,
          proofOfAddressType: _selectedProofType,
          verificationPhoto: widget.verificationPhoto,
          hasIdCopy: false,
          hasPassportPhoto: widget.verificationPhoto != null,
          hasProofOfAddress: _proofOfAddressPhoto != null,
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 5,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    if (step <= 5) return;

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
          altPhone: widget.altPhone,
          email: widget.email,
          streetName: _streetNameCtrl.text.trim().isNotEmpty
              ? _streetNameCtrl.text.trim()
              : widget.ghanaCardProfile.address,
          houseAddress: _houseAddressCtrl.text.trim(),
          digitalAddress: _digitalAddressCtrl.text.trim(),
          poBox: _poBoxCtrl.text.trim(),
          city: _selectedCity.isNotEmpty
              ? _selectedCity
              : widget.ghanaCardProfile.city,
          region: _selectedRegion.isNotEmpty ? _selectedRegion : 'Greater Accra',
          metroMunicipal: _selectedMetroMunicipal,
          proofOfAddressType:
              _selectedProofType.isNotEmpty ? _selectedProofType : 'Utility Bill',
          verificationPhoto: widget.verificationPhoto,
          hasIdCopy: false,
          hasPassportPhoto: widget.verificationPhoto != null,
          hasProofOfAddress: _proofOfAddressPhoto != null,
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
          altPhone: widget.altPhone,
          email: widget.email,
          streetName: _streetNameCtrl.text.trim().isNotEmpty
              ? _streetNameCtrl.text.trim()
              : widget.ghanaCardProfile.address,
          houseAddress: _houseAddressCtrl.text.trim(),
          digitalAddress: _digitalAddressCtrl.text.trim(),
          poBox: _poBoxCtrl.text.trim(),
          city: _selectedCity.isNotEmpty
              ? _selectedCity
              : widget.ghanaCardProfile.city,
          region: _selectedRegion.isNotEmpty ? _selectedRegion : 'Greater Accra',
          metroMunicipal: _selectedMetroMunicipal,
          proofOfAddressType:
              _selectedProofType.isNotEmpty ? _selectedProofType : 'Utility Bill',
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
          hasProofOfAddress: _proofOfAddressPhoto != null,
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
          altPhone: widget.altPhone,
          email: widget.email,
          streetName: _streetNameCtrl.text.trim().isNotEmpty
              ? _streetNameCtrl.text.trim()
              : widget.ghanaCardProfile.address,
          houseAddress: _houseAddressCtrl.text.trim(),
          digitalAddress: _digitalAddressCtrl.text.trim(),
          poBox: _poBoxCtrl.text.trim(),
          city: _selectedCity.isNotEmpty
              ? _selectedCity
              : widget.ghanaCardProfile.city,
          region: _selectedRegion.isNotEmpty ? _selectedRegion : 'Greater Accra',
          metroMunicipal: _selectedMetroMunicipal,
          proofOfAddressType:
              _selectedProofType.isNotEmpty ? _selectedProofType : 'Utility Bill',
          proofOfAddressPhoto: _proofOfAddressPhoto,
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
          hasProofOfAddress: _proofOfAddressPhoto != null,
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
          streetName: _streetNameCtrl.text.trim().isNotEmpty
              ? _streetNameCtrl.text.trim()
              : widget.ghanaCardProfile.address,
          houseAddress: _houseAddressCtrl.text.trim(),
          digitalAddress: _digitalAddressCtrl.text.trim(),
          poBox: _poBoxCtrl.text.trim(),
          city: _selectedCity.isNotEmpty
              ? _selectedCity
              : widget.ghanaCardProfile.city,
          region: _selectedRegion.isNotEmpty ? _selectedRegion : 'Greater Accra',
          metroMunicipal: _selectedMetroMunicipal,
          proofOfAddressType:
              _selectedProofType.isNotEmpty ? _selectedProofType : 'Utility Bill',
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
          hasProofOfAddress: _proofOfAddressPhoto != null,
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
          streetName: _streetNameCtrl.text.trim().isNotEmpty
              ? _streetNameCtrl.text.trim()
              : widget.ghanaCardProfile.address,
          houseAddress: _houseAddressCtrl.text.trim(),
          digitalAddress: _digitalAddressCtrl.text.trim(),
          poBox: _poBoxCtrl.text.trim(),
          city: _selectedCity.isNotEmpty
              ? _selectedCity
              : widget.ghanaCardProfile.city,
          region: _selectedRegion.isNotEmpty ? _selectedRegion : 'Greater Accra',
          metroMunicipal: _selectedMetroMunicipal,
          proofOfAddressType:
              _selectedProofType.isNotEmpty ? _selectedProofType : 'Utility Bill',
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
          hasProofOfAddress: _proofOfAddressPhoto != null,
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
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: widget.accentColor),
          SizedBox(width: 2.w),
        ],
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
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

  Widget _buildProofDocumentCard(bool isDark) {
    final hasDoc = _proofOfAddressPhoto != null;
    final isPdf = hasDoc &&
        _proofOfAddressPhoto!.path.toLowerCase().endsWith('.pdf');
    final cardBg = isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE5E7EB);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasDoc
              ? const Color(0xFF059669).withValues(alpha: 0.45)
              : borderColor,
          width: hasDoc ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 14.h,
            width: double.infinity,
            child: hasDoc
                ? isPdf
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              size: 36,
                              color: widget.accentColor,
                            ),
                            SizedBox(height: 0.6.h),
                            Text(
                              'PDF document attached',
                              style: GoogleFonts.inter(
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(11),
                        ),
                        child: Image.file(
                          _proofOfAddressPhoto!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file_outlined,
                          size: 32,
                          color: isDark ? Colors.white24 : const Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 0.6.h),
                        Text(
                          'Upload or capture proof document',
                          style: GoogleFonts.inter(
                            fontSize: 7.sp,
                            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _captureProofPhoto,
                    icon: const Icon(Icons.camera_alt_outlined, size: 16),
                    label: Text(
                      'Capture',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.accentColor,
                      side: BorderSide(
                        color: widget.accentColor.withValues(alpha: 0.35),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0.9.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _uploadProofDocument,
                    icon: const Icon(Icons.folder_open_outlined, size: 16),
                    label: Text(
                      'Upload',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.accentColor,
                      side: BorderSide(
                        color: widget.accentColor.withValues(alpha: 0.35),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0.9.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                if (hasDoc) ...[
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: () => setState(() => _proofOfAddressPhoto = null),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: const Color(0xFFDC2626),
                      size: 20,
                    ),
                    tooltip: 'Remove',
                  ),
                ],
              ],
            ),
          ),
        ],
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
              title: 'Address Information',
              subtitle:
                  'Open Account · Step 5 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.home_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              5,
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
                                Icons.home_outlined,
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
                                    'Address Details',
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
                                    'Residential address and proof of address document.',
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
                        _buildFormDivider(isDark),
                        _buildFormSectionHeader(
                          isDark: isDark,
                          title: 'Residence',
                          icon: Icons.location_on_outlined,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('Street Name *', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _streetNameCtrl,
                          hint: 'e.g. Osu Road, Ring Road East',
                          icon: Icons.signpost_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (_) => setState(() {}),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                          'House / Building No. *',
                          isDark,
                        ),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _houseAddressCtrl,
                          hint: 'e.g. Plot 5, House 12, Block B',
                          icon: Icons.home_work_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (_) => setState(() {}),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                          'Digital Address (Ghana Post GPS) *',
                          isDark,
                        ),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _digitalAddressCtrl,
                          hint: 'e.g. GA-123-4567',
                          icon: Icons.pin_drop_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!RegExp(r'^[A-Za-z]{2}-\d{3,4}-\d{4}$')
                                .hasMatch(value.trim())) {
                              return 'Use format e.g. GA-123-4567';
                            }
                            return null;
                          },
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel('P.O. Box', isDark),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildTextField(
                          controller: _poBoxCtrl,
                          hint: 'Optional',
                          icon: Icons.mail_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          required: false,
                          onChanged: (_) => setState(() {}),
                        ),
                        _fieldGap(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _OpenAccountUi.buildFieldLabel(
                                    'City / Town *',
                                    isDark,
                                  ),
                                  SizedBox(height: 0.4.h),
                                  _OpenAccountUi.buildDropdown(
                                    value: _selectedCity.isEmpty
                                        ? null
                                        : _selectedCity,
                                    items: _cities,
                                    hint: 'Select city',
                                    icon: Icons.location_city_rounded,
                                    isDark: isDark,
                                    accentColor: widget.accentColor,
                                    onChanged: (v) => setState(
                                      () => _selectedCity = v ?? '',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _OpenAccountUi.buildFieldLabel(
                                    'Region *',
                                    isDark,
                                  ),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                          'Metro / Municipal *',
                          isDark,
                        ),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedMetroMunicipal.isEmpty
                              ? null
                              : _selectedMetroMunicipal,
                          items: _metroMunicipals,
                          hint: 'Select metro or municipal assembly',
                          icon: Icons.account_balance_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) => setState(
                            () => _selectedMetroMunicipal = v ?? '',
                          ),
                        ),
                        _buildFormDivider(isDark),
                        _buildFormSectionHeader(
                          isDark: isDark,
                          title: 'Proof of Address',
                          icon: Icons.description_outlined,
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                          'Proof of Address Type *',
                          isDark,
                        ),
                        SizedBox(height: 0.4.h),
                        _OpenAccountUi.buildDropdown(
                          value: _selectedProofType.isEmpty
                              ? null
                              : _selectedProofType,
                          items: _proofOfAddressTypes,
                          hint: 'Select document type',
                          icon: Icons.article_outlined,
                          isDark: isDark,
                          accentColor: widget.accentColor,
                          onChanged: (v) =>
                              setState(() => _selectedProofType = v ?? ''),
                        ),
                        _fieldGap(),
                        _OpenAccountUi.buildFieldLabel(
                          'Proof of Address Document *',
                          isDark,
                        ),
                        SizedBox(height: 0.5.h),
                        _buildProofDocumentCard(isDark),
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
                label: 'Continue to Emergency Contact',
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
