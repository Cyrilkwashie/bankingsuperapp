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
  final _mothersMaidenCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  String _selectedGender = '';
  String _selectedMarital = '';
  String _selectedOccupation = '';
  DateTime? _selectedDob;

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
    _mothersMaidenCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _firstNameCtrl.text.trim().isNotEmpty &&
      _lastNameCtrl.text.trim().isNotEmpty &&
      _selectedGender.isNotEmpty &&
      _selectedMarital.isNotEmpty &&
      _selectedDob != null &&
      _selectedOccupation.isNotEmpty;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 18, now.month, now.day),
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
      setState(() {
        _selectedDob = picked;
        _dobCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
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
        builder: (_) => _OpenAccountIdContactScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          otherName: _otherNameCtrl.text.trim(),
          gender: _selectedGender,
          maritalStatus: _selectedMarital,
          dob: _dobCtrl.text,
          mothersMaidenName: _mothersMaidenCtrl.text.trim(),
          occupation: _selectedOccupation,
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
                      // Step indicator
                      _buildStepIndicator(isDark, 1, 4),
                      SizedBox(height: 2.5.h),

                      // Section
                      Text(
                        'Personal Details',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Enter the customer\'s personal information.',
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 2.5.h),

                      // First Name & Last Name side by side
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(
                                    'First Name *', isDark),
                                SizedBox(height: 0.8.h),
                                _buildTextField(
                                  controller: _firstNameCtrl,
                                  hint: 'e.g. Kwame',
                                  icon:
                                      Icons.person_outline_rounded,
                                  isDark: isDark,
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
                                    'Last Name *', isDark),
                                SizedBox(height: 0.8.h),
                                _buildTextField(
                                  controller: _lastNameCtrl,
                                  hint: 'e.g. Mensah',
                                  icon:
                                      Icons.person_outline_rounded,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Other Name(s)
                      _buildFieldLabel('Other Name(s)', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _otherNameCtrl,
                        hint: 'Optional',
                        icon: Icons.person_outline_rounded,
                        isDark: isDark,
                        required: false,
                      ),
                      SizedBox(height: 2.h),

                      // Date of Birth
                      _buildFieldLabel('Date of Birth *', isDark),
                      SizedBox(height: 0.8.h),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: _dobCtrl,
                            hint: 'DD/MM/YYYY',
                            icon: Icons.calendar_today_rounded,
                            isDark: isDark,
                            suffixIcon: Icons.arrow_drop_down_rounded,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Gender & Marital Status side by side dropdowns
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(
                                    'Gender *', isDark),
                                SizedBox(height: 0.8.h),
                                _buildDropdown(
                                  value: _selectedGender.isEmpty
                                      ? null
                                      : _selectedGender,
                                  items: _genders,
                                  hint: 'Select',
                                  icon: Icons
                                      .wc_rounded,
                                  isDark: isDark,
                                  onChanged: (v) => setState(
                                      () => _selectedGender =
                                          v ?? ''),
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
                                    'Marital Status *', isDark),
                                SizedBox(height: 0.8.h),
                                _buildDropdown(
                                  value:
                                      _selectedMarital.isEmpty
                                          ? null
                                          : _selectedMarital,
                                  items: _maritalStatuses,
                                  hint: 'Select',
                                  icon: Icons
                                      .favorite_border_rounded,
                                  isDark: isDark,
                                  onChanged: (v) => setState(
                                      () => _selectedMarital =
                                          v ?? ''),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Occupation dropdown
                      _buildFieldLabel('Occupation *', isDark),
                      SizedBox(height: 0.8.h),
                      _buildDropdown(
                        value: _selectedOccupation.isEmpty
                            ? null
                            : _selectedOccupation,
                        items: _occupations,
                        hint: 'Select occupation',
                        icon: Icons.work_outline_rounded,
                        isDark: isDark,
                        onChanged: (v) => setState(
                            () => _selectedOccupation = v ?? ''),
                      ),
                      SizedBox(height: 2.h),

                      // Mother's Maiden Name
                      _buildFieldLabel(
                          'Mother\'s Maiden Name', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _mothersMaidenCtrl,
                        hint: 'Optional — for security',
                        icon: Icons.family_restroom_rounded,
                        isDark: isDark,
                        required: false,
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

  // ── Shared widgets ────────────────────────────────────────

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
    IconData? suffixIcon,
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
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon,
                color:
                    isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                size: 24)
            : null,
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
              'Continue to ID & Contact',
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
                      'Personal Details',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Open Account · Step 1 of 4',
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
