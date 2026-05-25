part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 1 – Personal Details ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountPersonalScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountPersonalScreen({
    required this.accountType,
    required this.minDeposit,
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
  final _customOccupationCtrl = TextEditingController();

  String _selectedTitle = '';
  String _selectedGender = '';
  String _selectedMarital = '';
  String _selectedOccupation = '';
  DateTime? _selectedDob;

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

  static const _genders = ['Male', 'Female'];
  static const _maritalStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];
  static const _occupations = [
    'Trader',
    'Teacher',
    'Farmer',
    'Artisan',
    'Driver',
    'Civil Servant',
    'Nurse / Health Worker',
    'Engineer',
    'Student',
    'Business Owner',
    'Unemployed',
    'Retired',
    'Other',
  ];

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
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _otherNameCtrl.dispose();
    _dobCtrl.dispose();
    _customOccupationCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedTitle.isNotEmpty &&
      _firstNameCtrl.text.trim().isNotEmpty &&
      _lastNameCtrl.text.trim().isNotEmpty &&
      _selectedGender.isNotEmpty &&
      _selectedMarital.isNotEmpty &&
      _selectedDob != null &&
      _selectedOccupation.isNotEmpty &&
      (_selectedOccupation != 'Other' ||
          _customOccupationCtrl.text.trim().isNotEmpty);

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
        builder: (_) => _OpenAccountIdContactScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          title: _selectedTitle,
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          otherName: _otherNameCtrl.text.trim(),
          gender: _selectedGender,
          maritalStatus: _selectedMarital,
          dob: _dobCtrl.text,
          occupation: _selectedOccupation == 'Other'
              ? _customOccupationCtrl.text.trim()
              : _selectedOccupation,
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
              title: 'Personal Details',
              subtitle: 'Open Account · Step 1 of 4',
              gradientColors: widget.gradientColors,
              icon: Icons.person_outline_rounded,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              1,
              accentColor: widget.accentColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OpenAccountUi.buildIntroTip(
                        isDark,
                        'Enter the customer\'s personal information. All fields marked with * are required.',
                        accentColor: widget.accentColor,
                      ),
                      SizedBox(height: 1.5.h),
                      _OpenAccountUi.buildSectionCard(
                        isDark: isDark,
                        title: 'Personal Information',
                        subtitle: 'One field per line for clarity',
                        icon: Icons.badge_outlined,
                        accentColor: widget.accentColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OpenAccountUi.buildFieldLabel('Title *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildDropdown(
                              value: _selectedTitle.isEmpty
                                  ? null
                                  : _selectedTitle,
                              items: _titles,
                              hint: 'Select title',
                              icon: Icons.person_pin_outlined,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (v) =>
                                  setState(() => _selectedTitle = v ?? ''),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'First Name *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _firstNameCtrl,
                              hint: 'e.g. Kwame',
                              icon: Icons.person_outline_rounded,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Last Name *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _lastNameCtrl,
                              hint: 'e.g. Mensah',
                              icon: Icons.person_outline_rounded,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Other Name(s)', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _otherNameCtrl,
                              hint: 'Optional',
                              icon: Icons.person_outline_rounded,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              required: false,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Date of Birth *', isDark),
                            SizedBox(height: 0.4.h),
                            AgencyDateField(
                              label: 'Date of Birth',
                              value: _selectedDob,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              displayFormat: AgencyDateFormat.slash,
                              firstDate: DateTime(1920),
                              lastDate: DateTime(
                                DateTime.now().year - 18,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                              initialDate: DateTime(DateTime.now().year - 25),
                              pickerTitle: 'Date of Birth',
                              pickerSubtitle:
                                  'Customer must be at least 18 years old',
                              onChanged: (picked) {
                                setState(() {
                                  _selectedDob = picked;
                                  _dobCtrl.text = picked != null
                                      ? AgencyDatePicker.formatSlash(picked)
                                      : '';
                                });
                              },
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel('Gender *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildDropdown(
                              value: _selectedGender.isEmpty
                                  ? null
                                  : _selectedGender,
                              items: _genders,
                              hint: 'Select gender',
                              icon: Icons.wc_rounded,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (v) =>
                                  setState(() => _selectedGender = v ?? ''),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Marital Status *', isDark),
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
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Occupation *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildDropdown(
                              value: _selectedOccupation.isEmpty
                                  ? null
                                  : _selectedOccupation,
                              items: _occupations,
                              hint: 'Select occupation',
                              icon: Icons.work_outline_rounded,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (v) => setState(
                                  () => _selectedOccupation = v ?? ''),
                            ),
                            if (_selectedOccupation == 'Other') ...[
                              SizedBox(height: 1.3.h),
                              _OpenAccountUi.buildFieldLabel(
                                  'Specify Occupation *', isDark),
                              SizedBox(height: 0.4.h),
                              _OpenAccountUi.buildTextField(
                                controller: _customOccupationCtrl,
                                hint: 'Enter occupation',
                                icon: Icons.edit_outlined,
                                isDark: isDark,
                                accentColor: widget.accentColor,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: 'Continue to ID & Contact',
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
