part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 1 – Ghana Card Verification Entry ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountVerifyScreen extends StatefulWidget {
  final String accountType;
  final String minDeposit;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountVerifyScreen({
    required this.accountType,
    required this.minDeposit,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountVerifyScreen> createState() =>
      _OpenAccountVerifyScreenState();
}

class _OpenAccountVerifyScreenState extends State<_OpenAccountVerifyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isSubmitting = false;

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
    _nationalIdCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _OpenAccountGhanaCardLookup.isValidNationalId(_nationalIdCtrl.text) &&
      _phoneCtrl.text.trim().length == 10 &&
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailCtrl.text.trim());

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) return;

    final profile =
        _OpenAccountGhanaCardLookup.lookup(_nationalIdCtrl.text.trim());
    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ghana Card not found. Check the ID number and try again.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountOtpScreen(
          accountType: widget.accountType,
          minDeposit: widget.minDeposit,
          ghanaCardProfile: profile,
          phone: _phoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          accentColor: widget.accentColor,
          gradientColors: widget.gradientColors,
        ),
      ),
    );
  }

  _GhanaCardProfile? get _lookupProfile =>
      _OpenAccountGhanaCardLookup.lookup(_nationalIdCtrl.text.trim());

  void _handleWizardStepTap(int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 1,
      targetStep: targetStep,
      onForwardStep: _openWizardStep,
    );
  }

  void _openWizardStep(int step) {
    final profile = _lookupProfile;
    if (profile == null) return;

    if (step == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _OpenAccountOtpScreen(
            accountType: widget.accountType,
            minDeposit: widget.minDeposit,
            ghanaCardProfile: profile,
            phone: _phoneCtrl.text.trim().isNotEmpty
                ? _phoneCtrl.text.trim()
                : profile.phone,
            email: _emailCtrl.text.trim().isNotEmpty
                ? _emailCtrl.text.trim()
                : 'customer@email.com',
            accentColor: widget.accentColor,
            gradientColors: widget.gradientColors,
          ),
        ),
      );
      return;
    }

    if (step >= 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _OpenAccountPersonalScreen(
            accountType: widget.accountType,
            minDeposit: widget.minDeposit,
            ghanaCardProfile: profile,
            phone: _phoneCtrl.text.trim().isNotEmpty
                ? _phoneCtrl.text.trim()
                : profile.phone,
            email: _emailCtrl.text.trim().isNotEmpty
                ? _emailCtrl.text.trim()
                : 'customer@email.com',
            verificationPhoto: null,
            accentColor: widget.accentColor,
            gradientColors: widget.gradientColors,
          ),
        ),
      );
    }
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
              title: 'Verify Customer',
              subtitle:
                  'Open Account · Step 1 of ${_OpenAccountUi.wizardStepCount}',
              gradientColors: widget.gradientColors,
              icon: Icons.verified_user_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              1,
              accentColor: widget.accentColor,
              onStepTap: _handleWizardStepTap,
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
                        'Enter the customer\'s National ID number, phone and email. '
                        'An OTP will be sent to the phone number to verify ownership.',
                        accentColor: widget.accentColor,
                      ),
                      SizedBox(height: 1.5.h),
                      _OpenAccountUi.buildSectionCard(
                        isDark: isDark,
                        title: 'Customer Verification',
                        subtitle: 'Ghana Card lookup and OTP verification',
                        icon: Icons.badge_outlined,
                        accentColor: widget.accentColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OpenAccountUi.buildFieldLabel(
                              'National ID Number *',
                              isDark,
                            ),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _nationalIdCtrl,
                              hint: 'e.g. GHA-123456789-1',
                              icon: Icons.credit_card_outlined,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              onChanged: (_) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (!_OpenAccountGhanaCardLookup
                                    .isValidNationalId(value)) {
                                  return 'Use format GHA-123456789-1';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                              'Phone Number *',
                              isDark,
                            ),
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (value.trim().length != 10) {
                                  return 'Enter a 10-digit Ghana number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 1.3.h),
                            _OpenAccountUi.buildFieldLabel(
                              'Email Address *',
                              isDark,
                            ),
                            SizedBox(height: 0.4.h),
                            _OpenAccountUi.buildTextField(
                              controller: _emailCtrl,
                              hint: 'e.g. name@email.com',
                              icon: Icons.email_outlined,
                              isDark: isDark,
                              accentColor: widget.accentColor,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: widget.accentColor
                              .withValues(alpha: isDark ? 0.08 : 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.accentColor.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: widget.accentColor,
                            ),
                            SizedBox(width: 2.5.w),
                            Expanded(
                              child: Text(
                                'After OTP verification, personal details from the Ghana Card '
                                'will be filled automatically. Name, date of birth and gender '
                                'cannot be edited.',
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  height: 1.4,
                                  color: isDark
                                      ? Colors.white54
                                      : const Color(0xFF64748B),
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
            ),
            _OpenAccountUi.buildStickyActionBar(
              isDark: isDark,
              child: _OpenAccountUi.buildPrimaryButton(
                isDark: isDark,
                label: _isSubmitting ? 'Sending OTP...' : 'Send OTP',
                onTap: _isSubmitting || !_canContinue ? null : _onContinue,
                accentColor: widget.accentColor,
                icon: Icons.sms_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
