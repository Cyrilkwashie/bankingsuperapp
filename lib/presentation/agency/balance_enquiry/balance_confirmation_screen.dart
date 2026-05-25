part of 'agency_balance_enquiry_screen.dart';

class _BalanceConfirmationScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String accountType;
  final String enquiryType;
  final int? txnCount;
  final DateTime? txnStartDate;
  final DateTime? txnEndDate;
  final String destinationPhone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _BalanceConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
    required this.enquiryType,
    required this.txnCount,
    required this.txnStartDate,
    required this.txnEndDate,
    required this.destinationPhone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_BalanceConfirmationScreen> createState() =>
      _BalanceConfirmationScreenState();
}

class _BalanceConfirmationScreenState
    extends State<_BalanceConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String get _enquiryLabel =>
      widget.enquiryType == 'balance' ? 'Balance Enquiry' : 'Transaction Details';

  String get _scopeDescription {
    if (widget.enquiryType == 'balance') {
      return 'Current available account balance';
    }
    if (widget.txnCount != null) {
      return 'Last ${widget.txnCount} transactions';
    }
    final from = widget.txnStartDate != null
        ? _formatDate(widget.txnStartDate!)
        : '—';
    final to =
        widget.txnEndDate != null ? _formatDate(widget.txnEndDate!) : '—';
    return 'Transactions: $from – $to';
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  void _onConfirmTap() {
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: widget.accentColor,
      title: 'Authorize Enquiry',
      subtitle: 'Enter your 4-digit transaction PIN or use biometrics',
      onAuthenticated: _sendAfterAuth,
    );
  }

  Future<void> _sendAfterAuth() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _BalanceResultScreen(
            accountNo: widget.accountNo,
            accountName: widget.accountName,
            enquiryType: widget.enquiryType,
            scopeDescription: _scopeDescription,
            destinationPhone: widget.destinationPhone,
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
            _buildHeader(isDark),
            _AgencyBalanceEnquiryScreenState.buildFlowStepIndicator(3, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
                child: Column(
                  children: [
                    Text(
                      'Confirm & Send',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Review details before dispatching SMS to customer.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.15 : 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.person_rounded,
                            label: 'Account Holder',
                            value: widget.accountName,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.tag_rounded,
                            label: 'Account Number',
                            value: _maskAccountNo(widget.accountNo),
                            mono: true,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.account_balance_rounded,
                            label: 'Account Type',
                            value: widget.accountType,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.account_balance_wallet_rounded,
                            label: 'Enquiry Type',
                            value: _enquiryLabel,
                            accent: true,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.info_outline_rounded,
                            label: 'Scope',
                            value: _scopeDescription,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.phone_android_rounded,
                            label: 'Deliver To',
                            value: widget.destinationPhone,
                            mono: true,
                            accent: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sms_outlined,
                              color: Color(0xFFF59E0B), size: 16),
                          SizedBox(width: 2.5.w),
                          Expanded(
                            child: Text(
                              'Standard SMS charges may apply.',
                              style: GoogleFonts.inter(
                                fontSize: 7.sp,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF6B7280),
                                height: 1.4,
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
            _buildStickyActions(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyActions(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            GestureDetector(
              onTap: _isSending ? null : _onConfirmTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.25.h),
                decoration: BoxDecoration(
                  gradient: !_isSending
                      ? LinearGradient(
                          colors: [
                            widget.accentColor,
                            widget.accentColor.withValues(alpha: 0.85),
                          ],
                        )
                      : null,
                  color: _isSending
                      ? (isDark
                            ? const Color(0xFF1E2328)
                            : const Color(0xFFE5E7EB))
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline_rounded,
                                size: 16, color: Colors.white),
                            SizedBox(width: 1.5.w),
                            Text(
                              'Authorize & Send',
                              style: GoogleFonts.inter(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'Go Back',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmRow({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    bool mono = false,
    bool accent = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: widget.accentColor, size: 14),
            ),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  value,
                  style: mono
                      ? GoogleFonts.jetBrainsMono(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          color: accent
                              ? widget.accentColor
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF111827)),
                        )
                      : GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: accent
                              ? widget.accentColor
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF111827)),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 0,
        thickness: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF3F4F6),
      );

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
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
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
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Icon(Icons.send_outlined, color: Colors.white, size: 20),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Dispatch',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Balance Enquiry · Step 3 of 4',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 12, color: Color(0xFF34D399)),
                    SizedBox(width: 1.w),
                    Text(
                      'Verified',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF34D399),
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
