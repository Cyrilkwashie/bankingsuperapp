part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 2 – ID & Contact Details ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountIdContactScreen extends StatefulWidget {
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
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountIdContactScreen({
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
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountIdContactScreen> createState() =>
      _OpenAccountIdContactScreenState();
}

class _OpenAccountIdContactScreenState
    extends State<_OpenAccountIdContactScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String _selectedIdType = '';
  String _selectedCity = '';
  DateTime? _issueDate;
  DateTime? _expiryDate;
  final _idNumberCtrl = TextEditingController();
  final _issueDateCtrl = TextEditingController();
  final _expiryDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  static const _idTypes = [
    'Ghana Card',
    'Voter ID',
    'Passport',
    'Driver\'s License',
    'NHIS Card',
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
    _idNumberCtrl.dispose();
    _issueDateCtrl.dispose();
    _expiryDateCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedIdType.isNotEmpty &&
      _idNumberCtrl.text.trim().isNotEmpty &&
      _phoneCtrl.text.trim().isNotEmpty &&
      _addressCtrl.text.trim().isNotEmpty &&
      _selectedCity.isNotEmpty;

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
          occupation: widget.occupation,
          idType: _selectedIdType,
          idNumber: _idNumberCtrl.text.trim(),
          issueDate: _issueDateCtrl.text,
          expiryDate: _expiryDateCtrl.text,
          phone: _phoneCtrl.text.trim(),
          altPhone: _altPhoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          city: _selectedCity,
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
              title: 'ID & Contact',
              subtitle: 'Open Account · Step 2 of 4',
              gradientColors: widget.gradientColors,
              icon: Icons.badge_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              2,
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
                        'Valid government-issued ID and an active phone number are required for account SMS alerts.',
                        accentColor: widget.accentColor,
                      ),
                      SizedBox(height: 1.5.h),
                      _OpenAccountUi.buildSectionCard(
                        isDark: isDark,
                        title: 'Identification Details',
                        subtitle: 'Government-issued ID required',
                        icon: Icons.badge_outlined,
                        accentColor: widget.accentColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OpenAccountUi.buildFieldLabel('ID Type *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildDropdown(
                              value: _selectedIdType.isEmpty
                                  ? null
                                  : _selectedIdType,
                              items: _idTypes,
                              hint: 'Select ID type',
                              icon: Icons.badge_outlined,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (v) =>
                                  setState(() => _selectedIdType = v ?? ''),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'ID Number *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _idNumberCtrl,
                              hint: 'e.g. GHA-123456789-1',
                              icon: Icons.numbers_rounded,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Issue Date', isDark),
                            SizedBox(height: 0.4.h),
                            AgencyDateField(
                              label: 'Issue Date',
                              value: _issueDate,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              displayFormat: AgencyDateFormat.slash,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              pickerTitle: 'ID Issue Date',
                              pickerSubtitle:
                                  'When was this identification issued?',
                              onChanged: (picked) {
                                setState(() {
                                  _issueDate = picked;
                                  _issueDateCtrl.text = picked != null
                                      ? AgencyDatePicker.formatSlash(picked)
                                      : '';
                                });
                              },
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Expiry Date', isDark),
                            SizedBox(height: 0.4.h),
                            AgencyDateField(
                              label: 'Expiry Date',
                              value: _expiryDate,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              displayFormat: AgencyDateFormat.slash,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2040),
                              initialDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              pickerTitle: 'ID Expiry Date',
                              pickerSubtitle:
                                  'When does this identification expire?',
                              onChanged: (picked) {
                                setState(() {
                                  _expiryDate = picked;
                                  _expiryDateCtrl.text = picked != null
                                      ? AgencyDatePicker.formatSlash(picked)
                                      : '';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      _OpenAccountUi.buildSectionCard(
                        isDark: isDark,
                        title: 'Contact Details',
                        subtitle: 'Phone number required for SMS alerts',
                        icon: Icons.phone_outlined,
                        accentColor: widget.accentColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OpenAccountUi.buildFieldLabel(
                                'Phone Number *', isDark),
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
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Alternative Phone', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _altPhoneCtrl,
                              hint: 'Optional',
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
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Email Address', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _emailCtrl,
                              hint: 'Optional',
                              icon: Icons.email_outlined,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              required: false,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'Residential Address *', isDark),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _addressCtrl,
                              hint: 'e.g. Plot 5, Osu Road',
                              icon: Icons.location_on_outlined,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              maxLines: 2,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                                'City / Town *', isDark),
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
                              onChanged: (v) =>
                                  setState(() => _selectedCity = v ?? ''),
                            ),
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
                label: 'Continue to Documents',
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
