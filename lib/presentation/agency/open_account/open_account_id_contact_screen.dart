part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 3 – ID & Contact Details ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountIdContactScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final String firstName;
  final String lastName;
  final String otherName;
  final String gender;
  final String maritalStatus;
  final String dob;
  final String mothersMaidenName;
  final String occupation;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountIdContactScreen({
    required this.accountType,
    required this.minDeposit,
    required this.firstName,
    required this.lastName,
    required this.otherName,
    required this.gender,
    required this.maritalStatus,
    required this.dob,
    required this.mothersMaidenName,
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
  String _selectedNokRelation = '';
  final _idNumberCtrl = TextEditingController();
  final _issueDateCtrl = TextEditingController();
  final _expiryDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nokNameCtrl = TextEditingController();
  final _nokPhoneCtrl = TextEditingController();

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

  static const _nokRelationships = [
    'Spouse',
    'Parent',
    'Sibling',
    'Child',
    'Uncle / Aunt',
    'Cousin',
    'Friend',
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
    _idNumberCtrl.dispose();
    _issueDateCtrl.dispose();
    _expiryDateCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _nokNameCtrl.dispose();
    _nokPhoneCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _selectedIdType.isNotEmpty &&
      _idNumberCtrl.text.trim().isNotEmpty &&
      _phoneCtrl.text.trim().isNotEmpty &&
      _addressCtrl.text.trim().isNotEmpty &&
      _selectedCity.isNotEmpty &&
      _nokNameCtrl.text.trim().isNotEmpty &&
      _nokPhoneCtrl.text.trim().isNotEmpty &&
      _selectedNokRelation.isNotEmpty;

  Future<void> _pickDate({required bool isIssue}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isIssue ? now : now.add(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: isIssue ? now : DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {
        if (isIssue) {
          _issueDateCtrl.text = formatted;
        } else {
          _expiryDateCtrl.text = formatted;
        }
      });
    }
  }

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
          firstName: widget.firstName,
          lastName: widget.lastName,
          otherName: widget.otherName,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          dob: widget.dob,
          mothersMaidenName: widget.mothersMaidenName,
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
          nokName: _nokNameCtrl.text.trim(),
          nokPhone: _nokPhoneCtrl.text.trim(),
          nokRelation: _selectedNokRelation,
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
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStepIndicator(isDark, 2, 4),
                      SizedBox(height: 2.5.h),

                      // ── ID Details ────────────────────────
                      _buildSectionTitle(
                          'Identification Details', isDark),
                      SizedBox(height: 0.5.h),
                      _buildSectionSubtitle(
                          'Valid government-issued ID required.',
                          isDark),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('ID Type *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildDropdown(
                        value: _selectedIdType.isEmpty
                            ? null
                            : _selectedIdType,
                        items: _idTypes,
                        hint: 'Select ID Type',
                        icon: Icons.badge_outlined,
                        isDark: isDark,
                        onChanged: (v) =>
                            setState(() => _selectedIdType = v ?? ''),
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('ID Number *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _idNumberCtrl,
                        hint: 'e.g. GHA-123456789-1',
                        icon: Icons.numbers_rounded,
                        isDark: isDark,
                      ),
                      SizedBox(height: 2.h),

                      // Issue & Expiry in a row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(
                                    'Issue Date', isDark),
                                SizedBox(height: 0.8.h),
                                GestureDetector(
                                  onTap: () =>
                                      _pickDate(isIssue: true),
                                  child: AbsorbPointer(
                                    child: _buildTextField(
                                      controller: _issueDateCtrl,
                                      hint: 'DD/MM/YYYY',
                                      icon: Icons
                                          .calendar_today_rounded,
                                      isDark: isDark,
                                      required: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(
                                    'Expiry Date', isDark),
                                SizedBox(height: 0.8.h),
                                GestureDetector(
                                  onTap: () =>
                                      _pickDate(isIssue: false),
                                  child: AbsorbPointer(
                                    child: _buildTextField(
                                      controller: _expiryDateCtrl,
                                      hint: 'DD/MM/YYYY',
                                      icon: Icons
                                          .calendar_today_rounded,
                                      isDark: isDark,
                                      required: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),

                      // ── Contact Details ───────────────────
                      _buildSectionTitle('Contact Details', isDark),
                      SizedBox(height: 0.5.h),
                      _buildSectionSubtitle(
                          'Phone number is required for account SMS alerts.',
                          isDark),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('Phone Number *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _phoneCtrl,
                        hint: 'e.g. 0241234567',
                        icon: Icons.phone_outlined,
                        isDark: isDark,
                        keyboardType: TextInputType.phone,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel(
                          'Alternative Phone', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _altPhoneCtrl,
                        hint: 'Optional',
                        icon: Icons.phone_outlined,
                        isDark: isDark,
                        required: false,
                        keyboardType: TextInputType.phone,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('Email Address', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _emailCtrl,
                        hint: 'Optional',
                        icon: Icons.email_outlined,
                        isDark: isDark,
                        required: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel(
                          'Residential Address *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _addressCtrl,
                        hint: 'e.g. Plot 5, Osu Road',
                        icon: Icons.location_on_outlined,
                        isDark: isDark,
                        maxLines: 2,
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('City / Town *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildDropdown(
                        value: _selectedCity.isEmpty
                            ? null
                            : _selectedCity,
                        items: _cities,
                        hint: 'Select city',
                        icon: Icons.location_city_rounded,
                        isDark: isDark,
                        onChanged: (v) =>
                            setState(() => _selectedCity = v ?? ''),
                      ),
                      SizedBox(height: 3.h),

                      // ── Next of Kin ───────────────────────
                      _buildSectionTitle('Next of Kin', isDark),
                      SizedBox(height: 0.5.h),
                      _buildSectionSubtitle(
                          'Emergency contact person.',
                          isDark),
                      SizedBox(height: 2.h),

                      _buildFieldLabel(
                          'Full Name *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _nokNameCtrl,
                        hint: 'e.g. Ama Mensah',
                        icon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel(
                          'Phone Number *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _nokPhoneCtrl,
                        hint: 'e.g. 0271234567',
                        icon: Icons.phone_outlined,
                        isDark: isDark,
                        keyboardType: TextInputType.phone,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel(
                          'Relationship *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildDropdown(
                        value: _selectedNokRelation.isEmpty
                            ? null
                            : _selectedNokRelation,
                        items: _nokRelationships,
                        hint: 'Select relationship',
                        icon: Icons.people_outline_rounded,
                        isDark: isDark,
                        onChanged: (v) =>
                            setState(() => _selectedNokRelation = v ?? ''),
                      ),
                      SizedBox(height: 3.h),

                      // Continue
                      _buildContinueButton(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper builders ───────────────────────────────────────

  Widget _buildStepIndicator(bool isDark, int current, int total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: List.generate(total, (i) {
          final step = i + 1;
          final isActive = step == current;
          final isComplete = step < current;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 3,
                          decoration: BoxDecoration(
                            color: isComplete || isActive
                                ? widget.accentColor
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    _stepLabel(step),
                    style: GoogleFonts.inter(
                      fontSize: 6.sp,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? widget.accentColor
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _stepLabel(int step) {
    switch (step) {
      case 1:
        return 'Personal';
      case 2:
        return 'ID & Contact';
      case 3:
        return 'Documents';
      case 4:
        return 'Review';
      default:
        return '';
    }
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF111827),
      ),
    );
  }

  Widget _buildSectionSubtitle(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 8.5.sp,
        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 9.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : const Color(0xFF374151),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool required = true,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
      style: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        prefixIcon: Icon(icon,
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: widget.accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required bool isDark,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon,
              color:
                  isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w, vertical: 1.6.h),
        ),
        dropdownColor:
            isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        hint: Text(
          hint,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1A1D23),
        ),
        items: items
            .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildContinueButton(bool isDark) {
    return GestureDetector(
      onTap: _canContinue ? _onContinue : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: _canContinue
              ? const LinearGradient(
                  colors: [Color(0xFF2E8B8B), Color(0xFF1B6B6B)])
              : null,
          color: _canContinue
              ? null
              : (isDark
                  ? const Color(0xFF1E2328)
                  : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _canContinue
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E8B8B)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Documents',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: _canContinue
                    ? Colors.white
                    : (isDark
                        ? Colors.white24
                        : const Color(0xFF9CA3AF)),
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.arrow_forward_rounded,
              color: _canContinue
                  ? Colors.white
                  : (isDark
                      ? Colors.white24
                      : const Color(0xFF9CA3AF)),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : widget.gradientColors,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID & Contact',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Open Account · Step 2 of 4',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color:
                            Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Online',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
