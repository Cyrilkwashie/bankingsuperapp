part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 4 – Review & Confirm ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountReviewScreen extends StatefulWidget {
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
  final String idType;
  final String idNumber;
  final String issueDate;
  final String expiryDate;
  final String phone;
  final String altPhone;
  final String email;
  final String address;
  final String city;
  final bool hasIdCopy;
  final bool hasPassportPhoto;
  final bool hasProofOfAddress;
  final bool hasSignature;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountReviewScreen({
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
    required this.idType,
    required this.idNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.address,
    required this.city,
    required this.hasIdCopy,
    required this.hasPassportPhoto,
    required this.hasProofOfAddress,
    required this.hasSignature,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountReviewScreen> createState() =>
      _OpenAccountReviewScreenState();
}

class _OpenAccountReviewScreenState
    extends State<_OpenAccountReviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isSubmitting = false;

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
    super.dispose();
  }

  String get _fullName => [
        if (widget.title.isNotEmpty) widget.title,
        widget.firstName,
        if (widget.otherName.isNotEmpty) widget.otherName,
        widget.lastName,
      ].join(' ');

  String _docStatus(bool provided) =>
      provided ? '✓ Provided' : '— Not provided';

  void _onSubmit() {
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: widget.accentColor,
      title: 'Authorize Account Opening',
      subtitle:
          'Enter your PIN to open a ${widget.accountType} account for $_fullName',
      onAuthenticated: () {
        setState(() => _isSubmitting = true);

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() => _isSubmitting = false);

          final random = Random();
          final accountNum =
              '${1000 + random.nextInt(9000)}${1000 + random.nextInt(9000)}${10 + random.nextInt(90)}';
          final refNum =
              'OA${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => _OpenAccountSuccessScreen(
                accountType: widget.accountType,
                fullName: _fullName,
                accountNumber: accountNum,
                referenceNumber: refNum,
                phone: widget.phone,
                accentColor: widget.accentColor,
                gradientColors: widget.gradientColors,
              ),
            ),
          );
        });
      },
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
              title: 'Review & Confirm',
              subtitle: 'Open Account · Step 4 of 4',
              gradientColors: widget.gradientColors,
              icon: Icons.fact_check_outlined,
            ),
            _OpenAccountUi.buildWizardStepIndicator(
              isDark,
              4,
              accentColor: widget.accentColor,
            ),
            Expanded(
              child: _isSubmitting
                  ? _buildLoadingState(isDark)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                      child: Column(
                        children: [
                          _OpenAccountUi.buildHeroBanner(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            icon: Icons.account_balance_rounded,
                            label: 'Account Type',
                            headline: widget.accountType,
                            subtitle: 'Min. deposit ${widget.minDeposit}',
                          ),
                          SizedBox(height: 1.5.h),
                          _OpenAccountUi.buildSummaryCard(
                            isDark: isDark,
                            accentColor: widget.accentColor,
                            title: 'Application Summary',
                            rows: [
                              _OpenAccountSummaryRow('Full Name', _fullName),
                              _OpenAccountSummaryRow('Date of Birth', widget.dob),
                              _OpenAccountSummaryRow('Gender', widget.gender),
                              _OpenAccountSummaryRow(
                                  'Marital Status', widget.maritalStatus),
                              _OpenAccountSummaryRow(
                                  'Occupation', widget.occupation),
                              _OpenAccountSummaryRow('ID Type', widget.idType),
                              _OpenAccountSummaryRow(
                                  'ID Number', widget.idNumber, mono: true),
                              if (widget.issueDate.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Issue Date', widget.issueDate),
                              if (widget.expiryDate.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Expiry Date', widget.expiryDate),
                              _OpenAccountSummaryRow('Phone', widget.phone),
                              if (widget.altPhone.isNotEmpty)
                                _OpenAccountSummaryRow(
                                    'Alt Phone', widget.altPhone),
                              _OpenAccountSummaryRow('Email', widget.email),
                              _OpenAccountSummaryRow('Address', widget.address),
                              _OpenAccountSummaryRow('City', widget.city),
                              _OpenAccountSummaryRow(
                                'ID Copy',
                                _docStatus(widget.hasIdCopy),
                                valueColor: widget.hasIdCopy
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                              _OpenAccountSummaryRow(
                                'Passport Photo',
                                _docStatus(widget.hasPassportPhoto),
                                valueColor: widget.hasPassportPhoto
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                              _OpenAccountSummaryRow(
                                'Proof of Address',
                                _docStatus(widget.hasProofOfAddress),
                                valueColor: widget.hasProofOfAddress
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                              _OpenAccountSummaryRow(
                                'Signature',
                                _docStatus(widget.hasSignature),
                                valueColor: widget.hasSignature
                                    ? _OpenAccountUi.success
                                    : null,
                              ),
                            ],
                          ),
                          SizedBox(height: 1.5.h),
                          _OpenAccountUi.buildSecurityNote(
                            isDark,
                            'You will be asked to authorize this account opening with your transaction PIN.',
                          ),
                        ],
                      ),
                    ),
            ),
            if (!_isSubmitting)
              _OpenAccountUi.buildStickyActionBar(
                isDark: isDark,
                child: Column(
                  children: [
                    _OpenAccountUi.buildPrimaryButton(
                      isDark: isDark,
                      label: 'Submit & Open Account',
                      onTap: _onSubmit,
                      accentColor: widget.accentColor,
                      icon: Icons.lock_outline_rounded,
                      showArrow: false,
                    ),
                    SizedBox(height: 0.8.h),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.6.h),
                        child: Text(
                          'Go Back & Edit',
                          style: GoogleFonts.inter(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w600,
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            'Processing Account Opening...',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            'Please wait while we create the account',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
