part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Step 5 – Review & Confirm ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountReviewScreen extends StatefulWidget {
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
  final String idType;
  final String idNumber;
  final String issueDate;
  final String expiryDate;
  final String phone;
  final String altPhone;
  final String email;
  final String address;
  final String city;
  final String nokName;
  final String nokPhone;
  final String nokRelation;
  final bool hasIdCopy;
  final bool hasPassportPhoto;
  final bool hasProofOfAddress;
  final bool hasSignature;
  final String initialDeposit;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountReviewScreen({
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
    required this.idType,
    required this.idNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.address,
    required this.city,
    required this.nokName,
    required this.nokPhone,
    required this.nokRelation,
    required this.hasIdCopy,
    required this.hasPassportPhoto,
    required this.hasProofOfAddress,
    required this.hasSignature,
    required this.initialDeposit,
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
        widget.firstName,
        if (widget.otherName.isNotEmpty) widget.otherName,
        widget.lastName,
      ].join(' ');

  void _onSubmit() {
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: widget.accentColor,
      title: 'Authorize Account Opening',
      subtitle: 'Enter your PIN to open a ${widget.accountType} account for $_fullName',
      onAuthenticated: () {
        setState(() => _isSubmitting = true);

        // Simulated processing
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
                initialDeposit: widget.initialDeposit,
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
            _buildHeader(isDark),
            Expanded(
              child: _isSubmitting
                  ? _buildLoadingState(isDark)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _buildStepIndicator(isDark, 4, 4),
                          SizedBox(height: 2.5.h),

                          Text(
                            'Review Application',
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
                            'Please review all details before submitting.',
                            style: GoogleFonts.inter(
                              fontSize: 8.5.sp,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: 2.h),

                          // Account Type Banner
                          _buildAccountBanner(isDark),
                          SizedBox(height: 2.h),

                          // Personal
                          _buildSection(
                            title: 'Personal Details',
                            icon: Icons.person_outline_rounded,
                            isDark: isDark,
                            rows: [
                              _row('Full Name', _fullName),
                              _row('Date of Birth', widget.dob),
                              _row('Gender', widget.gender),
                              _row('Marital Status',
                                  widget.maritalStatus),
                              _row('Occupation',
                                  widget.occupation),
                              if (widget.mothersMaidenName
                                  .isNotEmpty)
                                _row('Mother\'s Maiden',
                                    widget.mothersMaidenName),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // ID
                          _buildSection(
                            title: 'Identification',
                            icon: Icons.badge_outlined,
                            isDark: isDark,
                            rows: [
                              _row('ID Type', widget.idType),
                              _row('ID Number', widget.idNumber),
                              if (widget.issueDate.isNotEmpty)
                                _row('Issue Date',
                                    widget.issueDate),
                              if (widget.expiryDate.isNotEmpty)
                                _row('Expiry Date',
                                    widget.expiryDate),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Contact
                          _buildSection(
                            title: 'Contact Details',
                            icon: Icons.phone_outlined,
                            isDark: isDark,
                            rows: [
                              _row('Phone', widget.phone),
                              if (widget.altPhone.isNotEmpty)
                                _row('Alt Phone',
                                    widget.altPhone),
                              if (widget.email.isNotEmpty)
                                _row('Email', widget.email),
                              _row('Address', widget.address),
                              _row('City', widget.city),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Next of Kin
                          _buildSection(
                            title: 'Next of Kin',
                            icon: Icons.people_outline_rounded,
                            isDark: isDark,
                            rows: [
                              _row('Name', widget.nokName),
                              _row('Phone', widget.nokPhone),
                              _row('Relationship',
                                  widget.nokRelation),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Documents
                          _buildSection(
                            title: 'Documents',
                            icon: Icons.folder_outlined,
                            isDark: isDark,
                            rows: [
                              _checkRow('ID Copy',
                                  widget.hasIdCopy),
                              _checkRow('Passport Photo',
                                  widget.hasPassportPhoto),
                              _checkRow('Proof of Address',
                                  widget.hasProofOfAddress),
                              _checkRow('Signature',
                                  widget.hasSignature),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Deposit
                          _buildSection(
                            title: 'Initial Deposit',
                            icon: Icons.account_balance_wallet_outlined,
                            isDark: isDark,
                            rows: [
                              _row('Amount',
                                  'GH₵${widget.initialDeposit}'),
                              _row('Account Type',
                                  widget.accountType),
                            ],
                          ),
                          SizedBox(height: 3.h),

                          // Submit
                          _buildSubmitButton(isDark),
                          SizedBox(height: 1.5.h),

                          // Back
                          Center(
                            child: TextButton.icon(
                              onPressed: () =>
                                  Navigator.of(context).pop(),
                              icon: Icon(
                                  Icons.arrow_back_rounded,
                                  size: 16,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF9CA3AF)),
                              label: Text(
                                'Go Back & Edit',
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Processing Account Opening...',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Please wait while we create the account',
            style: GoogleFonts.inter(
              fontSize: 8.5.sp,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountBanner(bool isDark) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
            widget.accentColor.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.account_balance_rounded,
                color: widget.accentColor,
                size: 22,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.accountType} Account',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  'For $_fullName · GH₵${widget.initialDeposit} deposit',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    color: isDark
                        ? Colors.white54
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MapEntry<String, String> _row(String label, String value) =>
      MapEntry(label, value);

  MapEntry<String, String> _checkRow(String label, bool checked) =>
      MapEntry(label, checked ? '✓ Provided' : '— Not provided');

  Widget _buildSection({
    required String title,
    required IconData icon,
    required bool isDark,
    required List<MapEntry<String, String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
            child: Row(
              children: [
                Icon(icon,
                    color: widget.accentColor, size: 18),
                SizedBox(width: 2.w),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : const Color(0xFFF3F4F6),
          ),
          // Rows
          ...rows.map((entry) => Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 4.w, vertical: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30.w,
                      child: Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          color: entry.value.startsWith('✓')
                              ? const Color(0xFF059669)
                              : entry.value.startsWith('—')
                                  ? (isDark
                                      ? Colors.white24
                                      : const Color(0xFFD1D5DB))
                                  : (isDark
                                      ? Colors.white
                                      : const Color(0xFF111827)),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

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

  Widget _buildSubmitButton(bool isDark) {
    return GestureDetector(
      onTap: _onSubmit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF2E8B8B), Color(0xFF1B6B6B)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFF2E8B8B).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded,
                color: Colors.white, size: 18),
            SizedBox(width: 2.w),
            Text(
              'Submit & Open Account',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
                      'Review & Confirm',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Open Account · Step 4 of 4',
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
